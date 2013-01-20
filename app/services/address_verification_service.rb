class AddressVerificationService
  def initialize(address)
    @verifier = GoogleAPI::GoogleLocation.new(address)
  end

  def validated_address_attributes
    {
      :address => @verifier.get_location,
      :latitude => @verifier.lat,
      :longitude => @verifier.lng
    }
  end
end