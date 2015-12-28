Utils.Chat = {
	LastMessage = {},
	LastTimestamp = {}
}

function Utils.HandleChat(msg,msgType)
	local lastMsg = Utils.Chat.LastMessage[source]
	if lastMsg then
		if msg == lastMsg then
			cancelEvent()
			outputChatBox(Utils.GetL10N(source,"CHAT_REPEATING"),source,255,0,0)
			return
		end
	end
	Utils.Chat.LastMessage[source] = msg
	local lastTimestamp = Utils.Chat.LastTimestamp[source]
	if lastTimestamp then
		if getTickCount()-lastTimestamp < 1000 then
			cancelEvent()
			outputChatBox(Utils.GetL10N(source,"CHAT_TOO_FAST"),source,255,0,0)
			return
		end
	end
	Utils.Chat.LastTimestamp[source] = getTickCount()
	if msgType ~= 1 then
		local city = source:getZoneName(true)
		if city == "Los Santos" then
			city = "(LS) "
		elseif city == "San Fierro" then
			city = "(SF) "
		elseif city == "Las Venturas" then
			city = "(LV) "
		else
			city = ""
		end
		local r,g,b = source:getNametagColor()
		cancelEvent()
		while msg:find("#%x%x%x%x%x%x") do
			msg = msg:gsub("#%x%x%x%x%x%x","")
		end
		outputChatBox(city..(msgType == 2 and "(TEAM) " or "")..getPlayerName(source)..":#FFFFFF "..msg,root,r,g,b,true)
	end
end
addEventHandler("onPlayerChat",root,Utils.HandleChat)

function Utils.ClearPlayerChatCache(player)
	if Utils.Chat.LastMessage[player] then
		Utils.Chat.LastMessage[player] = nil
	end
	if Utils.Chat.LastTimestamp[player] then
		Utils.Chat.LastTimestamp[player] = nil
	end
end