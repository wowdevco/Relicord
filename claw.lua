-- ╔══════════════════════════════════════════════╗
-- ║    🚢  TITANIC EXPLOIT  ·  Delta v3.0         ║
-- ║        Pure Lua · No Libraries                ║
-- ╚══════════════════════════════════════════════╝

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UIS               = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris            = game:GetService("Debris")

local LP   = Players.LocalPlayer
local pGui = LP:WaitForChild("PlayerGui")

-- ─────────────────────────────────────────────────
-- STATE
-- ─────────────────────────────────────────────────
local conns          = {}
local espConns       = {}
local selectedPlayer = nil

local function drop(k)
    if conns[k] then conns[k]:Disconnect(); conns[k] = nil end
end
local function ch()  return LP.Character end
local function hrp()
    local c = ch(); return c and c:FindFirstChild("HumanoidRootPart")
end
local function hum()
    local c = ch(); return c and c:FindFirstChildOfClass("Humanoid")
end
local function tw(o, p, t)
    TweenService:Create(o, TweenInfo.new(t or 0.18, Enum.EasingStyle.Quad), p):Play()
end

-- ─────────────────────────────────────────────────
-- CLEANUP STALE GUI
-- ─────────────────────────────────────────────────
if pGui:FindFirstChild("TitanicUI_v3") then
    pGui.TitanicUI_v3:Destroy()
end

-- ─────────────────────────────────────────────────
-- PALETTE
-- ─────────────────────────────────────────────────
local C = {
    bg        = Color3.fromRGB(8,  8,  14),
    sidebar   = Color3.fromRGB(5,  5,  10),
    card      = Color3.fromRGB(13, 13, 22),
    cardHov   = Color3.fromRGB(17, 17, 28),
    cardOn    = Color3.fromRGB(6,  18, 34),
    accent    = Color3.fromRGB(0,  175, 255),
    accentDim = Color3.fromRGB(0,  80,  140),
    sepLine   = Color3.fromRGB(18, 24, 44),
    txtPri    = Color3.fromRGB(210, 225, 250),
    txtSec    = Color3.fromRGB(55,  70,  115),
    txtMuted  = Color3.fromRGB(35,  45,  80),
    trkOff    = Color3.fromRGB(24, 24, 40),
    knbOff    = Color3.fromRGB(80, 85, 130),
    tabActive = Color3.fromRGB(0,  100, 165),
    tabInact  = Color3.fromRGB(10, 10, 18),
    danger    = Color3.fromRGB(180, 35, 55),
    btnBg     = Color3.fromRGB(0,  90, 145),
    btnHov    = Color3.fromRGB(0,  120, 185),
    btnPrs    = Color3.fromRGB(0,  200, 255),
}

-- ─────────────────────────────────────────────────
-- ROOT GUI
-- ─────────────────────────────────────────────────
local SG = Instance.new("ScreenGui")
SG.Name           = "TitanicUI_v3"
SG.ResetOnSpawn   = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent         = pGui

-- main frame
local M = Instance.new("Frame", SG)
M.Size             = UDim2.new(0, 600, 0, 430)
M.Position         = UDim2.new(0.5, -300, 0.5, -215)
M.BackgroundColor3 = C.bg
M.BorderSizePixel  = 0
M.Active           = true
Instance.new("UICorner", M).CornerRadius = UDim.new(0, 14)

-- outer glow border
do
    local s = Instance.new("UIStroke", M)
    s.Color        = C.accent
    s.Thickness    = 1.4
    s.Transparency = 0.35
end

-- top accent strip
local AccentStrip = Instance.new("Frame", M)
AccentStrip.Size             = UDim2.new(1, 0, 0, 3)
AccentStrip.BackgroundColor3 = C.accent
AccentStrip.BorderSizePixel  = 0
AccentStrip.ZIndex           = 3
Instance.new("UICorner", AccentStrip).CornerRadius = UDim.new(0, 14)
do
    local g = Instance.new("UIGradient", AccentStrip)
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(0,  50, 180)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 220, 255)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(0,  50, 180)),
    })
end

-- ─────────────────────────────────────────────────
-- TITLE BAR
-- ─────────────────────────────────────────────────
local TBar = Instance.new("Frame", M)
TBar.Size                   = UDim2.new(1, 0, 0, 52)
TBar.Position               = UDim2.new(0, 0, 0, 3)
TBar.BackgroundTransparency = 1
TBar.ZIndex                 = 3

