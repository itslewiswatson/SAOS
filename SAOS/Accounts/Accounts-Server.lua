Accounts = {}

function Accounts.Setup()
	SQL.Exec("CREATE TABLE IF NOT EXISTS accounts (id INTEGER PRIMARY KEY AUTO"..(Config.GetValue("db_type") == "mysql" and "_" or "").."INCREMENT, username TEXT UNIQUE, password TEXT, email TEXT, lastnick TEXT, lastip TEXT, lastserial TEXT, lastseen TIMESTAMP DEFAULT CURRENT_TIMESTAMP)")
end

function Accounts.Login(username,password)
	if not isElement(client) then
		return false
	end
	if username and password then
		local id = Accounts.Authenticate(username,password)
		if id then
			client:setData("account",id)
			client:setData("username",username)
			triggerClientEvent(client,"SAOS.onLogin",client,1)
			triggerEvent("SAOS.onLogin",client,id,username)
			Spawn.SetupBlip(client)
			Utils.PlaytimeStart(client,id)
			Weapons.LoadWeapons(client)
			return SQL.Exec("UPDATE accounts SET lastnick = ?, lastip = ?, lastserial = ?, lastseen = CURRENT_TIMESTAMP WHERE id = ?",client:getName(),client:getIP(),client:getSerial(),id)
		else
			return triggerClientEvent(client,"SAOS.onLogin",client,2)
		end
	end
	triggerClientEvent(client,"SAOS.onLogin",client,0)
end
addEvent("SAOS.Login",true)
addEventHandler("SAOS.Login",root,Accounts.Login)

function Accounts.Register(username,password,email)
	if not isElement(client) then
		return false
	end
	if username and password and email then
		if not Accounts.IsAccount(username) then
			local result,rows = SQL.Query("INSERT INTO accounts (username,password,email,lastnick,lastip,lastserial) VALUES (?,?,?,?,?,?)",username,password,email,client:getName(),client:getIP(),client:getSerial())
			return triggerClientEvent(client,"SAOS.onRegister",client,rows == 1 and 1 or 0)
		else
			return triggerClientEvent(client,"SAOS.onRegister",client,2)
		end
	end
	triggerClientEvent(client,"SAOS.onRegister",client,0)
end
addEvent("SAOS.Register",true)
addEventHandler("SAOS.Register",root,Accounts.Register)

function Accounts.Authenticate(username,password)
	if username and password then
		local query = SQL.Query("SELECT id FROM accounts WHERE username = ? AND password = ? LIMIT 1",username,password)
		return query and #query == 1 and query[1].id
	end
	return false
end

function Accounts.IsAccount(username)
	if username then
		local query = SQL.Query("SELECT id FROM accounts WHERE username = ? LIMIT 1",username)
		return query and #query == 1
	end
	return false
end

function Accounts.GetAccountPlayer(account)
	if account then
		for k, v in ipairs(getElementsByType("player")) do
			if v:getData("account") == account then
				return v
			end
		end
	end
	return false
end

function Accounts.GetPlayerAccount(player)
	return isElement(player) and player:getData("account") or false
end