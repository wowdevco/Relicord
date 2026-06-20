-- ╔════════════════════════════════════════╗
-- ║       ⚡ GOD MODE GUI v2.0             ║
-- ║     Natural Disaster Survival          ║
-- ╚════════════════════════════════════════╝

local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")

local player = Players.LocalPlayer
local pGui   = player:WaitForChild("PlayerGui")

-- ── State ──────────────────────────────────────────────────
local conns      = {}
local btnStates  = {}
local btnSetters = {}

-- ── Helpers ────────────────────────────────────────────────
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

-- ── Features ───────────────────────────────────────────────

local function applyInfHealth(on)
    drop("infH")
    if not on then return end
    conns.infH = RunService.Heartbeat:Connect(function()
        local h = H()
        if h then h.MaxHealth = math.huge; h.Health = math.huge end
    end)
end

local function applyAntiDeath(on)
    drop("adLoop"); drop("adDied")
    if not on then return end
    conns.adLoop = RunService.Heartbeat:Connect(function()
        local h = H()
        if h and h.Health < 1 then
            h.MaxHealth = math.huge; h.Health = math.huge
        end
    end)
    local h = H()
    if h then
        conns.adDied = h.Died:Connect(function()
            task.wait(0.05)
            local h2 = H()
            if h2 then h2.MaxHealth = math.huge; h2.Health = math.huge end
        end)
    end
end

local function applyAntiRagdoll(on)
    drop("ar")
    if not on then return end
    conns.ar = RunService.Heartbeat:Connect(function()
        local h = H()
        if not h then return end
        h.PlatformStand = false
        local s = h:GetState()
        if s == Enum.HumanoidStateType.Ragdoll
        or s == Enum.HumanoidStateType.FallingDown then
            h:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end

local function applyNoFall(on)
    drop("nf")
    if not on then return end
    local h = H()
    if not h then return end
    conns.nf = h.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Landed then
            local r = R()
            if r then
                local v = r.AssemblyLinearVelocity
                r.AssemblyLinearVelocity = Vector3.new(v.X, 0, v.Z)
            end
            local h2 = H()
            if h2 then h2.MaxHealth = math.huge; h2.Health = math.huge end
        end
    end)
end

-- Re-apply on character respawn
player.CharacterAdded:Connect(function()
    task.wait(0.4)
    if btnStates["Infinite Health"] then applyInfHealth(true)    end
    if btnStates["Anti-Death"]      then applyAntiDeath(true)    end
    if btnStates["Anti-Ragdoll"]    then applyAntiRagdoll(true)  end
    if btnStates["No Fall Damage"]  then applyNoFall(true)       end
end)

-- ── GUI Construction ───────────────────────────────────────

if pGui:FindFirstChild("GodGUI") then pGui.GodGUI:Destroy() end

local SG = Instance.new("ScreenGui")
SG.Name           = "GodGUI"
SG.ResetOnSpawn   = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent         = pGui

-- Main frame
local M = Instance.new("Frame")
M.Size             = UDim2.new(0, 286, 0, 415)
M.Position         = UDim2.new(0, 18, 0, 56)
M.BackgroundColor3 = Color3.fromRGB(9, 9, 15)
M.BorderSizePixel  = 0
M.Active           = true
M.Parent           = SG
Instance.new("UICorner", M).CornerRadius = UDim.new(0, 13)

do  -- outer purple glow
    local s = Instance.new("UIStroke", M)
    s.Color        = Color3.fromRGB(115, 62, 240)
    s.Thickness    = 1.5
    s.Transparency = 0.18
end

-- Top gradient accent bar
local TopBar = Instance.new("Frame", M)
TopBar.Size             = UDim2.new(1, 0, 0, 4)
TopBar.BackgroundColor3 = Color3.fromRGB(115, 62, 240)
TopBar.BorderSizePixel  = 0
TopBar.ZIndex           = 3
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 13)
do
    local g = Instance.new("UIGradient", TopBar)
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(75,  42, 200)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(190, 100, 255)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(75,  42, 200)),
    })
end

-- Title zone
local TZ = Instance.new("Frame", M)
TZ.Size                   = UDim2.new(1, 0, 0, 54)
TZ.Position               = UDim2.new(0, 0, 0, 4)
TZ.BackgroundTransparency = 1

do
    local t = Instance.new("TextLabel", TZ)
    t.Size                = UDim2.new(1, -90, 0, 26)
    t.Position            = UDim2.new(0, 14, 0, 6)
    t.BackgroundTransparency = 1
    t.Text                = "⚡  GOD MODE"
    t.TextColor3          = Color3.fromRGB(210, 168, 255)
    t.TextSize            = 16
    t.Font                = Enum.Font.GothamBold
    t.TextXAlignment      = Enum.TextXAlignment.Left
end
do
    local s = Instance.new("TextLabel", TZ)
    s.Size                = UDim2.new(1, -90, 0, 14)
    s.Position            = UDim2.new(0, 14, 0, 35)
    s.BackgroundTransparency = 1
    s.Text                = "Natural Disaster Survival"
    s.TextColor3          = Color3.fromRGB(72, 62, 112)
    s.TextSize            = 10
    s.Font                = Enum.Font.Gotham
    s.TextXAlignment      = Enum.TextXAlignment.Left
