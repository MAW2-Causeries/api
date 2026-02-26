class InvalideGuildlData < SyntaxError
  def initialize(msg = "The guild was not found")
    super(msg)
  end
end
