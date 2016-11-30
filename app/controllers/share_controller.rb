class ShareController < ApplicationController
    include ShareHelper
    include DiskImageHelper
    
    
    skip_before_filter :verify_authenticity_token

    def story_picture_params
        params.permit(:picture, :caption, :story_id)
    end

    def previous_pictures
        logger.debug "Inside Previous Pictures"
        user = get_current_user
        if(user.blank?)
            #error that please login
            logger.debug "Blank User"
            return
        end

        puts "previous pictures"
        logger.debug params.inspect

        story_id = params[:story_id]
        logger.debug story_id
        sps = StoryPicture.where(travel_story_id: story_id)
        logger.debug sps.inspect

        picture_array = Array.new
        sps.each do |sp|
            pic = Picture.new
            pic.url = sp.picture.url(:medium_reduced)
            pic.caption = sp.caption
            pic.name = sp.picture_file_name
            pic.size = sp.picture_file_size
            pic.picture_id = sp.id

            picture_array << pic
        end

        logger.debug picture_array.to_json

        render :json => picture_array.to_json,
               :status => 200
    end

    def share
        puts "inside share"
        logger.debug "inside share "
        @user = get_current_user

        @user = define_sign_in_out_variables(@user)
        logger.debug @user
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



    def file_uploader
        user = get_current_user
        if(user.blank?)
            #error that please login
            return
        end

        logger.debug params.inspect
        sp = StoryPicture.new
        sp.travel_story_id = params[:story_id]
        sp.picture = params[:picture]
        sp.save

        logger.debug sp

        render :json => {:picture_id => sp.id}
    end

    def deleteFile
      user = get_current_user
      if(user.blank?)
          #error that please login
          return
      end

      existing_ts = TravelStory.find_by(user_id: user.id, completed: 0)
      uploaded_io = params[:file]
      story_path = get_story_path(user.id.to_s, existing_ts.id.to_s)
      delete_image(:story, story_path, params[:name])
      respond_to do |format|
        format.json { head :no_content }
      end
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
