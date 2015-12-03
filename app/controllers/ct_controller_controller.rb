class CtControllerController < ApplicationController
  include CtControllerHelper

  skip_before_filter  :verify_authenticity_token

  def index
    @user = get_current_user
    @user = define_sign_in_out_variables(@user)
  end

  def about
    @user = get_current_user
    @user = define_sign_in_out_variables(@user)
  end

  def contact
    @user = get_current_user
    @user = define_sign_in_out_variables(@user)
  end



  # Call during registeration or cookie expiration or logout which leads to cookie expiration
  def login_request
    #TODO validate incoming parameters
    client_user = User.new params.require(:user).permit(
      :user,
      :external_id,
      :name,
      :email,
      :access_token,
      :profile_pictures)
    client_user.password = "1"

    # This is to spam calls to api which will cause unwanted entries into database 

    existing_user = User.find_by(external_id: client_user.external_id);
    if existing_user.blank?
      client_user.save
    else
      # WHY IS THIS REQUIRED?
      existing_user.name = client_user.name

      # NO POINT SAVING THIS TOKEN - this is short lived.
      existing_user.access_token = client_user.access_token
      existing_user.email = client_user.email
      existing_user.profile_pictures = client_user.profile_pictures
      existing_user.save
    end
    log_in(client_user)
    render :nothing => true
  end

end
