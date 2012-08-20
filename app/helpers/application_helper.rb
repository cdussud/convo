module ApplicationHelper
  def opentok_key
    Rails.application.config.opentok[:api_key]
  end

  def opentok_token(session)
    config = Rails.application.config
    opentok = OpenTok::OpenTokSDK.new opentok_key, config.opentok[:api_secret]
    opentok.api_url = config.opentok[:api_endpoint]
    token = opentok.generate_token :session_id => session #, role: OpenTok::RoleConstants::MODERATOR
  end

  def opentok_js
    Rails.application.config.opentok[:js_endpoint]
  end
end
