class PlacesController < ApplicationController
  #before_action :set_place, only: [:show, :edit, :update, :destroy]
  

  # GET /places
  # GET /places.json
  def get_place
    puts params[:id]
    place_and_storyid = params[:id].split("_")
    @story_id = place_and_storyid[place_and_storyid.size - 1]
    @ts = TravelStory.find(@story_id)
    @user = get_current_user
    @user = define_sign_in_out_variables(@user)
    
    @canonical_location = @ts.canonical_location
    puts @canonical_location
    
    # puts @placeHeading
    # puts params.inspect
    # puts 'hi hello'
  end

  # # GET /places/1
  # # GET /places/1.json
  # def show
  # end

  # # GET /places/new
  # def new
  #   @place = Place.new
  # end

  # # GET /places/1/edit
  # def edit
  # end

  # # POST /places
  # # POST /places.json
  # def create
  #   @place = Place.new(place_params)

  #   respond_to do |format|
  #     if @place.save
  #       format.html { redirect_to @place, notice: 'Place was successfully created.' }
  #       format.json { render :show, status: :created, location: @place }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @place.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # PATCH/PUT /places/1
  # # PATCH/PUT /places/1.json
  # def update
  #   respond_to do |format|
  #     if @place.update(place_params)
  #       format.html { redirect_to @place, notice: 'Place was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @place }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @place.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /places/1
  # # DELETE /places/1.json
  # def destroy
  #   @place.destroy
  #   respond_to do |format|
  #     format.html { redirect_to places_url, notice: 'Place was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_place
  #     @place = Place.find(params[:id])
  #   end

  #   # Never trust parameters from the scary internet, only allow the white list through.
  #   def place_params
  #     params.require(:place).permit(:About, :Story, :Gallery, :Attractions, :Stay)
  #   end
end
