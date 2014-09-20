Utils = {}

function Utils.GetPlayerCountry(player)
	if isElement(player) then
		local admin = getResourceFromName("admin")
		if admin and getResourceState(admin) == "running" then
			return exports.admin:getPlayerCountry(player)
		end
	end
	return false
end

function Utils.GetPlayerL10N(player)
	if isElement(player) then
		return getElementData(player,"language")
	end
	return false
end

function Utils.GetL10N(player,message)
	if isElement(player) and message then
		local playerL10N = Utils.GetPlayerL10N(player)
		return L10N[message][L10N[message][playerL10N] and playerL10N or "en_US"]
	end
end