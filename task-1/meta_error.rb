require 'pry'

module MetaError
  def self.snatch(*methods)
    methods.each do |method|
      define_method(method) do |*args|
        begin
          super(*args)
        rescue => e
          puts "\n#{e.class} - #{e.message} \nAt: #{self.name}##{method}\nArgs: #{args}\n\n"
        end
      end
    end
  end
end
