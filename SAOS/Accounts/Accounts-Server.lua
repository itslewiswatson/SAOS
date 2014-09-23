Accounts = {}

function Accounts.Setup()
	SQL.Exec("CREATE TABLE IF NOT EXISTS accounts (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT(32) UNIQUE, password TEXT(32), email TEXT(64), lastnick TEXT(32), lastip TEXT(15), lastserial TEXT(32), lastseen TIMESTAMP DEFAULT CURRENT_TIMESTAMP)")
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
			triggerClientEvent(client,"SAOS.onClientLogin",client,true)
			return triggerEvent("SAOS.onLogin",client,id,username)
		end
	end
	triggerClientEvent(client,"SAOS.onClientLogin",client,false)
end

function Accounts.Register(username,password,email)
	if not isElement(client) then
		return false
	end
	if username and password and email then
		if not Accounts.IsAccount(username) then
			local result,rows = SQL.Query("INSERT INTO accounts (username,password,email,lastnick,lastip,lastserial) VALUES (?,?,?,?,?,?)",username,password,email,client:getName(),client:getIP(),client:getSerial())
			return triggerClientEvent(client,"SAOS.onClientRegister",client,rows == 1)
		end
	end
	triggerClientEvent(client,"SAOS.onClientRegister",client,false)
end

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
		for k, v in ipairs(root:getAllByType("player")) do
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