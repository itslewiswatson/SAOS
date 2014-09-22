SQL = {}

function SQL.Connect()
	SQL.Connection = dbConnect("sqlite","Data.db")
	return isElement(SQL.connection)
end

function SQL.Query(query,...)
	if query then
		local queryHandle = dbQuery(SQL.Connection,query,...)
		return dbPoll(queryHandle,-1)
	end
	return false
end

function SQL.Exec(query,...)
	return query and dbExec(SQL.Connection,query,...) or false
end