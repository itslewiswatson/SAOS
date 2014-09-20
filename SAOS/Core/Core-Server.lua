Core = {}

function Core.Initialize()
	Config.Parse()
end
addEventHandler("onResourceStart",resourceRoot,Core.Initialize)