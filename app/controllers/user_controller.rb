class UserController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    @user = User.new(user_params)
    if @user.save
      logger.debug 'User save completed'
      render :nothing => true
    else
      flash.now[:notice] =
        @user.errors.full_messages.map{|m| "\t#{m}"}.join("\n")
      raise 'Unauthorized login' 
    end
  end

  private
    def user_params
      params.require(:user).permit(:name,
                                   :email,
                                   :password)
    end
end
