Spawn = {}

function Spawn.Setup()
	SQL.Exec("CREATE TABLE IF NOT EXISTS spawn_data (id INTEGER PRIMARY KEY, x FLOAT, y FLOAT, z FLOAT, rotation FLOAT, interior INTEGER, dimension INTEGER, skin INTEGER, health FLOAT, armor FLOAT, money INTEGER)")
end

function Spawn.SpawnPlayer(id)
	local data = SQL.Query("SELECT * FROM spawn_data WHERE id = ? LIMIT 1",id)
	if data and #data == 1 then
		source:spawn(data[1].x,data[1].y,data[1].z,data[1].rotation,data[1].skin,data[1].interior,data[1].dimension)
	else
		source:spawn(1685.65234375,-2330.4931640625,13.546875)
	end
	source:setCameraTarget()
	source:fadeCamera(true,5)
end
addEvent("SAOS.onLogin",true)
addEventHandler("SAOS.onLogin",root,Spawn.SpawnPlayer)

function Spawn.QuitHandler(player)
	local id = player:getData("account")
	if id then
		local x,y,z = player:getPosition()
		local rotX,rotY,rotZ = player:getRotation()
		local exists = SQL.Query("SELECT id FROM spawn_data WHERE id = ? LIMIT 1",id)
		if exists and #exists == 1 then
			SQL.Exec("UPDATE spawn_data SET x = ?, y = ?, z = ?, rotation = ?, interior = ?, dimension = ?, skin = ?, health = ?, armor = ?, money = ? WHERE id = ?",x,y,z,rotZ,player:getInterior(),player:getDimension(),player:getModel(),player:getHealth(),getPedArmor(player),player:getMoney(),id)
		else
			SQL.Exec("INSERT INTO spawn_data (x,y,z,rotation,interior,dimension,skin,health,armor,money) VALUES (?,?,?,?,?,?,?,?,?,?)",x,y,z,rotZ,player:getInterior(),player:getDimension(),player:getModel(),player:getHealth(),getPedArmor(player),player:getMoney(),id)
		end
	end
end