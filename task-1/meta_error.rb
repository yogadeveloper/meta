module MetaError
  def self.snatch(*methods)
    methods.each do |method|
      define_method(method) do |*args|
        begin
          super(*args)
        rescue => e
          puts "#{e.class} - #{e.message} \nCulprit: #{self.name}##{method}\nArgs: #{args}\n"
          e.backtrace.each{|b| puts b }
        end
      end
    end
  end
end
