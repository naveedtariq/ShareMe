module SocialProfile
  def self.included(base)
    base.class_eval do
      include InstanceMethods
    end
  end
  
  module InstanceMethods
    
    def authenticated_with(provider)
      self.user_tokens.find_by_provider(provider)
    end

    def facebook_access_token
      if self.user_tokens.find_by_provider("facebook")
        token = self.user_tokens.find_by_provider("facebook").token
        consumer = OAuth2::Client.new(Devise.omniauth_configs[:facebook].args[0], Devise.omniauth_configs[:facebook].args[1], :site => 'https://graph.facebook.com')
        access_token = OAuth2::AccessToken.new(consumer ,token)
      end
    end

    def twitter_access_token
      if self.user_tokens.find_by_provider("twitter")
        token = self.user_tokens.find_by_provider("twitter").token
        secret = self.user_tokens.find_by_provider("twitter").secret
        consumer = OAuth::Consumer.new(Devise.omniauth_configs[:twitter].args[0],Devise.omniauth_configs[:twitter].args[1],{:site => 'http://api.twitter.com',:scheme => :header} )
        access_token = OAuth::AccessToken.from_hash(consumer,{:oauth_token=>token,:oauth_token_secret=>secret})
      end
    end

    def linked_in_access_token
      if self.user_tokens.find_by_provider("linked_in")
        token = self.user_tokens.find_by_provider("linked_in").token
        secret = self.user_tokens.find_by_provider("linked_in").secret
        consumer = OAuth::Consumer.new(Devise.omniauth_configs[:linked_in].args[0],Devise.omniauth_configs[:linked_in].args[1],:site => 'http://api.linkedin.com')
        access_token = OAuth::AccessToken.from_hash(consumer,{:oauth_token=>token,:oauth_token_secret=>secret})
      end
    end

		def fb_status_feed
      if token = facebook_access_token
        @fb_status_feed ||= JSON.parse(token.get("/me/home?limit=10"))["data"]
      end
		end

		def tweets
      if token = twitter_access_token
        @tweets ||= JSON.parse(token.get("/1/statuses/home_timeline.json?count=10").body)
      end
		end

		def linkedin_social_stream
      if token = linked_in_access_token
        @li_Stream||= JSON.parse(token.get("/v1/people/~/network/updates?type=SHAR", 'x-li-format' => 'json').body)["values"]
      end
		end

    def facebook
      if token = facebook_access_token
        @facebook ||= JSON.parse(token.get("/me"))
      end
    end
    
    def twitter
      if token = twitter_access_token
        @twitter ||= JSON.parse(token.get("/account/verify_credentials.json").body)
      end
    end

		def linked_in
      if token = linked_in_access_token
        fields = ['id','first-name', 'last-name', 'picture-url', 'headline', 'public-profile-url','location:(name)'].join(',')
        @linked_in ||= JSON.parse(token.get("/v1/people/~:(#{fields})", 'x-li-format' => 'json').body)
      end
		end

		def myspace 
#			if token = authenticated_with?(:myspace)
#				@myspace ||= JSON.parse(token.get('http://api.myspace.com/v1/users/@me/profile'))
#			end
		end

    def google
#      @google ||= "" # todo
    end

    def get_facebook_friends_list
      if authenticated_with("facebook")
        fb_friends ||= JSON.parse(self.facebook_access_token.get("/me/friends"))["data"]
        return fb_friends
      end
    end

		def get_fb_name_from_id(id) 
      if token = facebook_access_token
        JSON.parse(token.get("/#{id}"))["name"]
      end
		end

    def post_on_fb(id)
      begin
				invited_token = self.invite_fb_users(get_fb_name_from_id(id))
        hay = self.facebook_access_token.post("/"+id.to_s+"/feed",:link=>"http://localhost.com/invitations/accept?invitation_token=#{invited_token}",:message=>"I am using this awesome website!")     
      rescue => msg
        puts "Exception occurred! " + msg.inspect
      end
    end


    
    # primitive profile to show what's possible
    def social_profile
#puts facebook.inspect + "&&&&&&&&&&&&&&&&&&&&&&&&"
      unless @social_profile
        @social_profile = if facebook
          {
            :id     => facebook["id"],
            :name   => facebook["name"],
						:first_name => facebook["first_name"],
						:last_name => facebook["last_name"],
            :photo  => "https://graph.facebook.com/#{facebook["id"]}/picture",
            :link   => facebook["link"],
            :title  => "Facebook",
						:email => facebook["email"],
						:company_name => (facebook["work"]) ? facebook["work"][0]["employer"]["name"] : "",
						:location => (facebook["location"]) ? facebook["location"]["name"] : "",
						:all_data => facebook
          }
        elsif twitter
          {
            :id     => twitter["id"],
            :name   => twitter["name"],
						:first_name => twitter["name"].split[0],
            :last_name   => (twitter["name"].split.length > 1) ? (twitter["name"].split[1] + (twitter["name"].split.length > 2 ? " "+twitter["name"].split[2]: "")) :  "",
            :photo  => twitter["profile_image_url"],
            :link   => "http://twitter.com/#{twitter["screen_name"]}",
            :title  => "Twitter",
						:location => twitter["location"],
						:all => twitter
          }
				elsif linked_in
					{
            :id     => linked_in["id"],
            :name   => linked_in["firstName"] + " " + linked_in["lastName"],
						:first_name => linked_in["firstName"],
            :last_name   => linked_in["lastName"],
            :photo  => linked_in["pictureUrl"],
            :link   => linked_in["publicProfileUrl"],
						:company_name => linked_in["headline"],
            :title  => "LinkedIn",
						:location => linked_in["location"]["name"],
						:all => linked_in
					}
				elsif myspace 
					{
						:id 		=> myspace["id"],
						:name		=> myspace["name"],
            :photo  => "/images/icons/google.png",
						:title	=> "Myspace"
					}
        else
          {
            :id     => "unknown",
            :name   => "User",
            :photo  => "/images/generic_profile.jpg",
            :link   => "/images/icons/google.png",
            :title  => "Google"
          }
        end
      end

      @social_profile
    end
    
  end
  
end
