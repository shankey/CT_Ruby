module ShareHelper
    
    def get_last_draft_id
        user = get_current_user
        
        if(user.blank?)
            return
        end
        
        draft_ts = TravelStory.find_by(user_id: user.id, completed: 0)
        
        if(draft_ts.blank?)
            return
        else
            return draft_ts.id
        end
        
    end
    
    def get_saved_story(story_id)
        user = get_current_user

        if(user.blank?)
            return
        end
    
        if(story_id.blank?)
            return
        else
            existing_ts = TravelStory.find_by(user_id: user.id, id: story_id)
            if(existing_ts.blank?)
                return
            end
        end

        saved_story = SavedStory.new
        base_story_path = get_story_path(user.id.to_s, existing_ts.id.to_s)

        placeLocation = base_story_path.join("place")
        saved_story.place = File.exist?(placeLocation) ? File.read(placeLocation) : ""

        titleLocation = base_story_path.join("title")
        saved_story.title = File.exist?(titleLocation) ? File.read(titleLocation) : ""

        storyLocation = base_story_path.join("story")
        saved_story.story = File.exist?(storyLocation) ? File.read(storyLocation) : ""
    
        saved_story.story_id = existing_ts.id

        return saved_story
    end
    
    
    def get_story_path(dir_user, dir_story)
        Rails.root.join('stories', dir_user, dir_story)
    end
  
end