end

local function mkIconBtn(parent, xOff, lbl, bg)
    local b = Instance.new("TextButton", parent)
    b.Size             = UDim2.new(0, 26, 0, 26)
    b.Position         = UDim2.new(1, xOff, 0.5, -13)
    b.BackgroundColor3 = bg
    b.Text             = lbl
    b.TextColor3       = Color3.fromRGB(238, 235, 255)
    b.TextSize         = 12
    b.Font             = Enum.Font.GothamBold
    b.BorderSizePixel  = 0
    b.ZIndex           = 4
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    return b
end

local BtnHide  = mkIconBtn(TZ, -68, "−", Color3.fromRGB(40, 38, 68))
local BtnClose = mkIconBtn(TZ, -36, "✕", Color3.fromRGB(162, 36, 62))

-- Divider
local Div = Instance.new("Frame", M)
Div.Size             = UDim2.new(1, -22, 0, 1)
Div.Position         = UDim2.new(0, 11, 0, 60)
Div.BackgroundColor3 = Color3.fromRGB(32, 28, 58)
Div.BorderSizePixel  = 0

-- Scroll area
local Scr = Instance.new("ScrollingFrame", M)
Scr.Size                  = UDim2.new(1, -22, 1, -106)
Scr.Position              = UDim2.new(0, 11, 0, 66)
Scr.BackgroundTransparency = 1
Scr.BorderSizePixel       = 0
Scr.ScrollBarThickness    = 3
Scr.ScrollBarImageColor3  = Color3.fromRGB(115, 62, 240)
Scr.CanvasSize            = UDim2.new(0, 0, 0, 0)
Scr.AutomaticCanvasSize   = Enum.AutomaticSize.Y
Scr.ClipsDescendants      = true

do
    local ll = Instance.new("UIListLayout", Scr)
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll.Padding   = UDim.new(0, 7)
end

-- Status bar
local StatBg = Instance.new("Frame", M)
StatBg.Size             = UDim2.new(1, -22, 0, 28)
StatBg.Position         = UDim2.new(0, 11, 1, -34)
StatBg.BackgroundColor3 = Color3.fromRGB(13, 12, 22)
StatBg.BorderSizePixel  = 0
Instance.new("UICorner", StatBg).CornerRadius = UDim.new(0, 8)

local StatLbl = Instance.new("TextLabel", StatBg)
StatLbl.Size                = UDim2.new(1, -12, 1, 0)
StatLbl.Position            = UDim2.new(0, 8, 0, 0)
StatLbl.BackgroundTransparency = 1
StatLbl.Text                = "● STANDBY — no features active"
StatLbl.TextColor3          = Color3.fromRGB(80, 75, 125)
StatLbl.TextSize            = 11
StatLbl.Font                = Enum.Font.Gotham
StatLbl.TextXAlignment      = Enum.TextXAlignment.Left

local function refreshStatus()
    local n = 0
    for _, v in pairs(btnStates) do if v then n = n + 1 end end
    if n == 0 then
        StatLbl.Text       = "● STANDBY — no features active"
        StatLbl.TextColor3 = Color3.fromRGB(80, 75, 125)
    else
        StatLbl.Text       = "● ACTIVE — " .. n .. " feature" .. (n ~= 1 and "s" or "") .. " running"
        StatLbl.TextColor3 = Color3.fromRGB(70, 200, 115)
    end
end

-- ── Button Factory ─────────────────────────────────────────

local CON  = Color3.fromRGB(60, 180, 100)
local COFF = Color3.fromRGB(34, 32, 58)
local KON  = Color3.fromRGB(255, 255, 255)
local KOFF = Color3.fromRGB(125, 115, 170)

local function tw(obj, props)
    TweenService:Create(obj, TweenInfo.new(0.17, Enum.EasingStyle.Quad), props):Play()
end

