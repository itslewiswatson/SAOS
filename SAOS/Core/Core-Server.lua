Core = {}

function Core.Initialize()
	Config.Parse()
	SQL.Connect()
	Accounts.Setup()
	Jobs.Setup()
	Spawn.Setup()
	Weapons.Setup()
	Vehicles.Setup()
	Utils.SetupPlaytime()
	Core.SetupMisc()
end
addEventHandler("onResourceStart",resourceRoot,Core.Initialize)

function Core.Shutdown()
	for k, v in ipairs(getElementsByType("player")) do
		Spawn.QuitHandler(v)
		Utils.StorePlaytime(v)
	end
end
addEventHandler("onResourceStop",resourceRoot,Core.Shutdown)

function Core.PlayerJoin()
	Joinquit.JoinHandler(source)
end
addEventHandler("onPlayerJoin",root,Core.PlayerJoin)

function Core.PlayerQuit(quitType)
	Spawn.QuitHandler(source)
	Weapons.SaveWeapons(source)
	Joinquit.QuitHandler(source,quitType)
	Utils.StorePlaytime(source)
end
addEventHandler("onPlayerQuit",root,Core.PlayerQuit)

function Core.PlayerChangeNick(oldNick,newNick)
	Joinquit.NickHandler(oldNick,newNick)
end
addEventHandler("onPlayerChangeNick",root,Core.PlayerChangeNick)

function Core.PlayerWasted()
	Spawn.PlayerWasted(source)
end
addEventHandler("onPlayerWasted",root,Core.PlayerWasted)

function Core.SetupMisc()
	setFPSLimit(60)
	setCloudsEnabled(false)
	setMapName("San Andreas")
	setGameType("San Andreas Open Source")
end