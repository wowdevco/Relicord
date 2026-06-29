-- Deobfuscated & Fixed Roblox Titanic Script (2026)
-- Original by RIP#6666 - Cleaned & Improved

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FixedTitanicGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 420, 0, 520)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "Titanic GUI - Fixed 2026"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.Parent = TitleBar

-- Draggable (Fixed)
local dragging, dragInput, dragStart, startPos

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

-- Announcement Section
local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.9, 0, 0, 80)
TextBox.Position = UDim2.new(0.05, 0, 0.12, 0)
TextBox.PlaceholderText = "Type announcement message here..."
TextBox.Text = ""
TextBox.TextColor3 = Color3.new(1,1,1)
TextBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TextBox.ClearTextOnFocus = false
TextBox.Parent = MainFrame

local SendButton = Instance.new("TextButton")
SendButton.Size = UDim2.new(0.4, 0, 0, 45)
SendButton.Position = UDim2.new(0.05, 0, 0.32, 0)
SendButton.Text = "Send Announcement"
SendButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
SendButton.TextColor3 = Color3.new(1,1,1)
SendButton.Font = Enum.Font.GothamSemibold
SendButton.TextSize = 16
SendButton.Parent = MainFrame

SendButton.MouseButton1Click:Connect(function()
    local message = TextBox.Text
    if message and message:len() > 0 then
        -- Common announcement remote (adjust if needed)
        local announceRemote = ReplicatedStorage:FindFirstChild("SendAnnouncement") or 
                              ReplicatedStorage:FindFirstChild("AnnouncementEvent", true)
        if announceRemote then
            announceRemote:FireServer(message)
            print("✅ Announcement sent: " .. message)
        else
            warn("Announcement remote not found - try different executor/server")
        end
    end
end)

-- Boat Fling
local FlingButton = Instance.new("TextButton")
FlingButton.Size = UDim2.new(0.4, 0, 0, 45)
FlingButton.Position = UDim2.new(0.55, 0, 0.32, 0)
FlingButton.Text = "Fling Nearest Boat"
FlingButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
FlingButton.TextColor3 = Color3.new(1,1,1)
FlingButton.Font = Enum.Font.GothamSemibold
FlingButton.TextSize = 16
FlingButton.Parent = MainFrame

FlingButton.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local root = char.HumanoidRootPart
    local closest, minDist = nil, math.huge
    
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name:lower():find("boat") or part.Name:lower():find("titanic") or part.Name:lower():find("ship")) then
            local distance = (part.Position - root.Position).Magnitude
            if distance < minDist and distance < 500 then
                minDist = distance
                closest = part
            end
        end
    end
    
    if closest then
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = (closest.Position - root.Position).Unit * 350 + Vector3.new(0, 80, 0)
        bv.Parent = root
        Debris:AddItem(bv, 1.5)
        
        print("🚤 Flinging boat: " .. closest.Name)
    else
        print("No boat found nearby")
    end
end)

print("✅ Fixed Titanic GUI Loaded Successfully!")