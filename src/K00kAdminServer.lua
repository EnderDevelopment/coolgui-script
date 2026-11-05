-- C00LGUI Server Handler
-- Place this in a Script inside ServerScriptService.
-- Listens for the RemoteEvent fired by the client LocalScript.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Create the RemoteEvent if it does not exist
local RemoteEvent = ReplicatedStorage:FindFirstChild("K00kAdminEvent")
if not RemoteEvent then
	RemoteEvent = Instance.new("RemoteEvent")
	RemoteEvent.Name = "K00kAdminEvent"
	RemoteEvent.Parent = ReplicatedStorage
end

RemoteEvent.OnServerEvent:Connect(function(player, action, data)
	if not action then return end

	if action == "ApplyDecal" then
		-- Server-side handling: apply decal to every other player who receives it.
		-- Here we simply broadcast a flag and can apply the decal to the server character.
		local character = player.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid:SetAttribute("K00pkidDecalApplied", true)
			end
		end
	end
end)

print("[C00LGUI Server] K00kAdminEvent handler ready.")
