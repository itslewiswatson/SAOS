addCommandHandler("language",function()
	outputChatBox("* Your language is currently set to "..getLocalization()["name"]..".",0,255,0)
end,false)

addCommandHandler("clearchat",function()
	for i=1,getChatboxLayout()["chat_lines"] do
		outputChatBox("")
	end
end,false)

addCommandHandler("getpos",function()
	local pos = localPlayer:getPosition()
	outputChatBox("* Position: "..tostring(pos.x)..", "..tostring(pos.y)..", "..tostring(pos.z),153,50,204)
	setClipboard(tostring(pos.x)..","..tostring(pos.y)..","..tostring(pos.z))
end,false)