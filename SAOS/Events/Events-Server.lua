Events = {
	Ready = {},
	Queued = {}
}

function Events.QueueEvent(player,event,source,...)
	if Events.Ready[player] then
		triggerClientEvent(player,event,source,...)
	else
		if not Events.Queued[player] then
			Events.Queued[player] = {{event,source,{...}}}
		else
			table.insert(Events.Queued[player],{event,source,{...}})
		end
	end
end

function Events.DownloadQueue()
	Events.Ready[client] = true
	if Events.Queued[client] then
		for k, v in ipairs(Events.Queued[client]) do
			triggerClientEvent(client,v[1],v[2],unpack(v[3]))
		end
		Events.Queued[client] = nil
	end
end
addEvent("SAOS.DownloadEventQueue",true)
addEventHandler("SAOS.DownloadEventQueue",root,Events.DownloadQueue)

function Events.Cleanup(player)
	Events.Ready[player] = nil
	Events.Queued[player] = nil
end