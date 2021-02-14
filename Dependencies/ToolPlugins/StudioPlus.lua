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
local RenderStepped = RunService.RenderStepped

local FPSCounterGui = CoreGui:WaitForChild("FPSCounterGui")

local MainFrame = FPSCounterGui:FindFirstChild("MainFrame")
local FPSText = MainFrame:FindFirstChild("FPSText")
local FPSStatus = MainFrame:FindFirstChild("Status")

local FPSTypes = {
	Insane = "Powerful Computer | You have a very Powerful Computer!",
	Epic = "Insane! | You have quite the insane computer!",
	Awesome = "Good | Your computer is just above stable.",
	Great = "Great | Your computer is at a stable FPS.",
	Good = "Good | Your computer is just a little below stable.",
	Laggy = "Laggy | Your FPS is becoming unstable.",
	InsanelyLaggy = "Insanely laggy! | FPS is unstable."
}

local RunDebounce = false
local Active = Config.Plugins.StudioPlus.Active
local RunDebounceTime = 0.25

local Connections = Config.Plugins.StudioPlus.Connections


--// Module Functions //--
function PluginModule.Init(Plugin)
	if not Active then
		Run()

		Active = true
	else
		Disable()

		Active = false
	end

	return Active
end

function Run()
	FPSCounterGui.Enabled = true
	
	Connections.RenderStepped = RunService.RenderStepped:Connect(function()
		if RunDebounce then
			return
		end
		
		local Rendered = 1 / RenderStepped:Wait()
		local FPS = math.floor(Rendered)

		FPSText.Text = FPS

		if FPS >= 200 then
			FPSStatus.Text = FPSTypes.Insane

			FPSText.TextColor3 = Color3.new(0.85098, 0, 1)
			FPSStatus.TextColor3 = Color3.new(0.85098, 0, 1)
		elseif FPS >= 120 then
			FPSStatus.Text = FPSTypes.Epic

			FPSText.TextColor3 = Color3.new(0.843137, 0.52549, 1)
			FPSStatus.TextColor3 = Color3.new(0.843137, 0.52549, 1)
		elseif FPS >= 60 then
			FPSStatus.Text = FPSTypes.Awesome

			FPSText.TextColor3 = Color3.new(0, 0.517647, 1)
			FPSStatus.TextColor3 = Color3.new(0, 0.517647, 1)
		elseif FPS >= 45 then
			FPSStatus.Text = FPSTypes.Great

			FPSText.TextColor3 = Color3.new(0, 1, 0.533333)
			FPSStatus.TextColor3 = Color3.new(0, 1, 0.533333)
		elseif FPS >= 25 then
			FPSStatus.Text = FPSTypes.Good

			FPSStatus.TextColor3 = Color3.new(0.556863, 1, 0.34902)
			FPSText.TextColor3 = Color3.new(0.556863, 1, 0.34902)
		elseif FPS >= 10 then
			FPSStatus.Text = FPSTypes.Laggy

			FPSStatus.TextColor3 = Color3.new(0.901961, 1, 0)
			FPSText.TextColor3 = Color3.new(0.901961, 1, 0)
		else
			FPSStatus.Text = FPSTypes.InsanelyLaggy

			FPSStatus.TextColor3 = Color3.new(1,0,0)
			FPSText.TextColor3 = Color3.new(1,0,0)
		end
		
		RunDebounce = true
		
		wait(RunDebounceTime)
		
		RunDebounce = false
	end)
end

function Disable()
	FPSCounterGui.Enabled = false
	
	for _, Connection in pairs(Connections) do
		Connection:Disconnect()
	end
end

return PluginModule
