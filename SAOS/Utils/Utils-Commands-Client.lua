addCommandHandler("language",function()
	outputChatBox("* Your language is currently set to "..getLocalization()["name"]..".",0,255,0)
end,false,false)

addCommandHandler("clearchat",function()
	for i=1,getChatboxLayout()["chat_lines"] do
		outputChatBox("")
	end
end,false,false)