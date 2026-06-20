-- GOD MODE GUI v2.2 for NDS + Tool Giver
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local InsertService = game:GetService("InsertService")

local player = Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

local conns = {}
local btnStates = {}
local btnSetters = {}

local function H()
    local c = player.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function R()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function drop(key)
    if conns[key] then conns[key]:Disconnect(); conns[key] = nil end
end

-- ==================== ORIGINAL FEATURES (Improved) ====================
local function applyInfHealth(on)
    drop("infH")
    if not on then return end
    local hum = H()
    if hum then hum.MaxHealth = math.huge; hum.Health = math.huge end
    
    conns.infH = RunService.Heartbeat:Connect(function()
        local h = H()
        if h then
            h.MaxHealth = math.huge
            h.Health = math.huge
        end
    end)
end

local function applyAntiDeath(on)
    drop("adLoop")
    if not on then return end
    conns.adLoop = RunService.Heartbeat:Connect(function()
        local h = H()
        if h and h.Health < 1 then
            h.MaxHealth = math.huge; h.Health = math.huge
        end
    end)
end

local function applyAntiRagdoll(on)
    drop("ar")
    if not on then return end
    conns.ar = RunService.Heartbeat:Connect(function()
        local h = H()
        if not h then return end
        h.PlatformStand = false
        local state = h:GetState()
        if state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            h:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end

local function applyNoFall(on)
    drop("nf"); drop("nfState")
    if not on then return end
    
    conns.nf = RunService.Heartbeat:Connect(function()
        local root = R()
        local hum = H()
        if root and hum then
            local vel = root.AssemblyLinearVelocity
            if vel.Y < -45 then
                root.AssemblyLinearVelocity = Vector3.new(vel.X, math.max(vel.Y, -25), vel.Z)
            end
        end
    end)
    
    local hum = H()
    if hum then
        conns.nfState = hum.StateChanged:Connect(function(_, new)
            if new == Enum.HumanoidStateType.Landed then
                local root = R()
                if root then
                    local vel = root.AssemblyLinearVelocity
                    root.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z)
                end
            end
        end)
    end
end

local function applyGodMode(on)
    applyInfHealth(on)
    applyAntiDeath(on)
    applyAntiRagdoll(on)
    applyNoFall(on)
    for _, n in ipairs({"Infinite Health", "Anti-Death", "Anti-Ragdoll", "No Fall Damage"}) do
        if btnSetters[n] then btnSetters[n](on, true) end
    end
end

-- ==================== TOOL GIVER ====================
local function giveTool(toolId)
    if not toolId or toolId == "" then
        warn("Please enter a valid Tool ID")
        return false
    end
    
    local success, err = pcall(function()
        local objects = game:GetObjects("rbxassetid://" .. toolId)
        local tool = objects[1]
        
        if tool and tool:IsA("Tool") then
            tool = tool:Clone()
            tool.Parent = player:WaitForChild("Backpack")
            print("✅ Tool given: " .. tool.Name .. " (ID: " .. toolId .. ")")
            return true
        elseif tool then
            -- Some assets have the tool inside a model
            local foundTool = tool:FindFirstChildWhichIsA("Tool", true)
            if foundTool then
                foundTool = foundTool:Clone()
                foundTool.Parent = player.Backpack
                print("✅ Tool given: " .. foundTool.Name .. " (ID: " .. toolId .. ")")
                return true
            end
        end
        warn("Could not find Tool in asset ID: " .. toolId)
        return false
    end)
    
    if not success then
        warn("Failed to load tool: " .. tostring(err))
        return false
    end
end

-- ==================== GUI ====================
if pGui:FindFirstChild("GodGUI") then pGui.GodGUI:Destroy() end

local SG = Instance.new("ScreenGui")
SG.Name = "GodGUI"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = pGui

local M = Instance.new("Frame")
M.Size = UDim2.new(0, 320, 0, 480)
M.Position = UDim2.new(0, 18, 0, 56)
M.BackgroundColor3 = Color3.fromRGB(9, 9, 15)
M.BorderSizePixel = 0
M.Active = true
M.Parent = SG
Instance.new("UICorner", M).CornerRadius = UDim.new(0, 13)

-- Outer glow
local s = Instance.new("UIStroke", M)
s.Color = Color3.fromRGB(115, 62, 240)
s.Thickness = 1.5
s.Transparency = 0.18

-- Title
local TZ = Instance.new("Frame", M)
TZ.Size = UDim2.new(1, 0, 0, 54)
TZ.Position = UDim2.new(0, 0, 0, 4)
TZ.BackgroundTransparency = 1

