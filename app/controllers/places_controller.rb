class PlacesController < ApplicationController
	def index
	end

	def search
	  @places = BeermappingApi.places_in(params[:city])
	  if @places.empty?
	  	redirect_to places_path, notice: "no locations in #{params[:city]}"
	  else
	  	session[:last_place_search] = @places
	  	render :index
	  end
    end

    def show
    	@places = session[:last_place_search]
    	@places.each do |place|
    		@place = place if place.id == params[:id]
        end
    end
end