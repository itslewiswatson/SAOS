Spawn = {
	PlayerBlips = {}
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
	Spawn.SetupBlip(source)
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

function Spawn.Cleanup(player)
	if Spawn.PlayerBlips[player] then
		destroyElement(Spawn.PlayerBlips[player])
		Spawn.PlayerBlips[player] = nil
	end
end