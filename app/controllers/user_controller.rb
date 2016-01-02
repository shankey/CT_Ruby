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
    
    logger.debug params[:user][:profile_pictures]
    logger.debug params[:user][:name]
    logger.debug params[:user][:email]
    
    @updated_user = User.find(@user.id)
    
    if(params[:user][:name])
      @updated_user.name = params[:user][:name]
    end
    
    if(params[:user][:email])
      @updated_user.email = params[:user][:email]
    end
    
    if(params[:user][:profile_pictures])
      uploaded_io = params[:user][:profile_pictures]
    
      base_user_directory = Rails.root.join('public', 'users', @user.id.to_s)
      FileUtils.mkdir_p(base_user_directory) unless File.exists?(base_user_directory)
    
      extension = uploaded_io.original_filename.split(".")[uploaded_io.original_filename.split(".").size - 1]
      profie_picture_upload_location = base_user_directory.join(@user.id.to_s+"_image."+extension)
      profie_picture_upload_html_location = File.join('users', @user.id.to_s, @user.id.to_s+"_image."+extension)
    
      File.open(profie_picture_upload_location, 'wb') do |file|
        file.write(uploaded_io.read)
      end
      
      @updated_user.profile_pictures = profie_picture_upload_html_location.to_s
    end
    
    
    
    @updated_user.save
    
    redirect_to '/edit_user_info'
    
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
