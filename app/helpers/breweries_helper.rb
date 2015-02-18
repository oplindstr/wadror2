module BreweriesHelper
	def activity_toggle_label_name(brewery)
		return "deactivate" if brewery.active
		"activate"
	end
end
