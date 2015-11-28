class ApplicationController < ActionController::Base
  include DisplayHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper :all

  def log_in(user)
    cookies.permanent[:external_id] = user.external_id
  end

  def set_token(token)
    cookies.permanent[:remember_token] = token
  end

  def get_remember_digest
    token = User.new_token
    set_token(token)
    User.digest(token)
  end

  def validate_incoming_request
    if(cookies[:remember_token].blank? || cookies[:external_id].blank?)
      return nil
    end
  end

  def verify_current_user
    if (cookies[:external_id].blank? || cookies[:remember_token].blank?)
      return nil
    end

    existing_user = User.find_by(external_id: cookies[:external_id])  
    if(existing_user.blank?)
      return nil
    else
      Rails.logger.info("id from db of exisitng user = "+existing_user.external_id+ " " + existing_user.remember_digest)
      if(BCrypt::Password.new(existing_user.remember_digest) == cookies[:remember_token])
        Rails.logger.info("remember digest verified "); 
        return existing_user
      end
    end
    return nil
  end

  def define_sign_in_out_variables(user)
    if(user.blank?)
      user = User.new
      @sign_in_out = "signin"
    else
      puts "profile picture image = "+@user.profile_pictures
      @sign_in_out = "signout"
    end
    @profile_image_display = get_log_in_display(user)
    return user
  end
end
