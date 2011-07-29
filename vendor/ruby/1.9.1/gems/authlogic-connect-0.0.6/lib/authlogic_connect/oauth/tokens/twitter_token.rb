class TwitterToken < OauthToken
  
  key :user_id
  
  settings "http://api.twitter.com",
    :authorize_url => "https://api.twitter.com/oauth/authorize"
  
end
