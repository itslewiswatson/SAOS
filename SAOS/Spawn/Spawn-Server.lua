Spawn = {
	PlayerBlips = {},
	Hospitals = {
		{"County General Hospital",2033.94921875,-1407.1396484375,17.190710067749,152},
		{"All Saints General Hospital",1179.3544921875,-1323.6357421875,14.165296554565,270},
		{"Crippen Memorial Hospital",1244.642578125,332.912109375,19.5546875,335},
		{"Angel Pine Medical Center",-2196.41796875,-2306.9501953125,30.625,320},
		{"San Fierro Medical Center",-2663.953125,634.890625,14.453125,180},
		{"El Quebrados Medical Center",-1514.609375,2525.583984375,55.773216247559,0},
		{"Fort Carson Medical Center",-321.361328125,1057.021484375,19.7421875,0},
		{"Las Venturas Hospital",1607.7412109375,1820.1416015625,10.828001022339,0}
	}
}

function Spawn.Setup()
	SQL.Exec("CREATE TABLE IF NOT EXISTS spawn_data (id INTEGER PRIMARY KEY, x FLOAT, y FLOAT, z FLOAT, rotation FLOAT, interior INTEGER, dimension INTEGER, skin INTEGER, health FLOAT, armor FLOAT, money INTEGER, job TEXT, jobskin INTEGER, jobactive BOOL)")
	for k, v in ipairs(getElementsByType("player")) do
		Spawn.SetupBlip(v)
	end
	for k, v in ipairs(Spawn.Hospitals) do
		createBlip(v[2],v[3],v[4],22,2,255,0,0,255,0,500)
	end
end

function Spawn.SpawnPlayer(id)
	local data = SQL.Query("SELECT * FROM spawn_data WHERE id = ? LIMIT 1",id)
	if data and #data == 1 then
		source:spawn(data[1].x,data[1].y,data[1].z,data[1].rotation,data[1].skin,data[1].interior,data[1].dimension)
		source:setHealth(data[1].health)
		source:setArmor(data[1].armor)
		source:setMoney(data[1].money)
		source:setData("skin",data[1].skin,false)
		source:setData("jobSkin",data[1].jobskin,false)
		source:setData("jobActive",data[1].jobactive,false)
		if data[1].jobactive then
			Jobs.ApplyJob(source,data[1].job)
		elseif not data[1].job then
			triggerClientEvent(source,"SAOS.DownloadJobMarkers",source,Jobs.Markers)
		end
	else
		source:spawn(1685.65234375,-2330.4931640625,13.546875)
		local skin = Config.GetValue("default_spawn_skin")
		if skin == "random" then
			repeat until source:setModel(math.random(312))
		elseif type(tonumber(skin)) == "number" then
			source:setModel(tonumber(skin))
		end
		source:setData("skin",source:getModel(),false)
	end
	source:setCameraTarget()
	source:fadeCamera(true,5)
	Jobs.SpawnHandler(source)
end
addEvent("SAOS.onLogin",true)
addEventHandler("SAOS.onLogin",root,Spawn.SpawnPlayer)

function Spawn.QuitHandler(player)
	local id = player:getData("account")
	if id then
		local pos = player:getPosition()
		local rot = player:getRotation()
		local exists = SQL.Query("SELECT id FROM spawn_data WHERE id = ? LIMIT 1",id)
		if exists and #exists == 1 then
			SQL.Exec("UPDATE spawn_data SET x = ?, y = ?, z = ?, rotation = ?, interior = ?, dimension = ?, skin = ?, health = ?, armor = ?, money = ?, job = ?, jobskin = ?, jobactive = ? WHERE id = ?",pos.x,pos.y,pos.z,rot.z,player:getInterior(),player:getDimension(),player:getData("skin") or nil,player:getHealth(),getPedArmor(player),player:getMoney(),player:getData("job") or nil,player:getData("jobSkin") or nil,player:getData("jobActive") or nil,id)
		else
			SQL.Exec("INSERT INTO spawn_data (id,x,y,z,rotation,interior,dimension,skin,health,armor,money,job,jobskin,jobactive) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)",id,pos.x,pos.y,pos.z,rot.z,player:getInterior(),player:getDimension(),player:getData("skin") or nil,player:getHealth(),getPedArmor(player),player:getMoney(),player:getData("job") or nil,player:getData("jobSkin") or nil,player:getData("jobActive") or nil,id)
		end
	end
	Spawn.Cleanup(player)
end

function Spawn.SetupBlip(player)
	if not Spawn.PlayerBlips[player] and player:getTeam() then
		local r,g,b = getPlayerNametagColor(player)
		Spawn.PlayerBlips[player] = createBlipAttachedTo(player,0,2,r,g,b)
	end
end

function Spawn.PlayerWasted(player)
	player:fadeCamera(false,10)
	local wepTable = Weapons.GenerateWeaponsTable(player)
	setTimer(function(player,wepTable)
		if isElement(player) then
			local nearestHospital = nil
			local nearestDistance = nil
			local pos = player:getPosition()
			for k, v in ipairs(Spawn.Hospitals) do
				local distance = getDistanceBetweenPoints3D(pos.x,pos.y,pos.z,v[2],v[3],v[4])
				if not nearestDistance or distance < nearestDistance then
					nearestHospital = v
					nearestDistance = distance
				end
			end
			local money = player:getMoney()
			local model = player:getModel()
			player:spawn(nearestHospital[2]+math.random(-2,2),nearestHospital[3]+math.random(-2,2),nearestHospital[4],nearestHospital[5],model)
			local bill = money >= 100 and 100 or money > 0 and money or 0
			player:fadeCamera(true,5)
			player:takeMoney(bill)
			if bill < 100 then
				player:setHealth(math.max(bill,10))
			end
			Weapons.ApplyWeaponsTable(player,wepTable)
			outputChatBox("* You were treated at "..nearestHospital[1].." and billed $"..tostring(bill)..".",player,255,0,0)
		end
	end,15000,1,player,wepTable)
end

function Spawn.Cleanup(player)
	if Spawn.PlayerBlips[player] then
		destroyElement(Spawn.PlayerBlips[player])
		Spawn.PlayerBlips[player] = nil
	end
end