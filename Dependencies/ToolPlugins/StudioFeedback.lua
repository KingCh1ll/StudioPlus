--// KingCh1ll //--
--// 12/12/2020 //--

--// Module Table //--
local PluginModule = {}
PluginModule.__index = PluginModule

--// Services //--
local HTTP = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")

--// Modules //--
local Config = require(script.Parent.Parent.Parent.PluginConfig)

--// Varibles //--
local Active = Config.Plugins.StudioFeedback.Active
local CooldownActive = false
local cache = {}
local cache2 = {}

local StudioFeedbackGui = game.PluginGuiService:WaitForChild("StudioFeedback")

local Feedback = StudioFeedbackGui.Background.Buttons.Feedback.TextBox
local Submit = StudioFeedbackGui.Background.Buttons.Submit

StudioFeedbackGui.Enabled = false

local function FilterText(Text, PlayerId)
	if Players.LocalPlayer then
		local Result = ""

		local Success, ErrorMessage = pcall(function()
			local FilteredText = TextService:FilterStringAsync(Text, PlayerId)

			Result = FilteredText:GetNonChatStringForBroadcastAsync()
		end)

		if not Success then
			warn("Failed to filter text. Error: " .. ErrorMessage)

			return false, nil
		else
			return true, Result
		end
	else
		warn("Failed to filter. Please enable Team Create to resolve this error.")
		
		return false, nil
	end
end

local function GetUserIdFromUsername(name)
	-- First, check if the cache contains the name
	if cache[name] then 
		return cache[name] 
	end

	-- Second, check if the user is already connected to the server
	local player = Players:FindFirstChild(name)

	if player then
		cache[name] = player.UserId

		return player.UserId
	end 

	-- If all else fails, send a request
	local id
	pcall(function ()
		id = Players:GetUserIdFromNameAsync(name)
	end)

	cache[name] = id
	return id
end

--// Module Functions //--
function PluginModule.Init(Plugin, username)
	if username == nil then
		return warn("User not logged in. Please log in.")
	end

	if not Active then
		Run(username)
		Active = true
	else
		Disable()

		Active = false
	end

	return Active
end

function Run(Username)	
	Submit.MouseButton1Click:Connect(function()
		if CooldownActive then
			local LastFeedbackText = Feedback.Text

			Feedback.Text = "Cooldown is currently active. Please wait."

			wait(10)

			Feedback.Text = LastFeedbackText

			return
		end

		if Feedback.Text:len() < 5 or Feedback.Text:len() > 500 then
			local LastFeedbackText = Feedback.Text

			Feedback.Text = "Please edit your feedback. Minimum 5 & maximum 500 chars. Feedback " .. Feedback.Text.len() .. " chars."

			wait(5)

			Feedback.Text = LastFeedbackText

			return
		end
		
		local Success, ErrorMessage
		
		Success, ErrorMessage = pcall(function()
			local Status, FilterFeedback = FilterText(Feedback.Text, GetUserIdFromUsername(Username))
			
			if not Status and FilterFeedback == nil then
				Success = false
				ErrorMessage = "Failed to filter. Check output more more information. Need help? Contact KingCh1ll."
				
				return
			end
			
			local Data = HTTP:JSONEncode({
				username = Username,
				avatar_url = game.Players:GetUserThumbnailAsync(GetUserIdFromUsername(Username), Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420),
				content = Feedback
			})

			HTTP:PostAsync("https://discord.com/api/webhooks/808412663410851912/ztlYPCSgZ3PPdGc0wb6Wl4RQhoqJfdZtp-AioZcFOkSJrIIkKQMkmJ4b26kXhPb7noZQ", Data)
		end)

		if not Success then
			local OldFeedbackText = Feedback.Text
			Feedback.Text = "Failed to send feedback! Error Message: " .. ErrorMessage

			wait(10)

			Feedback.Text = OldFeedbackText
		else
			Feedback.Text = "Successfully sent feedback!"
			CooldownActive = true

			wait(1800)

			CooldownActive = false
		end
	end)
end

function Disable()

end

return PluginModule
