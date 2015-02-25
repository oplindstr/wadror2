module UsersHelper
	def activity_toggle_label_name(user)
		return "Activate account" if user.disabled.nil? or user.disabled
		"Freeze account"
	end
end
