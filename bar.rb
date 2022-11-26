require_relative './attributes'

State = Attributes.define do
  state do
    enum %i[pending running stopped failed]
    default :pending
  end
end

Name = Attributes.define do
  name { required! }
end

class Bar
  include State
  include Name
end
