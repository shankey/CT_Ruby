class UserController < ApplicationController
  def signup
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    p user_params
    if @user.save
      redirect_to login_path 
    else
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
