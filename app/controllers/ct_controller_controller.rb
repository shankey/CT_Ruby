class CtControllerController < ApplicationController
  
  
  skip_before_filter  :verify_authenticity_token
  
  def index
    puts "inside index"
    @user = verify_current_user
    @user = define_sign_in_out_variables(@user)
    
  end
  
  def about
    puts "inside aboutus"
    @user = verify_current_user
    @user = define_sign_in_out_variables(@user)
    
  end
  
  def contact
    puts "inside contact"
    @user = verify_current_user
    @user = define_sign_in_out_variables(@user)
    
  end
 
  def share
    @user = verify_current_user
    @user = define_sign_in_out_variables(@user)
  end
  
  # Call during registeration or cookie expiration or logout which leads to cookie expiration
  def login_request
    #TODO validate incoming parameters
    client_user = User.new params.require(:user).permit(:user, :external_id, :name, :email, :access_token, :profile_pictures)
    client_user.remember_digest = get_remember_digest
    client_user.password = "1";
    
    puts "name = " + client_user.name
    
    puts "external_id = " + client_user.external_id
    
    
    # make facebook call and see if access token is valid. TODO
    # This is to spam calls to api which will cause unwanted entries into database 
    
    
    existing_user = User.find_by(external_id: client_user.external_id);
    
    if existing_user.blank?
      client_user.save
    else
      existing_user.name = client_user.name
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
    user = verify_current_user
    
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

    
    FileUtils.mkdir_p(get_story_path(user.id.to_s, existing_ts.id.to_s)) unless File.exists?(get_story_path(user.id.to_s, existing_ts.id.to_s))
    File.open(get_story_path(user.id.to_s, existing_ts.id.to_s).join("title"), 'wb') do |file|
      file.write(params[:title])
    end
    
    puts params
    
    render :nothing => true
  end
  
  def placeUploader
    user = verify_current_user
    
    if(user.blank?)
      #error that please login
      return
    end
    
    existing_ts = TravelStory.find_by(user_id: user.id, completed: 0)
    
    FileUtils.mkdir_p(get_story_path(user.id.to_s, existing_ts.id.to_s)) unless File.exists?(get_story_path(user.id.to_s, existing_ts.id.to_s))
    File.open(get_story_path(user.id.to_s, existing_ts.id.to_s).join("place"), 'wb') do |file|
      file.write(params[:place])
    end
    

    
    render :nothing => true
  end
  
  
  def storyUploader
    
    puts params
    
    user = verify_current_user
    
    if(user.blank?)
      #error that please login
      return
    end
    
    existing_ts = TravelStory.find_by(user_id: user.id, completed: 0)
    
    FileUtils.mkdir_p(get_story_path(user.id.to_s, existing_ts.id.to_s)) unless File.exists?(get_story_path(user.id.to_s, existing_ts.id.to_s))
    File.open(get_story_path(user.id.to_s, existing_ts.id.to_s).join("story"), 'wb') do |file|
      file.write(params[:story])
    end
    
    if(params[:draft].blank?)
      existing_ts.completed = 1;
      existing_ts.save
    end
    UserMailer.welcome_email(existing_ts).deliver_now
    
    puts params
    
    render :nothing => true
  end
  
  def fileUploader
    user = verify_current_user
    
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
  
    def log_in(user)
        cookies.permanent[:external_id] = user.external_id
    end
    
    def set_token(token)
        cookies.permanent[:remember_token] = token
    end
    
    def get_remember_digest
        token = User.new_token
        set_token(token)
        User.digest(token)
    end
    
    def validate_incoming_request
      if(cookies[:remember_token].blank? || cookies[:external_id].blank?)
        return nil
      end
    end
    
    
    
    
    def verify_current_user
        
        if (cookies[:external_id].blank? || cookies[:remember_token].blank?)
            return nil
        end
        
        existing_user = User.find_by(external_id: cookies[:external_id])  
      
        if(existing_user.blank?)
          return nil
        else
          Rails.logger.info("id from db of exisitng user = "+existing_user.external_id)
          if(BCrypt::Password.new(existing_user.remember_digest) == cookies[:remember_token])
            Rails.logger.info("remember digest verified "); 
            return existing_user
          end
        end
        
        return nil
    end
  
  def get_story_path(dir_user, dir_story)
    Rails.root.join('stories', dir_user, dir_story)
  end
    
  def define_sign_in_out_variables(user)
    if(!(user.blank?))
      
      puts "profile picture image = "+@user.profile_pictures
      @profile_image_display = "block"
      @sign_in_out = "signout"
      return user
    else
      user = User.new
      @profile_image_display = "none"
      @sign_in_out = "signin"
      return user
    end
  end

end
