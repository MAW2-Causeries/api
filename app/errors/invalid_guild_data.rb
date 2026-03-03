class InvalidGuildData < SyntaxError
  def initialize(msg = "The guild data is invalid")
    super(msg)
  end
end
