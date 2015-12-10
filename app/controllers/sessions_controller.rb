class SessionsController < ApplicationController
  def new
    render 'new'
  end

  def create
    session_params = params[:session]
    user = User.verify_user(session_params[:email].downcase,
                            session_params[:password])
    if user
      logger.debug 'Successful Signin'
      redirect_to '/'
      # Login USER
    else
      logger.debug 'Unsuccessful attempt to signin'
      flash.now[:notice] = 'Invalid email/password combination' 
      render 'new'
    end
  end

  def destroy
    render 'new'
  end
end
