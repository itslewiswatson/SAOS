Utils = {}

function Utils.GetL10N(message)
	if message then
		local playerL10N = localPlayer:getData("language")
		return L10N[message][L10N[message][playerL10N] and playerL10N or "en_US"]
	end
end