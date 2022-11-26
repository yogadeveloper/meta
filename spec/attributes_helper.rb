module IncludeAttrs
  include Attributes.define {
    name do
      required!
    end

    state do
      enum %i[pending running stopped failed]
      default :pending
    end

    started_at { default { Time.new(2022, 1, 1) } }

    count do
      default 0
      actions do
        incr! do
          @count += 1
        end
        decr! do
          @count -= 1
        end
      end
    end
  }
end
