require 'net/http'


module ApplicationHelper

  class User
    attr_accessor :name
    attr_accessor :email
    attr_accessor :id
  end


  def app_name
    APP_CONFIG["app_name"].capitalize
  end


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

  def clippy(text, bgcolor='#FFFFFF')
    html = <<-EOF
      <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
              width="110"
              height="14"
              id="clippy" >
      <param name="movie" value="/clippy.swf"/>
      <param name="allowScriptAccess" value="always" />
      <param name="quality" value="high" />
      <param name="scale" value="noscale" />
      <param NAME="FlashVars" value="text=#{text}">
      <param name="bgcolor" value="#{bgcolor}">
      <embed src="/clippy.swf"
             width="110"
             height="14"
             name="clippy"
             quality="high"
             allowScriptAccess="always"
             type="application/x-shockwave-flash"
             pluginspage="http://www.macromedia.com/go/getflashplayer"
             FlashVars="text=#{text}"
             bgcolor="#{bgcolor}"
      />
      </object>
    EOF
    raw(html)
  end
end
