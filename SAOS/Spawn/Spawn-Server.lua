Spawn = {
	PlayerBlips = {},
	Hospitals = {}
}

function Spawn.Setup()
	SQL.Exec("CREATE TABLE IF NOT EXISTS spawn_data (id INTEGER PRIMARY KEY, x FLOAT, y FLOAT, z FLOAT, rotation FLOAT, interior INTEGER, dimension INTEGER, skin INTEGER, health FLOAT, armor FLOAT, money INTEGER, job TEXT, jobskin INTEGER, jobactive BOOL)")
	for k, v in ipairs(getElementsByType("player")) do
		Spawn.SetupBlip(v)
	end
	local file = XML.load("Spawns.xml"):getChildren()
	for i, node in ipairs(file) do
		local hospitalName = node:getAttribute("name")
		local coordinates = node:getChildren(0)
		local x, y, z = coordinates:getAttribute("x"), coordinates:getAttribute("y"), coordinates:getAttribute("z")
		table.insert(Spawn.Hospitals, {hospitalName, x, y, z})
	end
	file:unload()
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
		local distance = Config.GetValue("player_blip_distance")
		if not distance or (distance and tonumber(distance) > 0) then
			local r,g,b = getPlayerNametagColor(player)
			Spawn.PlayerBlips[player] = createBlipAttachedTo(player,0,2,r,g,b,255,0,distance or 1000)
		end
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
			local model = player:getModel()
			player:spawn(nearestHospital[2]+math.random(-2,2),nearestHospital[3]+math.random(-2,2),nearestHospital[4],nearestHospital[5],model)
			local hospitalBill = (Config.GetValue("hospital_bill") == "true")
			local bill = 0
			if hospitalBill then
				local money = player:getMoney()
				bill = money >= 100 and 100 or money > 0 and money or 0
				player:takeMoney(bill)
				if bill < 100 then
					player:setHealth(math.max(bill,10))
				end
			end
			player:fadeCamera(true,5)
			Weapons.ApplyWeaponsTable(player,wepTable)
			outputChatBox("* You were treated at "..nearestHospital[1]..(hospitalBill and " and billed $"..tostring(bill).."." or "."),player,255,0,0)
		end
	end,15000,1,player,wepTable)
end

function Spawn.Cleanup(player)
	if Spawn.PlayerBlips[player] then
		destroyElement(Spawn.PlayerBlips[player])
		Spawn.PlayerBlips[player] = nil
	end
end