-- icon
local TIco = Instance.new("TextLabel", TBar)
TIco.Size                   = UDim2.new(0, 32, 0, 32)
TIco.Position               = UDim2.new(0, 14, 0.5, -16)
TIco.BackgroundTransparency = 1
TIco.Text                   = "🚢"
TIco.TextSize               = 22
TIco.Font                   = Enum.Font.GothamBold
TIco.ZIndex                 = 4

-- title
local TTtl = Instance.new("TextLabel", TBar)
TTtl.Size                   = UDim2.new(0, 260, 0, 22)
TTtl.Position               = UDim2.new(0, 50, 0, 8)
TTtl.BackgroundTransparency = 1
TTtl.Text                   = "TITANIC EXPLOIT"
TTtl.TextColor3             = C.txtPri
TTtl.TextSize               = 15
TTtl.Font                   = Enum.Font.GothamBold
TTtl.TextXAlignment         = Enum.TextXAlignment.Left
TTtl.ZIndex                 = 4

-- subtitle
local TSub = Instance.new("TextLabel", TBar)
TSub.Size                   = UDim2.new(0, 260, 0, 14)
TSub.Position               = UDim2.new(0, 50, 0, 33)
TSub.BackgroundTransparency = 1
TSub.Text                   = "Delta Executor  ·  v3.0"
TSub.TextColor3             = C.txtMuted
TSub.TextSize               = 10
TSub.Font                   = Enum.Font.Gotham
TSub.TextXAlignment         = Enum.TextXAlignment.Left
TSub.ZIndex                 = 4

-- title bar buttons
local function mkTBtn(xOff, lbl, bg)
    local b = Instance.new("TextButton", TBar)
    b.Size             = UDim2.new(0, 28, 0, 28)
    b.Position         = UDim2.new(1, xOff, 0.5, -14)
    b.BackgroundColor3 = bg
    b.Text             = lbl
    b.TextColor3       = C.txtPri
    b.TextSize         = 13
    b.Font             = Enum.Font.GothamBold
    b.BorderSizePixel  = 0
    b.ZIndex           = 5
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseEnter:Connect(function()
        tw(b, {BackgroundColor3 = bg == C.danger and Color3.fromRGB(220, 50, 70) or Color3.fromRGB(45, 45, 70)})
    end)
    b.MouseLeave:Connect(function() tw(b, {BackgroundColor3 = bg}) end)
    return b
end

local BtnMin   = mkTBtn(-66, "−", Color3.fromRGB(28, 28, 48))
local BtnClose = mkTBtn(-32, "✕", C.danger)

-- divider under title bar
local Sep0 = Instance.new("Frame", M)
Sep0.Size             = UDim2.new(1, 0, 0, 1)
Sep0.Position         = UDim2.new(0, 0, 0, 57)
Sep0.BackgroundColor3 = C.sepLine
Sep0.BorderSizePixel  = 0

-- ─────────────────────────────────────────────────
-- SIDEBAR
-- ─────────────────────────────────────────────────
local Side = Instance.new("Frame", M)
Side.Size             = UDim2.new(0, 140, 1, -60)
Side.Position         = UDim2.new(0, 0, 0, 59)
Side.BackgroundColor3 = C.sidebar
Side.BorderSizePixel  = 0
-- clip inside parent corners — no separate UICorner needed

do
    local ul = Instance.new("UIListLayout", Side)
    ul.SortOrder              = Enum.SortOrder.LayoutOrder
    ul.Padding                = UDim.new(0, 4)
    ul.HorizontalAlignment    = Enum.HorizontalAlignment.Center
end
do
    local p = Instance.new("UIPadding", Side)
    p.PaddingTop   = UDim.new(0, 10)
    p.PaddingLeft  = UDim.new(0, 8)
    p.PaddingRight = UDim.new(0, 8)
end

-- vertical separator sidebar | content
local SideSep = Instance.new("Frame", M)
SideSep.Size             = UDim2.new(0, 1, 1, -60)
SideSep.Position         = UDim2.new(0, 140, 0, 59)
SideSep.BackgroundColor3 = C.sepLine
SideSep.BorderSizePixel  = 0

-- ─────────────────────────────────────────────────
-- CONTENT AREA
-- ─────────────────────────────────────────────────
local CA = Instance.new("Frame", M)
CA.Size                   = UDim2.new(1, -146, 1, -63)
CA.Position               = UDim2.new(0, 144, 0, 61)
CA.BackgroundTransparency = 1
CA.ClipsDescendants       = true

-- ─────────────────────────────────────────────────
-- TAB SYSTEM
-- ─────────────────────────────────────────────────
local tabs      = {}
local activeTab = nil

