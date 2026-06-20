-- ==================== Key Improvements & Why They Help ====================
-- * game:GetObjects("rbxassetid://") → Only reliable client-side method
-- * Robust Handle naming + RequiresHandle → Critical for guns
-- * Script enabling → Forces LocalScripts to run
-- * Better timing/delays + multiple equip/activate attempts → Helps replication & stubborn tools
-- * Cleanup → Prevents memory leaks
-- * Extra safety checks → Better error handling
-- =========================================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

local function giveTool(toolId)
    if not toolId or toolId == "" then
        warn("❌ Please enter a valid Tool ID")
        return false
    end

    local success, result = pcall(function()
        local assetId = tonumber(toolId)
        if not assetId then
            warn("❌ Invalid numeric Tool ID")
            return false
        end

        -- Load asset (client-safe)
        local objects = game:GetObjects("rbxassetid://" .. assetId)
        local loadedModel = objects[1]
        
        if not loadedModel then
            warn("❌ Failed to load asset " .. toolId)
            return false
        end

        -- Find Tool (handles wrapped models)
        local tool = loadedModel:FindFirstChildWhichIsA("Tool", true) or (loadedModel:IsA("Tool") and loadedModel)
        if not tool then
            warn("❌ No Tool found in asset " .. toolId)
            loadedModel:Destroy()
            return false
        end

        tool = tool:Clone()
        loadedModel:Destroy()  -- Cleanup original

        -- === Fix Handle (most common gun issue) ===
        local handle = tool:FindFirstChild("Handle")
        if not handle then
            handle = tool:FindFirstChildWhichIsA("BasePart", true)
            if handle then
                handle.Name = "Handle"
                warn("⚠️ Renamed part to 'Handle' for compatibility")
            end
        end

        if handle then
            tool.RequiresHandle = true
            handle.CanCollide = false
            handle.Anchored = false
            print("✅ Handle setup complete for " .. tool.Name)
        else
            tool.RequiresHandle = false
            warn("⚠️ No Handle found")
        end

        -- Enable ALL scripts
        for _, desc in ipairs(tool:GetDescendants()) do
            if desc:IsA("LuaSourceContainer") then
                desc.Disabled = false
            end
        end

        -- Parent to Backpack
        local backpack = player:WaitForChild("Backpack")
        tool.Parent = backpack
        print("🔧 Tool added to Backpack: " .. tool.Name)

        -- Equip with delays
        task.wait(0.5)
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid", 5)

        if humanoid and tool.Parent == backpack then
            humanoid:EquipTool(tool)
            print("✅ Equipped: " .. tool.Name)

            task.wait(0.4)

            -- Multiple activation attempts
            for i = 1, 4 do
                pcall(function()
                    tool:Activate()
                end)
                task.wait(0.15)
            end

            -- Final delayed attempt
            task.delay(0.7, function()
                if tool.Parent and tool.Parent == character then
                    pcall(function() tool:Activate() end)
                end
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

-- ==================== GUI Setup ====================
if pGui:FindFirstChild("ToolGiverGUI") then
    pGui.ToolGiverGUI:Destroy()
end

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
subtitle.Text = "Paste Tool ID → Best client-side support"
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

-- Draggable
local dragging, dragStart, startPos
M.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = M.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
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

print("✅ Improved Client-Side Tool Giver Loaded (cxzpher)")