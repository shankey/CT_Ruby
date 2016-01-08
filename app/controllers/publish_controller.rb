class PublishController < ApplicationController
    include PublishHelper
    
    skip_before_filter :verify_authenticity_token
    
    def update_travel_story
        logger.debug params
        
        ts= TravelStory.find(params[:travel_story][:travel_story_id])
        ts.live = params[:travel_story][:live]
        ts.save
        
        render :json => {:message => "Live updated success"},
             :status => 200
    end
    
    def collection
       @collections = Collection.all.entries
       @collections.push(Collection.new)
    end
    
    def collection_update
        logger.debug params
        if(params[:collection][:id] && !params[:collection][:id].nil? && params[:collection][:id]!="")
            cl = Collection.find(params[:collection][:id])
        else
            cl = Collection.new
        end
        
        cl.resource_id = params[:collection][:resource_id]
        cl.collection_type = params[:collection][:collection_type]
        cl.collection_id = params[:collection][:collection_id]
        cl.save
        
        if(params[:collection][:collection_type] == "USER" && params[:collection][:user_tile_picture]!=nil)
            @user_ts = User.find(params[:collection][:resource_id])
        
            uploaded_io = params[:collection][:user_tile_picture]
            base_user_directory = Rails.root.join('public', 'users', @user_ts.id.to_s)
            FileUtils.mkdir_p(base_user_directory) unless File.exists?(base_user_directory)
    
            profie_picture_upload_location = base_user_directory.join(uploaded_io.original_filename)
            profie_picture_upload_html_location = File.join('/users', @user_ts.id.to_s, uploaded_io.original_filename)
    
            File.open(profie_picture_upload_location, 'wb') do |file|
                file.write(uploaded_io.read)
            end
            
            puts @user_ts.id
            puts profie_picture_upload_html_location
            @user_ts.user_tile_picture = profie_picture_upload_html_location
            @user_ts.save
            
            
         end
         
         render :json => {:message => "Collection updated success"},
             :status => 200
    end
    
    def all_images
        
        story_id = params[:story_id]
        base_image_folder = get_image_story_folder(story_id)
        if(!File.exists?(base_image_folder))
            render :nothing => true
        end
        
        @image_hash = Hash.new
        
        image_names = Dir.entries(base_image_folder.to_s)
        image_names.delete(".")
        image_names.delete("..")
        image_names.each do |image|
            
            if(image.start_with?("_"))
                next
            end
            
            @image_hash["/images/"+story_id + "/" +image] = "../images/"+story_id + "/" +image
            
        end
        
    end
    
    def attach_stories
        @users = User.all
        @user_array = Array.new
        @users.each do |key|
            if (key!=nil || key.name != nil)
                @user_array.push(key)
            end
        end
        
        @user_array.each do |key|
            puts key.name
        end
        
        @tss = TravelStory.all
        @ts_array = Array.new
        @tss.each do |key|
            if (key!=nil || key.location != nil)
                @ts_array.push(key)
            end
        end
        
        @ts_array.each do |key|
            puts key.location
        end
        
        puts @ts_array
    end
    
    def attach_stories_save
        puts params
        
        ts = TravelStory.find(params[:id])
        ts.user_id = params[:user_id]
        ts.save
        
        
        render :nothing => true
    end
    
    def all_user
        @user_array = Array.new
        User.all.each do |user|
            if(user.name.blank?)
                next
            end
            @user_array.push(user)
        end
    end
    
    def all_stories
        @story_array = Array.new
        TravelStory.where(user_id: params[:user_id]).each do |ts|
            base_path = get_story_folder(ts.id)
            location = ""
            if(File.exists?(base_path))
                if(File.exists?(base_path.join("_location.html.erb")))
                    location = File.read(base_path.join("_location.html.erb"))
                end
                ts.published = true
            else
                ts.published = false
            end
            ts.location = location
            @story_array.push(ts)
        end
    end
    
    
    
    def if_blank_partial_then_template(partial, partial_name, story_id)
        template_folder = get_template_folder
        if(partial.strip.blank?)
            return File.read(template_folder.to_s + "/" + partial_name)
        end
        
        return partial
        
    end
    
    def get_edit_story_object(story_id)
        est = EditStoryTemplate.new
        base_path = get_story_folder(story_id)
        est.about = if_blank_partial_then_template(File.read(base_path.join("_about.html.erb")), "about", story_id)
        est.attractions = if_blank_partial_then_template(File.read(base_path.join("_attractions.html.erb")), "attractions", story_id)
        est.besttime = if_blank_partial_then_template(File.read(base_path.join("_besttime.html.erb")), "besttime", story_id)
        est.gallery = if_blank_partial_then_template(File.read(base_path.join("_gallery.html.erb")), "gallery", story_id)
        est.location = if_blank_partial_then_template(File.read(base_path.join("_location.html.erb")), "place", story_id)
        est.reach = if_blank_partial_then_template(File.read(base_path.join("_reach.html.erb")), "reach", story_id)
        est.stay = if_blank_partial_then_template(File.read(base_path.join("_stay.html.erb")), "stay", story_id)
        est.story = if_blank_partial_then_template(File.read(base_path.join("_story.html.erb")), "story", story_id)
        est.title = if_blank_partial_then_template(File.read(base_path.join("_title.html.erb")), "title", story_id)
        est.tile_title = TravelStory.find(story_id).title || ""
        
        return est
    end
    
    def write_story_object(params)
        base_path = get_story_folder(params[:story_id])
        
        File.open(base_path.join("_about.html.erb"), 'wb') do |file|
                file.write(params[:about])
        end
        
        File.open(base_path.join("_attractions.html.erb"), 'wb') do |file|
                file.write(params[:attractions])
        end
        
        File.open(base_path.join("_besttime.html.erb"), 'wb') do |file|
                file.write(params[:besttime])
        end
        
        File.open(base_path.join("_gallery.html.erb"), 'wb') do |file|
                file.write(params[:gallery])
        end
        
        File.open(base_path.join("_location.html.erb"), 'wb') do |file|
                file.write(params[:location])
        end
        
        File.open(base_path.join("_reach.html.erb"), 'wb') do |file|
                file.write(params[:reach])
        end
        
        File.open(base_path.join("_stay.html.erb"), 'wb') do |file|
                file.write(params[:stay])
        end
        
        File.open(base_path.join("_story.html.erb"), 'wb') do |file|
                file.write(params[:story])
        end
        
        File.open(base_path.join("_title.html.erb"), 'wb') do |file|
                file.write(params[:title])
        end

        
    end
    
    def edit_story_save
        puts params
        write_story_object(params)
        
        ts = TravelStory.find(params[:story_id])
        ts.title = params[:tile_title] || ""
        ts.save
        
        render :nothing =>true
    end
    
    def edit_story
        @story_id = params[:story_id]
        @est = get_edit_story_object(@story_id)
        
    end
    
    def publish
        
        user_id = params[:user_id]
        story_id = params[:story_id]
        base_story_path = get_unpublished_story_folder(story_id, user_id)
        template_folder = get_template_folder
        base_path = get_story_folder(story_id)
        FileUtils.mkdir_p(base_path) unless File.exists?(base_path)
        
        puts base_story_path.to_s + "/title"
        title = File.read(base_story_path.to_s + "/title")
        template_title = File.read(template_folder.to_s + "/title")
        puts "template_title = "+template_title
        template_final = template_title.gsub('_title_', title)
        puts "template_final = "+template_final
        
        File.open(base_path.join("_title.html.erb"), 'wb') do |file|
                file.write(template_final)
        end
        
        puts base_story_path.to_s + "/place"
        place = File.read(base_story_path.to_s + "/place")
        template_place = File.read(template_folder.to_s + "/place")
        puts "template_location = "+template_place
        template_final_place = template_place.gsub('_place_', place)
        puts "template_final = "+template_final_place
        
        File.open(base_path.join("_location.html.erb"), 'wb') do |file|
                file.write(template_final_place)
        end
        
        puts base_story_path.to_s + "/story"
        story = File.read(base_story_path.to_s + "/story")
        template_story = File.read(template_folder.to_s + "/story")
        puts "template_story = "+template_story
        template_final_story = template_story.gsub('_story_', story)
        puts "template_final = "+template_final_story
        
        File.open(base_path.join("_story.html.erb"), 'wb') do |file|
                file.write(template_final_story)
        end
        
        image_names = Dir.entries(base_story_path.to_s)
        image_names.delete('place')
        image_names.delete('story')
        image_names.delete('title')
        image_names.delete('.')
        image_names.delete('..')
        
        base_image_folder = get_image_story_folder(story_id)
        FileUtils.mkdir_p(base_image_folder) unless File.exists?(base_image_folder)
        
        template_gallery = ""
        index = 1
        image_names.each do |image|
            FileUtils.cp(base_story_path.join(image),base_image_folder.join(image))
            template_gallery_list = File.read(template_folder.to_s + "/gallery_list")
            template_gallery_list = template_gallery_list.gsub("_number_",index.to_s)
            index = index + 1
            template_gallery.concat(template_gallery_list.gsub("_imagepath_", base_image_folder.join(image).to_s.gsub(/.*public/, '..') ))
        end
        
        base_image_folder = get_image_story_folder(story_id)
        File.open(base_path.join("_gallery.html.erb"), 'wb') do |file|
            gallery = File.read(template_folder.to_s + "/gallery")
            puts "gallery = " + gallery
            file.write(gallery.gsub("_gallery_", template_gallery))
        end
        
        File.open(base_path.join("_about.html.erb"), 'wb') do |file|
            about_template = File.read(template_folder.to_s + "/about")
            file.write(about_template.gsub("_about_", ""))
        end
        
        File.open(base_path.join("_attractions.html.erb"), 'wb') do |file|
            attractions_template = File.read(template_folder.to_s + "/attractions")
            file.write(attractions_template.gsub("_attractions_", ""))
        end
        
        File.open(base_path.join("_besttime.html.erb"), 'wb') do |file|
            besttime_template = File.read(template_folder.to_s + "/besttime")
            file.write(besttime_template.gsub("_besttime_", ""))
        end
        
        File.open(base_path.join("_reach.html.erb"), 'wb') do |file|
            reach_template = File.read(template_folder.to_s + "/reach")
            file.write(reach_template.gsub("_reach_", ""))
        end
        
        File.open(base_path.join("_stay.html.erb"), 'wb') do |file|
            stay_template = File.read(template_folder.to_s + "/stay")
            file.write(stay_template.gsub("_stay_", ""))
        end
        render :nothing => true
    end
    
    def migrate
        file_name = params[:file]
        file_title = params[:title]
        page = Nokogiri::HTML(open("app/views/places/" + file_name))
        
        about = page.css('div#about').css('div')[1].text().to_s
        location = page.css('div#about').css('h4')[0].text().gsub("About","").to_s.strip
        besttime = page.css('div.best-time').to_s
        story = page.css('div#travelstory').to_html
        attractions = page.css('div#attractions').to_html
        gallery = page.css('div#photogallery').to_html
        stay = page.css('div#stay').to_html
        reach = page.css('div.reach-by').to_html
        title = File.read("app/views/places/" + file_title)
        sample_image_path = page.css("div#travelstory").css("img")[0].attribute("src").to_s.split("/")[2]
        
        
        
        
        ts = TravelStory.new
        ts.location = location
        ts.save
        puts ts
        base_path = get_story_folder(ts.id)
        
        FileUtils.mkdir_p(base_path) unless File.exists?(base_path)
           
        image_names = Dir.entries(get_image_story_folder(sample_image_path))
        puts image_names
        image_names.delete(".")
        image_names.delete("..")
        FileUtils.mkdir_p(get_image_story_folder(ts.id.to_s)) unless File.exists?(get_image_story_folder(ts.id.to_s))
        image_names.each do |image|
            puts get_image_story_folder(sample_image_path).join(image).to_s
            puts base_path.join(image).to_s
            FileUtils.cp(get_image_story_folder(sample_image_path).join(image), get_image_story_folder(ts.id.to_s).join(image))
        end
            
            File.open(base_path.join("_title.html.erb"), 'wb') do |file|
                file.write(title)
            end
            
            File.open(base_path.join("_about.html.erb"), 'wb') do |file|
                file.write(about)
            end
            
            File.open(base_path.join("_location.html.erb"), 'wb') do |file|
                file.write(location)
            end
            
            File.open(base_path.join("_besttime.html.erb"), 'wb') do |file|
                file.write(besttime)
            end
            
            File.open(base_path.join("_story.html.erb"), 'wb') do |file|
                file.write(story)
            end
            
            File.open(base_path.join("_attractions.html.erb"), 'wb') do |file|
                file.write(attractions)
            end
            
            File.open(base_path.join("_gallery.html.erb"), 'wb') do |file|
                file.write(gallery)
            end
            
            File.open(base_path.join("_stay.html.erb"), 'wb') do |file|
                file.write(stay)
            end
            
            File.open(base_path.join("_reach.html.erb"), 'wb') do |file|
                file.write(reach)
            end
            
            render :nothing => true
    end
end
