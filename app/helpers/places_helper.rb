module PlacesHelper
    
    def get_place_url(params)
        url = '/places/' + params[:id]
        puts url
        return url
    end
    
    def get_story_partial_path(story_id)
        url = "/places/" + story_id + "/"
        puts url
        return url
    end
    
    
    def get_r_place_title_path(story_id)
        url = get_story_partial_path(story_id) + 'title.html.erb'
        puts url
        return url
    end
    
    def get_r_place_story_path(story_id)
        url = get_story_partial_path(story_id) + 'story.html.erb'
        puts url
        return url
    end
    
    def get_r_place_location_path(story_id)
        url = get_story_partial_path(story_id) + 'location.html.erb'
        puts url
        return url
    end
    
    def get_r_place_about_path(story_id)
        url = get_story_partial_path(story_id) + 'about.html.erb'
        puts url
        return url
    end
    
    def get_r_place_reach_path(story_id)
        url = get_story_partial_path(story_id) + 'reach.html.erb'
        puts url
        return url
    end
    
    def get_r_place_besttime_path(story_id)
        url = get_story_partial_path(story_id) + 'besttime.html.erb'
        puts url
        return url
    end
    
    def get_r_place_attractions_path(story_id)
        url = get_story_partial_path(story_id) + 'attractions.html.erb'
        puts url
        return url
    end
    
    def get_r_place_reach_path(story_id)
        url = get_story_partial_path(story_id) + 'reach.html.erb'
        puts url
        return url
    end
    
    def get_r_place_gallery_path(story_id)
        url = get_story_partial_path(story_id) + 'gallery.html.erb'
        puts url
        return url
    end
    
    def get_r_place_stay_path(story_id)
        url = get_story_partial_path(story_id) + 'stay.html.erb'
        puts url
        return url
    end
end
