local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Sound feedback
local function playClickSound()
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://8394620892"
	sound.Volume = 0.6
	sound.Parent = SoundService
	sound:Play()
	game.Debris:AddItem(sound, 2)
end

-- UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerStatusUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Panel
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 270, 0, 320)
panel.Position = UDim2.new(0, 20, 0.3, 0)
panel.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
panel.BorderSizePixel = 0
panel.AnchorPoint = Vector2.new(0, 0)
panel.ClipsDescendants = true
panel.Parent = screenGui

-- Glow border (flashing)
local glow = Instance.new("UIStroke", panel)
glow.Thickness = 1.2
glow.Transparency = 0
glow.Color = Color3.fromRGB(0, 170, 255)

-- Animate glow color
task.spawn(function()
	while panel.Parent do
		local t = tick()
		local r = math.abs(math.sin(t * 1.5)) * 255
		glow.Color = Color3.fromRGB(0, 170, math.floor(r))
		RunService.RenderStepped:Wait()
	end
end)

local corner = Instance.new("UICorner", panel)
corner.CornerRadius = UDim.new(0, 10)

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = panel

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 8, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Player Status"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Minimize and Close Buttons
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 1, 0)
minimizeBtn.Position = UDim2.new(1, -60, 0, 0)
minimizeBtn.Text = "-"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 14
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = titleBar

-- Scrollable Content
local scroll = Instance.new("ScrollingFrame")
scroll.Name = "Content"
scroll.Size = UDim2.new(1, 0, 1, -30)
scroll.Position = UDim2.new(0, 0, 0, 30)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 4
scroll.BorderSizePixel = 0
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = panel

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 4)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Dragging
local dragging, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = panel.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Player Entries
local playerFrames = {}

local function getDevice(plr)
	local dev = plr.UserInputType
	if dev then return tostring(dev) end
	if plr:IsDescendantOf(Players) and plr:FindFirstChild("DeviceType") then
		return plr.DeviceType.Value
	end
	return "Unknown"
end

local function createPlayerEntry(plr)
	local char = plr.Character or plr.CharacterAdded:Wait()
	local humanoid = char:WaitForChild("Humanoid")

	local entry = Instance.new("TextLabel")
	entry.Size = UDim2.new(1, -10, 0, 24)
	entry.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	entry.TextColor3 = Color3.new(1, 1, 1)
	entry.TextXAlignment = Enum.TextXAlignment.Left
	entry.Font = Enum.Font.Gotham
	entry.TextSize = 13
	entry.BorderSizePixel = 0
	entry.Text = string.format("%s | HP: %d | Ping: ... | Device: ...", plr.Name, humanoid.Health)
	entry.Parent = scroll
	playerFrames[plr] = entry

	local function update()
		local ping = plr:GetNetworkPing() * 1000
		local device = UserInputService.TouchEnabled and "Mobile" or "PC"
		entry.Text = string.format("%s | HP: %d | Ping: %dms | Device: %s", plr.Name, humanoid.Health, math.floor(ping), device)
	end

	update()

	humanoid.HealthChanged:Connect(update)
	plr:GetPropertyChangedSignal("NetworkPing"):Connect(update)
	RunService.Heartbeat:Connect(update)

	plr.CharacterAdded:Connect(function(newChar)
		local newHumanoid = newChar:WaitForChild("Humanoid")
		newHumanoid.HealthChanged:Connect(update)
	end)
end

local function removePlayerEntry(plr)
	if playerFrames[plr] then
		playerFrames[plr]:Destroy()
		playerFrames[plr] = nil
	end
end

for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= localPlayer then
		createPlayerEntry(plr)
	end
end

Players.PlayerAdded:Connect(function(plr)
	if plr ~= localPlayer then
		createPlayerEntry(plr)
	end
end)

Players.PlayerRemoving:Connect(removePlayerEntry)

-- Minimize
local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	playClickSound()
	isMinimized = not isMinimized

	local newSize = isMinimized and UDim2.new(0, 270, 0, 30) or UDim2.new(0, 270, 0, 320)
	TweenService:Create(panel, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Size = newSize}):Play()
end)

-- Close
closeBtn.MouseButton1Click:Connect(function()
	playClickSound()
	TweenService:Create(panel, TweenInfo.new(0.25), {Transparency = 1}):Play()
	wait(0.3)
	screenGui:Destroy()
end)
