module CtControllerHelper
    
    
    def default_sign_in_name(user)
        if (user.blank? || user.name.blank?) 
            return "Sign In" 
        else 
            return user.name.split(" ")[0]
        end
    end
    
    def get_log_in_display(user)
        if (user.blank? || user.name.blank?)
            return "block"
        else
            return "none"
        end
    end
    
    def get_log_out_display(user)
        if (user.blank? || user.name.blank?)
            return "none"
        else
            return "block"
        end
    end
end
