-- Script was deobfuscated with 5 seconds of work. very easy!
local tweenService = game:GetService("TweenService")
local players = game:GetService("Players")
local starterGui = game:GetService("StarterGui")
local localPlayer = players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
pcall(function()
    starterGui:SetCore("SendNotification", {
        Title = "Enjoy!",
        Text = "Made by youcannotsth",
        Duration = 5
    })
end)
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "ShaderPanel"
screenGui.ResetOnSpawn = false
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Name = "MainPanel"
local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 10)
local titleText = Instance.new("TextButton", mainFrame)
titleText.Size = UDim2.new(1, -90, 0, 30)
titleText.Position = UDim2.new(0, 0, 0, 0)
titleText.Text = "Shader Panel"
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.GothamBold
titleText.TextScaled = true
titleText.AutoButtonColor = false
local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 0.4, 0.4)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextScaled = true
closeButton.BackgroundTransparency = 1
local minimizeButton = Instance.new("TextButton", mainFrame)
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -60, 0, 0)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextScaled = true
minimizeButton.BackgroundTransparency = 1
local resetButton = Instance.new("TextButton", mainFrame)
resetButton.Size = UDim2.new(0, 30, 0, 25)
resetButton.Position = UDim2.new(1, -90, 0, 2)
resetButton.Text = "Reset"
resetButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
resetButton.TextColor3 = Color3.new(1, 1, 1)
resetButton.Font = Enum.Font.GothamBold
resetButton.TextScaled = true
local resetCorner = Instance.new("UICorner", resetButton)
resetCorner.CornerRadius = UDim.new(0, 6)
resetButton.MouseEnter:Connect(function()
    tweenService:Create(resetButton, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(90, 90, 90) }):Play()
end)
resetButton.MouseLeave:Connect(function()
    tweenService:Create(resetButton, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(60, 60, 60) }):Play()
end)
local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
scrollFrame.Size = UDim2.new(1, -10, 1, -95)
scrollFrame.Position = UDim2.new(0, 5, 0, 35)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
local layout = Instance.new("UIListLayout", scrollFrame)
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
local shaderActions = {
    XRay = function()
        game.Lighting.Ambient = Color3.fromRGB(180, 180, 255)
    end,
    Blur = function()
        local blur = Instance.new("BlurEffect", game.Lighting)
        blur.Size = 24
    end,
    Night = function()
        game.Lighting.Ambient = Color3.fromRGB(30, 30, 80)
    end,
    Day = function()
        game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    end,
    Antilag = function()
        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Decal") then
                obj.Enabled = false
            end
        end
    end
}
for _, shaderName in ipairs({ "XRay", "Blur", "Night", "Day", "Antilag" }) do
    local button = Instance.new("TextButton", scrollFrame)
    button.Size = UDim2.new(1, -10, 0, 25)
    button.Text = shaderName
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSans
    button.TextScaled = true

    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, 6)

    button.MouseButton1Click:Connect(function()
        local action = shaderActions[shaderName]
        if action then
            action()
        end
    end)
end
resetButton.MouseButton1Click:Connect(function()
    for _, v in ipairs(game.Lighting:GetChildren()) do
        if v:IsA("BlurEffect") then
            v:Destroy()
        end
    end
    game.Lighting.Ambient = Color3.fromRGB(127, 127, 127)
end)
local bottomFrame = Instance.new("Frame", mainFrame)
bottomFrame.Size = UDim2.new(1, -20, 0, 25)
bottomFrame.Position = UDim2.new(0, 10, 1, -30)
bottomFrame.BackgroundTransparency = 1
local urlBox = Instance.new("TextBox", bottomFrame)
urlBox.Size = UDim2.new(0.8, 0, 1, 0)
urlBox.Position = UDim2.new(0, 0, 0, 0)
urlBox.PlaceholderText = "Enter shader URL"
urlBox.Font = Enum.Font.Code
urlBox.TextSize = 14
urlBox.Text = ""
urlBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
urlBox.TextColor3 = Color3.new(1, 1, 1)
urlBox.TextScaled = true
local urlCorner = Instance.new("UICorner", urlBox)
urlCorner.CornerRadius = UDim.new(0, 5)
local enterButton = Instance.new("TextButton", bottomFrame)
enterButton.Size = UDim2.new(0.2, -5, 1, 0)
enterButton.Position = UDim2.new(0.8, 5, 0, 0)
enterButton.Text = "Enter"
enterButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
enterButton.TextColor3 = Color3.new(1, 1, 1)
enterButton.Font = Enum.Font.GothamBold
enterButton.TextScaled = true
local enterCorner = Instance.new("UICorner", enterButton)
enterCorner.CornerRadius = UDim.new(0, 6)
local function executeURL()
    local url = urlBox.Text
    if url ~= "" then
        local success, result = pcall(function()
            loadstring(game:HttpGet(url))()
        end)

        if success then
            pcall(function()
                starterGui:SetCore("SendNotification", {
                    Title = "Shader Loaded",
                    Text = "Your shader was applied.",
                    Duration = 4
                })
            end)
        else
            pcall(function()
                starterGui:SetCore("SendNotification", {
                    Title = "Shader Error",
                    Text = tostring(result),
                    Duration = 5
                })
            end)
        end
    end
end
urlBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        executeURL()
    end
end)
enterButton.MouseButton1Click:Connect(executeURL)
local collapsed = false
minimizeButton.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    scrollFrame.Visible = not collapsed
    bottomFrame.Visible = not collapsed
    resetButton.Visible = not collapsed

    mainFrame:TweenSize(collapsed and UDim2.new(0, 300, 0, 40) or UDim2.new(0, 300, 0, 200), "Out", "Quad", 0.3, true)
    minimizeButton.Text = collapsed and "+" or "-"
end)
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
