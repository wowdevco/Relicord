-- 🚢 Titanic Roblox Delta Exploit - Custom Minimalist UI
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TitanicMinimalUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 650, 0, 420)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 200, 180)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.7
MainStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "TITANIC • DELTA"
Title.TextColor3 = Color3.fromRGB(0, 255, 220)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBlack
Title.Parent = TitleBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Tabs Container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 45)
TabContainer.Position = UDim2.new(0, 0, 0, 50)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local tabButtons = {}
local tabContents = {}

local function createTab(name, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, 0, 1, 0)
    btn.Position = UDim2.new(pos, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(180, 180, 190)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextScaled = true
    btn.Parent = TabContainer
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -20, 1, -110)
    content.Position = UDim2.new(0, 10, 0, 105)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 180)
    content.Parent = MainFrame
    content.Visible = false
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 12)
    contentCorner.Parent = content
    
    tabButtons[name] = btn
    tabContents[name] = content
    
    btn.MouseButton1Click:Connect(function()
        for _, c in pairs(tabContents) do c.Visible = false end
        content.Visible = true
        for _, b in pairs(tabButtons) do 
            b.BackgroundColor3 = Color3.fromRGB(25,25,30)
            b.TextColor3 = Color3.fromRGB(180,180,190)
        end
        btn.BackgroundColor3 = Color3.fromRGB(0, 140, 120)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
    end)
    return content
end

local playerTab = createTab("Players", 0)
local shipTab = createTab("Ship", 0.25)
local miscTab = createTab("Misc", 0.5)

-- Default open Players tab
playerTab.Visible = true
tabButtons["Players"].BackgroundColor3 = Color3.fromRGB(0, 140, 120)
tabButtons["Players"].TextColor3 = Color3.fromRGB(255,255,255)

-- Draggable
local dragging, dragInput, dragStart
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        dragInput = input
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset + delta.X, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset + delta.Y)
        dragStart = input.Position
    end
end)
MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- === FEATURES ===

-- Player List + Selection
local selectedPlr = nil
local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(1, 0, 0.7, 0)
listFrame.Position = UDim2.new(0, 0, 0, 0)
listFrame.BackgroundTransparency = 1
listFrame.Parent = playerTab

local function refreshPlayers()
    for _, child in pairs(listFrame:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 35)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            btn.Text = plr.Name
            btn.TextColor3 = Color3.fromRGB(200,200,210)
            btn.Font = Enum.Font.Gotham
            btn.Parent = listFrame
            btn.MouseButton1Click:Connect(function()
                selectedPlr = plr
                -- Teleport
                if character:FindFirstChild("HumanoidRootPart") and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                end
            end)
        end
    end
end
refreshPlayers()
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)

-- Kill on Touch
local killToggle = Instance.new("TextButton")
killToggle.Size = UDim2.new(0.48, 0, 0, 45)
killToggle.Position = UDim2.new(0, 10, 0.75, 0)
killToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
killToggle.Text = "Kill on Touch: OFF"
killToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
killToggle.Parent = playerTab
local killConn
killToggle.MouseButton1Click:Connect(function()
    local on = killToggle.Text:find("OFF")
    killToggle.Text = "Kill on Touch: " .. (on and "ON" or "OFF")
    killToggle.BackgroundColor3 = on and Color3.fromRGB(30, 120, 80) or Color3.fromRGB(45,45,50)
    if on then
        killConn = character.HumanoidRootPart.Touched:Connect(function(hit)
            local hum = hit.Parent:FindFirstChildWhichIsA("Humanoid")
            if hum and hit.Parent ~= character then hum.Health = 0 end
        end)
    else
        if killConn then killConn:Disconnect() end
    end
end)

-- Fling Button
local flingBtn = Instance.new("TextButton")
flingBtn.Size = UDim2.new(0.48, 0, 0, 45)
flingBtn.Position = UDim2.new(0.5, 0, 0.75, 0)
flingBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
flingBtn.Text = "Fling Selected"
flingBtn.TextColor3 = Color3.fromRGB(0, 220, 200)
flingBtn.Parent = playerTab
flingBtn.MouseButton1Click:Connect(function()
    if selectedPlr and selectedPlr.Character and selectedPlr.Character:FindFirstChild("HumanoidRootPart") then
        local root = selectedPlr.Character.HumanoidRootPart
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = root.CFrame.LookVector * -350 + Vector3.new(0, 120, 0)
        bv.Parent = root
        Debris:AddItem(bv, 2)
    end
end)

-- Ship Tab
local sinkBtn = Instance.new("TextButton")
sinkBtn.Size = UDim2.new(0.48, 0, 0, 50)
sinkBtn.Position = UDim2.new(0, 10, 0, 10)
sinkBtn.BackgroundColor3 = Color3.fromRGB(30,30,35)
sinkBtn.Text = "Sink Ship (Bow)"
sinkBtn.TextColor3 = Color3.fromRGB(255, 120, 80)
sinkBtn.Parent = shipTab
sinkBtn.MouseButton1Click:Connect(function()
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name:lower():find("titanic") or part.Name:lower():find("hull") or part.Name:lower():find("deck")) then
            part.Anchored = false
            part.Velocity = Vector3.new(0, -45, 0)
            part.RotVelocity = Vector3.new(8, 2, 0)
        end
    end
end)

local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(0.48, 0, 0, 50)
speedBtn.Position = UDim2.new(0.5, 0, 0, 10)
speedBtn.BackgroundColor3 = Color3.fromRGB(30,30,35)
speedBtn.Text = "Speed Boat Up"
speedBtn.TextColor3 = Color3.fromRGB(0, 255, 180)
speedBtn.Parent = shipTab
speedBtn.MouseButton1Click:Connect(function()
    local boat = Workspace:FindFirstChild("Titanic") or Workspace:FindFirstChildWhichIsA("Model", true)
    if boat then
        local root = boat.PrimaryPart or boat:FindFirstChild("HumanoidRootPart")
        if root then root.Velocity = root.CFrame.LookVector * 180 end
    end
end)

-- Misc Tab
local coinsBtn = Instance.new("TextButton")
coinsBtn.Size = UDim2.new(0.95, 0, 0, 55)
coinsBtn.Position = UDim2.new(0.025, 0, 0, 20)
coinsBtn.BackgroundColor3 = Color3.fromRGB(25, 60, 40)
coinsBtn.Text = "Free Coins / VIP (Fire Remotes)"
coinsBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
coinsBtn.Parent = miscTab
coinsBtn.MouseButton1Click:Connect(function()
    for _, rem in pairs(ReplicatedStorage:GetDescendants()) do
        if rem:IsA("RemoteEvent") then
            for i=1, 25 do
                rem:FireServer(9999999)
            end
        end
    end
end)

print("✅ Titanic Minimalist UI Loaded - Clean & Functional")