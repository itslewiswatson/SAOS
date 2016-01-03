Jobs = {
	Teams = {},
	JobData = {},
	Markers = {}
}

function Jobs.Setup()
	local file = XML.load("Jobs.xml")
	if file then
		for k, v in ipairs(file:getChildren()) do
			if v:getName() == "team" then
				local teamName = v:getAttribute("name")
				if teamName then
					local r,g,b = v:getAttribute("r") or 0,v:getAttribute("g") or 0,v:getAttribute("b") or 0
					Jobs.Teams[teamName] = createTeam(teamName,r,g,b)
					for k,job in ipairs(v:getChildren()) do
					if job:getName() == "job" then
						local jobName = job:getAttribute("name")
						if jobName then
							local weaponsTable = {}
							for k,jobData in ipairs(job:getChildren()) do
								if jobData:getName() == "weapons" then
									for k,weapon in ipairs(jobData:getChildren()) do
										local weaponID = weapon:getAttribute("id")
										if weaponID then
											table.insert(weaponsTable,{weaponID,weapon:getAttribute("ammo") or 1})
										end
									end
								elseif jobData:getName() == "marker" then
									local x,y,z = jobData:getAttribute("x"),jobData:getAttribute("y"),jobData:getAttribute("z")
									if x and y and z then
										table.insert(Jobs.Markers,{x,y,z,jobName,teamName,jobData:getAttribute("description") or "",r,g,b})
									end
								end
							end
							local skin = job:getAttribute("skin")
							Jobs.JobData[jobName] = {teamName,skin and tonumber(skin) or false,weaponsTable ~= {} and weaponsTable or nil}
						end
					end
				end
				end
			end
		end
		file:unload()
	end
	for k, v in ipairs(getElementsByType("player")) do
		Jobs.SpawnHandler(v)
	end
end

function Jobs.SpawnHandler(player)
	local job = player:getData("job")
	if job and Jobs.JobData[job] and Jobs.Teams[Jobs.JobData[job][1]] then
		player:setTeam(Jobs.Teams[Jobs.JobData[job][1]])
	elseif not job then
		Events.QueueEvent(player,"SAOS.DownloadJobMarkers",player,Jobs.Markers)
		if Jobs.Teams["Unemployed"] then
			setPlayerTeam(player,Jobs.Teams["Unemployed"])
		end
	end
end

function Jobs.ApplyJob(player,job,weapons)
	local jobData = Jobs.JobData[job]
	if jobData and Jobs.Teams[jobData[1]] then
		player:setTeam(Jobs.Teams[jobData[1]])
		local jobSkin = player:getData("jobSkin") or jobData[2]
		if jobSkin then
			player:setModel(jobSkin)
			player:setData("jobSkin",jobSkin)
		end
		if weapons and jobData[3] then
			for k, v in ipairs(jobData[3]) do
				giveWeapon(player,v[1],v[2],v[3])
				setWeaponAmmo(player,v[1],v[2])
			end
		end
		player:setData("job",job)
		player:setData("jobActive",true)
		triggerClientEvent(player,"SAOS.DeleteJobMarkers",player)
	end
end

function Jobs.PlayerResign(source)
	local job = source:getData("job")
	if job then
		local jobData = Jobs.JobData[job]
		if jobData and jobData[3] then
			for k, v in ipairs(jobData[3]) do
				takeWeapon(source,v[1],v[2])
			end
		end
		source:setTeam(Jobs.Teams["Unemployed"] and Jobs.Teams["Unemployed"] or nil)
		source:setModel(source:getData("skin") or 0)
		source:removeData("job")
		source:removeData("jobSkin")
		triggerClientEvent(source,"SAOS.DownloadJobMarkers",source,Jobs.Markers)
		outputChatBox(string.format(Utils.GetL10N(source,"JOB_RESIGNED"),job),source,255,255,0)
	else
		outputChatBox(string.format(Utils.GetL10N(source,"JOB_NOT_EMPLOYED"),job),source,255,0,0)
	end
end
addCommandHandler("resign",Jobs.PlayerResign,false,false)

function Jobs.RequestJob(job)
	Jobs.ApplyJob(client,job,true)
end
addEvent("SAOS.RequestJob",true)
addEventHandler("SAOS.RequestJob",root,Jobs.RequestJob)