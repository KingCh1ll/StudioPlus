--// KingCh1ll //--
--// 12/12/2020 //--

--// Module Table //--
local PluginModule = {}
PluginModule.__index = PluginModule

--// Services //--
local Players = game:GetService("Players")
local SelectionService = game:GetService("Selection")
local MarketPlaceService = game:GetService("MarketplaceService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

--// Modules //--
local Config = require(script.Parent.Parent.Parent.PluginConfig)
local UtilityModule = require(script.Parent.Parent.Utility.UtilityModule)

--// Varibles //--
local Storage = script.Parent.Parent.Parent.Storage
local Active = Config.Plugins.BuildingPlus.Active
local StudioInserterGui = game.PluginGuiService:WaitForChild("BuildingPlus")

local Main = StudioInserterGui.StudioBuildingPlus

local ToggleBuildTools = Main.Toolbar.BuildToolsButton
local ToggleStudioLoader = Main.Toolbar.StudioLoaderButton

local SpawnButtons = Main.StudioLoader.Buttons.SpawnButtons
local InsertButton = Main.StudioLoader.Buttons.Insert
local InsertTextButton = Main.StudioLoader.Buttons.InsertTextButton
local UserButton = Main.StudioLoader.Buttons.UserButton
local CharacterSelectionFrame = Main.StudioLoader.CharacterSelection
local CatalogSelectionFrame = Main.StudioLoader.CatalogSelection
local WeldButton = Main.BuildingTools.Weld

local AccessoryTypes = {
	[41] = "Hair",
	[42] = "Face",
	[43] = "Neck",
	[44] = "Shoulders",
	[45] = "Front",
	[46] = "Back",
	[47] = "Waist",

	[8] = "Hat"
}

--// Code //--
StudioInserterGui.Enabled = false

--// Module Functions //--
function PluginModule.Init()
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
	ToggleBuildTools.MouseButton1Click:Connect(function()
		Main.BuildingTools.Visible = true
		Main.StudioLoader.Visible = false
	end)

	ToggleStudioLoader.MouseButton1Click:Connect(function()
		Main.BuildingTools.Visible = false
		Main.StudioLoader.Visible = true
	end)

	for _, Button in pairs(SpawnButtons:GetDescendants()) do
		if Button:IsA("TextButton") then
			Button.MouseButton1Click:Connect(function()
				local Username = UserButton.TextBox.Text
				local RigType = Button.Name
				local Char

				local Success, ErrorMessage = pcall(function()
					Char = UtilityModule.LoadCharacter(Username, RigType, workspace)
				end)

				if Success then
					Char:MoveTo(Vector3.new(0, 0, 0))
					SelectionService:Set({Char})
				else
					warn("[".. Config.Toolbar.Name .."]: An error occurred! This could be because this user doesn't exsist, You have no WiFi, or Roblox is down. Full details: " .. ErrorMessage or "ErrorMessageNil")
				end
			end)
		end
	end

	InsertButton.MouseButton1Click:Connect(function()
		local Assets

		local Success, ErrorMessage = pcall(function()
			Assets =  UtilityModule.LoadAsset(InsertTextButton.TextBox.Text) -- Id of asset - required, parent - default workspace, MoveTo - default 0, 0, 0.
		end)

		if Success then
			SelectionService:Set(Assets)
		else
			warn("[".. Config.Toolbar.Name .. "]: An error occurred! This could be because this hat doesn't exist, Roblox is down, or because of no WiFi. Full details: " .. ErrorMessage or "nil")
		end
	end)

	WeldButton.MouseButton1Click:Connect(function()
		warn("Weld function is currently offline.")

		-- Weld Functions here
	end)

	UserButton.TextBox.Changed:Connect(function(NewValue) -- When the textbox changes value...
		if NewValue == "Text" and UserButton.TextBox.Text:len() >= 3 then -- You cannot have a username on roblox under 3 chars.
			pcall(function()
				CharacterSelectionFrame.User.Text = UserButton.TextBox.Text
				CharacterSelectionFrame.Player.Image = Players:GetUserThumbnailAsync(game.Players:GetUserIdFromNameAsync(UserButton.TextBox.Text), Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
			end)
		end
	end)

	InsertTextButton.TextBox.Changed:Connect(function(NewValue) -- When the textbox changes value...
		if NewValue == "Text" then
			local Success, ProductInfo = pcall(function()
				return MarketPlaceService:GetProductInfo(InsertTextButton.TextBox.Text)
			end)

			if Success and ProductInfo and AccessoryTypes[ProductInfo.AssetTypeId] then
				CatalogSelectionFrame.CatalogId.Text = ProductInfo.Name
				CatalogSelectionFrame.CatalogImage.Image = string.format("rbxthumb://type=Asset&id=%s&w=420&h=420", InsertTextButton.TextBox.Text)
				Main.StudioLoader.Buttons.CatalogItemType.Text = "Catalog Item Type: " .. AccessoryTypes[ProductInfo.AssetTypeId]
			end
		end
	end)
	
	StudioInserterGui:BindToClose(function()
		StudioInserterGui.Enabled = not Active
	end)
end

function Disable()

end

return PluginModule
