-- C00LGUI Style Admin/Utility Script
-- Place this in a LocalScript inside StarterPlayer > StarterPlayerScripts.
-- Requires a RemoteEvent named "K00kAdminEvent" in ReplicatedStorage for server-side effects.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================================================
-- CONFIGURATION
-- ============================================================================
local CONFIG = {
	Keybind = Enum.KeyCode.RightShift, -- Open/close the GUI
	-- The decal applied by the "Decal" option (K00pkid decal asset id)
	K00pkidDecal = "rbxassetid://12128031320", -- <-- REPLACE with your K00pkid decal id
	GuiColor = Color3.fromRGB(30, 30, 30),
	AccentColor = Color3.fromRGB(255, 80, 80),
	TextColor = Color3.fromRGB(255, 255, 255),
}

-- ============================================================================
-- SERVER COMMUNICATION
-- ============================================================================
local RemoteEvent = ReplicatedStorage:FindFirstChild("K00kAdminEvent")

local function fireServer(action, data)
	if RemoteEvent then
		RemoteEvent:FireServer(action, data)
	else
		warn("[C00LGUI] K00kAdminEvent not found in ReplicatedStorage. Effects won't be applied on the server.")
	end
end

-- ============================================================================
-- GUI BUILDER
-- ============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "C00LGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

-- Main frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(220, 320)
Main.Position = UDim2.new(0.5, -110, 0.5, -160)
Main.BackgroundColor3 = CONFIG.GuiColor
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Main

-- Accent bar on top
local AccentBar = Instance.new("Frame")
AccentBar.Name = "AccentBar"
AccentBar.Size = UDim2.new(1, 0, 0, 4)
AccentBar.BackgroundColor3 = CONFIG.AccentColor
AccentBar.BorderSizePixel = 0
AccentBar.Parent = Main

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "C00LGUI"
Title.TextColor3 = CONFIG.AccentColor
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = Main

-- OptionButton factory
local function createOptionButton(name, text, callback, parent)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(1, -24, 0, 34)
	button.BackgroundColor3 = CONFIG.AccentColor
	button.BackgroundTransparency = 0.15
	button.BorderSizePixel = 0
	button.Text = text
	button.TextColor3 = CONFIG.TextColor
	button.TextSize = 16
	button.Font = Enum.Font.Gotham
	button.AutoButtonColor = true
	button.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = button

	button.Activated:Connect(function()
		callback(button)
	end)

	return button
end

-- Options container
local Options = Instance.new("Frame")
Options.Name = "Options"
Options.Size = UDim2.new(1, 0, 1, -50)
Options.Position = UDim2.new(0, 0, 0, 50)
Options.BackgroundTransparency = 1
Options.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Parent = Options

-- ============================================================================
-- OPTIONS / BUTTONS
-- ============================================================================
local buttons = {}

-- 1. K00pkid Decal option
createOptionButton(
	"K00pkidDecal",
	"K00pkid Decal",
	function(button)
		-- Apply decal to the user's character (local effect) and inform server
		coroutine.wrap(function()
			local character = player.Character or player.CharacterAdded:Wait()
			local humanoid = character:WaitForChild("Humanoid")
			humanoid:SetAttribute("C00KGuiDecalApplied", true)

			-- Apply to all BaseParts of the character
			for _, part in ipairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					local decal = Instance.new("Decal")
					decal.Name = "K00pkidDecal"
					decal.Texture = CONFIG.K00pkidDecal
					decal.Parent = part
				end
			end

			-- Notify the player
			titleNotification("K00pkid decal applied!")
		end)()
		fireServer("ApplyDecal", { decalId = CONFIG.K00pkidDecal })
	end,
	Options
)

-- 2. Remove Decal option
createOptionButton(
	"RemoveDecal",
	"Remove K00pkid Decal",
	function(button)
		local character = player.Character
		if character then
			for _, decal in ipairs(character:GetDescendants()) do
				if decal.Name == "K00pkidDecal" and decal:IsA("Decal") then
					decal:Destroy()
				end
			end
			titleNotification("K00pkid decal removed!")
		end
	end,
	Options
)

-- 3. Fly option
createOptionButton(
	"Fly",
	"Fly (Toggle)",
	function(button)
		local character = player.Character
		if not character then return end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local rootPart = character:FindFirstChild("HumanoidRootPart")
		if not humanoid or not rootPart then return end

		local flying = button:GetAttribute("Flying") == true
		flying = not flying
		button:SetAttribute("Flying", flying)

		if flying then
			local bodyGyro = Instance.new("BodyGyro")
			bodyGyro.MaxTorque = Vector3.new(0, 0, 0)
			bodyGyro.Parent = rootPart

			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bodyVelocity.Velocity = Vector3.new(0, 0, 0)
			bodyVelocity.Parent = rootPart

			button.Text = "Fly (ON)"
			titleNotification("Fly enabled - use WASD/Space")
		else
			for _, obj in ipairs(rootPart:GetChildren()) do
				if obj:IsA("BodyGyro") or obj:IsA("BodyVelocity") then
					obj:Destroy()
				end
			end
			button.Text = "Fly (Toggle)"
			titleNotification("Fly disabled")
		end
	end,
	Options
)

-- 4. Speed option (small text conversion demo)
createOptionButton(
	"Speed",
	"Speed  ᴏɴ",
	function(button)
		local character = player.Character
		if not character then return end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = humanoid.WalkSpeed >= 100 and 16 or 100
			titleNotification("Speed: " .. (humanoid.WalkSpeed == 16 and "ɴᴏʀᴍᴀʟ" or "ꜰᴀꜱᴛ"))
		end
	end,
	Options
)

-- 5. Close option
createOptionButton(
	"Close",
	"Close",
	function(button)
		setGuiVisible(false)
	end,
	Options
)

-- ============================================================================
-- NOTIFICATION (small text)
-- ============================================================================
local Notification = Instance.new("TextLabel")
Notification.Name = "Notification"
Notification.Size = UDim2.new(0, 300, 0, 30)
Notification.Position = UDim2.new(0.5, -150, 0.8, 0)
Notification.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Notification.BackgroundTransparency = 0.3
Notification.BorderSizePixel = 0
Notification.TextColor3 = Color3.fromRGB(255, 255, 255)
Notification.TextSize = 14
Notification.Font = Enum.Font.Gotham
Notification.Visible = false
Notification.Parent = ScreenGui

local NotificationCorner = Instance.new("UICorner")
NotificationCorner.CornerRadius = UDim.new(0, 6)
NotificationCorner.Parent = Notification

local function titleNotification(text)
	Notification.Text = text
	Notification.Visible = true
	TweenService:Create(Notification, TweenInfo.new(0.15), { BackgroundTransparency = 0.3 }):Play()
	task.wait(2)
	TweenService:Create(Notification, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
	task.wait(0.4)
	Notification.Visible = false
end

-- ============================================================================
-- GUI VISIBILITY
-- ============================================================================
local function setGuiVisible(state)
	Main.Visible = state
	UserInputService.MouseBehavior = state and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default
	if state then
		TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(220, 320) }):Play()
	end
end

UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == CONFIG.Keybind then
		setGuiVisible(not Main.Visible)
	end
end)

-- Guard against duplicate GUIs on respawn
player.CharacterAdded:Connect(function(character)
	task.wait()
	-- Re-apply decal option stays available; nothing to do here
end)

print("[C00LGUI] Loaded. Press RightShift to toggle.")
