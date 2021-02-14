--// KingCh1ll //--
--// 12/12/2020 //--

if game:GetService("RunService"):IsRunning() then
	return
end

local LoadingStartTime = tick()

--// Services //--
local RunService = game:GetService("RunService")

--// Modules //--
local Config = require(script.Parent.PluginConfig)
local PluginCreator = require(script.Parent.Dependencies.PluginHandler)

--// Varibles //--
local LoggedInUserId = game.StudioService:GetUserId() or -1

--// Functions //--
local function CheckPermisions(PermisionType)
	if PermisionType == "ScriptInjection" then
		local Success, ErrorMessage = pcall(function()
			Instance.new("Script", workspace):Destroy()
		end)

		if not Success then
			warn("[Studio Plus]: Studio Plus requires permision to modify scripts / insert scripts! Please enable Script Injection for Studio Plus to work.")
		end
	end
end

local function LoadModules(ModulesArray)
	for _, Descendant in pairs(ModulesArray) do
		if Descendant:IsA("ModuleScript") then
			local Success, ErrorMessage = pcall(function()
				require(Descendant)
			end)

			if not Success then
				warn(ErrorMessage)
			end
		end
	end
end

--// Code //--
local Success, ErrorMessage = pcall(function()
	PluginCreator:New(plugin, Config.Toolbar.Name, LoggedInUserId)

	CheckPermisions("ScriptInjection")

	for ModuleName, PluginDetails in pairs(Config.Plugins) do
		PluginCreator:CreateButton(ModuleName, PluginDetails)
	end
	
	LoadModules(script.Parent:GetDescendants())

	plugin.Unloading:Connect(function()
		PluginCreator:Unpack()
	end)
end)

if not Success then
	warn(string.format("[%s]: Error! %s", Config.Toolbar.Name, ErrorMessage))
else
	print(string.format("[%s]: Plugin successfully loaded in %s seconds. Welcome, %s! \n©%s Studio Plus.", Config.Toolbar.Name, tostring(math.floor(tick() - LoadingStartTime)), game.Players:GetNameFromUserIdAsync(LoggedInUserId), os.date("*t").year))
end
