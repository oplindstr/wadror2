class BeermappingApi
	def self.places_in(city)
		city = city.downcase
		Rails.cache.fetch(city) { fetch_places_in(city) }
	end

	private

	def self.fetch_places_in(city)
		url = "http://beermapping.com/webservice/loccity/#{self.key}/"
        response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"

        return [] if response["bmp_locations"].nil?
		
		places = response.parsed_response["bmp_locations"]["location"]

        return [] if places.is_a?(Hash) and places['id'].nil?

        places = [places] if places.is_a?(Hash)
        places.inject([]) do | set, place |
        	set << Place.new(place)
        end
    end

	def self.key
		"70565bb129e39ac88e61262db37f7a14"
	end
end