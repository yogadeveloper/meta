class Attributes < Module
  autoload :DSL, File.join(__dir__, "attrs", "dsl")

  attr_reader :attrs
  attr_accessor :object, :proxy

  def self.define(&block)
    @proxy ||= DSL.proxy.new
    @proxy.instance_exec(&block)
    new(@proxy.attrs)
  end

  def initialize(attributes)
    @attrs = attributes
    @object = nil
    class_module = self

    @attrs.each do |key, value|
      define_method(key) { 
        class_module.attribute(key) 
      }
      define_method("#{key}=".to_sym) do |param|
        class_module.set_attribute(key, param, self, &value[:options])
      end
    end

    define_method :initialize do |**kwargs|
      class_module.object = self
      attrs = class_module.attrs
      attrs.each{|k,v| attrs[k][:value] = kwargs[k] }

      attrs.each do |k,v|
        class_module.set_attribute(k, v[:value], self, &v[:options])
      end
    end

    define_singleton_method :inspect do
      "Attributes<#{self}>" 
    end
  end

  def attribute(name)
    @object.instance_variable_get("@#{name}".to_sym)
  end

  def set_attribute(name, value, object, &block)
    opts = {}
    fiber = Fiber.new { block.call }

    loop do
      option_proc = fiber.resume
      break unless option_proc
      opts.merge!(option_proc)
    end

    value = opts[:default].call(name, value) if value.nil? && opts[:default]

    if opts[:enum]
      enum = opts[:enum].call(name, value)

      enum.each do |e|
        object.define_singleton_method("#{e}!".to_sym) do
          instance_variable_set(:"@#{name}", e)
        end

        object.define_singleton_method("#{e}?".to_sym) do
          instance_variable_get(:"@#{name}") == e 
        end
      end
    end

    opts[:required!].call(name, value) if opts[:required!]

    object.instance_variable_set("@#{name}", value)

    instance_exec(&opts[:actions]) if opts[:actions]

  rescue ArgumentError => e 
    puts "#{e.class} - #{e.message} \nCulprit: #{self.name}##{method}\nArgs: #{args}\n"
    e.backtrace.each{|b| puts b }
  end

  define_method(:method_missing) do |name, *args, &block|
    self.define_method(name) { instance_exec(&block) }
  end
end
