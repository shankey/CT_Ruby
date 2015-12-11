class CtControllerController < ApplicationController
  include CtControllerHelper
  require 'twitter'
  require 'thread'
  
  @@arrayFollow = Array.new

  skip_before_filter  :verify_authenticity_token

  def index
    @user = get_current_user
    logger.debug "Current User : #{@user} "
    @user = define_sign_in_out_variables(@user)
    @story_array = Array.new
    user = User.find_by(name: "Sheetal Virmani")
    TravelStory.where("user_id= #{user.id} AND live=1").each do |ts|
      
      @story_array.push(ts)
    end
    
      
  end

  def about
    @user = get_current_user
    @user = define_sign_in_out_variables(@user)
  end

  def contact
    @user = get_current_user
    @user = define_sign_in_out_variables(@user)
  end

  # Call during registeration or cookie expiration or logout which leads to cookie expiration
  def login_request
    #TODO validate incoming parameters
    client_user = User.new params.require(:user).permit(
      :user,
      :external_id,
      :name,
      :email,
      :access_token,
      :profile_pictures)
    client_user.password = "1"

    # This is to spam calls to api which will cause unwanted entries into database 

    existing_user = User.find_by(external_id: client_user.external_id)
    if existing_user.blank?
      client_user.save
    else
      # WHY IS THIS REQUIRED?
      existing_user.name = client_user.name

      # NO POINT SAVING THIS TOKEN - this is short lived.
      existing_user.access_token = client_user.access_token
      existing_user.email = client_user.email
      existing_user.profile_pictures = client_user.profile_pictures
      existing_user.save
    end
    log_in(client_user)
    render :nothing => true
  end
  
  def subscribe
  end
  
  def ifttt
    if(!params[:name].blank?)
      @@arrayFollow.push(params[:name])
    end
    
    if(!params[:tweet].blank?)
      ifttt_like
    end
    
    puts "current queue size = "+@@arrayFollow.size.to_s
    
    if(@@arrayFollow.size > 50)
      ifttt_follow
    end
    
    render :nothing => true
  end
  
  def ifttt_like
    client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "IGEpNQSbzPokonHlFQzAdGxOI"
        config.consumer_secret     = "jNhr5ITUsX9NQlpKtT6GtQb0Gtj33z6OBZtcUSioJr5IhK7F5E"
        config.access_token        = "4069963099-on9tZ6ZwxJxNSqoQvJzLLbjQs6fLO9FNF9HsJVg"
        config.access_token_secret = "1QKvMEpUy2ZVEn5xzQ49zbmIE6rdioRKEt8NJiYs8TQ9u"
    end
    
    if(!params[:tweet].blank?)
        uri = URI.parse(params[:tweet])
        index = uri.path.split('/').size - 1
        statusid = uri.path.split('/')[index];
        client.fav(statusid)
    end
  end
  
  def ifttt_follow
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "IGEpNQSbzPokonHlFQzAdGxOI"
      config.consumer_secret     = "jNhr5ITUsX9NQlpKtT6GtQb0Gtj33z6OBZtcUSioJr5IhK7F5E"
      config.access_token        = "4069963099-on9tZ6ZwxJxNSqoQvJzLLbjQs6fLO9FNF9HsJVg"
      config.access_token_secret = "1QKvMEpUy2ZVEn5xzQ49zbmIE6rdioRKEt8NJiYs8TQ9u"
    end

    client.follow(@@arrayFollow)
    logger.debug "Successful follow"
    @@arrayFollow.clear
  rescue Twitter::Error::TooManyRequests => error
    puts error
    puts "UNSUCCESSFUL"
  end
  
  def callback
    puts request.env['omniauth.auth']
    render :nothing => true
  end
end
