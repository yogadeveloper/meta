require_relative './meta_error'

module Memoizable
  prepend MetaError

  MetaError.snatch :memoize

  def memoize(method, options = {})
    cache = options.fetch(:as, nil) || :"@#{method}_cached"
    raise ArgumentError.new(':@ please!') unless (cache.is_a? Symbol) && (cache[0] == '@')

    unbound_method = instance_method(method)

    define_method(method) do
      return instance_variable_get(cache) if instance_variable_defined?(cache)
      instance_variable_set(cache, unbound_method.bind(self).call)
    end
  end
end
