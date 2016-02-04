class PomoSpace < Sinatra::Base
  register Sinatra::Reloader if CONFIG['development']


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
      @user = User.new(:email => params["email"])
      @user.password = params["password"]
      @user.password_confirmation = params["password"] # yes I know....
      @user.activated = false
      @user.save
      confirm_mail(params) if !CONFIG['development']
    end
    redirect "/thankyou"
  end

  get "/thankyou" do
    erb :'public/thankyou', :layout => :'public/layout'
  end


  ###
  ### ADMIN SIDE
  ###

  get "/dashboard" do
    @users = User.where(:activated => false)
    erb :'admin/dashboard', :layout => :'admin/layout'
  end

  def confirm_mail(params)
    Pony.mail(:charset => 'utf-8', :to => "#{CONFIG['confirm_mail_to']}", :from => "#{CONFIG['confirm_mail_from']}", :subject => 'Confirm Him', :body => 'Can you confirm him ?', :via => :sendmail)
  end


  ###
  ### USER SIDE - See '/' for index
  ###

  get "/home" do
    check_authentication
    @user = User[current_user]
    now = Time.now()
    @chart_data = {
      week_pomodoros: @user.pomodoros.select{|p| p.h.year==now.year && p.h.yday.between?(now.yday-6, now.yday) },
      week_yday: (Array.new(7) {|d| (now-86400*d).yday}).reverse,
      week_dates: (Array.new(7) {|d| (now-86400*d)}).reverse,
    }
    erb :'users/index', :layout => :'users/layout'
  end

  post "/add" do
    check_authentication
    p_time_a = Time.at(params[:day].to_i).to_a
    p_time_a[0] = 0
    p_time_a[1] = 0
    p_time_a[2] = params[:hour].to_i
    p_time = Time.local(*p_time_a)
    puts params[:tag]==""
    User[current_user].add_pomodoro(Pomodoro.new(:h => p_time))
    redirect back
  end


  ###
  ### USER MANAGEMENT
  ###

  use Warden::Manager do |manager|
    manager.default_strategies :password
    manager.failure_app = PomoSpace
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
