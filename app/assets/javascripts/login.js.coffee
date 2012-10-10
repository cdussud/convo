class FBLogin
  appId: null

  constructor: (appId) ->
    @appId = appId; 

    if (window.location.hash.length == 0)
      @getToken()
    else
      accessToken = /access_token=[^&$]+/.exec(window.location.hash)[0];
      @sendToken(accessToken)

  getToken: ->
    path = 'https://www.facebook.com/dialog/oauth?';
    queryParams = ['client_id=' + @appId, 
                   'redirect_uri=' + window.location,
                   'response_type=token'];
    query = queryParams.join('&');
    url = path + query;
    #window.open(url);
    window.location = url; # no popup


  sendToken: (accessToken) ->
    # post to our server w/ the token
    #path = "http://secret-ocean-2894.herokuapp.com/fb?"

    path = "http://localhost:3000/login/facebook?"

    queryParams = [accessToken, 'callback=displayUser'];
    query = queryParams.join('&');
    url = path + query;

    # use jsonp to call the server
    script = document.createElement('script');
    script.src = url;
    document.body.appendChild(script);

    
window.FBLogin = FBLogin