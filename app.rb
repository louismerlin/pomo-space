class Trackodoro < Sinatra::Base
  register Sinatra::Reloader if CONFIG['development']

  get '/' do
    erb :'public/index', :layout => :'public/layout'
  end

end
