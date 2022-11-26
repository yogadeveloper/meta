class EnumError < ArgumentError
  def initialize(arg, value, enum)
    msg = "#{arg}: Enum, please!\nGiven value: #{value}\nAllowed values: #{enum}"
    super(msg)
  end
end

class RequiredError < ArgumentError
  def initialize(arg, value)
    msg = "#{arg} is required!\n"
    super(msg)
  end
end
