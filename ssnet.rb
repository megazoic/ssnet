require 'rubygems'

# If you're using bundler, you will need to add this
require 'bundler/setup'

require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

#require './auth_user'
require './post'

module BlogMaker
  class BLOG < Sinatra::Base
    def initialize(post: Post.new)#, auth_user: Auth_user.new)
      #@auth_user = auth_user
      @post = post
      super()
    end
    #when using class BLOG, need this to see the method flash see redirectwithflash on github
    register Sinatra::Flash
    helpers Sinatra::RedirectWithFlash
    enable :sessions
    get "/" do
      @posts = Post.order(:created_at)
      @title = "Welcome."
      erb :"posts/index"
    end
    get "/posts/create" do
     @title = "Create post"
     @post = Post.new
     erb :"posts/create"
    end
    post "/posts" do
      puts params.inspect
      new_post = params[:post]
      new_post["created_at"] = Time.now.to_s
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
      @post = Post[params[:id].to_i]
      @title = "Edit Form"
      erb :"posts/edit"
    end
    put "/posts/:id" do
      updated_post = params[:post]
      updated_post["updated_at"] = Time.now
      @post = Post[params[:id].to_i]
      @post.update(updated_post)
      #@post.valid?
      redirect "/posts/#{@post.id}"
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