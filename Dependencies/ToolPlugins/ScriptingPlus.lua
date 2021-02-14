--// KingCh1ll //--
--// 12/12/2020 //--

--// Module Table //--
local PluginModule = {}
PluginModule.__index = PluginModule

--// Services //--
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

--// Modules //--
local Config = require(script.Parent.Parent.Parent.PluginConfig)

--// Varibles //--
local Active = Config.Plugins.ScriptingPlus.Active

local RunableServices = {
	workspace,
	game.Players,
	game.Lighting,
	game.ReplicatedFirst,
	game.ReplicatedStorage,
	game.ServerScriptService,
	game.ServerStorage,
	game.StarterPack,
	game.StarterPlayer,
	game.StarterPlayer.StarterCharacterScripts,
	game.StarterPlayer.StarterPlayerScripts,
	game.SoundService,
}

local Username = "Unknown"

for _, Service in pairs(RunableServices) do
	Service.DescendantAdded:Connect(function(Child)
		if Child:IsA("LuaSourceContainer") then
			if Child.Source == "print(\"Hello world!\")\n" then
				local Date = string.format("%s/%s/%s", os.date("*t").month, os.date("*t").day, os.date("*t").year)
				local NewScriptText = string.format("--[[ --// INFORMATION //--\n		WRITERS(S) = %s\n		CREATION DATE = %s\n		LAST EDITED DATE = %s\n		DETAILS = No details\n--]]\n\n", Username, Date, Date)

				local Success, ErrorMessage = pcall(function()
					Child.Source = NewScriptText
				end)

				if not Success then
					warn(string.format("[%s]: Failed to change the source. Error Message: %s", "Studio Plus", ErrorMessage))
				end
			end
		end
	end)
end

--// Module Functions //--
function PluginModule.Init(Plugin, username)
	if not Active then
		Username = username
		Run()
		Active = true
	else
		Disable()

		Active = false
	end

	return Active
end

function Run()
	-- No functions to run
end

function Disable()
	-- No functions / connections to disable
end

return PluginModule
