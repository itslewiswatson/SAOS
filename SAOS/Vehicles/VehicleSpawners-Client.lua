VehicleSpawners = {
	Data = {
		{restType="Team",restValue="Law Enforcement",x=1566.9326171875,y=-1609.494140625,z=12,rot=180,vehicles={596,523}},
		{restType="Job",restValue="Paramedic",x=2014.2890625,y=-1414.27734375,z=16,rot=90,vehicles={416}},
		{x=1683.173828125,y=-2305.4375,z=12,rot=0,vehicles={481}}
	},
	Markers = {}
}

function VehicleSpawners.Cleanup()
	for k, v in ipairs(VehicleSpawners.Markers) do
		if isElement(v) then
			v:destroy()
		end
	end
	VehicleSpawners.CloseSpawner()
	VehicleSpawners.Markers = {}
end

function VehicleSpawners.Setup()
	VehicleSpawners.Cleanup()
	for k, v in ipairs(VehicleSpawners.Data) do
		local allowed = false
		local r,g,b = 255,255,255
		if v.restType then
			if v.restType == "Team" then
				local team = localPlayer:getTeam()
				allowed = (team and getTeamName(team) == v.restValue)
			elseif v.restType == "Job" then
				local job = localPlayer:getData("job")
				allowed = (job and job == v.restValue)
			end
			r,g,b = localPlayer:getNametagColor()
		else
			allowed = true
		end
		if allowed then
			local spawner = Marker(v.x,v.y,v.z,"cylinder",3,r,g,b)
			spawner:setData("data",k)
			addEventHandler("onClientMarkerHit",spawner,VehicleSpawners.UseSpawner)
			addEventHandler("onClientMarkerLeave",spawner,VehicleSpawners.CloseSpawner)
			table.insert(VehicleSpawners.Markers,spawner)
		end
	end
end

function VehicleSpawners.UseSpawner(player,dim)
	if player == localPlayer and dim and not isPedInVehicle(localPlayer) then
		local data = source:getData("data")
		if data then
			VehicleSpawners.Window = guiCreateWindow(Core.ResX/2-150,Core.ResY/2-175,300,350,Utils.GetL10N("SPAWNER_TITLE"),false)
			VehicleSpawners.Window.sizable = false
			local vehGrid = guiCreateGridList(10,30,280,200,false,VehicleSpawners.Window)
			guiGridListAddColumn(vehGrid,Utils.GetL10N("SPAWNER_VEHICLE"),0.9)
			local spawnButton = guiCreateButton(10,235,280,50,Utils.GetL10N("SPAWNER_SPAWN"),false,VehicleSpawners.Window)
			spawnButton.enabled = false
			addEventHandler("onClientGUIClick",vehGrid,function()
				guiSetEnabled(spawnButton,guiGridListGetSelectedItem(vehGrid) ~= -1)
			end,false)
			addEventHandler("onClientGUIClick",spawnButton,function()
				local spawnData = VehicleSpawners.Data[data]
				triggerServerEvent("SAOS.UseVehicleSpawner",localPlayer,getVehicleModelFromName(guiGridListGetItemText(vehGrid,guiGridListGetSelectedItem(vehGrid),1)),spawnData.x,spawnData.y,spawnData.z,spawnData.rot)
				VehicleSpawners.CloseSpawner()
			end,false)
			local closeButton = guiCreateButton(10,290,280,50,Utils.GetL10N("SPAWNER_CLOSE"),false,VehicleSpawners.Window)
			addEventHandler("onClientGUIClick",closeButton,VehicleSpawners.CloseSpawner,false)
			showCursor(true)
			for k, v in ipairs(VehicleSpawners.Data[data].vehicles) do
				guiGridListSetItemText(vehGrid,guiGridListAddRow(vehGrid),1,getVehicleNameFromModel(v),false,false)
			end
		end
	end
end

function VehicleSpawners.CloseSpawner()
	if isElement(VehicleSpawners.Window) then
		VehicleSpawners.Window:destroy()
		showCursor(false)
	end
end

function VehicleSpawners.JobChange(data)
	if data == "job" then
		VehicleSpawners.Setup()
	end
end
addEventHandler("onClientElementDataChange",localPlayer,VehicleSpawners.JobChange)