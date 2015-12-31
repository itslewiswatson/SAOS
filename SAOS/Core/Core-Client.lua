Core = {}
Core.ResX,Core.ResY = guiGetScreenSize()

function Core.Initialize()
	Events.DownloadQueue()
	Accounts.Initialize()
	VehicleSpawners.Setup()
end
addEventHandler("onClientResourceStart",resourceRoot,Core.Initialize)

function Core.Pulse()
	Jobs.RenderMarkers()
end
addEventHandler("onClientRender",root,Core.Pulse)

function Core.Wasted()
	VehicleSpawners.CloseSpawner()
end
addEventHandler("onClientPlayerWasted",localPlayer,Core.Wasted)