require_relative './errors'

module DSL
  module_function def proxy
    Class.new do 
      attr_reader :attrs

      define_method(:initialize) do
        @attrs = {}
      end

      define_method(:required!) do
        Fiber.yield({__method__ =>
          -> (arg, v) { raise RequiredError.new(arg, v) unless v }
        })
      end

      define_method(:default) do |*default_value, &block|
        Fiber.yield({__method__ =>
         -> (arg, v) { v || default_value[0] || block.call }
        })
      end

      define_method(:enum) do |arr|
        Fiber.yield({__method__ =>
          -> (arg, v) { 
            raise EnumError.new(arg, v, arr) unless arr.include?(v)
            arr
          }
        })
      end

      define_method(:actions) do |&block|
        Fiber.yield({__method__ => block})
      end

      define_method(:method_missing) do |name, *args, &block|
        @attrs[name] = { options: block }
      end
    end
  end
end
