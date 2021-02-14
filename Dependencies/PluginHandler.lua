--[[ --// INFORMATION //--
	WRITERS(S) = KingCh1ll
	CREATION DATE = 9/12/2020
	LAST EDITED DATE = 2/8/2021
	DETAILS = This is Studio Plus's Plugin Handler that is easily customizable.
--]]

--// Module Table //--
local Plugin = {}

--// Services //--
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local PluginGuiService = game:GetService("PluginGuiService")

--// Modules //--
local PluginConfig = require(script.Parent.Parent.PluginConfig)
local CheckForUpdate = require(script.Parent.Utility.UpdateChecker)

--// Varibles //--

--// Module Functions //--
function Plugin:New(NewPlugin, ToolbarName, UserId)
	if self.Loading then
		return
	end

	self.Plugin = NewPlugin

	self.UserID = UserId
	self.Username = game.Players:GetNameFromUserIdAsync(self.UserID)
	self.Toolbar = Plugin:CreateToolbar(ToolbarName)
	
	self.Loading = true

	return true
end

function Plugin:CreateToolbar(Name)
	if not self.UserID and not self.Username then
		return
	elseif self.Toolbar then
		local ExistingToolbar = self.Toolbar

		return ExistingToolbar
	end

	return self.Plugin:CreateToolbar(Name)
end

function Plugin:CreateWidget(Name, Title, Gui, WidgetInfo)
	if not self.PluginGuis then
		self.PluginGuis = {}
	elseif self.PluginGuis[Name] then
		return self.PluginGuis[Name]
	end

	local WidgetGui = self.Plugin:CreateDockWidgetPluginGui(Name, WidgetInfo)
	WidgetGui.Name = Name
	WidgetGui.Title = Title

	self.PluginGuis[Name] = WidgetGui

	for _,Children in pairs(Gui:GetChildren()) do
		local ClonedChildren = Children:Clone()

		ClonedChildren.Parent = WidgetGui
	end

	return WidgetGui
end

function Plugin:CreateButton(ModuleName, ToolDetails)
	if not self.ToolPlugins then
		self.ToolPlugins = {}
	end

	if self.ToolPlugins[ModuleName] then
		return self.ToolPlugins[ModuleName]
	else
		self.ToolPlugins[ModuleName] = {}
	end

	for _, Gui in pairs(script.Parent.Parent.Ui:GetChildren()) do
		if Gui.AutoCore.Value then
			if CoreGui:FindFirstChild(Gui.Name) then
				CoreGui:FindFirstChild(Gui.Name):Destroy()
			end

			Gui.Parent = CoreGui
		elseif PluginGuiService:FindFirstChild(Gui.Name) then
			PluginGuiService:FindFirstChild(Gui.Name):Destroy()
		end
	end

	local NewTool = self.ToolPlugins[ModuleName]

	NewTool.Name = ToolDetails.Name or "Untitled Studio Plus Plugin"
	NewTool.Description = ToolDetails.Description or "No description."
	NewTool.Icon = ToolDetails.Icon or "rbxasset://textures/ui/RobloxNameIcon.png"
	NewTool.IsWidget = ToolDetails.IsWidget or false
	NewTool.ScriptView = ToolDetails.ScriptView or false

	local PluginButton = self.Toolbar:CreateButton(NewTool.Name, NewTool.Description, NewTool.Icon)
	PluginButton.ClickableWhenViewportHidden = NewTool.ScriptView

	if NewTool.IsWidget then
		local PluginGui = Plugin:CreateWidget(ModuleName, NewTool.Name, ToolDetails.UILocation, ToolDetails.WidgetInfo)

		PluginButton.Click:Connect(function()
			local Module = require(script.Parent.ToolPlugins:FindFirstChild(ModuleName))
			local InitStatus = Module.Init(Plugin, self.Username)

			PluginGui.Enabled = not PluginGui.Enabled

			PluginButton:SetActive(InitStatus)
			ToolDetails.Active = InitStatus

			CheckForUpdate(PluginConfig.Toolbar.Name, PluginConfig.Toolbar.PluginID)
		end)
	else
		PluginButton.Click:Connect(function()
			local Module = require(script.Parent.ToolPlugins:FindFirstChild(ModuleName))
			local InitStatus = Module.Init(Plugin, self.Username)

			PluginButton:SetActive(InitStatus)
			ToolDetails.Active = InitStatus

			CheckForUpdate(PluginConfig.Toolbar.Name, PluginConfig.Toolbar.PluginID)
		end)
	end

	CheckForUpdate(PluginConfig.Toolbar.Name, PluginConfig.Toolbar.PluginID)
end

function Plugin:Unpack()
	for Name, Details in pairs(PluginConfig.Plugins) do
		local Connections = Details.Connections
		
		if not Connections or #Connections == 0 then
			return
		end
		
		for _, Connection in pairs(Connections) do
			Connection:Disconnect()
		end
	end
end

return Plugin
