local InsertService = game:GetService("InsertService")
local RunService = game:GetService("RunService")

local ThisConfig = require(script.Parent.Parent.Parent.PluginConfig)

return function(PluginName, PluginId)
	local ThisPluginVersion = ThisConfig.Toolbar.PluginVersion
	
	local Success, PluginVersion = pcall(function()
		local LoadPlugin =  InsertService:LoadAsset(PluginId)
		local PluginConfig = require(LoadPlugin[script.Parent.Parent.Parent.Name]:FindFirstChild("PluginConfig"))
		
		return PluginConfig.Toolbar.PluginVersion
	end)

	if Success and PluginVersion then
		if ThisPluginVersion < PluginVersion then
			return warn(string.format("[%s]: Plugin needs to be updated! Please navigate to Plugins > Manage Plugins in order to update %s.", PluginName, PluginName))
		end
	else
		return warn(string.format("[%s]: Failed to check for update. Please manually check.", PluginName))
	end
end