local function setTab(name)
    if activeTab == name then return end
    activeTab = name
    for n, t in pairs(tabs) do
        local on = (n == name)
        tw(t.frame, {BackgroundColor3 = on and C.tabActive or C.tabInact})
        t.content.Visible  = on
        t.lbl.TextColor3   = on and C.txtPri  or C.txtSec
        t.ico.TextColor3   = on and C.accent  or C.txtMuted
        t.indic.Visible    = on
    end
end

local function newTab(order, name, icon)
    -- sidebar button
    local frame = Instance.new("Frame", Side)
    frame.Size             = UDim2.new(1, 0, 0, 46)
    frame.BackgroundColor3 = C.tabInact
    frame.BorderSizePixel  = 0
    frame.LayoutOrder      = order
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    -- active bar indicator
    local indic = Instance.new("Frame", frame)
    indic.Size             = UDim2.new(0, 3, 0.55, 0)
    indic.Position         = UDim2.new(0, 0, 0.225, 0)
    indic.BackgroundColor3 = C.accent
    indic.BorderSizePixel  = 0
    indic.Visible          = false
    Instance.new("UICorner", indic).CornerRadius = UDim.new(1, 0)

    local ico = Instance.new("TextLabel", frame)
    ico.Size                   = UDim2.new(0, 20, 0, 20)
    ico.Position               = UDim2.new(0, 11, 0.5, -10)
    ico.BackgroundTransparency = 1
    ico.Text                   = icon
    ico.TextSize               = 15
    ico.Font                   = Enum.Font.GothamBold
    ico.TextColor3             = C.txtMuted

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size                   = UDim2.new(1, -36, 1, 0)
    lbl.Position               = UDim2.new(0, 35, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = name
    lbl.TextSize               = 12
    lbl.Font                   = Enum.Font.GothamBold
    lbl.TextColor3             = C.txtSec
    lbl.TextXAlignment         = Enum.TextXAlignment.Left

    local ovr = Instance.new("TextButton", frame)
    ovr.Size                   = UDim2.new(1, 0, 1, 0)
    ovr.BackgroundTransparency = 1
    ovr.Text                   = ""
    ovr.ZIndex                 = 2
    ovr.MouseButton1Click:Connect(function() setTab(name) end)
    ovr.MouseEnter:Connect(function()
        if activeTab ~= name then tw(frame, {BackgroundColor3 = Color3.fromRGB(14, 14, 26)}) end
    end)
    ovr.MouseLeave:Connect(function()
        if activeTab ~= name then tw(frame, {BackgroundColor3 = C.tabInact}) end
    end)

    -- content scroll frame
    local content = Instance.new("ScrollingFrame", CA)
    content.Size                  = UDim2.new(1, -6, 1, -6)
    content.Position              = UDim2.new(0, 3, 0, 3)
    content.BackgroundTransparency= 1
    content.BorderSizePixel       = 0
    content.ScrollBarThickness    = 3
    content.ScrollBarImageColor3  = C.accent
    content.CanvasSize            = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize   = Enum.AutomaticSize.Y
    content.Visible               = false
    do
        local ul = Instance.new("UIListLayout", content)
        ul.SortOrder = Enum.SortOrder.LayoutOrder
        ul.Padding   = UDim.new(0, 6)
    end
    do
        local p = Instance.new("UIPadding", content)
        p.PaddingTop    = UDim.new(0, 4)
        p.PaddingBottom = UDim.new(0, 6)
        p.PaddingRight  = UDim.new(0, 4)
    end

    tabs[name] = {frame=frame, content=content, ico=ico, lbl=lbl, indic=indic}
    return content
end

-- ─────────────────────────────────────────────────
-- WIDGET BUILDERS
-- ─────────────────────────────────────────────────

-- section header
local function mkSect(parent, order, text)
    local f = Instance.new("Frame", parent)
    f.Size                   = UDim2.new(1, 0, 0, 26)
    f.BackgroundTransparency = 1
    f.LayoutOrder            = order
    local lbl = Instance.new("TextLabel", f)
    lbl.Size                   = UDim2.new(1, -4, 1, 0)
    lbl.Position               = UDim2.new(0, 4, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = text:upper()
    lbl.TextColor3             = C.accentDim
    lbl.TextSize               = 10
    lbl.Font                   = Enum.Font.GothamBold
    lbl.TextXAlignment         = Enum.TextXAlignment.Left
    -- underline
    local ul = Instance.new("Frame", f)
    ul.Size             = UDim2.new(1, -4, 0, 1)
    ul.Position         = UDim2.new(0, 4, 1, -1)
    ul.BackgroundColor3 = C.sepLine
    ul.BorderSizePixel  = 0
end

-- card base
local function mkCard(parent, order, h)
    local f = Instance.new("Frame", parent)
    f.Size             = UDim2.new(1, 0, 0, h or 48)
    f.BackgroundColor3 = C.card
    f.BorderSizePixel  = 0
    f.LayoutOrder      = order
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    return f
end

-- toggle widget
local function mkToggle(parent, order, label, desc, fn)
    local h   = desc and 58 or 46
    local card = mkCard(parent, order, h)

    local dot = Instance.new("TextLabel", card)
    dot.Size                   = UDim2.new(0, 8, 0, 8)
    dot.Position               = UDim2.new(0, 13, 0.5, -4)
    dot.BackgroundTransparency = 1
    dot.Text                   = "●"
    dot.TextSize               = 8
    dot.Font                   = Enum.Font.GothamBold
    dot.TextColor3             = C.txtMuted

    local lbl = Instance.new("TextLabel", card)
    lbl.Size                   = UDim2.new(1, -82, 0, 20)
    lbl.Position               = UDim2.new(0, 28, 0, desc and 10 or 13)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = label
    lbl.TextColor3             = C.txtPri
    lbl.TextSize               = 13
    lbl.Font                   = Enum.Font.GothamBold
    lbl.TextXAlignment         = Enum.TextXAlignment.Left

    if desc then
        local dl = Instance.new("TextLabel", card)
        dl.Size                   = UDim2.new(1, -82, 0, 14)
        dl.Position               = UDim2.new(0, 28, 0, 34)
        dl.BackgroundTransparency = 1
        dl.Text                   = desc
        dl.TextColor3             = C.txtSec
        dl.TextSize               = 10
        dl.Font                   = Enum.Font.Gotham
        dl.TextXAlignment         = Enum.TextXAlignment.Left
    end

    local trk = Instance.new("Frame", card)
    trk.Size             = UDim2.new(0, 42, 0, 22)
    trk.Position         = UDim2.new(1, -54, 0.5, -11)
    trk.BackgroundColor3 = C.trkOff
    trk.BorderSizePixel  = 0
    Instance.new("UICorner", trk).CornerRadius = UDim.new(1, 0)

    local knb = Instance.new("Frame", trk)
    knb.Size             = UDim2.new(0, 16, 0, 16)
    knb.Position         = UDim2.new(0, 3, 0.5, -8)
    knb.BackgroundColor3 = C.knbOff
    knb.BorderSizePixel  = 0
    Instance.new("UICorner", knb).CornerRadius = UDim.new(1, 0)

    local state = false
    local function set(on)
        state = on
        if on then
            tw(trk, {BackgroundColor3 = C.accent})
            tw(knb,  {Position = UDim2.new(0, 23, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255,255,255)})
            tw(card, {BackgroundColor3 = C.cardOn})
            tw(dot,  {TextColor3 = C.accent})
        else
            tw(trk, {BackgroundColor3 = C.trkOff})
            tw(knb,  {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = C.knbOff})
            tw(card, {BackgroundColor3 = C.card})
            tw(dot,  {TextColor3 = C.txtMuted})
        end
        if fn then fn(on) end
    end

    local ovr = Instance.new("TextButton", card)
    ovr.Size                   = UDim2.new(1, 0, 1, 0)
    ovr.BackgroundTransparency = 1
    ovr.Text                   = ""
    ovr.ZIndex                 = 2
    ovr.MouseButton1Click:Connect(function() set(not state) end)
    ovr.MouseEnter:Connect(function()
        if not state then tw(card, {BackgroundColor3 = C.cardHov}) end
    end)
    ovr.MouseLeave:Connect(function()
        if not state then tw(card, {BackgroundColor3 = C.card}) end
    end)

    return set
end

-- action button card
local function mkBtn(parent, order, label, desc, fn)
    local h    = desc and 58 or 46
    local card = mkCard(parent, order, h)

    local lbl = Instance.new("TextLabel", card)
    lbl.Size                   = UDim2.new(1, -78, 0, 20)
    lbl.Position               = UDim2.new(0, 14, 0, desc and 10 or 13)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = label
    lbl.TextColor3             = C.txtPri
    lbl.TextSize               = 13
    lbl.Font                   = Enum.Font.GothamBold
    lbl.TextXAlignment         = Enum.TextXAlignment.Left

    if desc then
        local dl = Instance.new("TextLabel", card)
        dl.Size                   = UDim2.new(1, -78, 0, 14)
        dl.Position               = UDim2.new(0, 14, 0, 34)
        dl.BackgroundTransparency = 1
        dl.Text                   = desc
        dl.TextColor3             = C.txtSec
        dl.TextSize               = 10
        dl.Font                   = Enum.Font.Gotham
        dl.TextXAlignment         = Enum.TextXAlignment.Left
    end

    local btn = Instance.new("TextButton", card)
    btn.Size             = UDim2.new(0, 52, 0, 28)
    btn.Position         = UDim2.new(1, -60, 0.5, -14)
    btn.BackgroundColor3 = C.btnBg
    btn.Text             = "RUN"
    btn.TextColor3       = C.accent
    btn.TextSize         = 11
    btn.Font             = Enum.Font.GothamBold
    btn.BorderSizePixel  = 0
    btn.ZIndex           = 2
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        tw(btn, {BackgroundColor3 = C.btnPrs, TextColor3 = Color3.fromRGB(10, 10, 20)})
        task.delay(0.22, function()
            tw(btn, {BackgroundColor3 = C.btnBg, TextColor3 = C.accent})
        end)
        if fn then fn() end
    end)
    btn.MouseEnter:Connect(function()  tw(btn, {BackgroundColor3 = C.btnHov}) end)
    btn.MouseLeave:Connect(function()  tw(btn, {BackgroundColor3 = C.btnBg})  end)

    card.MouseEnter:Connect(function() tw(card, {BackgroundColor3 = C.cardHov}) end)
    card.MouseLeave:Connect(function() tw(card, {BackgroundColor3 = C.card})    end)
end

-- number input card
local function mkInput(parent, order, label, default, fn)
    local card = mkCard(parent, order, 54)

    local lbl = Instance.new("TextLabel", card)
    lbl.Size                   = UDim2.new(1, -14, 0, 16)
    lbl.Position               = UDim2.new(0, 12, 0, 6)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = label
    lbl.TextColor3             = C.txtSec
    lbl.TextSize               = 10
    lbl.Font                   = Enum.Font.GothamBold
    lbl.TextXAlignment         = Enum.TextXAlignment.Left

    local box = Instance.new("TextBox", card)
    box.Size             = UDim2.new(1, -24, 0, 24)
    box.Position         = UDim2.new(0, 12, 0, 24)
    box.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
    box.Text             = tostring(default or "")
    box.TextColor3       = C.accent
    box.PlaceholderText  = "enter value..."
    box.PlaceholderColor3= C.txtMuted
    box.TextSize         = 12
    box.Font             = Enum.Font.GothamBold
    box.BorderSizePixel  = 0
    box.ClearTextOnFocus = false
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

    box.FocusLost:Connect(function(enter)
        if enter and fn then fn(box.Text) end
    end)
    return box
end

-- ══════════════════════════════════════════════
-- CREATE TABS
-- ══════════════════════════════════════════════
local plrC  = newTab(1, "Players",  "👤")
local shipC = newTab(2, "Ship",     "🚢")
local selfC = newTab(3, "Self",     "⚡")
local miscC = newTab(4, "Misc",     "⚙")

-- ══════════════════════════════════════════════
-- PLAYERS TAB
-- ══════════════════════════════════════════════
mkSect(plrC, 1, "Player List")

-- player list card
local PlrCard = mkCard(plrC, 2, 165)
PlrCard.BackgroundColor3 = Color3.fromRGB(8, 8, 16)

local PlrScr = Instance.new("ScrollingFrame", PlrCard)
PlrScr.Size                  = UDim2.new(1, -8, 1, -8)
PlrScr.Position              = UDim2.new(0, 4, 0, 4)
PlrScr.BackgroundTransparency= 1
PlrScr.BorderSizePixel       = 0
PlrScr.ScrollBarThickness    = 3
PlrScr.ScrollBarImageColor3  = C.accent
PlrScr.CanvasSize            = UDim2.new(0, 0, 0, 0)
PlrScr.AutomaticCanvasSize   = Enum.AutomaticSize.Y
do
    local ul = Instance.new("UIListLayout", PlrScr)
    ul.SortOrder = Enum.SortOrder.LayoutOrder
    ul.Padding   = UDim.new(0, 4)
end

-- selected display
local SelCard = mkCard(plrC, 3, 32)
SelCard.BackgroundColor3 = Color3.fromRGB(8, 14, 26)
local SelLbl = Instance.new("TextLabel", SelCard)
SelLbl.Size                   = UDim2.new(1, -16, 1, 0)
SelLbl.Position               = UDim2.new(0, 10, 0, 0)
SelLbl.BackgroundTransparency = 1
SelLbl.Text                   = "Selected: none"
SelLbl.TextColor3             = C.txtSec
SelLbl.TextSize               = 11
SelLbl.Font                   = Enum.Font.Gotham
SelLbl.TextXAlignment         = Enum.TextXAlignment.Left

local function rebuildPlrList()
    for _, c in ipairs(PlrScr:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    local i = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            i = i + 1
            local sel = (plr == selectedPlayer)
            local row = Instance.new("Frame", PlrScr)
            row.Size             = UDim2.new(1, 0, 0, 32)
            row.BackgroundColor3 = sel and Color3.fromRGB(6, 22, 42) or Color3.fromRGB(12, 12, 22)
            row.BorderSizePixel  = 0
            row.LayoutOrder      = i
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)
            if sel then
                local s = Instance.new("UIStroke", row)
                s.Color = C.accent; s.Thickness = 1; s.Transparency = 0.5
            end
            local nl = Instance.new("TextLabel", row)
            nl.Size                   = UDim2.new(1, -12, 1, 0)
            nl.Position               = UDim2.new(0, 10, 0, 0)
            nl.BackgroundTransparency = 1
            nl.Text                   = plr.Name
            nl.TextColor3             = sel and C.accent or C.txtPri
            nl.TextSize               = 12
            nl.Font                   = Enum.Font.GothamBold
            nl.TextXAlignment         = Enum.TextXAlignment.Left
            local ob = Instance.new("TextButton", row)
            ob.Size                   = UDim2.new(1, 0, 1, 0)
            ob.BackgroundTransparency = 1
            ob.Text                   = ""
            ob.ZIndex                 = 2
            ob.MouseButton1Click:Connect(function()
                selectedPlayer = plr
                SelLbl.Text      = "Selected: " .. plr.Name
                SelLbl.TextColor3 = C.accent
                rebuildPlrList()
            end)
            ob.MouseEnter:Connect(function()
                if not sel then tw(row, {BackgroundColor3 = Color3.fromRGB(16, 16, 28)}) end
            end)
            ob.MouseLeave:Connect(function()
                if not sel then tw(row, {BackgroundColor3 = Color3.fromRGB(12, 12, 22)}) end
            end)
        end
    end
end

Players.PlayerAdded:Connect(rebuildPlrList)
Players.PlayerRemoving:Connect(function() task.wait(0.1); rebuildPlrList() end)
rebuildPlrList()

mkSect(plrC, 4, "Actions")

mkBtn(plrC, 5, "Teleport to Player", "Warp to selected player", function()
    if not selectedPlayer then return end
    local r  = hrp()
    local tr = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if r and tr then r.CFrame = tr.CFrame + Vector3.new(4, 0, 0) end
end)

mkBtn(plrC, 6, "Fling Player", "Launch selected player skyward", function()
    if not selectedPlayer then return end
    local tc = selectedPlayer.Character
    if not tc then return end
    local tr = tc:FindFirstChild("HumanoidRootPart")
    if not tr then return end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = tr.CFrame.LookVector * 900 + Vector3.new(0, 350, 0)
    bv.Parent   = tr
    Debris:AddItem(bv, 0.25)
end)

mkToggle(plrC, 7, "Kill on Touch", "Drains health on contact", function(on)
    drop("kot")
    if not on then return end
    local myC = ch()
    if not myC then return end
    local root = myC:FindFirstChild("HumanoidRootPart")
    if not root then return end
    conns.kot = root.Touched:Connect(function(hit)
        local h = hit.Parent:FindFirstChildOfClass("Humanoid")
        if h and hit.Parent ~= myC then h.Health = 0 end
    end)
end)

mkToggle(plrC, 8, "Aura Kill", "Kills nearby players on loop", function(on)
    drop("aura")
    if not on then return end
    conns.aura = RunService.Heartbeat:Connect(function()
        local r = hrp()
        if not r then return end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local pr = plr.Character:FindFirstChild("HumanoidRootPart")
                local ph = plr.Character:FindFirstChildOfClass("Humanoid")
                if pr and ph and (pr.Position - r.Position).Magnitude < 20 then
                    ph.Health = 0
                end
            end
        end
    end)
end)

-- ══════════════════════════════════════════════
-- SHIP TAB
-- ══════════════════════════════════════════════
mkSect(shipC, 1, "Ship Control")

mkBtn(shipC, 2, "Sink Ship", "Unanchors & sinks all ship parts", function()
    for _, p in ipairs(workspace:GetDescendants()) do
        if p:IsA("BasePart") and (
            p.Name:lower():find("titanic") or
            p.Name:lower():find("hull")    or
            p.Name:lower():find("ship")    or
            p.Name:lower():find("deck")
        ) then
            p.Anchored = false
            local bf = Instance.new("BodyForce", p)
            bf.Force = Vector3.new(0, -p:GetMass() * 280, 0)
            Debris:AddItem(bf, 10)
        end
    end
end)

mkToggle(shipC, 3, "Speed Boost", "Continuously pushes ship forward", function(on)
    drop("boatSpd")
    if not on then return end
    conns.boatSpd = RunService.Heartbeat:Connect(function()
        local boat = workspace:FindFirstChild("Titanic")
        if boat and boat.PrimaryPart then
            boat.PrimaryPart.AssemblyLinearVelocity = boat.PrimaryPart.CFrame.LookVector * 90
        end
    end)
end)

mkBtn(shipC, 4, "Stop Ship", "Freezes all ship velocity", function()
    local boat = workspace:FindFirstChild("Titanic")
    if not boat then return end
    for _, p in ipairs(boat:GetDescendants()) do
        if p:IsA("BasePart") then
            p.AssemblyLinearVelocity  = Vector3.zero
            p.AssemblyAngularVelocity = Vector3.zero
        end
    end
end)

mkToggle(shipC, 5, "Anchor Ship", "Locks ship parts in place", function(on)
    local boat = workspace:FindFirstChild("Titanic")
    if not boat then return end
    for _, p in ipairs(boat:GetDescendants()) do
        if p:IsA("BasePart") then p.Anchored = on end
    end
end)

mkBtn(shipC, 6, "Teleport to Bow", "Warp to ship front", function()
    local r    = hrp()
    local boat = workspace:FindFirstChild("Titanic")
    if r and boat and boat.PrimaryPart then
        r.CFrame = boat.PrimaryPart.CFrame * CFrame.new(0, 25, -220)
    end
end)

mkBtn(shipC, 7, "Teleport to Stern", "Warp to ship rear", function()
    local r    = hrp()
    local boat = workspace:FindFirstChild("Titanic")
    if r and boat and boat.PrimaryPart then
        r.CFrame = boat.PrimaryPart.CFrame * CFrame.new(0, 25, 220)
    end
end)

-- ══════════════════════════════════════════════
-- SELF TAB
-- ══════════════════════════════════════════════
mkSect(selfC, 1, "Movement")

local wsBox = mkInput(selfC, 2, "WalkSpeed", 16, function(v)
    local n = tonumber(v)
    local h = hum()
    if h and n then h.WalkSpeed = n end
end)

local jpBox = mkInput(selfC, 3, "JumpPower", 50, function(v)
    local n = tonumber(v)
    local h = hum()
    if h and n then h.JumpPower = n end
end)

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    local h = hum()
    if not h then return end
    local ws = tonumber(wsBox.Text) or 16
    local jp = tonumber(jpBox.Text) or 50
    h.WalkSpeed = ws
    h.JumpPower = jp
end)

