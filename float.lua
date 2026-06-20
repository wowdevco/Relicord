-- ✅ TOOL GIVER GUI v3.2 - Improved for HyperlaserGun & other weapons
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

-- ==================== IMPROVED TOOL GIVER ====================
local function giveTool(toolId)
    if not toolId or toolId == "" then
        warn("❌ Please enter a valid Tool ID")
        return false
    end
    
    local success, result = pcall(function()
        local assetId = "rbxassetid://" .. toolId
        local objects = game:GetObjects(assetId)
        local item = objects[1]
        
        if not item then
            warn("❌ Failed to load asset")
            return false
        end
        
        -- Deep search for Tool
        local tool = item:IsA("Tool") and item or item:FindFirstChildWhichIsA("Tool", true)
        
        if not tool then
            warn("❌ No Tool found in asset " .. toolId)
            return false
        end
        
        tool = tool:Clone()
        
        -- Fix Handle / RequiresHandle
        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart", true)
        if handle then
            tool.RequiresHandle = true
            -- Avoid direct .Handle = assignment that causes errors
        end
        
        -- Parent to Backpack
        tool.Parent = player:WaitForChild("Backpack")
        
        print("🔧 Tool cloned to Backpack: " .. tool.Name)
        
        -- Wait for character and equip
        task.wait(0.3)
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid", 3)
        
        if humanoid then
            humanoid:EquipTool(tool)
            print("✅ Equipped: " .. tool.Name)
            
            task.wait(0.2)
            pcall(function() 
                tool:Activate() 
            end)
            
            -- Extra activation loop for stubborn guns
            task.delay(0.5, function()
                pcall(function() tool:Activate() end)
            end)
        end
        
        print("✅ Tool given & equipped: " .. tool.Name .. " (ID: " .. toolId .. ")")
        return true
    end)
    
    if not success then
        warn("❌ Tool failed to load: " .. tostring(result))
        return false
    end
end

-- ==================== GUI (unchanged) ====================
if pGui:FindFirstChild("ToolGiverGUI") then pGui.ToolGiverGUI:Destroy() end

local SG = Instance.new("ScreenGui")
SG.Name = "ToolGiverGUI"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = pGui

local M = Instance.new("Frame")
M.Size = UDim2.new(0, 340, 0, 220)
M.Position = UDim2.new(0, 30, 0, 100)
M.BackgroundColor3 = Color3.fromRGB(9, 9, 15)
M.BorderSizePixel = 0
M.Active = true
M.Parent = SG
Instance.new("UICorner", M).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke", M)
stroke.Color = Color3.fromRGB(115, 62, 240)
stroke.Thickness = 2
stroke.Transparency = 0.2

local title = Instance.new("TextLabel", M)
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "🔧 TOOL GIVER"
title.TextColor3 = Color3.fromRGB(210, 168, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center

local subtitle = Instance.new("TextLabel", M)
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 45)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Paste Tool ID → Improved gun support"
subtitle.TextColor3 = Color3.fromRGB(120, 110, 160)
subtitle.TextSize = 12
subtitle.Font = Enum.Font.Gotham

local InputFrame = Instance.new("Frame", M)
InputFrame.Size = UDim2.new(1, -40, 0, 70)
InputFrame.Position = UDim2.new(0, 20, 0, 80)
InputFrame.BackgroundColor3 = Color3.fromRGB(16, 14, 27)
InputFrame.BorderSizePixel = 0
Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 10)

local ToolBox = Instance.new("TextBox", InputFrame)
ToolBox.Size = UDim2.new(1, -90, 0, 36)
ToolBox.Position = UDim2.new(0, 12, 0, 18)
ToolBox.PlaceholderText = "130113146 (HyperlaserGun)"
ToolBox.BackgroundColor3 = Color3.fromRGB(25, 22, 40)
ToolBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ToolBox.TextSize = 14
ToolBox.Font = Enum.Font.Gotham
ToolBox.ClearTextOnFocus = false
Instance.new("UICorner", ToolBox).CornerRadius = UDim.new(0, 8)

local GiveBtn = Instance.new("TextButton", InputFrame)
GiveBtn.Size = UDim2.new(0, 70, 0, 36)
GiveBtn.Position = UDim2.new(1, -82, 0, 18)
GiveBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
GiveBtn.Text = "GIVE"
GiveBtn.TextColor3 = Color3.new(1,1,1)
GiveBtn.TextSize = 14
GiveBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", GiveBtn).CornerRadius = UDim.new(0, 8)

GiveBtn.MouseButton1Click:Connect(function()
    local id = ToolBox.Text:match("%d+")
    if id then
        giveTool(id)
    else
        warn("❌ Invalid Tool ID")
    end
end)

local Status = Instance.new("TextLabel", M)
Status.Size = UDim2.new(1, -40, 0, 20)
Status.Position = UDim2.new(0, 20, 1, -35)
Status.BackgroundTransparency = 1
Status.Text = "Ready — Try HyperlaserGun ID: 130113146"
Status.TextColor3 = Color3.fromRGB(100, 200, 120)
Status.TextSize = 12
Status.Font = Enum.Font.Gotham

-- Draggable (same as before)
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

UIS.InputChanged:Connect(function(input)
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

CloseBtn.MouseButton1Click:Connect(function()
    SG:Destroy()
end)

print("✅ Tool Giver GUI v3.2 loaded — Better gun support")