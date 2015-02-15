Utils = {}

function Utils.GetL10N(message)
	if message then
		local playerL10N = localPlayer:getData("language")
		return L10N[message][L10N[message][playerL10N] and playerL10N or "en_US"]
	end
end

function Utils.AddScoreboardColumns(resource)
	local scoreboard = getResourceFromName("scoreboard")
	if (resource == getThisResource() and scoreboard and getResourceState(scoreboard) == "running") or (scoreboard and resource == scoreboard) then
		exports.scoreboard:scoreboardAddColumn("job",100,Utils.GetL10N("SCOREBOARD_JOB"))
		exports.scoreboard:scoreboardAddColumn("playtime",80,Utils.GetL10N("SCOREBOARD_PLAYTIME"))
	end
end
addEventHandler("onClientResourceStart",root,Utils.AddScoreboardColumns)