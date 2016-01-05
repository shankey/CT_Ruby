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

  def get_resources_from_collection(collection_id)
    collections = Collection.where(collection_id: collection_id)
    puts collections
    if(collections.nil?)
      return nil
    end
    
    resource = Hash.new
    return_resource = Hash.new
    collections.each do |col|
      if(!resource[col.collection_type])
          resource[col.collection_type] = Array.new
      end
      
      resource[col.collection_type].push(col.resource_id)  
      
    end
    
    resource.each_key do |key|
      puts key
      case key
        when "STORY"
          return_resource["STORY"] = TravelStory.find(resource[key]).entries
        when "USER"
          return_resource["USER"] = User.find(resource[key]).entries
        else
          
      end
    end
    
    return return_resource
  end
  
  
end
