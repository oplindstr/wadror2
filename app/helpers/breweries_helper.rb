module BreweriesHelper
	def activity_toggle_brewery_label_name(brewery)
		return "deactivate" if brewery.active
		"activate"
	end
end
