class ImportContact::Facebook
  TEST_ACCESS = "2227470867|2.AQC2gbBPcckPGn2U.3600.1306501200.0-1509902962|cT8YnxBNuae4lmfpOKDq2-2yJvY"
  attr_accessor :user, :email, :password, :cookies, :user_info, :friends

  def initialize(user, options )
    @user, @cookies, @password, @email = user, options[:cookies], options[:password], options[:email]
  end

  def auth
    @user_info ||= begin
                     FbGraph::User.me(user.user_tokens.facebook.last.token).fetch
                   rescue
                     nil
                   end
    @user_info
  end

  def auth?
    auth.present?
  end

  def friends
    @friends ||= auth.friends.map{ |v|  { :name => v.name, :identifier => v.identifier, :picture => v.picture}  }
    @friends
  end

  class << self
    def auth_mechanize?(auth_params)
      @agent = Mechanize.new { |a| a.log = Rails.logger }
      @page = @agent.get("http://www.facebook.com/login.php")
      @login_form = @page.forms[0]
      @login_form.email = auth_params[:email]
      @login_form.pass  = auth_params[:password]
      @page = @agent.submit(@login_form)
      @page.link_with( :text => 'Logout' ) ? true : false
    end

    def import(user, options)
      @facebook_connect = new(user, options)
      @friends = @facebook_connect.auth.friends.map{ |v|  options[:contact_uids].include?(v.identifier.to_s) ? v : nil }.compact
      @agent = Mechanize.new { |a| a.log = Rails.logger }
      @page = @agent.get("http://www.facebook.com/login.php")
      @login_form = @page.forms[0]
      @login_form.email = options[:email]
      @login_form.pass  = options[:password]
      @page = @agent.submit(@login_form)

      @contacts = []
        @friends.map do |friend|
        @info = friend.fetch
        #@info_link = @info.link =~ /\?/ ? "#{@info.link}&sk=info" : "#{@info.link}?sk=info"
        @info_link = "http://www.facebook.com/profile.php?id="+@info.identifier+"&sk=info"
        @page = @agent.get(@info_link.gsub("http", "https"))
        @email = @page.body.to_s.match(/([\w\.%\+\-]+)&#64;([\w\-]+\.)+([\w]{2,})/).to_s.to_s.gsub('&#64;', '@')
        if @email.present?
          @contacts << Contact.add_contact(user, { :email => @email, :name => @info.name, :skip_invitation => true})
        end
      end
    end


  end # end class << self

end
