local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

local TORNADO_ID = "2333247519"

local function spawnTornado(position)
    local success, result = pcall(function()
        local objects = game:GetObjects("rbxassetid://" .. TORNADO_ID)
        local original = objects[1]
        
        if not original then
            error("Failed to load model")
        end
        
        local tornado = original:Clone()
        
        -- Critical fixes for models
        if tornado.PrimaryPart then
            tornado:PivotTo(CFrame.new(position) * CFrame.new(0, 10, 0))
        else
            -- Fallback if no PrimaryPart
            local root = tornado:FindFirstChildWhichIsA("BasePart") or tornado:FindFirstChild("Tornado") or tornado:FindFirstChild("Main")
            if root then
                root.CFrame = CFrame.new(position) * CFrame.new(0, 10, 0)
            else
                tornado:PivotTo(CFrame.new(position) * CFrame.new(0, 10, 0))
            end
        end
        
        -- Unanchor everything for physics/movement
        for _, part in ipairs(tornado:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = false
                part.CanCollide = true
            end
        end
        
        -- Re-parent scripts properly (many tornado models rely on Scripts)
        for _, script in ipairs(tornado:GetDescendants()) do
            if script:IsA("Script") or script:IsA("LocalScript") then
                script.Disabled = false
            end
        end
        
        tornado.Parent = workspace
        
        print("🌪️ Tornado spawned at " .. tostring(position))
        print("   Model Name: " .. tornado.Name)
        print("   PrimaryPart: " .. tostring(tornado.PrimaryPart))
        
        -- Extra: Try to run any init function if it exists
        if tornado:FindFirstChild("Init") or tornado:FindFirstChild("Start") then
            task.delay(0.5, function()
                pcall(function() tornado:FindFirstChild("Init"):Fire() end)
            end)
        end
        
        return true
    end)
    
    if not success then
        warn("❌ Tornado spawn failed: " .. tostring(result))
    end
end

-- Placement system
local placing = false
local connection

local function startPlacement()
    if placing then return end
    placing = true
    
    local mouse = player:GetMouse()
    mouse.Icon = "rbxasset://textures/GunCursor.png"
    
    connection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local hit = mouse.Hit
            if hit then
                spawnTornado(hit.Position)
                stopPlacement()
            end
        end
    end)
    
    print("🖱️ Click on the ground to spawn the tornado!")
end

local function stopPlacement()
    placing = false
    if connection then connection:Disconnect() end
    player:GetMouse().Icon = ""
end

-- ==================== GUI (same style) ====================
if pGui:FindFirstChild("TornadoSpawnerGUI") then pGui.TornadoSpawnerGUI:Destroy() end

local SG = Instance.new("ScreenGui")
SG.Name = "TornadoSpawnerGUI"
SG.ResetOnSpawn = false
SG.Parent = pGui

local M = Instance.new("Frame")
M.Size = UDim2.new(0, 340, 0, 200)
M.Position = UDim2.new(0, 30, 0, 100)
M.BackgroundColor3 = Color3.fromRGB(9, 9, 15)
M.Active = true
M.Parent = SG

Instance.new("UICorner", M).CornerRadius = UDim.new(0, 14)
local stroke = Instance.new("UIStroke", M)
stroke.Color = Color3.fromRGB(115, 62, 240)
stroke.Thickness = 2

local title = Instance.new("TextLabel", M)
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "🌪️ TORNADO SPAWNER"
title.TextColor3 = Color3.fromRGB(210, 168, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center

local subtitle = Instance.new("TextLabel", M)
subtitle.Size = UDim2.new(1, 0, 0, 40)
subtitle.Position = UDim2.new(0, 0, 0, 45)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Click Spawn → Click ground\n(Now with better replication & physics)"
subtitle.TextColor3 = Color3.fromRGB(120, 110, 160)
subtitle.TextSize = 13
subtitle.Font = Enum.Font.Gotham
subtitle.TextWrapped = true

local SpawnBtn = Instance.new("TextButton", M)
SpawnBtn.Size = UDim2.new(0.8, 0, 0, 50)
SpawnBtn.Position = UDim2.new(0.1, 0, 0, 100)
SpawnBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
SpawnBtn.Text = "SPAWN TORNADO"
SpawnBtn.TextColor3 = Color3.new(1,1,1)
SpawnBtn.TextSize = 18
SpawnBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", SpawnBtn).CornerRadius = UDim.new(0, 10)

SpawnBtn.MouseButton1Click:Connect(startPlacement)

-- Status + Draggable + Close (unchanged from before)
local Status = Instance.new("TextLabel", M)
Status.Size = UDim2.new(1, -40, 0, 20)
Status.Position = UDim2.new(0, 20, 1, -35)
Status.BackgroundTransparency = 1
Status.Text = "Improved spawning - check Output for logs"
Status.TextColor3 = Color3.fromRGB(100, 200, 120)
Status.TextSize = 12
Status.Font = Enum.Font.Gotham

-- Draggable code (same as your original)
local dragging, dragStart, startPos
M.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = M.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        M.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local CloseBtn = Instance.new("TextButton", M)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -30, 0, 8)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(200, 80, 80)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.MouseButton1Click:Connect(function() SG:Destroy() end)

print("✅ Improved Tornado Spawner loaded - Check Output window for debug info")