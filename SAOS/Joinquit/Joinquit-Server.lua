Joinquit = {}

function Joinquit.JoinHandler(player)
	for k, v in ipairs(Element.getAllByType("player")) do
		if v ~= player then
			outputChatBox(string.format(Utils.GetL10N(v,"PLAYER_JOIN"),getPlayerName(player),Utils.GetPlayerCountry(player)),v,255,100,100)
		end
	end
end

function Joinquit.QuitHandler(player,reason)
	for k, v in ipairs(Element.getAllByType("player")) do
		outputChatBox(string.format(Utils.GetL10N(v,"PLAYER_QUIT"),getPlayerName(player),reason),v,255,100,100)
	end
end

function Joinquit.NickHandler(oldNick,newNick)
	for k, v in ipairs(Element.getAllByType("player")) do
		outputChatBox(string.format(Utils.GetL10N(v,"PLAYER_NICK_CHANGE"),oldNick,newNick),v,255,100,100)
	end
end