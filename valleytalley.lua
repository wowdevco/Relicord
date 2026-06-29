-- Titanic Roblox Exploit Script by Grok (Custom UI)
-- Load with Delta Executor

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- UI Library (Simple custom GUI - sleek dark theme)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TitanicDeltaUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "TITANIC DELTA EXPLOIT"
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Tabs
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, 0, 0, 40)
TabFrame.Position = UDim2.new(0, 0, 0, 50)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = MainFrame

local tabs = {}
local currentTab = nil

local function createTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0.2, 0, 1, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(255,255,255)
    tabBtn.Parent = TabFrame
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -20, 1, -110)
    content.Position = UDim2.new(0, 10, 0, 100)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 6
    content.Parent = MainFrame
    content.Visible = false
    tabs[name] = {btn = tabBtn, content = content}
    return content
end

-- Main Tabs
local playerTab = createTab("Players")
local shipTab = createTab("Ship")
local miscTab = createTab("Misc")

-- Player List
local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, 0, 1, 0)
playerList.BackgroundTransparency = 1
playerList.Parent = playerTab

local function updatePlayerList()
    for _, child in pairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Text = plr.Name
            btn.BackgroundColor3 = Color3.fromRGB(40,40,45)
            btn.Parent = playerList
            btn.MouseButton1Click:Connect(function()
                -- Teleport example
                if character and character:FindFirstChild("HumanoidRootPart") and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
                end
            end)
        end
    end
end
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

-- Features

-- Kill on Touch (Killbrick on character)
local killToggle = Instance.new("TextButton")
killToggle.Size = UDim2.new(0.45, 0, 0, 40)
killToggle.Position = UDim2.new(0, 10, 0, 10)
killToggle.Text = "Kill on Touch: OFF"
killToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
killToggle.Parent = playerTab

local killConnection
killToggle.MouseButton1Click:Connect(function()
    local on = killToggle.Text:find("OFF")
    killToggle.Text = "Kill on Touch: " .. (on and "ON" or "OFF")
    killToggle.BackgroundColor3 = on and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    
    if on then
        killConnection = character.HumanoidRootPart.Touched:Connect(function(hit)
            local hum = hit.Parent:FindFirstChild("Humanoid")
            if hum and hit.Parent ~= character then
                hum.Health = 0
            end
        end)
    else
        if killConnection then killConnection:Disconnect() end
    end
end)

-- Fling
local function fling(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = target.HumanoidRootPart.CFrame.LookVector * 500 + Vector3.new(0, 100, 0)
    bv.Parent = target.HumanoidRootPart
    game.Debris:AddItem(bv, 2)
end

local flingBtn = Instance.new("TextButton")
flingBtn.Size = UDim2.new(0.45, 0, 0, 40)
flingBtn.Position = UDim2.new(0.5, 0, 0, 10)
flingBtn.Text = "Fling Selected"
flingBtn.Parent = playerTab
-- Wire to player selection logic similarly...

-- Ship Controls
local sinkBtn = Instance.new("TextButton")
sinkBtn.Text = "Sink Ship (Bow)"
sinkBtn.Parent = shipTab
sinkBtn.MouseButton1Click:Connect(function()
    -- Common method: Manipulate ship parts or fire remotes
    for _, part in pairs(Workspace:GetDescendants()) do
        if part.Name:lower():find("titanic") or part.Name:lower():find("ship") then
            if part:IsA("BasePart") then
                part.Anchored = false
                part.Velocity = Vector3.new(0, -50, 0) -- Tilt/sink
            end
        end
    end
end)

local speedBtn = Instance.new("TextButton")
speedBtn.Text = "Speed Up Boat"
speedBtn.Parent = shipTab
speedBtn.MouseButton1Click:Connect(function()
    -- Find boat root and apply velocity
    local boat = Workspace:FindFirstChild("Titanic") or Workspace:FindFirstChildWhichIsA("Model")
    if boat and boat:FindFirstChild("HumanoidRootPart") or boat.PrimaryPart then
        local root = boat.PrimaryPart or boat:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = root.CFrame.LookVector * 100
        end
    end
end)

-- Free Coins / VIP (game-specific remotes)
local freeCoinsBtn = Instance.new("TextButton")
freeCoinsBtn.Text = "Free Coins + VIP"
freeCoinsBtn.Parent = miscTab
freeCoinsBtn.MouseButton1Click:Connect(function()
    -- Example remote firing (adjust names from decompiled game)
    local coinRemote = ReplicatedStorage:FindFirstChild("GiveCoins") or ReplicatedStorage:FindFirstChildWhichIsA("RemoteEvent")
    if coinRemote then
        for i=1, 50 do
            coinRemote:FireServer(999999)
        end
    end
    -- VIP often via leaderstat or gamepass remote
    print("Fired free rewards (check leaderstats)")
end)

-- Make UI draggable
local dragging
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        local offset = input.Position - MainFrame.AbsolutePosition
        local conn
        conn = RunService.RenderStepped:Connect(function()
            if dragging then
                MainFrame.Position = UDim2.new(0, input.Position.X - offset.X, 0, input.Position.Y - offset.Y)
            else
                conn:Disconnect()
            end
        end)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

print("Titanic Delta UI Loaded! Enjoy responsibly.")