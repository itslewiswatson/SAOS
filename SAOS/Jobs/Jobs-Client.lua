Jobs = {
	JobData = {
		{"Paramedic","Emergency Services",2024.3330078125,-1405.1572265625,16,"Heal players by using a spraycan, or allowing them to enter your Ambulance."}
	},
	JobMarkers = {}
}

function Jobs.ShowJobInformation(marker)
	local job = marker:getData("job")
	local team = marker:getData("team")
	local desc = marker:getData("description")
	if job and team then
		if isElement(Jobs.InfoWindow) then
			destroyElement(Jobs.InfoWindow)
		end
		Jobs.InfoWindow = guiCreateWindow(Core.ResX/2-200,Core.ResY/2-100,400,200,Utils.GetL10N("JOB_INFORMATION").." - "..job,false)
		guiWindowSetSizable(Jobs.InfoWindow,false)
		guiSetFont(guiCreateLabel(20,40,360,20,Utils.GetL10N("JOB_TITLE"),false,Jobs.InfoWindow),"default-bold-small")
		guiCreateLabel(110,39,360,20,job,false,Jobs.InfoWindow)
		guiSetFont(guiCreateLabel(20,70,360,20,Utils.GetL10N("JOB_TEAM"),false,Jobs.InfoWindow),"default-bold-small")
		local teamLabel = guiCreateLabel(110,69,360,20,team,false,Jobs.InfoWindow)
		local teamElem = getTeamFromName(team)
		if teamElem then
			guiLabelSetColor(teamLabel,teamElem:getColor())
		end
		guiSetFont(guiCreateLabel(20,100,360,20,Utils.GetL10N("JOB_DESCRIPTION"),false,Jobs.InfoWindow),"default-bold-small")
		if desc then
			guiLabelSetHorizontalAlign(guiCreateLabel(110,99,270,50,desc,false,Jobs.InfoWindow),"left",true)
		end
		addEventHandler("onClientGUIClick",guiCreateButton(20,150,170,40,Utils.GetL10N("JOB_ACCEPT"),false,Jobs.InfoWindow),function()
			triggerServerEvent("SAOS.RequestJob",localPlayer,job)
			destroyElement(Jobs.InfoWindow)
			showCursor(false)
		end,false)
		addEventHandler("onClientGUIClick",guiCreateButton(200,150,170,40,Utils.GetL10N("ACCOUNTS_CANCEL"),false,Jobs.InfoWindow),function()
			destroyElement(Jobs.InfoWindow)
			showCursor(false)
		end,false)
		showCursor(true)
	end
end

function Jobs.SetupMarkers()
	for k, v in ipairs(Jobs.JobData) do
		local team = Team.getFromName(v[2])
		if team then
			local r,g,b = team:getColor()
			local marker = Marker(v[3],v[4],v[5],"cylinder",1.5,r,g,b)
			marker:setData("job",v[1])
			marker:setData("team",v[2])
			marker:setData("description",v[6])
			table.insert(Jobs.JobMarkers,marker)
		end
	end
	Jobs.JobData = nil
end

function Jobs.RenderMarkers()
	local playerPos = localPlayer:getPosition()
	for k, v in ipairs(Jobs.JobMarkers) do
		if isElementStreamedIn(v) then
			local pos = v:getPosition()
			local x,y = getScreenFromWorldPosition(pos.x,pos.y,pos.z+2,0,false)
			if x and y then
				local job = v:getData("job")
				local dist = getDistanceBetweenPoints3D(playerPos.x,playerPos.y,playerPos.z,pos.x,pos.y,pos.z)
				if dist <= 20 then
					local size = math.max(0,math.min(1.5,1.5-dist/20))
					if size > 0 then
						local width = dxGetTextWidth(job,size,"bankgothic")
						dxDrawText(v:getData("job"),(x-width/2)+2,y+2,(x+width/2)+2,Core.ResY+2,tocolor(0,0,0),size,"bankgothic")
						dxDrawText(v:getData("job"),x-width/2,y,x+width/2,Core.ResY,tocolor(255,255,255),size,"bankgothic")
					end
				end
			end
		end
	end
end

function Jobs.MarkerHit(player,dim)
	if player == localPlayer and dim then
		Jobs.ShowJobInformation(source)
	end
end
addEventHandler("onClientMarkerHit",root,Jobs.MarkerHit)