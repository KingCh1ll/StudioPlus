local UtilltysModule = {}

local Players = game:GetService("Players")
local InsertService = game:GetService("InsertService")

function UtilltysModule.AddComas(String)
	-- Thanks berezaa :)

	return #String % 3 == 0 and String:reverse():gsub("(%d%d%d)", "%1,"):reverse():sub(2) or String:reverse():gsub("(%d%d%d)", "%1,"):reverse()
end

function UtilltysModule.PlaySound(SoundData)
	local SoundName = SoundData[1]
	local SoundDuration = SoundData[2]
	local SoundLocation = SoundData[3]

	-- Stoping here. Future KingCh1ll, please put this on your TODO list.
	-- 2 months later KingCh1ll: Nah bro. Ask next mouth KingCh1ll.
end

function UtilltysModule.LoadAsset(AssetId, parent, MoveTo)
	local Model = InsertService:LoadAsset(AssetId)
	local Assets = {}

	for Number, CatalogItem in pairs(Model:GetChildren()) do
		Assets[Number] = CatalogItem
		Assets[Number].Parent = parent or workspace
	end
	
	Model:MoveTo(MoveTo or Vector3.new(0, 0, 0))
	Model:Destroy()

	return Assets
end

function UtilltysModule.LoadCharacter(Username, RigType, parent)
	local UserID = Players:GetUserIdFromNameAsync(Username)
	local HumanoidDescription = Players:GetHumanoidDescriptionFromUserId(UserID)

	local NewCharacter = script.Parent.Parent.Parent.Storage.RigTypes:FindFirstChild(RigType or "R15"):Clone()

	NewCharacter.Name = Username
	NewCharacter.Parent = parent

	--// Once the character is parented, we can give Username's stuff! //--
	NewCharacter.Humanoid:ApplyDescription(HumanoidDescription)

	for _, Object in pairs(NewCharacter:GetDescendants()) do
		if Object.Name == "Handle" then
			Object.Name = Object.Parent.Name
		end

		pcall(function()
			Object.Locked = false
		end)
	end

	return NewCharacter
end

function UtilltysModule.GetDevice()
	-- TODO
end

return UtilltysModule
