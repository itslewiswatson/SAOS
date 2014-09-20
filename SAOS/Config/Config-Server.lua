Config = {
	Values = {}
}

function Config.Parse()
	Config.File = XML.load("Config.xml") or XML.create("Config.xml","config")
	if Config.File then
		for k, v in ipairs(xmlNodeGetChildren(Config.File)) do
			Config.Values[xmlNodeGetName(v)] = xmlNodeGetValue(v)
		end
		Config.File:destroy()
		return true
	end
	return false
end

function Config.GetValue(key)
	return Config.Values[key]
end