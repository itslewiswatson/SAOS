Spawn = {
	PlayerBlips = {},
	Hospitals = {
		{"County General Hospital",2033.94921875,-1407.1396484375,17.190710067749,152},
		{"All Saints General Hospital",1179.3544921875,-1323.6357421875,14.165296554565,270},
		{"Las Venturas Hospital",1607.7412109375,1820.1416015625,10.828001022339,0}
	}
}

function Spawn.Setup()
	SQL.Exec("CREATE TABLE IF NOT EXISTS spawn_data (id INTEGER PRIMARY KEY, x FLOAT, y FLOAT, z FLOAT, rotation FLOAT, interior INTEGER, dimension INTEGER, skin INTEGER, health FLOAT, armor FLOAT, money INTEGER)")
	for k, v in ipairs(getElementsByType("player")) do
		Spawn.SetupBlip(v)
	end
end

function Spawn.SpawnPlayer(id)
	local data = SQL.Query("SELECT * FROM spawn_data WHERE id = ? LIMIT 1",id)
	if data and #data == 1 then
		source:spawn(data[1].x,data[1].y,data[1].z,data[1].rotation,data[1].skin,data[1].interior,data[1].dimension)
	else
		source:spawn(1685.65234375,-2330.4931640625,13.546875)
		local skin = Config.GetValue("default_spawn_skin")
		if skin == "random" then
			repeat until source:setModel(math.random(312))
		elseif type(tonumber(skin)) == "number" then
			source:setModel(tonumber(skin))
		end
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
			SQL.Exec("UPDATE spawn_data SET x = ?, y = ?, z = ?, rotation = ?, interior = ?, dimension = ?, skin = ?, health = ?, armor = ?, money = ? WHERE id = ?",pos.x,pos.y,pos.z,rot.z,player:getInterior(),player:getDimension(),player:getModel(),player:getHealth(),getPedArmor(player),player:getMoney(),id)
		else
			SQL.Exec("INSERT INTO spawn_data (id,x,y,z,rotation,interior,dimension,skin,health,armor,money) VALUES (?,?,?,?,?,?,?,?,?,?,?)",id,pos.x,pos.y,pos.z,rot.z,player:getInterior(),player:getDimension(),player:getModel(),player:getHealth(),getPedArmor(player),player:getMoney(),id)
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
	setTimer(function(player)
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
			if nearestHospital then
				local money = player:getMoney()
				local model = player:getModel()
				player:spawn(nearestHospital[2]+math.random(-2,2),nearestHospital[3]+math.random(-2,2),nearestHospital[4],nearestHospital[5],model)
				local bill = money >= 100 and 100 or money > 0 and money or 0
				player:fadeCamera(true,5)
				player:takeMoney(bill)
				if bill < 100 then
					player:setHealth(math.max(bill,10))
				end
				outputChatBox("* You were treated at "..nearestHospital[1].." and billed $"..tostring(bill)..".",player,255,0,0)
			end
		end
	end,15000,1,player)
end

function Spawn.Cleanup(player)
	if Spawn.PlayerBlips[player] then
		destroyElement(Spawn.PlayerBlips[player])
		Spawn.PlayerBlips[player] = nil
	end
end