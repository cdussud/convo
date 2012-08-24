config = Convo::Application.config
config.opentok = {
  api_endpoint: Rails.env.production? ? 'https://api.opentok.com/hl' : 'https://staging.tokbox.com/hl',
  #js_endpoint: 'http://static.opentok.com/v0.92-alpha/js/TB.min.js',  #alpha for webrtc
  js_endpoint: Rails.env.production? ? 'http://static.opentok.com/v0.91/js/TB.min.js': 'http://staging.tokbox.com/v0.91/js/TB.min.js',
  api_key: '15884001',
  api_secret: '5703a640b46d87dae5f88aa47e6f2530512c3051'
}
