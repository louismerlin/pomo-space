class Trackodoro < Sinatra::Base
  #register Sinatra::Reloader if CONFIG['development']


  ###
  ### PUBLIC SIDE
  ###

  get '/' do
    if warden_handler.authenticated?
      @user = User[current_user]
      erb :'users/index', :layout => :'users/layout'
    else
      @users = User.all
      erb :'public/index', :layout => :'public/layout'
    end
  end

  get "/login" do
    session[:temp]!=nil ? @message = session.delete(:temp) : nil
    redirect '/home' if warden_handler.authenticated?
    erb :'public/login', :layout => :'public/layout'
  end

  post "/session" do
    warden_handler.authenticate!
    if warden_handler.authenticated?
      redirect "/"
    else
      redirect "/login"
    end
  end

  get "/logout" do
    warden_handler.logout
    redirect '/'
  end

  post "/unauthenticated" do
    session[:temp] = "Wrong username or password"
    redirect "/login"
  end

  get "/signup" do
    erb :'public/signup', :layout => :'public/layout'
  end

  post "/signup" do
    if(params["email"].match(/\A[^@]+@[^@]+\Z/))
      # Add :activated = false, and send mail to confirm
      @user = User.new(:email => params["email"])
      @user.password = params["password"]
      @user.password_confirmation = params["password"] # yes I know....
      @user.save
    end
    redirect "/login"
  end


  ###
  ### USER SIDE - See '/' for index
  ###

  post "/add" do
    check_authentication
    p_time = Time.new().to_a
    p_time[0] = "0"
    p_time[1] = params[:minute].to_s
    p_time[3] = params[:day].to_s
    puts Time.local(*p_time)
    User[current_user].add_pomodoro(Pomodoro.new(:h => Time.local(*p_time)))
    redirect back
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
      if user!=nil && user.authenticate(params["password"])!=nil
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

end
