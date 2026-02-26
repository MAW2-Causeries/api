class InvalidChannelData < NoMethodError
  def initialize(msg = "The channel data is invalid")
    super(msg)
  end
end
