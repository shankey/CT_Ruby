module PlacesHelper
    
    def get_place_url(params)
        url = '/places/' + params[:id]
        puts url
        return url
    end
    
    def get_place_title_url(params)
        url = '/places/' + params[:id] + '_title'
        puts url
        return url
    end
end
