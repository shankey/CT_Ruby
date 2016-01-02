class ShareController < ApplicationController
    include ShareHelper
    
    
    skip_before_filter :verify_authenticity_token  
    
    def share
        @user = get_current_user
        @user = define_sign_in_out_variables(@user)
        
        #the first call will not have a storyid in DOM structure
        if(params[:storyid])
            @saved_story = get_saved_story(params[:storyid])
        else
        #storyid retrieved from DOM structure
            storyid = get_last_draft_id
            @saved_story = get_saved_story(storyid)
        end
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
        existing_ts.location = params[:place]
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
            file.write(URI.unescape(params[:story]))
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
    
    def discardStory
        if(params[:storyid].blank?)
            return
        end
        
        ts = TravelStory.find_by(id: params[:storyid]);
        ts.completed = -1;
        ts.save
        
        render :nothing => true, :status => 200, :content_type => 'text/html'
    end
    
end
