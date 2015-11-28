module CtControllerHelper
  extend ActiveSupport::Concern
  included do
   include DisplayHelper
  end

  def default_sign_in_name(user)
    if (user.blank? || user.name.blank?) 
      return "Sign In" 
    else 
      return user.name.split(" ")[0]
    end
  end

  def get_story_path(dir_user, dir_story)
    Rails.root.join('stories', dir_user, dir_story)
  end

  def get_saved_story(params)
    user = verify_current_user

    if(user.blank?)
      #error that please login
      return
    end

    existing_ts = TravelStory.find_by(user_id: user.id, completed: 0)
    if(existing_ts.blank?)
      return
    end

    saved_story = SavedStory.new
    base_story_path = get_story_path(user.id.to_s, existing_ts.id.to_s)

    placeLocation = base_story_path.join("place")
    saved_story.place = File.exist?(placeLocation) ? File.read(placeLocation) : ""

    titleLocation = base_story_path.join("title")
    saved_story.title = File.exist?(titleLocation) ? File.read(titleLocation) : ""

    storyLocation = base_story_path.join("story")
    saved_story.story = File.exist?(storyLocation) ? File.read(storyLocation) : ""

    return saved_story
  end
end
