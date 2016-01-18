class Trackodoro < Sinatra::Base
  #register Sinatra::Reloader if CONFIG['development']


  ###
  ### PUBLIC SIDE
  ###

  get '/' do
    if warden_handler.authenticated?
      redirect "/home"
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
    session[:temp] = "Invalid username or password"
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

  get "/home" do
    check_authentication
    @user = User[current_user]
    now = Time.now()
    @chart_data = {
      # CAREFUL NO SUPPORT FOR NEW YEAR !!
      week_pomodoros: @user.pomodoros.map{|p| p.h.year==now.year && p.h.yday.between?(now.yday, now.yday-6) },
      week_dates: (Array.new(7) {|d| (now-86400*d)}).reverse,
    }
    erb :'users/index', :layout => :'users/layout'
  end

  post "/add" do
    check_authentication
    puts Time.at(params[:day].to_i)
    User[current_user].add_pomodoro(Pomodoro.new(:h => Time.at(params[:day].to_i)))
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
