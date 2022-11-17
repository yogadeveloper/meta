require_relative './memoizable'

class Example
  extend Memoizable

  memoize def foo
    rand
  end
 
  memoize def bar
    rand
  end, as: :@bar_cached
end
