Core = {}

function Core.Initialize()
	Accounts.Initialize()
end
addEventHandler("onClientResourceStart",resourceRoot,Core.Initialize)