local title = Instance.new("TextLabel", TZ)
title.Size = UDim2.new(1, -100, 0, 26)
title.Position = UDim2.new(0, 14, 0, 6)
title.BackgroundTransparency = 1
title.Text = "⚡ GOD MODE"
title.TextColor3 = Color3.fromRGB(210, 168, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

local subtitle = Instance.new("TextLabel", TZ)
subtitle.Size = UDim2.new(1, -100, 0, 14)
subtitle.Position = UDim2.new(0, 14, 0, 35)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Natural Disaster Survival + Tool Giver"
subtitle.TextColor3 = Color3.fromRGB(72, 62, 112)
subtitle.TextSize = 10
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left

-- Tool Giver Section
local ToolFrame = Instance.new("Frame", M)
ToolFrame.Size = UDim2.new(1, -22, 0, 80)
ToolFrame.Position = UDim2.new(0, 11, 0, 70)
ToolFrame.BackgroundColor3 = Color3.fromRGB(16, 14, 27)
ToolFrame.BorderSizePixel = 0
Instance.new("UICorner", ToolFrame).CornerRadius = UDim.new(0, 10)

local ToolLabel = Instance.new("TextLabel", ToolFrame)
ToolLabel.Size = UDim2.new(1, 0, 0, 25)
ToolLabel.Position = UDim2.new(0, 0, 0, 8)
ToolLabel.BackgroundTransparency = 1
ToolLabel.Text = "🔧 Tool Giver"
ToolLabel.TextColor3 = Color3.fromRGB(192, 140, 255)
ToolLabel.TextSize = 14
ToolLabel.Font = Enum.Font.GothamBold

local ToolBox = Instance.new("TextBox", ToolFrame)
ToolBox.Size = UDim2.new(0.65, -20, 0, 30)
ToolBox.Position = UDim2.new(0, 12, 0, 40)
ToolBox.PlaceholderText = "Paste Tool ID here..."
ToolBox.BackgroundColor3 = Color3.fromRGB(25, 22, 40)
ToolBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ToolBox.TextSize = 13
ToolBox.Font = Enum.Font.Gotham
Instance.new("UICorner", ToolBox).CornerRadius = UDim.new(0, 6)

local GiveBtn = Instance.new("TextButton", ToolFrame)
GiveBtn.Size = UDim2.new(0.3, 0, 0, 30)
GiveBtn.Position = UDim2.new(0.68, 8, 0, 40)
GiveBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
GiveBtn.Text = "GIVE"
GiveBtn.TextColor3 = Color3.new(1,1,1)
GiveBtn.TextSize = 13
GiveBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", GiveBtn).CornerRadius = UDim.new(0, 6)

GiveBtn.MouseButton1Click:Connect(function()
    local id = ToolBox.Text:match("%d+")
    if id then
        giveTool(id)
    else
        warn("Invalid Tool ID")
    end
end)

-- Scroll for normal toggles (moved down)
local Scr = Instance.new("ScrollingFrame", M)
Scr.Size = UDim2.new(1, -22, 1, -190)
Scr.Position = UDim2.new(0, 11, 0, 165)
Scr.BackgroundTransparency = 1
Scr.ScrollBarThickness = 3
Scr.ScrollBarImageColor3 = Color3.fromRGB(115, 62, 240)
Scr.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scr.ClipsDescendants = true

local ll = Instance.new("UIListLayout", Scr)
ll.SortOrder = Enum.SortOrder.LayoutOrder
ll.Padding = UDim.new(0, 7)

-- Status bar
local StatBg = Instance.new("Frame", M)
StatBg.Size = UDim2.new(1, -22, 0, 28)
StatBg.Position = UDim2.new(0, 11, 1, -34)
StatBg.BackgroundColor3 = Color3.fromRGB(13, 12, 22)
Instance.new("UICorner", StatBg).CornerRadius = UDim.new(0, 8)

local StatLbl = Instance.new("TextLabel", StatBg)
StatLbl.Size = UDim2.new(1, -12, 1, 0)
StatLbl.Position = UDim2.new(0, 8, 0, 0)
StatLbl.BackgroundTransparency = 1
StatLbl.Text = "● STANDBY"
StatLbl.TextColor3 = Color3.fromRGB(80, 75, 125)
StatLbl.TextSize = 11
StatLbl.Font = Enum.Font.Gotham
StatLbl.TextXAlignment = Enum.TextXAlignment.Left

local function refreshStatus()
    local n = 0
    for _, v in pairs(btnStates) do if v then n = n + 1 end end
    if n == 0 then
        StatLbl.Text = "● STANDBY — no features active"
        StatLbl.TextColor3 = Color3.fromRGB(80, 75, 125)
    else
        StatLbl.Text = "● ACTIVE — " .. n .. " feature" .. (n ~= 1 and "s" or "")
        StatLbl.TextColor3 = Color3.fromRGB(70, 200, 115)
    end
end

-- Button Factory (same as before)
local CON  = Color3.fromRGB(60, 180, 100)
local COFF = Color3.fromRGB(34, 32, 58)
local KON  = Color3.fromRGB(255, 255, 255)
local KOFF = Color3.fromRGB(125, 115, 170)

local function tw(obj, props)
    TweenService:Create(obj, TweenInfo.new(0.17, Enum.EasingStyle.Quad), props):Play()
end

local function newButton(order, ico, name, desc, applyFn, special)
    local C = Instance.new("Frame", Scr)
    C.Size = UDim2.new(1, 0, 0, 60)
    C.BackgroundColor3 = Color3.fromRGB(16, 14, 27)
    C.LayoutOrder = order
    Instance.new("UICorner", C).CornerRadius = UDim.new(0, 10)

    if special then
        local stroke = Instance.new("UIStroke", C)
        stroke.Color = Color3.fromRGB(172, 90, 255)
        stroke.Thickness = 1
        stroke.Transparency = 0.48
    end

    -- (Icon, Name, Desc, Toggle code same as your original)
    local IcoL = Instance.new("TextLabel", C)
    IcoL.Size = UDim2.new(0, 40, 1, 0)
    IcoL.Position = UDim2.new(0, 7, 0, 0)
    IcoL.BackgroundTransparency = 1
    IcoL.Text = ico
    IcoL.TextSize = 18
    IcoL.Font = Enum.Font.GothamBold
    IcoL.TextColor3 = special and Color3.fromRGB(192, 140, 255) or Color3.fromRGB(132, 118, 192)

    local NL = Instance.new("TextLabel", C)
    NL.Size = UDim2.new(1, -106, 0, 22)
    NL.Position = UDim2.new(0, 48, 0, 9)
    NL.BackgroundTransparency = 1
    NL.Text = name
    NL.TextColor3 = Color3.fromRGB(202, 192, 252)
    NL.TextSize = 13
    NL.Font = Enum.Font.GothamBold
    NL.TextXAlignment = Enum.TextXAlignment.Left

    local DL = Instance.new("TextLabel", C)
    DL.Size = UDim2.new(1, -106, 0, 15)
    DL.Position = UDim2.new(0, 48, 0, 34)
    DL.BackgroundTransparency = 1
    DL.Text = desc
    DL.TextColor3 = Color3.fromRGB(68, 60, 105)
    DL.TextSize = 10
    DL.Font = Enum.Font.Gotham
    DL.TextXAlignment = Enum.TextXAlignment.Left

    local Trk = Instance.new("Frame", C)
    Trk.Size = UDim2.new(0, 42, 0, 22)
    Trk.Position = UDim2.new(1, -49, 0.5, -11)
    Trk.BackgroundColor3 = COFF
    Instance.new("UICorner", Trk).CornerRadius = UDim.new(1, 0)

    local Knb = Instance.new("Frame", Trk)
    Knb.Size = UDim2.new(0, 16, 0, 16)
    Knb.Position = UDim2.new(0, 3, 0.5, -8)
    Knb.BackgroundColor3 = KOFF
    Instance.new("UICorner", Knb).CornerRadius = UDim.new(1, 0)

    local Ovr = Instance.new("TextButton", C)
    Ovr.Size = UDim2.new(1, 0, 1, 0)
    Ovr.BackgroundTransparency = 1
    Ovr.Text = ""

    local function visualSet(on)
        if on then
            tw(Trk, {BackgroundColor3 = CON})
            tw(Knb, {Position = UDim2.new(0, 23, 0.5, -8), BackgroundColor3 = KON})
            tw(C, {BackgroundColor3 = special and Color3.fromRGB(20, 14, 34) or Color3.fromRGB(14, 25, 19)})
        else
            tw(Trk, {BackgroundColor3 = COFF})
            tw(Knb, {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = KOFF})
            tw(C, {BackgroundColor3 = Color3.fromRGB(16, 14, 27)})
        end
    end

    local function setter(state, silent)
        btnStates[name] = state
        visualSet(state)
        if not silent then
            applyFn(state)
            refreshStatus()
        end
    end

    btnSetters[name] = setter
    btnStates[name] = false

    Ovr.MouseButton1Click:Connect(function()
        setter(not btnStates[name])
    end)
end

-- Build Buttons
newButton(1, "★", "GOD MODE",       "Enable all protections", applyGodMode, true)
newButton(2, "♥", "Infinite Health","Force max health",       applyInfHealth)
newButton(3, "⚔", "Anti-Death",     "Prevent death",          applyAntiDeath)
newButton(4, "⊙", "Anti-Ragdoll",   "No ragdoll",             applyAntiRagdoll)
newButton(5, "▽", "No Fall Damage", "Reduce fall damage",     applyNoFall)

-- Character respawn handler
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    for name, active in pairs(btnStates) do
        if active and btnSetters[name] then
            btnSetters[name](true)
        end
    end
end)

-- Draggable + Hide/Close (same as before)
-- ... (keep your original draggable, hide, and close code here)

print("✅ GodMode GUI v2.2 loaded with Tool Giver")