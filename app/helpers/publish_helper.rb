module PublishHelper
    
    def get_story_folder(story_id)
        url = Rails.root.join('app','views','places', story_id.to_s)
        puts url
        return url
    end
    
    def get_unpublished_story_folder(user_id, story_id)
        url = Rails.root.join('stories',story_id, user_id)
        puts url
        return url
    end
    
    def get_image_story_folder(story_id)
        url = Rails.root.join('public','images', story_id)
        puts url
        return url
    end
    
    
    def get_template_folder()
        url = Rails.root.join('app','template')
        puts url
        return url
    end
    
    def get_relative_image_path()
        #url = "../images/Ananthagiri_images/Ananta%20Padmanabhaswamy%20Temple.jpg" data-lightbox="roadtrip" data-title="Beautiful Anantha Padmanabhaswamy Temple at Ananthagiri"><img src="../images/Ananthagiri_images/Ananta%20Padmanabhaswamy%20Temple.jpg"
        puts url
        return url
    end
    
    def get_place_title_path(story_id)
        url = get_story_folder(story_id) + 'title.html.erb'
        puts url
        return url
    end
    
    def get_place_story_path(story_id)
        url = get_story_folder(story_id) + 'story.html.erb'
        puts url
        return url
    end
    
    def get_place_location_path(story_id)
        url = get_story_folder(story_id) + 'location.html.erb'
        puts url
        return url
    end
    
    def get_place_about_path(story_id)
        url = get_story_folder(story_id) + 'about.html.erb'
        puts url
        return url
    end
    
    def get_place_reach_path(story_id)
        url = get_story_folder(story_id) + 'reach.html.erb'
        puts url
        return url
    end
    
    def get_place_besttime_path(story_id)
        url = get_story_folder(story_id) + 'besttime.html.erb'
        puts url
        return url
    end
    
    def get_place_attractions_path(story_id)
        url = get_story_folder(story_id) + 'attractions.html.erb'
        puts url
        return url
    end
    
    def get_place_reach_path(story_id)
        url = get_story_folder(story_id) + 'reach.html.erb'
        puts url
        return url
    end
    
    def get_place_gallery_path(story_id)
        url = get_story_folder(story_id) + 'gallery.html.erb'
        puts url
        return url
    end
    
    def get_place_stay_path(story_id)
        url = get_story_folder(story_id) + 'stay.html.erb'
        puts url
        return url
    end
end
