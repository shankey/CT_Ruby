class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def new
    render 'new'
  end

  def create
    session_params = params[:session]
    user = User.verify_user(session_params[:email].downcase,
                            session_params[:password])
    if user
      logger.debug 'Successful Signin'
      # This is a hack, we need to figure out a streamlined way to login.
      cookies[:login]="1" 
      # To ensure that client can decide whether to call FB logout or not.
      cookies[:custom]="1" 
      log_in(user)
      redirect_to '/'
      # Login USER
    else
      logger.debug 'Unsuccessful attempt to signin'
      flash.now[:notice] = 'Invalid email/password combination' 
      render 'new'
    end
  end

  def destroy
    log_out
    render :nothing => true
  end
end
