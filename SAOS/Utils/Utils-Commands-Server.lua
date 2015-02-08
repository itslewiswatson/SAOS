addCommandHandler("playtime",function(source)
	local playtime = Utils.GetPlaytime(source)
	if playtime then
		outputChatBox("* Playtime: "..Utils.GetFullFormattedPlaytime(playtime),source,0,255,0)
	end
end,false,false)

addCommandHandler("totalplaytime",function(source)
	if source:getType() == "player" then
		outputChatBox("* Total playtime: "..Utils.GetFullFormattedPlaytime(Utils.GetTotalPlaytime()),source,0,255,0)
	elseif source:getType() == "console" then
		outputServerLog("* Total playtime: "..Utils.GetFullFormattedPlaytime(Utils.GetTotalPlaytime()))
	end
end,false,false)