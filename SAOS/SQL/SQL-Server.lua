SQL = {}

function SQL.Connect()
	SQL.Connection = Connection(Config.GetValue("db_type") or "sqlite",Config.GetValue("db_host") or "Data.db",Config.GetValue("db_username") or "",Config.GetValue("db_password") or "")
	return isElement(SQL.connection)
end

function SQL.Query(query,...)
	if isElement(SQL.Connection) and query then
		local queryHandle = SQL.Connection:query(query,...)
		return queryHandle:poll(-1)
	end
	return false
end

function SQL.Exec(query,...)
	return isElement(SQL.Connection) and query and SQL.Connection:exec(query,...) or false
end