require_relative './meta_error'

module Memoizable
  prepend MetaError

  MetaError.snatch :memoize

  def memoize(method, options = {})
    var = validate_and_return_instance_name(method, options)
    unbound_method = instance_method(method)

    define_method(method) do |*args|
      cache = instance_variable_get(var) 
      cache_defined = instance_variable_defined?(var)

      if args.any?
        key = Marshal.dump(args)
        return cache[key] if cache_defined && cache[key]

        cache ||= {}
        
        cache.merge!({
          key => unbound_method.bind(self).call(*args)
        })

        instance_variable_set(var, cache)
        return cache[key]
      end

      return cache if cache_defined
      instance_variable_set(var, unbound_method.bind(self).call)
    end
  end

  private

  def validate_and_return_instance_name(method, options)
    as = options.fetch(:as, :"@#{method}_cached")
    raise ArgumentError.new(":@ please!") unless (as.is_a? Symbol) && (as[0] == '@')
    as
  end
end
