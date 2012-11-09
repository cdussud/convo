require 'net/http'
    

# Optional: if I want to toss this in myself
ActiveSupport.on_load(:action_controller) do
  include LoginPrompt::ActionController
end



module LoginPrompt

  # Simple user model
  class User
    attr_accessor :name, :email, :id

    def initialize(hash)
      hash.each do |k, v|
        self.send("#{k}=", v)
      end
    end
  end

  # When included into ActionController provides
  # current_user and signed_in?

  module ActionController
    extend ActiveSupport::Concern

    included do
      helper_method :current_user, :signed_in?
    end

    def current_user

      if @current_user.nil? && cookies['LP-auth']
        begin 
          token = JSON.parse(cookies['LP-auth']) 
        rescue
          token = nil
        end
      
        user = Api.get_user(token)
        @current_user = user if user
      end

      @current_user
    end

    def signed_in?
      current_user.present?
    end
  end


    # Helper to make API calls
  class Api

    # Returns a user object if successful
    def self.get_user(token)
      #call('https://demo.loginprompt.com/login/get_user?remember_token=' + token['remember_token']) if token
      if token
        result = call('http://localhost:3000/login/get_user?remember_token=' + token['remember_token'])
        user = result['user'] if result

        return User.new(id: user['id'], email: user['email'], name: user['name'])
      end

      return nil
    end

    private 

      # Calls a given URL and checks for success
      def self.call(api_url)
        result = nil

        uri = URI(api_url)
        http = Net::HTTP.new(uri.host, uri.port)

        if uri.scheme =='https'
          http.use_ssl = true
        end

        http.start do
          request = Net::HTTP::Get.new(uri.request_uri)
          answer = http.request(request)

          if (answer.is_a? Net::HTTPOK)
            response = JSON.parse(answer.body)
            result = response if response['success'] == true
          end
        end

        result
      end
  end
end

