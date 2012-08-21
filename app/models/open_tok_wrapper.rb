class OpenTokWrapper
  def self.new_session(address)
    config = Rails.application.config
    opentok = OpenTok::OpenTokSDK.new config.opentok[:api_key], config.opentok[:api_secret]
    opentok.api_url = config.opentok[:api_endpoint]
    session_properties = { OpenTok::SessionPropertyConstants::P2P_PREFERENCE => "enabled" }  # do peer to peer
    session = opentok.create_session address
    session.session_id
  end
end