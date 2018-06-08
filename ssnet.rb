require 'rubygems'

# If you're using bundler, you will need to add this
require 'bundler/setup'

require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

require './auth_user'
require './post'
require './edit_history'

module BlogMaker
  class BLOG < Sinatra::Base
    def initialize(post: Post.new, auth_user: Auth_user.new, edit_history: Edit_history.new)
      @auth_user = auth_user
      @post = post
      @edit_history = edit_history
      @au_visible = false
      super()
    end
    #when using class BLOG, need this to see the method flash see redirectwithflash on github
    register Sinatra::Flash
    helpers Sinatra::RedirectWithFlash
    enable :sessions
    before do
      if !session[:auth_user_id].nil?
        @au_visible = true
      end
    end
    get "/" do
      @posts = Post.order(:created_at)
      @title = "Welcome."
      erb :"posts/index"
    end
    get '/login' do
      erb :login
    end
    post '/login' do
      # only if passes test in auth_user
      #puts "request body is #{request.body.read}"
      #puts "params pwd is #{params[:password]} and email is #{params[:email]}"
      #for RSpec test JSON.parse() request.body.read )
      auth_user_credentials = params
      auth_user_result = @auth_user.authenticate(auth_user_credentials)
      if auth_user_result.has_key?('auth_user_id')
      ######begin for rack testing ########
        #response.set_cookie "auth_user_id", :value => auth_user_result['auth_user_id']
        #response.set_cookie "auth_user_authority",
        #  :value => auth_user_result['authority']
        #########end for rack testing###########
        #########begin web configuration ############
        session[:auth_user_id] = auth_user_result['auth_user_id']
        session[:auth_user_authority] = auth_user_result['auth_user_authority']
        #########end web configuration ############
        redirect '/posts/create'
      else
        #there is an error message in the auth_user_result if needed
        redirect '/login'
      end
    end
    get '/logout' do
      session.clear
      redirect '/'
    end
    get "/posts/create" do
      if session[:auth_user_id].nil?
        redirect '/login'
      end
     @title = "Create post"
     @post = Post.new
     erb :"posts/create"
    end
    post "/posts" do
      puts params.inspect
      new_post = params[:post]
      new_post["created_at"] = Time.now.to_s
      new_post["au_id"] = session[:auth_user_id]
      puts new_post.inspect
     @post = Post.new(new_post)
     #@post.valid?
     if @post.valid?
       @post.save
       redirect "posts/#{@post.id}", :notice => 'Congrats! Love the new post.'
     else
       redirect "posts/create", :error => 'Something went wrong. Try again.'
     end
    end
    get "/posts/:id" do
     @post = Post[params[:id].to_i]
     @title = @post.title
     erb :"posts/view"
    end
    # edit post
    get "/posts/:id/edit" do
      if session[:auth_user_id].nil?
        redirect '/login'
      end
      @post = Post[params[:id].to_i]
      @title = "Edit Form"
      erb :"posts/edit"
    end
    put "/posts/:id" do
      edit_time = Time.now
      updated_post = params[:post]
      updated_post["updated_at"] = edit_time
      edit_history = Hash.new
      edit_history["created_at"] = edit_time
      edit_history["post"] = params[:id]
      edit_history["au_id"] = session[:auth_user_id]
      @edit_history = Edit_history.new(edit_history)
      @post = Post[params[:id].to_i]
      if @post.valid? && @edit_history.valid?
        @post.update(updated_post)
        @edit_history.save
        redirect "/posts/#{@post.id}"
      else
        redirect "/post/#{params[:id]}/edit", :error => 'Something went wrong. Try again'
      end
    end
    helpers do
      include Rack::Utils
      alias_method :h, :escape_html
      def title
        if @title
          "#{@title}"
        else
          "Welcome."
        end
      end
    end
  end
end