local function newButton(order, ico, name, desc, applyFn, special)
    local C = Instance.new("Frame", Scr)
    C.Size             = UDim2.new(1, 0, 0, 60)
    C.BackgroundColor3 = Color3.fromRGB(16, 14, 27)
    C.BorderSizePixel  = 0
    C.LayoutOrder      = order
    Instance.new("UICorner", C).CornerRadius = UDim.new(0, 10)

    if special then
        local s = Instance.new("UIStroke", C)
        s.Color        = Color3.fromRGB(172, 90, 255)
        s.Thickness    = 1
        s.Transparency = 0.48
    end

    local IcoL = Instance.new("TextLabel", C)
    IcoL.Size                = UDim2.new(0, 40, 1, 0)
    IcoL.Position            = UDim2.new(0, 7, 0, 0)
    IcoL.BackgroundTransparency = 1
    IcoL.Text                = ico
    IcoL.TextSize            = 18
    IcoL.Font                = Enum.Font.GothamBold
    IcoL.TextColor3          = special and Color3.fromRGB(192, 140, 255) or Color3.fromRGB(132, 118, 192)

    local NL = Instance.new("TextLabel", C)
    NL.Size                = UDim2.new(1, -106, 0, 22)
    NL.Position            = UDim2.new(0, 48, 0, 9)
    NL.BackgroundTransparency = 1
    NL.Text                = name
    NL.TextColor3          = Color3.fromRGB(202, 192, 252)
    NL.TextSize            = 13
    NL.Font                = Enum.Font.GothamBold
    NL.TextXAlignment      = Enum.TextXAlignment.Left

    local DL = Instance.new("TextLabel", C)
    DL.Size                = UDim2.new(1, -106, 0, 15)
    DL.Position            = UDim2.new(0, 48, 0, 34)
    DL.BackgroundTransparency = 1
    DL.Text                = desc
    DL.TextColor3          = Color3.fromRGB(68, 60, 105)
    DL.TextSize            = 10
    DL.Font                = Enum.Font.Gotham
    DL.TextXAlignment      = Enum.TextXAlignment.Left

    local Trk = Instance.new("Frame", C)
    Trk.Size             = UDim2.new(0, 42, 0, 22)
    Trk.Position         = UDim2.new(1, -49, 0.5, -11)
    Trk.BackgroundColor3 = COFF
    Trk.BorderSizePixel  = 0
    Instance.new("UICorner", Trk).CornerRadius = UDim.new(1, 0)

    local Knb = Instance.new("Frame", Trk)
    Knb.Size             = UDim2.new(0, 16, 0, 16)
    Knb.Position         = UDim2.new(0, 3, 0.5, -8)
    Knb.BackgroundColor3 = KOFF
    Knb.BorderSizePixel  = 0
    Instance.new("UICorner", Knb).CornerRadius = UDim.new(1, 0)

    local Ovr = Instance.new("TextButton", C)
    Ovr.Size                = UDim2.new(1, 0, 1, 0)
    Ovr.BackgroundTransparency = 1
    Ovr.Text                = ""
    Ovr.ZIndex              = 2

    local function visualSet(on)
        if on then
            tw(Trk, {BackgroundColor3 = CON})
            tw(Knb, {Position = UDim2.new(0, 23, 0.5, -8), BackgroundColor3 = KON})
            tw(C,   {BackgroundColor3 = special and Color3.fromRGB(20, 14, 34) or Color3.fromRGB(14, 25, 19)})
        else
            tw(Trk, {BackgroundColor3 = COFF})
            tw(Knb, {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = KOFF})
            tw(C,   {BackgroundColor3 = Color3.fromRGB(16, 14, 27)})
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
    btnStates[name]  = false

    Ovr.MouseButton1Click:Connect(function()
        setter(not btnStates[name])
    end)
    Ovr.MouseEnter:Connect(function()
        if not btnStates[name] then tw(C, {BackgroundColor3 = Color3.fromRGB(22, 19, 36)}) end
    end)
    Ovr.MouseLeave:Connect(function()
        if not btnStates[name] then tw(C, {BackgroundColor3 = Color3.fromRGB(16, 14, 27)}) end
    end)
end

-- ── God Mode (master toggle) ───────────────────────────────
local function applyGodMode(on)
    applyInfHealth(on)
    applyAntiDeath(on)
    applyAntiRagdoll(on)
    applyNoFall(on)
    for _, n in ipairs({"Infinite Health", "Anti-Death", "Anti-Ragdoll", "No Fall Damage"}) do
        if btnSetters[n] then btnSetters[n](on, true) end
    end
end

-- ── Build Buttons ──────────────────────────────────────────
newButton(1, "★", "GOD MODE",       "Enable all protections at once",        applyGodMode,     true)
newButton(2, "♥", "Infinite Health","MaxHealth + Health forced every frame",  applyInfHealth,   false)
newButton(3, "⚔", "Anti-Death",     "Blocks kill scripts & Died events",      applyAntiDeath,   false)
newButton(4, "⊙", "Anti-Ragdoll",   "Forces standing, prevents rag state",    applyAntiRagdoll, false)
newButton(5, "▽", "No Fall Damage", "Zeroes vertical velocity on landing",    applyNoFall,      false)

-- ── Draggable ──────────────────────────────────────────────
do
    local drag, ds, sp
    M.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true; ds = i.Position; sp = M.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then drag = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - ds
            M.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
        end
    end)
end

-- ── Hide / Close ───────────────────────────────────────────
local hidden = false

BtnHide.MouseButton1Click:Connect(function()
    hidden = not hidden
    Scr.Visible    = not hidden
    Div.Visible    = not hidden
    StatBg.Visible = not hidden
    if hidden then
        tw(M, {Size = UDim2.new(0, 286, 0, 62)})
        BtnHide.Text = "+"
    else
        tw(M, {Size = UDim2.new(0, 286, 0, 415)})
        BtnHide.Text = "−"
    end
end)

BtnClose.MouseButton1Click:Connect(function()
    for _, c in pairs(conns) do
        if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
    end
    SG:Destroy()
end)

print("✅ GodMode GUI v2.0 — loaded")
