module PlacesHelper
    
    def getPlaceUrl(params)
        url = '/places/' + params[:id]
        puts url
        return url
    end
end
