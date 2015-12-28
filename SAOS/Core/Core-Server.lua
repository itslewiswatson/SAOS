Core = {}

function Core.Initialize()
	Config.Parse()
	SQL.Connect()
	Accounts.Setup()
	Jobs.Setup()
	Spawn.Setup()
	Weapons.Setup()
	Utils.SetupPlaytime()
	Updater.Setup()
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
	VehicleSpawners.RemovePlayerVehicle(source)
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
	Core.ChangeWeather()
	setMapName("San Andreas")
	setGameType("San Andreas Open Source")
end

function Core.ChangeWeather()
	setWeatherBlended(math.random(0,16))
	setTimer(Core.ChangeWeather,math.random(600000,1200000),1)
end