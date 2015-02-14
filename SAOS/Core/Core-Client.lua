Core = {}
Core.ResX,Core.ResY = guiGetScreenSize()

function Core.Initialize()
	Accounts.Initialize()
	Jobs.SetupMarkers()
end
addEventHandler("onClientResourceStart",resourceRoot,Core.Initialize)

function Core.Pulse()
	Jobs.RenderMarkers()
end
addEventHandler("onClientRender",root,Core.Pulse)