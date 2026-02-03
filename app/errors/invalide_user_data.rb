class InvalideUserData < AuthentificationError
  def initialize(msg = "The user data is invalid")
    super(msg)
  end
end
