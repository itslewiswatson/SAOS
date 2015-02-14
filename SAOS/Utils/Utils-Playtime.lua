Utils.Playtime = {
	LoginTime = {},
	TotalPlaytime = {}
}

function Utils.SetupPlaytime()
	SQL.Exec("CREATE TABLE IF NOT EXISTS player_playtime (id INT PRIMARY KEY, playtime INT)")
	for k, v in ipairs(getElementsByType("player")) do
		local id = v:getData("account")
		if id then
			Utils.PlaytimeStart(v,id)
		end
	end
	local scoreboard = getResourceFromName("scoreboard")
	if scoreboard and getResourceState(scoreboard) == "running" then
		exports.scoreboard:scoreboardAddColumn("playtime",root,80,"Playtime",11)
	end
end

function Utils.StorePlaytime(source)
	local id = source:getData("account")
	if id and Utils.Playtime.LoginTime[source] and Utils.Playtime.TotalPlaytime[source] then
		if #SQL.Query("SELECT playtime FROM player_playtime WHERE id = ? LIMIT 1",id) == 1 then
			SQL.Query("UPDATE player_playtime SET playtime = playtime+?? WHERE id = ??",getTickCount()-Utils.Playtime.LoginTime[source],id)
		else
			SQL.Query("INSERT INTO player_playtime (playtime,id) VALUES (??,??)",getTickCount()-Utils.Playtime.LoginTime[source],id)
		end
	end
	if Utils.Playtime.LoginTime[source] then
		Utils.Playtime.LoginTime[source] = nil
	end
	if Utils.Playtime.TotalPlaytime[source] then
		Utils.Playtime.TotalPlaytime[source] = nil
	end
end

function Utils.PlaytimeStart(player,id)
	Utils.Playtime.LoginTime[player] = getTickCount()
	local query = SQL.Query("SELECT playtime FROM player_playtime WHERE id = ? LIMIT 1",id)
	if query and query[1] then
		Utils.Playtime.TotalPlaytime[player] = query[1].playtime
	else
		Utils.Playtime.TotalPlaytime[player] = 0
	end
	player:setData("playtime",Utils.GetFormattedPlaytime(Utils.GetPlaytime(player)))
end

function Utils.GetPlaytime(target)
	if target:getType() == "player" then
		if Utils.Playtime.TotalPlaytime[target] and Utils.Playtime.LoginTime[target] then
			return Utils.Playtime.TotalPlaytime[target]+(getTickCount()-Utils.Playtime.LoginTime[target])
		end
	elseif type(target) == "number" then
		local query = SQL.Query("SELECT playtime FROM player_playtime WHERE id = ? LIMIT 1",target)
		if query and query[1] then
			return query[1].playtime
		end
	end
	return false
end

function Utils.GetFormattedPlaytime(playtime)
	if playtime then
		local months = math.floor(playtime/1000/60/60/24/28)
		if months > 0 then
			return tostring(months).." "..(months == 1 and "month" or "months")
		end
		local days = math.floor(playtime/1000/60/60/24)
		if days > 0 then
			return tostring(days).." "..(days == 1 and "day" or "days")
		end
		local hours = math.floor(playtime/1000/60/60)
		if hours > 0 then
			return tostring(hours).." "..(hours == 1 and "hour" or "hours")
		end
		local minutes = math.floor(playtime/1000/60)
		if minutes > 0 then
			return tostring(minutes).." "..(minutes == 1 and "minute" or "minutes")
		end
		local seconds = math.floor(playtime/1000)
		if seconds > 0 then
			return tostring(seconds).." "..(seconds == 1 and "second" or "seconds")
		end
	end
	return false
end

function Utils.GetFullFormattedPlaytime(playtime)
	if playtime then
		local returnStr = ""
		local months = math.floor(playtime/1000/60/60/24/28)
		if months > 0 then
			returnStr = returnStr..tostring(months).." "..(months == 1 and "month, " or "months, ")
			playtime = playtime-(months*1000*60*60*24*28)
		end
		local days = math.floor(playtime/1000/60/60/24)
		if days > 0 then
			returnStr = returnStr..tostring(days).." "..(days == 1 and "day, " or "days, ")
			playtime = playtime-(days*1000*60*60*24)
		end
		local hours = math.floor(playtime/1000/60/60)
		if hours > 0 then
			returnStr = returnStr..tostring(hours).." "..(hours == 1 and "hour, " or "hours, ")
			playtime = playtime-(hours*1000*60*60)
		end
		local minutes = math.floor(playtime/1000/60)
		if minutes > 0 then
			returnStr = returnStr..tostring(minutes).." "..(minutes == 1 and "minute, " or "minutes, ")
			playtime = playtime-(minutes*1000*60)
		end
		local seconds = math.floor(playtime/1000)
		if seconds > 0 then
			returnStr = returnStr..tostring(seconds).." "..(seconds == 1 and "second, " or "seconds, ")
			playtime = playtime-(seconds*1000)
		end
		return returnStr:sub(1,-3)
	end
	return false
end

function Utils.GetTotalPlaytime()
	local query = SQL.Query("SELECT SUM(playtime) AS total_playtime FROM player_playtime")
	if query and query[1] then
		local total = query[1].total_playtime
		for k, v in ipairs(getElementsByType("player")) do
			if Utils.Playtime.LoginTime[v] then
				total = total+(getTickCount()-Utils.Playtime.LoginTime[v])
			end
		end
		return total
	end
	return 0
end

function Utils.PlaytimePulse()
	for k, v in ipairs(getElementsByType("player")) do
		local playtime = Utils.GetFormattedPlaytime(Utils.GetPlaytime(v))
		if playtime then
			v:setData("playtime",playtime)
		end
	end
end
setTimer(Utils.PlaytimePulse,30000,0)

addEventHandler("onResourceStart",root,function(resource)
	if getResourceName(resource) == "scoreboard" then
		exports.scoreboard:scoreboardAddColumn("playtime",root,80,"Playtime",11)
	end
end)