module ApplicationHelper
    def blank_on_nil (string)
        if(string.blank?)
            return ""
        end
        return string
    end
    
    def default_blog_cover_on_nil (string)
        if(string.blank?)
            return "../images/banner3-new2.jpg"
        end
        return string
    end
    
    def default_blog_name_on_nil (blogname, username)
        if(blogname.blank?)
            return username.camelize+"'s Travel Blog"
        end
        return blogname
    end
    
    def get_tile_title(story)
        return story.title || blank_on_nil(story.location).upcase
    end
end
