Updater = {}

function Updater.Setup()
	Updater.StartCheck()
	setTimer(Updater.StartCheck,3600000,0)
end

function Updater.CheckStatus(source)
	if Updater.UpdateAvailable then
		outputChatBox("* "..Utils.GetL10N(source,"UPDATE_AVAILABLE"),source,0,255,255)
	else
		outputChatBox("* "..Utils.GetL10N(source,"NO_UPDATE_AVAILABLE"),source,0,255,0)
	end
end
addCommandHandler("update",Updater.CheckStatus,false,false)

function Updater.StartCheck()
	if Updater.UpdateAvailable then
		Updater.UpdateDetected()
	else
		fetchRemote("http://cdn.rawgit.com/CallumDawson/SAOS/master/SAOS/meta.xml",Updater.CheckMeta)
	end
end

function Updater.CheckMeta(meta,errno)
	if errno == 0 then
		local localMeta = File("meta.xml",true)
		if Updater.FormatData(meta) == Updater.FormatData(localMeta:read(localMeta:getSize())) then
			Updater.UpdateDetected()
		else
			Updater.Files = {}
			local pos = 1
			while pos do
				local fileStart = meta:find("src=\"",pos,true)
				if fileStart then
					local fileEnd = meta:find("\"",fileStart+5,true)
					if fileEnd then
						table.insert(Updater.Files,meta:sub(fileStart+5,fileEnd-1))
						pos = fileEnd
					else
						pos = nil
					end
				else
					pos = nil
				end
			end
			if #Updater.Files > 0 then
				fetchRemote("http://cdn.rawgit.com/CallumDawson/SAOS/master/SAOS/"..Updater.Files[1],Updater.CheckFile,"",false,Updater.Files[1])
				table.remove(Updater.Files,1)
			else
				Updater.Files = nil
			end
		end
	end
end

function Updater.CheckFile(file,errno,path)
	if errno == 0 then
		local localFile = File(path,true)
		if not localFile or Updater.FormatData(file) ~= Updater.FormatData(localFile:read(localFile:getSize())) then
			Updater.UpdateDetected()
		end
		if localFile then
			localFile:close()
		end
		if Updater.Files and #Updater.Files > 0 then
			fetchRemote("http://cdn.rawgit.com/CallumDawson/SAOS/master/SAOS/"..Updater.Files[1],Updater.CheckFile,"",false,Updater.Files[1])
			table.remove(Updater.Files,1)
		else
			Updater.Files = nil
		end
	end
end

function Updater.FormatData(data)
	return data:gsub("\r\n","\n"):gsub("\r","\n")
end

function Updater.UpdateDetected()
	Updater.UpdateAvailable = true
	for k, v in ipairs(getElementsByType("player")) do
		outputChatBox("* "..Utils.GetL10N(v,"UPDATE_AVAILABLE"),v,0,255,255)
	end
	outputServerLog("* An updated version of SAOS is now available!")
	Updater.Files = nil
end