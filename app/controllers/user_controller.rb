class UserController < ApplicationController
  def signup
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      logger.debug 'User save completed'
      redirect_to login_path 
    else
      flash.now[:notice] =
        @user.errors.full_messages.map{|m| "\t#{m}"}.join("\n")
      render 'signup'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name,
                                   :email,
                                   :password)
    end
end