mkSect(selfC, 4, "Abilities")

mkToggle(selfC, 5, "Noclip", "Walk through all parts", function(on)
    drop("noclip")
    if not on then return end
    conns.noclip = RunService.Stepped:Connect(function()
        local c = ch()
        if not c then return end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end)
end)

mkToggle(selfC, 6, "Infinite Jump", "Jump mid-air indefinitely", function(on)
    drop("infJump")
    if not on then return end
    conns.infJump = UIS.JumpRequest:Connect(function()
        local h = hum()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end)

mkToggle(selfC, 7, "God Mode", "Max health every frame", function(on)
    drop("godMode")
    if not on then return end
    conns.godMode = RunService.Heartbeat:Connect(function()
        local h = hum()
        if h then h.MaxHealth = math.huge; h.Health = math.huge end
    end)
end)

mkToggle(selfC, 8, "Speed Lock", "Maintains WalkSpeed every frame", function(on)
    drop("spdLock")
    if not on then return end
    conns.spdLock = RunService.Heartbeat:Connect(function()
        local h = hum()
        local n = tonumber(wsBox.Text) or 16
        if h then h.WalkSpeed = n end
    end)
end)

mkBtn(selfC, 9, "Float / Fly (Toggle)", "BodyVelocity upward thrust", function()
    local r = hrp()
    if not r then return end
    if r:FindFirstChild("_FlyBF") then
        r._FlyBF:Destroy()
        drop("flyHB")
        return
    end
    local bg = Instance.new("BodyGyro", r)
    bg.Name     = "_FlyBG"
    bg.MaxTorque= Vector3.new(4e5, 4e5, 4e5)
    bg.CFrame   = r.CFrame
    local bf = Instance.new("BodyVelocity", r)
    bf.Name     = "_FlyBF"
    bf.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bf.Velocity = Vector3.new(0, 0, 0)
    conns.flyHB = RunService.Heartbeat:Connect(function()
        if not r or not r.Parent then drop("flyHB"); return end
        local vel = Vector3.new(0, 0, 0)
        if UIS:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0, 60, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then vel = vel + Vector3.new(0, -60, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.W) then vel = vel + r.CFrame.LookVector * 60 end
        if UIS:IsKeyDown(Enum.KeyCode.S) then vel = vel - r.CFrame.LookVector * 60 end
        if UIS:IsKeyDown(Enum.KeyCode.A) then vel = vel - r.CFrame.RightVector * 60 end
        if UIS:IsKeyDown(Enum.KeyCode.D) then vel = vel + r.CFrame.RightVector * 60 end
        bf.Velocity = vel
    end)
end)

-- ══════════════════════════════════════════════
-- MISC TAB
-- ══════════════════════════════════════════════
mkSect(miscC, 1, "Game Remotes")

mkBtn(miscC, 2, "Fire Coin Remote", "Attempts to fire GiveCoins remote", function()
    local r = ReplicatedStorage:FindFirstChild("GiveCoins")
    if r and r:IsA("RemoteEvent") then
        for _ = 1, 10 do r:FireServer(99999) end
        print("[TitanicUI] Fired coin remote x10")
    else
        print("[TitanicUI] GiveCoins remote not found — try Dump Remotes")
    end
end)

mkBtn(miscC, 3, "Dump All Remotes", "Prints every remote to console", function()
    print("── ReplicatedStorage ──")
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            print(string.format("  [%s] %s", v.ClassName, v:GetFullName()))
        end
    end
    print("── Workspace ──")
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            print(string.format("  [%s] %s", v.ClassName, v:GetFullName()))
        end
    end
end)

mkSect(miscC, 4, "Visual")

mkToggle(miscC, 5, "Player ESP", "Highlights all players with boxes", function(on)
    -- clean old esp
    for _, c in ipairs(espConns) do c:Disconnect() end
    espConns = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local h = plr.Character:FindFirstChild("_ESP")
            if h then h:Destroy() end
        end
    end
    if not on then return end
    local function applyESP(plr)
        if plr == LP then return end
        local function doChar(c)
            pcall(function()
                local ex = c:FindFirstChild("_ESP"); if ex then ex:Destroy() end
                local sb        = Instance.new("SelectionBox")
                sb.Name         = "_ESP"
                sb.Color3       = C.accent
                sb.LineThickness= 0.04
                sb.SurfaceTransparency = 0.88
                sb.SurfaceColor3= C.accentDim
                sb.Adornee      = c
                sb.Parent       = c
            end)
        end
        if plr.Character then task.spawn(doChar, plr.Character) end
        local c1 = plr.CharacterAdded:Connect(function(chr)
            task.wait(0.25); doChar(chr)
        end)
        table.insert(espConns, c1)
    end
    for _, plr in ipairs(Players:GetPlayers()) do applyESP(plr) end
    local c2 = Players.PlayerAdded:Connect(applyESP)
    table.insert(espConns, c2)
end)

mkBtn(miscC, 6, "Remove Fog", "Clears all fog from Lighting", function()
    local L = game:GetService("Lighting")
    L.FogStart = 0
    L.FogEnd   = 9e9
    L.FogColor = Color3.fromRGB(0, 0, 0)
end)

mkBtn(miscC, 7, "Fullbright", "Sets brightness to max", function()
    local L = game:GetService("Lighting")
    L.Ambient          = Color3.fromRGB(255, 255, 255)
    L.OutdoorAmbient   = Color3.fromRGB(255, 255, 255)
    L.Brightness       = 5
    L.ClockTime        = 14
end)

-- ══════════════════════════════════════════════
-- DRAGGABLE
-- ══════════════════════════════════════════════
do
    local drag, ds, sp
    TBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            ds   = i.Position
            sp   = M.Position
        end
    end)
    TBar.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - ds
            M.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
        end
    end)
end

-- ══════════════════════════════════════════════
-- MINIMIZE / CLOSE
-- ══════════════════════════════════════════════
local minimized = false
BtnMin.MouseButton1Click:Connect(function()
    minimized = not minimized
    Side.Visible        = not minimized
    SideSep.Visible     = not minimized
    CA.Visible          = not minimized
    Sep0.Visible        = not minimized
    BtnMin.Text         = minimized and "+" or "−"
    tw(M, {Size = UDim2.new(0, 600, 0, minimized and 56 or 430)})
end)

BtnClose.MouseButton1Click:Connect(function()
    for _, c in pairs(conns) do
        if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
    end
    for _, c in ipairs(espConns) do c:Disconnect() end
    SG:Destroy()
end)

-- ══════════════════════════════════════════════
-- BOOT
-- ══════════════════════════════════════════════
setTab("Players")
print("[TitanicUI v3.0] loaded.")
