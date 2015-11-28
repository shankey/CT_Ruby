module ApplicationHelper
    def blank_on_nil (string)
        if(string.blank?)
            return ""
        end
        return string
    end
end
