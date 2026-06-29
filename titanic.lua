-- Enhanced Titanic GUI 2026 - Fixed & Upgraded
-- Features: Tabs, Resizable, Teleport, Player Fling, Kill, Improved Announcement, Boat Fling

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EnhancedTitanicGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame (Resizable + Draggable)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 580)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -290)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 55)
TitleBar.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "TITANIC GUI • 2026"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.Parent = TitleBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 8)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1, 0.3, 0.3)
CloseBtn.TextSize = 28
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Dragging
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Tab System
local TabHolder = Instance.new("Frame")
TabHolder.Size = UDim2.new(1, -20, 1, -75)
TabHolder.Position = UDim2.new(0, 10, 0, 65)
TabHolder.BackgroundTransparency = 1
TabHolder.Parent = MainFrame

local Tabs = {
    Main = Instance.new("Frame"),
    Players = Instance.new("Frame"),
    Boats = Instance.new("Frame")
}

for _, tab in pairs(Tabs) do
    tab.Size = UDim2.new(1, 0, 1, 0)
    tab.BackgroundTransparency = 1
    tab.Visible = false
    tab.Parent = TabHolder
end

Tabs.Main.Visible = true

-- Tab Buttons
local tabButtons = {}
local currentTab = "Main"

local function createTabButton(name, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 16
    btn.Parent = TitleBar
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Visible = false end
        Tabs[name].Visible = true
    end)
    
    return btn
end

createTabButton("Main", UDim2.new(0, 15, 0, 8))
createTabButton("Players", UDim2.new(0, 135, 0, 8))
createTabButton("Boats", UDim2.new(0, 255, 0, 8))

-- === MAIN TAB ===
local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.9, 0, 0, 100)
TextBox.Position = UDim2.new(0.05, 0, 0.05, 0)
TextBox.PlaceholderText = "Enter announcement message..."
TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TextBox.TextColor3 = Color3.new(1,1,1)
TextBox.ClearTextOnFocus = false
TextBox.Parent = Tabs.Main

local SendBtn = Instance.new("TextButton")
SendBtn.Size = UDim2.new(0.4, 0, 0, 50)
SendBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
SendBtn.Text = "Send Announcement"
SendBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
SendBtn.TextColor3 = Color3.new(1,1,1)
SendBtn.Parent = Tabs.Main

SendBtn.MouseButton1Click:Connect(function()
    local msg = TextBox.Text
    if msg and #msg > 0 then
        local remote = ReplicatedStorage:FindFirstChild("SendAnnouncement") or 
                       ReplicatedStorage:FindFirstChild("Announcement") or
                       ReplicatedStorage:FindFirstChild("ChatEvent", true)
        if remote then
            remote:FireServer(msg)
            print("📢 Announcement sent: " .. msg)
        else
            warn("Announcement remote not found")
        end
    end
end)

-- === PLAYERS TAB ===
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(0.95, 0, 0.6, 0)
PlayerList.Position = UDim2.new(0.025, 0, 0.05, 0)
PlayerList.BackgroundTransparency = 0.3
PlayerList.BackgroundColor3 = Color3.fromRGB(30,30,30)
PlayerList.ScrollBarThickness = 6
PlayerList.Parent = Tabs.Players

local UIListLayout = Instance.new("UIListLayout", PlayerList)
UIListLayout.SortOrder = Enum.SortOrder.Name
UIListLayout.Padding = UDim.new(0, 4)

local selectedPlayer = nil

local function refreshPlayers()
    for _, child in pairs(PlayerList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 40)
            btn.Text = plr.Name
            btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Parent = PlayerList
            
            btn.MouseButton1Click:Connect(function()
                selectedPlayer = plr
                print("Selected: " .. plr.Name)
            end)
        end
    end
end

refreshPlayers()
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)

-- Teleport
local TpBtn = Instance.new("TextButton")
TpBtn.Size = UDim2.new(0.45, 0, 0, 50)
TpBtn.Position = UDim2.new(0.025, 0, 0.7, 0)
TpBtn.Text = "Teleport to Player"
TpBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
TpBtn.Parent = Tabs.Players

TpBtn.MouseButton1Click:Connect(function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
    end
end)

-- Fling Player
local FlingPlayerBtn = Instance.new("TextButton")
FlingPlayerBtn.Size = UDim2.new(0.45, 0, 0, 50)
FlingPlayerBtn.Position = UDim2.new(0.525, 0, 0.7, 0)
FlingPlayerBtn.Text = "Fling Player"
FlingPlayerBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 0)
FlingPlayerBtn.Parent = Tabs.Players

FlingPlayerBtn.MouseButton1Click:Connect(function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetRoot = selectedPlayer.Character.HumanoidRootPart
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.new(math.random(-200,200), 150, math.random(-200,200))
        bv.Parent = targetRoot
        Debris:AddItem(bv, 2)
    end
end)

-- Kill Player
local KillBtn = Instance.new("TextButton")
KillBtn.Size = UDim2.new(0.45, 0, 0, 50)
KillBtn.Position = UDim2.new(0.025, 0, 0.82, 0)
KillBtn.Text = "Kill Player"
KillBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
KillBtn.Parent = Tabs.Players

KillBtn.MouseButton1Click:Connect(function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Humanoid") then
        selectedPlayer.Character.Humanoid.Health = 0
    end
end)

-- === BOATS TAB ===
local BoatFlingBtn = Instance.new("TextButton")
BoatFlingBtn.Size = UDim2.new(0.9, 0, 0, 70)
BoatFlingBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
BoatFlingBtn.Text = "FLING NEAREST BOAT"
BoatFlingBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
BoatFlingBtn.TextSize = 20
BoatFlingBtn.Parent = Tabs.Boats

BoatFlingBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    
    local closest, dist = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("boat") or obj.Name:lower():find("ship") or obj.Name:lower():find("titanic")) then
            local d = (obj.Position - root.Position).Magnitude
            if d < dist and d < 600 then
                dist = d
                closest = obj
            end
        end
    end
    
    if closest then
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bv.Velocity = (closest.Position - root.Position).Unit * 420 + Vector3.new(0, 120, 0)
        bv.Parent = root
        Debris:AddItem(bv, 1.8)
        print("🚤 Flung boat: " .. closest.Name)
    end
end)

print("✅ Enhanced Titanic GUI Loaded! Use tabs for different features.")