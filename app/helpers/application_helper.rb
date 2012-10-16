require 'net/http'


module ApplicationHelper

  class User
    attr_accessor :name
    attr_accessor :email
    attr_accessor :id
  end

  def current_user
    cookies.each do |cookie|
      p cookie
    end

    token = JSON.parse(cookies['LP-auth']) if cookies['LP-auth']

    p "token is #{token}"
    if token

      result = nil

      base_path = Rails.env.production? ? 'http://demo.loginprompt.com' : 'http://localhost:3000'
      uri = URI(base_path + '/login/check?remember_token=' + token['remember_token'])

      p "Calling server..."
      p uri

      http = Net::HTTP.new(uri.host, uri.port)

      if uri.scheme =='https'
        http.use_ssl = true
      end

      result = nil
      http.start do
        request = Net::HTTP::Get.new(uri.request_uri)
        answer = http.request(request)

        if (answer.is_a? Net::HTTPOK)
          result = JSON.parse(answer.body)
        end
      end

      logger.debug("Result from my thing: " + result.inspect)
      

      if result
        user = User.new
        user.email =  result['email']
        user.id = result['id']
        user.name = result['name']
      end

      @current_user = user


    end





#    @current_user ||=
 #   p @current_user

    # get a remember token from this: look it up by calling the server.
    # todo: put an exires date in the token.

    #@current_user
   # User.new
  end

 # ..........................


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
