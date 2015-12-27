Weapons = {}

function Weapons.Setup()
	SQL.Exec("CREATE TABLE IF NOT EXISTS player_weapons (id INTEGER, weapon INTEGER, ammo INTEGER)")
end

function Weapons.SaveWeapons(player)
	local id = player:getData("account")
	if id then
		SQL.Exec("DELETE FROM player_weapons WHERE id = ?",id)
		for i=0,12 do
			local wep = player:getWeapon(i)
			local ammo = player:getTotalAmmo(i)
			if wep and wep > 0 and ammo and ammo > 0 then
				SQL.Exec("INSERT INTO player_weapons (id,weapon,ammo) VALUES (?,?,?)",id,wep,ammo)
			end
		end
	end
end

function Weapons.LoadWeapons(player)
	local id = player:getData("account")
	if id then
		local weps = SQL.Query("SELECT weapon, ammo FROM player_weapons WHERE id = ?",id)
		for k, v in ipairs(weps) do
			giveWeapon(player,v.weapon,v.ammo)
		end
	end
end

function Weapons.GenerateWeaponsTable(player)
	local wepTable = {}
	for i=0,12 do
		local wep = player:getWeapon(i)
		local ammo = player:getTotalAmmo(i)
		if wep and wep > 0 and ammo and ammo > 0 then
			table.insert(wepTable,{wep,ammo})
		end
	end
	return wepTable
end

function Weapons.ApplyWeaponsTable(player,wepTable)
	for k, v in ipairs(wepTable) do
		giveWeapon(player,v[1],v[2])
	end
end