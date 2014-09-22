Core = {}

function Core.Initialize()
	Config.Parse()
	SQL.Connect()
end
addEventHandler("onResourceStart",resourceRoot,Core.Initialize)

function Core.PlayerJoin()
	Joinquit.JoinHandler(source)
end
addEventHandler("onPlayerJoin",root,Core.PlayerJoin)

function Core.PlayerQuit(quitType)
	Joinquit.QuitHandler(source,quitType)
end
addEventHandler("onPlayerQuit",root,Core.PlayerQuit)

function Core.PlayerChangeNick(oldNick,newNick)
	Joinquit.NickHandler(oldNick,newNick)
end
addEventHandler("onPlayerChangeNick",root,Core.PlayerChangeNick)