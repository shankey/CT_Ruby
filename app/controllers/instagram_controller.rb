class InstagramController < ApplicationController
    require "sinatra"
    require 'instagram'
    
    CALLBACK_URL = "https://rails-tutorial-shankey.c9.io/instagram/callback"
    
    Instagram.configure do |config|
        config.client_id = "32d75da58d824c65a5500b736b5cd0e1"
        config.client_secret = "2931bd69ea94487aa9528d18fcbacb3e"
    end
    
    def ifttt_instagram
        client = Instagram.client(:access_token => "2261333272.32d75da.7abc589a414b493fa9ed2158f1987d8a")
        userMap = client.user_search("adinema")
        puts "user id = "+userMap.at(0).id.to_s
        
        client.follow_user(userMap.at(0).id)
        
        render :nothing => true
    end
    
    def connect
        redirect_to Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
    end
    
    def callback
        response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
        puts "access token " + response.access_token
        
        render :nothing => true
    end
    
    
    
end
