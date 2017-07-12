require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'active_record'
require 'bcrypt'
require_relative 'db_config'
require_relative 'models/user'

enable :sessions

helpers do
	def logged_in?
		if current_user
			true
		else
			false
		end
	end
	def current_user
		User.find_by(id: session[:user_id])
	end
end

get "/" do
  redirect "/login"
end

get "/login" do
  erb :index
end

post "/session" do
  user = User.find_by( email: params[:email] )
  if user
    success = user.authenticate(params[:password])
    if success
			session[:user_id] = user.id
			session[:user_name] = "#{user.firstname} #{user.lastname}"
      redirect "/users/#{user.id}/home"
    else
		  @error = "An error occurred. Please check your login credentials and try again."
      erb :index
    end
  else
		@error = "An error occurred. Please check your login credentials and try again."
    erb :index
  end
end

delete "/session" do
	session[:user_id] = ""
  redirect "/login"
end

get "/users/new" do
  erb :account
end

get "/users/:user_id/home" do
  @message = "This will be the first screen the logged in user sees."
  erb :home
end

post "/users" do
  pass = params[:password]
  pass_confirmation = params[:password_confirm]
  email = params[:email]
	firstname = params[:firstname]
	lastname = params[:lastname]
  existing_user = User.find_by(email: email)
  if !existing_user
    if pass == pass_confirmation
      new_user = User.new(email: email, password: pass, firstname: firstname, lastname: lastname)
      new_user.save
			session[:user_id] = new_user.id
			session[:user_name] = "#{new_user.firstname} #{new_user.lastname}"
      redirect "/users/#{new_user.id}/home"
    else
      @error = "The entered passwords do not match."
      erb :account
    end
  else
    @error = "An error occurred. Please contact the site administrator."
    erb :account
  end
end
