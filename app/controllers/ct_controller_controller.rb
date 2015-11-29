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

  def share
    @user = get_current_user
    @user = define_sign_in_out_variables(@user)
    @saved_story = get_saved_story(params)
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
      existing_user.remember_digest = client_user.remember_digest
      existing_user.profile_pictures = client_user.profile_pictures
      existing_user.save
    end
    log_in(client_user)
    render :nothing => true
  end

  def titleUploader
    user = get_current_user 

    if(user.blank?)
      #error that please login
      return
    end

    existing_ts = TravelStory.find_by(user_id: user.id, completed: 0)
    if(existing_ts.blank?)
      existing_ts = TravelStory.new
      existing_ts.completed = 0;
      existing_ts.user_id = user.id
      existing_ts.save
    end

    base_path = get_story_path(user.id.to_s, existing_ts.id.to_s)

    FileUtils.mkdir_p(base_path) unless File.exists?(base_path)
    File.open(base_path.join("title"), 'wb') do |file|
      file.write(params[:title])
    end

    render :nothing => true
  end

  def placeUploader
    user = get_current_user

    if(user.blank?)
      #error that please login
      return
    end
    existing_ts = TravelStory.find_by(user_id: user.id, completed: 0)

    base_path = get_story_path(user.id.to_s, existing_ts.id.to_s)
    FileUtils.mkdir_p(base_path) unless File.exists?(base_path)
    File.open(base_path.join("place"), 'wb') do |file|
      file.write(params[:place])
    end
    render :nothing => true
  end

  def storyUploader
    user = get_current_user

    if(user.blank?)
      #error that please login
      return
    end

    existing_ts = TravelStory.find_by(user_id: user.id, completed: 0)

    base_path = get_story_path(user.id.to_s, existing_ts.id.to_s)
    FileUtils.mkdir_p(base_path) unless File.exists?(base_path)
    File.open(base_path.join("story"), 'wb') do |file|
      file.write(params[:story])
    end

    if(params[:draft].blank?)
      existing_ts.completed = 1;
      existing_ts.save
    end
    UserMailer.welcome_email(existing_ts).deliver_now
    render :nothing => true
  end

  def fileUploader
    user = get_current_user

    if(user.blank?)
      #error that please login
      return
    end

    existing_ts = TravelStory.find_by(user_id: user.id, completed: 0)
    uploaded_io = params[:file]
    File.open(get_story_path(user.id.to_s, existing_ts.id.to_s).join(uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    tempfile = params[:file].tempfile.path
    if File::exists?(tempfile)
      File::delete(tempfile)
    end
    render :nothing => true
  end
end
