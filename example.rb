class Example
  include Memoize
 
  memoize def foo
    rand
  end
 
  memoize def bar
    rand
  end, as: :@bar_cached
end
