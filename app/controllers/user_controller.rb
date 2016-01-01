class UserController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def profile
    @user = get_current_user
    @user = define_sign_in_out_variables(@user)
    
    profile_user_id = params[:id]
    @profile_user = User.find_by(id: profile_user_id) or not_found
    logger.debug @profile_user
    @ts_array = TravelStory.where("user_id= #{params[:id]} AND live=1")
    
  end
  
  def edit_profile_save
    @user = get_current_user
    @user = define_sign_in_out_variables(@user)
    
    logger.debug params
    
    render :nothing => true , :status => 200
    
  end
  
  def edit_user_info
    @user = get_current_user
    @user = define_sign_in_out_variables(@user)
    
    
  end

  def create
    @user = User.new(user_params)
    if @user.save
      logger.debug 'User save completed'
      render :nothing => true
    else
      flash.now[:notice] =
        @user.errors.full_messages.map{|m| "\t#{m}"}.join("\n")
      render :json => {:errors => @user.errors.full_messages},
             :status => 422
    end
  end

  private
    def user_params
      params.require(:user).permit(:name,
                                   :email,
                                   :password)
    end
end
