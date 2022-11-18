require_relative './memoizable_marshal'

class ExampleWithMarshal
  extend MemoizableMarshal

  memoize def foo
    rand
  end

  memoize def bar
    rand
  end, as: :@bar_cached

  memoize def sum(x, y)
    x + y
  end
end
