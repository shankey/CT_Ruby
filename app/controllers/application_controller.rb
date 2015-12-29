class ApplicationController < ActionController::Base
  include DisplayHelper
  include UserHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper :all

  def log_in(user)
    if cookies[:login] == "1"
      if user.external_id
        session[:current_user_id] = user.external_id
      else
        session[:current_user_email] = user.email
      end
      cookies[:noautologin]="0" 
    else
      log_out
    end
  end

  def log_out
    cookies[:login] = "0"
    if session[:current_user_email]
      cookies[:noautologin]="0" 
    end
    cookies[:custom] = "0"
    reset_session
  end

  def is_logged_in
    return session[:current_user_id] || session[:current_user_email]
  end

  def get_current_user 
    if cookies[:login] != "1"
      return nil
    end

    if !is_logged_in
      return nil
    end

    # Look by external id first.
    existing_user = nil
    if session[:current_user_id]
      existing_user = User.find_by(
        external_id: session[:current_user_id])  
    end


    # Look by email id next.
    if !existing_user || existing_user.blank?
      existing_user = User.find_by(
        email: session[:current_user_email])  
    end
    if existing_user.blank?
      return nil
    else
      return existing_user
    end
  end

  def define_sign_in_out_variables(user)
    if(user.blank?)
      user = User.new
      @sign_in_out = "signin"
    else
      logger.debug @user.profile_pictures
      @sign_in_out = "signout"
    end
    @profile_image_display = get_log_out_display(user)
    return user
  end
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
