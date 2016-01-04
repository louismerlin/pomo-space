class Trackodoro < Sinatra::Base
  register Sinatra::Reloader if CONFIG['development']
  use Rack::Session::Cookie

  ###
  ### PUBLIC SIDE
  ###


  get '/' do
    erb :'public/index', :layout => :'public/layout'
  end

  get "/protected_pages" do
    check_authentication
    erb :'public/admin_only_page', :layout => :'public/layout'
  end

  get "/login" do
    erb :'public/login', :layout => :'public/layout'
  end

  post "/session" do
    warden_handler.authenticate!
    if warden_handler.authenticated?
      redirect "/users/#{warden_handler.user.id}"
    else
      redirect "/"
    end
  end

  get "/logout" do
    warden_handler.logout
    redirect '/login'
  end

  post "/unauthenticated" do
    redirect "/"
  end

  get "/signup" do
    erb :'public/signup', :layout => :'public/layout'
  end

  post "/signup" do
    @user = User.new(:email => params["email"], :password => params["password"])
    @user.save
    redirect "/login"
  end


  ###
  ### USER MANAGEMENT
  ###

  use Warden::Manager do |manager|
    manager.default_strategies :password
    manager.failure_app = Trackodoro
    manager.serialize_into_session {|user| user.id}
    manager.serialize_from_session {|id| User.get(id)}
  end

  Warden::Manager.before_failure do |env,opts|
    env['REQUEST_METHOD'] = 'POST'
  end

  Warden::Strategies.add(:password) do
    def valid?
      params["email"] || params["password"]
    end

    def authenticate!
      user = User.first(:email => params["email"])
      if user && user.authenticate(params["password"])
        success!(user)
      else
        fail!("Could not log in")
      end
    end
  end

  def warden_handler
    env['warden']
  end

  def check_authentication
    unless warden_handler.authenticated?
      redirect '/login'
    end
  end

  def current_user
    warden_handler.user
  end

  ###
  ### DATABASE
  ###

  class User
    include DataMapper::Resource
    include BCrypt

    property :id, Serial, :key => true
    property :email, String, :length => 3..50
    property :password, BCryptHash

    def authenticate(attempted_password)
        if self.password == attempted_password
          true
        else
          false
        end
      end

  end

  DataMapper.finalize
  DataMapper.auto_upgrade!


end
