module CtControllerHelper
    
    def default_sign_in_name(user)
        if (user.blank? || user.name.blank?) 
            return "Sign In" 
        else 
            return user.name.split(" ")[0]
        end
    end
end
