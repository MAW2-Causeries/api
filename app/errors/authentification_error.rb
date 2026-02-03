class AuthentificationError < NoMethodError
    def initialize(msg)
      super(msg)
    end
end
