-- ╔══════════════════════════════════════════════════╗
-- ║ 🔇 QUIET OR DIE — VOID EXPLOIT v1.0 ║
-- ║ Pure Lua · No Libraries ║
-- ╚══════════════════════════════════════════════════╝

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer
local pGui = LP:WaitForChild("PlayerGui")

-- ─────────────────────────────────────────────────
-- HELPERS
-- ─────────────────────────────────────────────────
local conns = {}
local espConns = {}
local selectedPlayer = nil

local function drop(k)
if conns[k] then conns[k]:Disconnect(); conns[k] = nil end
end
local function ch() return LP.Character end
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
-- CROSS-SESSION SAVE (writefile / readfile)
-- ─────────────────────────────────────────────────
local SAVE_KEY = "QoDVoid_save.json"
local saveData = {}

local function loadSave()
pcall(function()
if readfile then
local raw = readfile(SAVE_KEY)
if raw and #raw > 2 then
saveData = HttpService:JSONDecode(raw)
end
end
end)
end

local function writeSave()
pcall(function()
if writefile then
writefile(SAVE_KEY, HttpService:JSONEncode(saveData))
end
end)
end

loadSave()

-- ─────────────────────────────────────────────────
-- CLEANUP STALE GUI
-- ─────────────────────────────────────────────────
if pGui:FindFirstChild("QoDVoid_v1") then
pGui.QoDVoid_v1:Destroy()
end

-- ─────────────────────────────────────────────────
-- PALETTE
-- ─────────────────────────────────────────────────
local C = {
bg = Color3.fromRGB(8, 8, 14),
sidebar = Color3.fromRGB(5, 5, 10),
card = Color3.fromRGB(13, 13, 22),
cardHov = Color3.fromRGB(17, 17, 28),
cardOn = Color3.fromRGB(6, 18, 34),
accent = Color3.fromRGB(0, 175, 255),
accentDim = Color3.fromRGB(0, 80, 140),
sepLine = Color3.fromRGB(18, 24, 44),
txtPri = Color3.fromRGB(210, 225, 250),
txtSec = Color3.fromRGB(55, 70, 115),
txtMuted = Color3.fromRGB(35, 45, 80),
trkOff = Color3.fromRGB(24, 24, 40),
knbOff = Color3.fromRGB(80, 85, 130),
tabActive = Color3.fromRGB(0, 100, 165),
tabInact = Color3.fromRGB(10, 10, 18),
danger = Color3.fromRGB(180, 35, 55),
btnBg = Color3.fromRGB(0, 90, 145),
btnHov = Color3.fromRGB(0, 120, 185),
btnPrs = Color3.fromRGB(0, 200, 255),
gold = Color3.fromRGB(230, 180, 40),
green = Color3.fromRGB(40, 190, 90),
purple = Color3.fromRGB(140, 60, 220),
}

-- ─────────────────────────────────────────────────
-- ROOT GUI
-- ─────────────────────────────────────────────────
local SG = Instance.new("ScreenGui")
SG.Name = "QoDVoid_v1"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = pGui

local M = Instance.new("Frame", SG)
M.Size = UDim2.new(0, 625, 0, 445)
M.Position = UDim2.new(0.5, -312, 0.5, -222)
M.BackgroundColor3 = C.bg
M.BorderSizePixel = 0
M.Active = true
Instance.new("UICorner", M).CornerRadius = UDim.new(0, 14)

do
local s = Instance.new("UIStroke", M)
s.Color = C.accent
s.Thickness = 1.4
s.Transparency = 0.35
end

local AccentStrip = Instance.new("Frame", M)
AccentStrip.Size = UDim2.new(1, 0, 0, 3)
AccentStrip.BackgroundColor3 = C.accent
AccentStrip.BorderSizePixel = 0
AccentStrip.ZIndex = 3
Instance.new("UICorner", AccentStrip).CornerRadius = UDim.new(0, 14)
do
local g = Instance.new("UIGradient", AccentStrip)
g.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 0, 200)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 200, 255)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 0, 200)),
})
end

-- ─────────────────────────────────────────────────
-- TITLE BAR
-- ─────────────────────────────────────────────────
local TBar = Instance.new("Frame", M)
TBar.Size = UDim2.new(1, 0, 0, 52)
TBar.Position = UDim2.new(0, 0, 0, 3)
TBar.BackgroundTransparency = 1
TBar.ZIndex = 3

local TIco = Instance.new("TextLabel", TBar)
TIco.Size = UDim2.new(0, 32, 0, 32)
TIco.Position = UDim2.new(0, 14, 0.5, -16)
TIco.BackgroundTransparency = 1
TIco.Text = "🔇"
TIco.TextSize = 22
TIco.Font = Enum.Font.GothamBold
TIco.ZIndex = 4

local TTtl = Instance.new("TextLabel", TBar)
TTtl.Size = UDim2.new(0, 300, 0, 22)
TTtl.Position = UDim2.new(0, 50, 0, 8)
TTtl.BackgroundTransparency = 1
TTtl.Text = "QUIET OR DIE — VOID"
TTtl.TextColor3 = C.txtPri
TTtl.TextSize = 15
TTtl.Font = Enum.Font.GothamBold
TTtl.TextXAlignment = Enum.TextXAlignment.Left
TTtl.ZIndex = 4

local TSub = Instance.new("TextLabel", TBar)
TSub.Size = UDim2.new(0, 300, 0, 14)
TSub.Position = UDim2.new(0, 50, 0, 33)
TSub.BackgroundTransparency = 1
TSub.Text = "Void Exploit · v1.0"
TSub.TextColor3 = C.txtMuted
TSub.TextSize = 10
TSub.Font = Enum.Font.Gotham
TSub.TextXAlignment = Enum.TextXAlignment.Left
TSub.ZIndex = 4

local function mkTBtn(xOff, lbl, bg)
local b = Instance.new("TextButton", TBar)
b.Size = UDim2.new(0, 28, 0, 28)
b.Position = UDim2.new(1, xOff, 0.5, -14)
b.BackgroundColor3 = bg
b.Text = lbl
b.TextColor3 = C.txtPri
b.TextSize = 13
b.Font = Enum.Font.GothamBold
b.BorderSizePixel = 0
b.ZIndex = 5
Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
b.MouseEnter:Connect(function()
tw(b, {BackgroundColor3 = bg == C.danger and Color3.fromRGB(220, 50, 70) or Color3.fromRGB(45, 45, 70)})
end)
b.MouseLeave:Connect(function() tw(b, {BackgroundColor3 = bg}) end)
return b
end

local BtnMin = mkTBtn(-66, "−", Color3.fromRGB(28, 28, 48))
local BtnClose = mkTBtn(-32, "✕", C.danger)

local Sep0 = Instance.new("Frame", M)
Sep0.Size = UDim2.new(1, 0, 0, 1)
Sep0.Position = UDim2.new(0, 0, 0, 57)
Sep0.BackgroundColor3 = C.sepLine
Sep0.BorderSizePixel = 0

-- ─────────────────────────────────────────────────
-- SIDEBAR
-- ─────────────────────────────────────────────────
local Side = Instance.new("Frame", M)
Side.Size = UDim2.new(0, 140, 1, -60)
Side.Position = UDim2.new(0, 0, 0, 59)
Side.BackgroundColor3 = C.sidebar
Side.BorderSizePixel = 0
do
local ul = Instance.new("UIListLayout", Side)
ul.SortOrder = Enum.SortOrder.LayoutOrder
ul.Padding = UDim.new(0, 4)
ul.HorizontalAlignment = Enum.HorizontalAlignment.Center
end
do
local p = Instance.new("UIPadding", Side)
p.PaddingTop = UDim.new(0, 10)
p.PaddingLeft = UDim.new(0, 8)
p.PaddingRight = UDim.new(0, 8)
end

local SideSep = Instance.new("Frame", M)
SideSep.Size = UDim2.new(0, 1, 1, -60)
SideSep.Position = UDim2.new(0, 140, 0, 59)
SideSep.BackgroundColor3 = C.sepLine
SideSep.BorderSizePixel = 0

-- ─────────────────────────────────────────────────
-- CONTENT AREA
-- ─────────────────────────────────────────────────
local CA = Instance.new("Frame", M)
CA.Size = UDim2.new(1, -146, 1, -63)
CA.Position = UDim2.new(0, 144, 0, 61)
CA.BackgroundTransparency = 1
CA.ClipsDescendants = true

-- ─────────────────────────────────────────────────
-- TOAST NOTIFICATIONS
-- ─────────────────────────────────────────────────
local toastQueue = 0
local function toast(msg, col)
col = col or C.accent
toastQueue = toastQueue + 1
local slot = toastQueue
local tf = Instance.new("Frame", SG)
tf.Size = UDim2.new(0, 270, 0, 38)
tf.Position = UDim2.new(1, -280, 1, 10 + (slot - 1) * 0)
tf.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
tf.BorderSizePixel = 0
tf.ZIndex = 20
Instance.new("UICorner", tf).CornerRadius = UDim.new(0, 10)
do
local s = Instance.new("UIStroke", tf)
s.Color = col; s.Thickness = 1.2; s.Transparency = 0.3
end
local tl = Instance.new("TextLabel", tf)
tl.Size = UDim2.new(1, -16, 1, 0)
tl.Position = UDim2.new(0, 10, 0, 0)
tl.BackgroundTransparency = 1
tl.Text = msg
tl.TextColor3 = col
tl.TextSize = 12
tl.Font = Enum.Font.GothamBold
tl.TextXAlignment = Enum.TextXAlignment.Left
tl.ZIndex = 21
tw(tf, {Position = UDim2.new(1, -280, 1, -52)}, 0.28)
task.delay(2.6, function()
tw(tf, {Position = UDim2.new(1, -280, 1, 10)}, 0.25)
task.delay(0.3, function()
tf:Destroy()
toastQueue = math.max(0, toastQueue - 1)
end)
end)
end

-- ─────────────────────────────────────────────────
-- TAB SYSTEM
-- ─────────────────────────────────────────────────
local tabs = {}
local activeTab = nil

local function setTab(name)
if activeTab == name then return end
activeTab = name
for n, t in pairs(tabs) do
local on = (n == name)
tw(t.frame, {BackgroundColor3 = on and C.tabActive or C.tabInact})
t.content.Visible = on
t.lbl.TextColor3 = on and C.txtPri or C.txtSec
t.ico.TextColor3 = on and C.accent or C.txtMuted
t.indic.Visible = on
end
end

local function newTab(order, name, icon)
local frame = Instance.new("Frame", Side)
frame.Size = UDim2.new(1, 0, 0, 46)
frame.BackgroundColor3 = C.tabInact
frame.BorderSizePixel = 0
frame.LayoutOrder = order
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local indic = Instance.new("Frame", frame)
indic.Size = UDim2.new(0, 3, 0.55, 0)
indic.Position = UDim2.new(0, 0, 0.225, 0)
indic.BackgroundColor3 = C.accent
indic.BorderSizePixel = 0
indic.Visible = false
Instance.new("UICorner", indic).CornerRadius = UDim.new(1, 0)

local ico = Instance.new("TextLabel", frame)
ico.Size = UDim2.new(0, 20, 0, 20)
ico.Position = UDim2.new(0, 11, 0.5, -10)
ico.BackgroundTransparency = 1
ico.Text = icon
ico.TextSize = 15
ico.Font = Enum.Font.GothamBold
ico.TextColor3 = C.txtMuted

local lbl = Instance.new("TextLabel", frame)
lbl.Size = UDim2.new(1, -36, 1, 0)
lbl.Position = UDim2.new(0, 35, 0, 0)
lbl.BackgroundTransparency = 1
lbl.Text = name
lbl.TextSize = 12
lbl.Font = Enum.Font.GothamBold
lbl.TextColor3 = C.txtSec
lbl.TextXAlignment = Enum.TextXAlignment.Left

local ovr = Instance.new("TextButton", frame)
ovr.Size = UDim2.new(1, 0, 1, 0)
ovr.BackgroundTransparency = 1
ovr.Text = ""
ovr.ZIndex = 2
ovr.MouseButton1Click:Connect(function() setTab(name) end)
ovr.MouseEnter:Connect(function()
if activeTab ~= name then tw(frame, {BackgroundColor3 = Color3.fromRGB(14, 14, 26)}) end
end)
ovr.MouseLeave:Connect(function()
if activeTab ~= name then tw(frame, {BackgroundColor3 = C.tabInact}) end
end)

local content = Instance.new("ScrollingFrame", CA)
content.Size = UDim2.new(1, -6, 1, -6)
content.Position = UDim2.new(0, 3, 0, 3)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.ScrollBarImageColor3 = C.accent
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Visible = false
do
local ul = Instance.new("UIListLayout", content)
ul.SortOrder = Enum.SortOrder.LayoutOrder
ul.Padding = UDim.new(0, 6)
end
do
local p = Instance.new("UIPadding", content)
p.PaddingTop = UDim.new(0, 4)
p.PaddingBottom = UDim.new(0, 8)
p.PaddingRight = UDim.new(0, 4)
end

tabs[name] = {frame=frame, content=content, ico=ico, lbl=lbl, indic=indic}
return content
end

-- ─────────────────────────────────────────────────
-- WIDGET BUILDERS
-- ─────────────────────────────────────────────────

local function mkSect(parent, order, text)
local f = Instance.new("Frame", parent)
f.Size = UDim2.new(1, 0, 0, 26)
f.BackgroundTransparency = 1
f.LayoutOrder = order
local lbl = Instance.new("TextLabel", f)
lbl.Size = UDim2.new(1, -4, 1, 0)
lbl.Position = UDim2.new(0, 4, 0, 0)
lbl.BackgroundTransparency = 1
lbl.Text = text:upper()
lbl.TextColor3 = C.accentDim
lbl.TextSize = 10
lbl.Font = Enum.Font.GothamBold
lbl.TextXAlignment = Enum.TextXAlignment.Left
local ul = Instance.new("Frame", f)
ul.Size = UDim2.new(1, -4, 0, 1)
ul.Position = UDim2.new(0, 4, 1, -1)
ul.BackgroundColor3 = C.sepLine
ul.BorderSizePixel = 0
end

local function mkCard(parent, order, h)
local f = Instance.new("Frame", parent)
f.Size = UDim2.new(1, 0, 0, h or 48)
f.BackgroundColor3 = C.card
f.BorderSizePixel = 0
f.LayoutOrder = order
Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
return f
end

local function mkToggle(parent, order, label, desc, fn)
local h = desc and 58 or 46
local card = mkCard(parent, order, h)

local dot = Instance.new("TextLabel", card)
dot.Size = UDim2.new(0, 8, 0, 8)
dot.Position = UDim2.new(0, 13, 0.5, -4)
dot.BackgroundTransparency = 1
dot.Text = "●"
dot.TextSize = 8
dot.Font = Enum.Font.GothamBold
dot.TextColor3 = C.txtMuted

local lbl = Instance.new("TextLabel", card)
lbl.Size = UDim2.new(1, -82, 0, 20)
lbl.Position = UDim2.new(0, 28, 0, desc and 10 or 13)
lbl.BackgroundTransparency = 1
lbl.Text = label
lbl.TextColor3 = C.txtPri
lbl.TextSize = 13
lbl.Font = Enum.Font.GothamBold
lbl.TextXAlignment = Enum.TextXAlignment.Left

if desc then
local dl = Instance.new("TextLabel", card)
dl.Size = UDim2.new(1, -82, 0, 14)
dl.Position = UDim2.new(0, 28, 0, 34)
dl.BackgroundTransparency = 1
dl.Text = desc
dl.TextColor3 = C.txtSec
dl.TextSize = 10
dl.Font = Enum.Font.Gotham
dl.TextXAlignment = Enum.TextXAlignment.Left
end

local trk = Instance.new("Frame", card)
trk.Size = UDim2.new(0, 42, 0, 22)
trk.Position = UDim2.new(1, -54, 0.5, -11)
trk.BackgroundColor3 = C.trkOff
trk.BorderSizePixel = 0
Instance.new("UICorner", trk).CornerRadius = UDim.new(1, 0)

local knb = Instance.new("Frame", trk)
knb.Size = UDim2.new(0, 16, 0, 16)
knb.Position = UDim2.new(0, 3, 0.5, -8)
knb.BackgroundColor3 = C.knbOff
knb.BorderSizePixel = 0
Instance.new("UICorner", knb).CornerRadius = UDim.new(1, 0)

local state = false
local function set(on)
state = on
if on then
tw(trk, {BackgroundColor3 = C.accent})
tw(knb, {Position = UDim2.new(0, 23, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255,255,255)})
tw(card, {BackgroundColor3 = C.cardOn})
tw(dot, {TextColor3 = C.accent})
else
tw(trk, {BackgroundColor3 = C.trkOff})
tw(knb, {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = C.knbOff})
tw(card, {BackgroundColor3 = C.card})
tw(dot, {TextColor3 = C.txtMuted})
end
if fn then fn(on) end
end

local ovr = Instance.new("TextButton", card)
ovr.Size = UDim2.new(1, 0, 1, 0)
ovr.BackgroundTransparency = 1
ovr.Text = ""
ovr.ZIndex = 2
ovr.MouseButton1Click:Connect(function() set(not state) end)
ovr.MouseEnter:Connect(function()
if not state then tw(card, {BackgroundColor3 = C.cardHov}) end
end)
ovr.MouseLeave:Connect(function()
if not state then tw(card, {BackgroundColor3 = C.card}) end
end)
return set
end

local function mkBtn(parent, order, label, desc, fn)
local h = desc and 58 or 46
local card = mkCard(parent, order, h)

local lbl = Instance.new("TextLabel", card)
lbl.Size = UDim2.new(1, -78, 0, 20)
lbl.Position = UDim2.new(0, 14, 0, desc and 10 or 13)
lbl.BackgroundTransparency = 1
lbl.Text = label
lbl.TextColor3 = C.txtPri
lbl.TextSize = 13
lbl.Font = Enum.Font.GothamBold
lbl.TextXAlignment = Enum.TextXAlignment.Left

if desc then
local dl = Instance.new("TextLabel", card)
dl.Size = UDim2.new(1, -78, 0, 14)
dl.Position = UDim2.new(0, 14, 0, 34)
dl.BackgroundTransparency = 1
dl.Text = desc
dl.TextColor3 = C.txtSec
dl.TextSize = 10
dl.Font = Enum.Font.Gotham
dl.TextXAlignment = Enum.TextXAlignment.Left
end

local btn = Instance.new("TextButton", card)
btn.Size = UDim2.new(0, 52, 0, 28)
btn.Position = UDim2.new(1, -60, 0.5, -14)
btn.BackgroundColor3 = C.btnBg
btn.Text = "RUN"
btn.TextColor3 = C.accent
btn.TextSize = 11
btn.Font = Enum.Font.GothamBold
btn.BorderSizePixel = 0
btn.ZIndex = 2
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

btn.MouseButton1Click:Connect(function()
tw(btn, {BackgroundColor3 = C.btnPrs, TextColor3 = Color3.fromRGB(10, 10, 20)})
task.delay(0.22, function()
tw(btn, {BackgroundColor3 = C.btnBg, TextColor3 = C.accent})
end)
if fn then fn() end
end)
btn.MouseEnter:Connect(function() tw(btn, {BackgroundColor3 = C.btnHov}) end)
btn.MouseLeave:Connect(function() tw(btn, {BackgroundColor3 = C.btnBg}) end)
card.MouseEnter:Connect(function() tw(card, {BackgroundColor3 = C.cardHov}) end)
card.MouseLeave:Connect(function() tw(card, {BackgroundColor3 = C.card}) end)
end

local function mkInput(parent, order, label, default, fn)
local card = mkCard(parent, order, 54)
local lbl = Instance.new("TextLabel", card)
lbl.Size = UDim2.new(1, -14, 0, 16)
lbl.Position = UDim2.new(0, 12, 0, 6)
lbl.BackgroundTransparency = 1
lbl.Text = label
lbl.TextColor3 = C.txtSec
lbl.TextSize = 10
lbl.Font = Enum.Font.GothamBold
lbl.TextXAlignment = Enum.TextXAlignment.Left

local box = Instance.new("TextBox", card)
box.Size = UDim2.new(1, -24, 0, 24)
box.Position = UDim2.new(0, 12, 0, 24)
box.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
box.Text = tostring(default or "")
box.TextColor3 = C.accent
box.PlaceholderText = "enter value..."
box.PlaceholderColor3 = C.txtMuted
box.TextSize = 12
box.Font = Enum.Font.GothamBold
box.BorderSizePixel = 0
box.ClearTextOnFocus = false
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
box.FocusLost:Connect(function(enter)
if enter and fn then fn(box.Text) end
end)
return box
end

-- ─────────────────────────────────────────────────
-- FORCE FLING (collision bypass)
-- ─────────────────────────────────────────────────
local function forceFling(target)
if not target or not target.Character then return end
local tr = target.Character:FindFirstChild("HumanoidRootPart")
if not tr then return end

local myR = hrp()

-- step 1: teleport close to force network ownership
if myR then
local orig = myR.CFrame
myR.CFrame = tr.CFrame + Vector3.new(2.5, 0, 0)
task.wait(0.04)
myR.CFrame = orig
end

-- step 2: strip CanCollide from target
for _, p in ipairs(target.Character:GetDescendants()) do
if p:IsA("BasePart") then
pcall(function() p.CanCollide = false end)
end
end

-- step 3: random outward direction with strong upward component
local dir = Vector3.new(
math.random(-10, 10) / 10,
2,
math.random(-10, 10) / 10
).Unit

local power = 1400

-- step 4: direct velocity
pcall(function() tr.AssemblyLinearVelocity = dir * power end)

-- step 5: BodyVelocity on top
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
bv.Velocity = dir * power
bv.Parent = tr
Debris:AddItem(bv, 0.45)

-- step 6: sustain velocity for 0.35s so it really sends them
local t0 = tick()
local sc; sc = RunService.Heartbeat:Connect(function()
if tick() - t0 > 0.35 then sc:Disconnect(); return end
pcall(function()
tr.AssemblyLinearVelocity = dir * power
end)
end)

toast("⚡ Flung " .. target.Name, C.accent)
end

-- ─────────────────────────────────────────────────
-- KILLER FINDER
-- ─────────────────────────────────────────────────
local function findKiller()
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local c2 = plr.Character
-- check attributes
if c2:GetAttribute("IsKiller") or c2:GetAttribute("Killer")
or c2:GetAttribute("isSeeker") or c2:GetAttribute("Role") == "Killer" then
return plr, c2
end
-- check for blindfold/killer-named accessories or gui tags
for _, v in ipairs(c2:GetDescendants()) do
local ln = v.Name:lower()
if ln:find("blind") or ln:find("killerui") or ln:find("seekerui")
or ln:find("killermark") or ln:find("seeker") then
return plr, c2
end
end
end
end
return nil, nil
end

-- ══════════════════════════════════════════════════
-- CREATE TABS
-- ══════════════════════════════════════════════════
local plrC = newTab(1, "Players", "👤")
local gameC = newTab(2, "Game", "🔇")
local statsC = newTab(3, "Leaderstats", "📊")
local selfC = newTab(4, "Self", "⚡")
local visC = newTab(5, "Visual", "👁")

-- ══════════════════════════════════════════════════
-- PLAYERS TAB
-- ══════════════════════════════════════════════════
mkSect(plrC, 1, "Player List")

local PlrCard = mkCard(plrC, 2, 160)
PlrCard.BackgroundColor3 = Color3.fromRGB(8, 8, 16)

local PlrScr = Instance.new("ScrollingFrame", PlrCard)
PlrScr.Size = UDim2.new(1, -8, 1, -8)
PlrScr.Position = UDim2.new(0, 4, 0, 4)
PlrScr.BackgroundTransparency = 1
PlrScr.BorderSizePixel = 0
PlrScr.ScrollBarThickness = 3
PlrScr.ScrollBarImageColor3 = C.accent
PlrScr.CanvasSize = UDim2.new(0, 0, 0, 0)
PlrScr.AutomaticCanvasSize = Enum.AutomaticSize.Y
do
local ul = Instance.new("UIListLayout", PlrScr)
ul.SortOrder = Enum.SortOrder.LayoutOrder
ul.Padding = UDim.new(0, 4)
end

local SelCard = mkCard(plrC, 3, 32)
SelCard.BackgroundColor3 = Color3.fromRGB(8, 14, 26)
local SelLbl = Instance.new("TextLabel", SelCard)
SelLbl.Size = UDim2.new(1, -16, 1, 0)
SelLbl.Position = UDim2.new(0, 10, 0, 0)
SelLbl.BackgroundTransparency = 1
SelLbl.Text = "Selected: none"
SelLbl.TextColor3 = C.txtSec
SelLbl.TextSize = 11
SelLbl.Font = Enum.Font.Gotham
SelLbl.TextXAlignment = Enum.TextXAlignment.Left

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
row.Size = UDim2.new(1, 0, 0, 32)
row.BackgroundColor3 = sel and Color3.fromRGB(6, 22, 42) or Color3.fromRGB(12, 12, 22)
row.BorderSizePixel = 0
row.LayoutOrder = i
Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)
if sel then
local s = Instance.new("UIStroke", row)
s.Color = C.accent; s.Thickness = 1; s.Transparency = 0.5
end
local nl = Instance.new("TextLabel", row)
nl.Size = UDim2.new(1, -12, 1, 0)
nl.Position = UDim2.new(0, 10, 0, 0)
nl.BackgroundTransparency = 1
nl.Text = plr.Name
nl.TextColor3 = sel and C.accent or C.txtPri
nl.TextSize = 12
nl.Font = Enum.Font.GothamBold
nl.TextXAlignment = Enum.TextXAlignment.Left
local ob = Instance.new("TextButton", row)
ob.Size = UDim2.new(1, 0, 1, 0)
ob.BackgroundTransparency = 1
ob.Text = ""
ob.ZIndex = 2
ob.MouseButton1Click:Connect(function()
selectedPlayer = plr
SelLbl.Text = "Selected: " .. plr.Name
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

mkBtn(plrC, 5, "Teleport to Player", "Warp next to selected player", function()
if not selectedPlayer then toast("No player selected", C.danger); return end
local r = hrp()
local tr = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
if r and tr then
r.CFrame = tr.CFrame + Vector3.new(3, 0, 0)
toast("Teleported → " .. selectedPlayer.Name)
end
end)

mkBtn(plrC, 6, "Force Fling", "Physics fling, bypasses collision", function()
if not selectedPlayer then toast("No player selected", C.danger); return end
forceFling(selectedPlayer)
end)

mkBtn(plrC, 7, "Fling All Players", "Sends everyone flying at once", function()
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP then task.spawn(forceFling, plr) end
end
toast("Flung entire server", C.accent)
end)

mkToggle(plrC, 8, "Kill on Touch", "Drains health on contact", function(on)
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

mkToggle(plrC, 9, "Aura Kill", "Zero health to nearby players", function(on)
drop("aura")
if not on then return end
conns.aura = RunService.Heartbeat:Connect(function()
local r = hrp()
if not r then return end
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local pr = plr.Character:FindFirstChild("HumanoidRootPart")
local ph = plr.Character:FindFirstChildOfClass("Humanoid")
if pr and ph and (pr.Position - r.Position).Magnitude < 22 then
ph.Health = 0
end
end
end
end)
end)

mkToggle(plrC, 10, "Loop Fling Selected", "Continuously flings target player", function(on)
drop("loopFling")
if not on then return end
conns.loopFling = RunService.Heartbeat:Connect(function()
if selectedPlayer and selectedPlayer.Character then
forceFling(selectedPlayer)
end
end)
end)

-- ══════════════════════════════════════════════════
-- GAME TAB (Quiet or Die specific)
-- ══════════════════════════════════════════════════
mkSect(gameC, 1, "Round Control")

mkBtn(gameC, 2, "Become Killer", "Fires role/assign killer remotes", function()
local fired = 0
for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
local n = v.Name:lower()
if n:find("killer") or n:find("seeker") or n:find("assign") or n:find("role") or n:find("setRole") then
pcall(function()
if v:IsA("RemoteEvent") then v:FireServer(LP) v:FireServer() end
end)
fired = fired + 1
end
end
end
toast(fired > 0 and "Fired " .. fired .. " role remote(s)" or "Remote not found — Dump first", fired > 0 and C.green or C.danger)
end)

mkBtn(gameC, 3, "Skip / End Round", "Fires round-end remotes", function()
local fired = 0
for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
if v:IsA("RemoteEvent") then
local n = v.Name:lower()
if n:find("end") or n:find("finish") or n:find("round") or n:find("skip") or n:find("over") then
pcall(function() v:FireServer() end)
fired = fired + 1
end
end
end
toast("Fired " .. fired .. " end-round remote(s)", C.accent)
end)

mkBtn(gameC, 4, "Force Survivor Win", "Fires win/escape remotes", function()
local fired = 0
for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
if v:IsA("RemoteEvent") then
local n = v.Name:lower()
if n:find("win") or n:find("survive") or n:find("escape") or n:find("alive") then
pcall(function() v:FireServer(LP) end)
fired = fired + 1
end
end
end
toast("Fired " .. fired .. " win remote(s)", C.green)
end)

mkSect(gameC, 5, "Noise Tools")

mkBtn(gameC, 6, "Noise Bomb on Target", "Emits max noise from target's position", function()
if not selectedPlayer then toast("No player selected", C.danger); return end
local tr = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
if not tr then return end
-- fire noise detection remotes with target position
for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
if v:IsA("RemoteEvent") then
local n = v.Name:lower()
if n:find("noise") or n:find("sound") or n:find("step") or n:find("heard") or n:find("detect") or n:find("audio") then
pcall(function() v:FireServer(tr.Position, 999) end)
pcall(function() v:FireServer(tr.Position) end)
pcall(function() v:FireServer(selectedPlayer, 999) end)
end
end
end
-- audible client-side scream
local snd = Instance.new("Sound", tr)
snd.SoundId = "rbxassetid://131961136"
snd.Volume = 10
snd.RollOffMaxDistance = 9999
snd:Play()
Debris:AddItem(snd, 3)
toast("💥 Noise bomb on " .. selectedPlayer.Name, C.gold)
end)

mkToggle(gameC, 7, "Silent Mode", "Mutes all sounds on your character", function(on)
drop("silentMode")
if not on then
-- restore sounds
local c = ch()
if c then
for _, v in ipairs(c:GetDescendants()) do
if v:IsA("Sound") then pcall(function() v.Volume = 0.5 end) end
end
end
toast("Silent Mode OFF", C.txtSec)
return
end
local function muteChar(c)
for _, v in ipairs(c:GetDescendants()) do
if v:IsA("Sound") then pcall(function() v.Volume = 0 end) end
end
conns.silentMode = c.DescendantAdded:Connect(function(v)
if v:IsA("Sound") then pcall(function() v.Volume = 0 end) end
end)
end
local c = ch()
if c then muteChar(c) end
LP.CharacterAdded:Connect(function(c2) task.wait(0.2); muteChar(c2) end)
toast("Silent Mode ON", C.green)
end)

mkToggle(gameC, 8, "Noise Spam All Players", "Blasts noise events from every player", function(on)
drop("nspam")
if not on then return end
local nRemotes = {}
for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
if v:IsA("RemoteEvent") then
local n = v.Name:lower()
if n:find("noise") or n:find("sound") or n:find("step") or n:find("detect") or n:find("heard") then
table.insert(nRemotes, v)
end
end
end
conns.nspam = RunService.Heartbeat:Connect(function()
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local pr = plr.Character:FindFirstChild("HumanoidRootPart")
if pr then
for _, v in ipairs(nRemotes) do
pcall(function() v:FireServer(pr.Position, 999) end)
end
end
end
end
end)
end)

mkSect(gameC, 9, "Killer Control")

mkBtn(gameC, 10, "Freeze Killer", "Anchors killer's HRP for 6 seconds", function()
local kPlr, kChar = findKiller()
if kChar then
local kr = kChar:FindFirstChild("HumanoidRootPart")
if kr then
kr.Anchored = true
local kh = kChar:FindFirstChildOfClass("Humanoid")
if kh then kh.WalkSpeed = 0 end
task.delay(6, function()
pcall(function()
kr.Anchored = false
if kh then kh.WalkSpeed = 16 end
end)
end)
toast("Killer frozen 6s — " .. kPlr.Name, C.green)
end
else
toast("Killer not detected", C.danger)
end
end)

mkBtn(gameC, 11, "Yeet Killer Away", "Flings killer to a random position", function()
local kPlr, kChar = findKiller()
if kChar then
local kr = kChar:FindFirstChild("HumanoidRootPart")
if kr then
kr.CFrame = CFrame.new(math.random(-600, 600), 800, math.random(-600, 600))
pcall(function()
kr.AssemblyLinearVelocity = Vector3.new(0, -200, 0)
end)
toast("Killer yeeted — " .. kPlr.Name, C.gold)
end
else
toast("Killer not detected", C.danger)
end
end)

mkToggle(gameC, 12, "Track Killer in Chat", "Prints killer pos to output every 2s", function(on)
drop("killerTrack")
if not on then return end
conns.killerTrack = RunService.Heartbeat:Connect(function()
local _, kChar = findKiller()
if kChar then
local kr = kChar:FindFirstChild("HumanoidRootPart")
if kr then
local p = kr.Position
print(string.format("[Killer] X:%.1f Y:%.1f Z:%.1f", p.X, p.Y, p.Z))
end
end
end)
end)

mkSect(gameC, 13, "Remote Dump")

mkBtn(gameC, 14, "Dump All Remotes", "Prints every remote to console", function()
local count = 0
print("══════ QoD VOID · REMOTE DUMP ══════")
for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
print(string.format(" [RS][%s] %s", v.ClassName, v:GetFullName()))
count = count + 1
end
end
for _, v in ipairs(workspace:GetDescendants()) do
if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
print(string.format(" [WS][%s] %s", v.ClassName, v:GetFullName()))
count = count + 1
end
end
print("══════ Total: " .. count .. " ══════")
toast("Dumped " .. count .. " remotes → console", C.accent)
end)

-- ══════════════════════════════════════════════════
-- LEADERSTATS TAB
-- ══════════════════════════════════════════════════
local lsStatusCard = mkCard(statsC, 1, 38)
lsStatusCard.BackgroundColor3 = Color3.fromRGB(8, 14, 26)
local lsStatusLbl = Instance.new("TextLabel", lsStatusCard)
lsStatusLbl.Size = UDim2.new(1, -16, 1, 0)
lsStatusLbl.Position = UDim2.new(0, 10, 0, 0)
lsStatusLbl.BackgroundTransparency = 1
lsStatusLbl.Text = "Waiting for leaderstats..."
lsStatusLbl.TextColor3 = C.txtSec
lsStatusLbl.TextSize = 11
lsStatusLbl.Font = Enum.Font.Gotham
lsStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

-- dynamic container — rows built inside here
local lsDynamic = Instance.new("Frame", statsC)
lsDynamic.Size = UDim2.new(1, 0, 0, 10)
lsDynamic.BackgroundTransparency = 1
lsDynamic.LayoutOrder = 3
lsDynamic.AutomaticSize = Enum.AutomaticSize.Y
do
local ul = Instance.new("UIListLayout", lsDynamic)
ul.SortOrder = Enum.SortOrder.LayoutOrder
ul.Padding = UDim.new(0, 6)
end

local function buildStatRow(stat, order)
local savedVal = saveData["stat_" .. stat.Name]

local card = Instance.new("Frame", lsDynamic)
card.Size = UDim2.new(1, 0, 0, 84)
card.BackgroundColor3 = C.card
card.BorderSizePixel = 0
card.LayoutOrder = order
Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

-- stat name
local nameLbl = Instance.new("TextLabel", card)
nameLbl.Size = UDim2.new(0.6, 0, 0, 18)
nameLbl.Position = UDim2.new(0, 12, 0, 7)
nameLbl.BackgroundTransparency = 1
nameLbl.Text = stat.Name
nameLbl.TextColor3 = C.accent
nameLbl.TextSize = 12
nameLbl.Font = Enum.Font.GothamBold
nameLbl.TextXAlignment = Enum.TextXAlignment.Left

-- current value (live)
local curLbl = Instance.new("TextLabel", card)
curLbl.Size = UDim2.new(0.38, 0, 0, 14)
curLbl.Position = UDim2.new(0.62, 0, 0, 9)
curLbl.BackgroundTransparency = 1
curLbl.Text = "now: " .. tostring(stat.Value)
curLbl.TextColor3 = C.txtSec
curLbl.TextSize = 10
curLbl.Font = Enum.Font.Gotham
curLbl.TextXAlignment = Enum.TextXAlignment.Right

-- input box
local box = Instance.new("TextBox", card)
box.Size = UDim2.new(1, -90, 0, 26)
box.Position = UDim2.new(0, 12, 0, 30)
box.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
box.Text = savedVal ~= nil and tostring(savedVal) or tostring(stat.Value)
box.TextColor3 = C.accent
box.PlaceholderText = "enter value..."
box.PlaceholderColor3 = C.txtMuted
box.TextSize = 12
box.Font = Enum.Font.GothamBold
box.BorderSizePixel = 0
box.ClearTextOnFocus = false
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

-- apply button
local applyBtn = Instance.new("TextButton", card)
applyBtn.Size = UDim2.new(0, 68, 0, 26)
applyBtn.Position = UDim2.new(1, -80, 0, 30)
applyBtn.BackgroundColor3 = C.green
applyBtn.Text = "APPLY"
applyBtn.TextColor3 = Color3.fromRGB(8, 18, 12)
applyBtn.TextSize = 11
applyBtn.Font = Enum.Font.GothamBold
applyBtn.BorderSizePixel = 0
applyBtn.ZIndex = 2
Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 6)

-- info row
local infoLbl = Instance.new("TextLabel", card)
infoLbl.Size = UDim2.new(1, -14, 0, 13)
infoLbl.Position = UDim2.new(0, 12, 0, 62)
infoLbl.BackgroundTransparency = 1
infoLbl.Text = savedVal ~= nil and "💾 saved: " .. tostring(savedVal) or "not saved yet"
infoLbl.TextColor3 = savedVal ~= nil and C.green or C.txtMuted
infoLbl.TextSize = 9
infoLbl.Font = Enum.Font.Gotham
infoLbl.TextXAlignment = Enum.TextXAlignment.Left

applyBtn.MouseButton1Click:Connect(function()
local raw = box.Text
local val = tonumber(raw) or raw
-- 1. persist to disk
saveData["stat_" .. stat.Name] = val
writeSave()
-- 2. set locally
pcall(function()
stat.Value = type(val) == "number" and val or raw
end)
-- 3. fire any matching server remotes
local fired = 0
for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
if remote:IsA("RemoteEvent") then
local rn = remote.Name:lower()
local sn = stat.Name:lower()
if rn:find(sn) or rn:find("set") or rn:find("give") or rn:find("add") or rn:find("update") or rn:find("stat") or rn:find("currency") then
pcall(function()
remote:FireServer(stat.Name, val)
remote:FireServer(val)
end)
fired = fired + 1
end
end
end
-- 4. feedback
tw(applyBtn, {BackgroundColor3 = C.btnPrs})
curLbl.Text = "now: " .. tostring(stat.Value)
infoLbl.Text = "💾 saved: " .. tostring(val) .. " · fired " .. fired .. " remote(s)"
infoLbl.TextColor3 = C.green
task.delay(0.6, function() tw(applyBtn, {BackgroundColor3 = C.green}) end)
toast(stat.Name .. " → " .. tostring(val), C.green)
end)
applyBtn.MouseEnter:Connect(function() tw(applyBtn, {BackgroundColor3 = Color3.fromRGB(70, 220, 120)}) end)
applyBtn.MouseLeave:Connect(function() tw(applyBtn, {BackgroundColor3 = C.green}) end)

-- live current value update
task.spawn(function()
while card.Parent do
task.wait(1.2)
pcall(function()
curLbl.Text = "now: " .. tostring(stat.Value)
end)
end
end)

-- auto-apply saved value on load
if savedVal ~= nil then
task.spawn(function()
task.wait(1.8)
pcall(function()
stat.Value = tonumber(savedVal) or savedVal
end)
end)
end
end

local function refreshLeaderstats()
for _, c in ipairs(lsDynamic:GetChildren()) do
if not c:IsA("UIListLayout") then c:Destroy() end
end

local ls = LP:FindFirstChild("leaderstats")
if not ls then
lsStatusLbl.Text = "No leaderstats found in this game."
lsStatusLbl.TextColor3 = C.danger
return
end

local stats = {}
for _, v in ipairs(ls:GetChildren()) do
if v:IsA("IntValue") or v:IsA("NumberValue") or v:IsA("StringValue") or v:IsA("BoolValue") then
table.insert(stats, v)
end
end

if #stats == 0 then
lsStatusLbl.Text = "Leaderstats folder is empty."
lsStatusLbl.TextColor3 = C.gold
return
end

lsStatusLbl.Text = "Found " .. #stats .. " stat(s) · saves persist to disk"
lsStatusLbl.TextColor3 = C.green

for i, stat in ipairs(stats) do
buildStatRow(stat, i)
end
end

mkBtn(statsC, 2, "Refresh / Re-scan Stats", "Rebuild the leaderstat list", function()
refreshLeaderstats()
toast("Leaderstats refreshed", C.accent)
end)

task.spawn(function()
task.wait(2.8)
refreshLeaderstats()
end)

LP.CharacterAdded:Connect(function()
task.wait(2.2)
refreshLeaderstats()
end)

mkSect(statsC, 4, "Bulk Actions")

mkBtn(statsC, 5, "Max All Numeric Stats", "Sets every IntValue / NumberValue to 999999", function()
local ls = LP:FindFirstChild("leaderstats")
if not ls then toast("No leaderstats", C.danger); return end
local count = 0
for _, v in ipairs(ls:GetChildren()) do
if v:IsA("IntValue") or v:IsA("NumberValue") then
pcall(function()
v.Value = 999999
saveData["stat_" .. v.Name] = 999999
end)
count = count + 1
end
end
writeSave()
refreshLeaderstats()
toast("Maxed " .. count .. " stat(s) to 999999", C.gold)
end)

mkBtn(statsC, 6, "Clear Saved Stat Data", "Wipes disk-saved stat values", function()
for k in pairs(saveData) do
if k:sub(1, 5) == "stat_" then saveData[k] = nil end
end
writeSave()
refreshLeaderstats()
toast("Saved stat data wiped", C.danger)
end)

-- ══════════════════════════════════════════════════
-- SELF TAB
-- ══════════════════════════════════════════════════
mkSect(selfC, 1, "Movement")

local wsBox = mkInput(selfC, 2, "WalkSpeed", saveData.walkspeed or 16, function(v)
local n = tonumber(v)
local h = hum()
if h and n then
h.WalkSpeed = n
saveData.walkspeed = n
writeSave()
end
end)

local jpBox = mkInput(selfC, 3, "JumpPower", saveData.jumppower or 50, function(v)
local n = tonumber(v)
local h = hum()
if h and n then
h.JumpPower = n
saveData.jumppower = n
writeSave()
end
end)

LP.CharacterAdded:Connect(function()
task.wait(0.6)
local h = hum()
if not h then return end
h.WalkSpeed = tonumber(wsBox.Text) or 16
h.JumpPower = tonumber(jpBox.Text) or 50
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

mkToggle(selfC, 7, "God Mode", "Infinite health locked every frame", function(on)
drop("godMode")
if not on then return end
conns.godMode = RunService.Heartbeat:Connect(function()
local h = hum()
if h then h.MaxHealth = math.huge; h.Health = math.huge end
end)
end)

mkToggle(selfC, 8, "Anti-Kill", "Resets health if it hits zero", function(on)
drop("antiKill")
if not on then return end
conns.antiKill = RunService.Heartbeat:Connect(function()
local h = hum()
if h and h.Health <= 1 then
h.MaxHealth = 100
h.Health = 100
end
end)
end)

mkToggle(selfC, 9, "Speed Lock", "Maintains WalkSpeed every frame", function(on)
drop("spdLock")
if not on then return end
conns.spdLock = RunService.Heartbeat:Connect(function()
local h = hum()
local n = tonumber(wsBox.Text) or 16
if h then h.WalkSpeed = n end
end)
end)

mkBtn(selfC, 10, "Fly (Toggle)", "WASD + Space/Ctrl · Shift = boost", function()
local r = hrp()
if not r then return end
if r:FindFirstChild("_FlyBF") then
r._FlyBF:Destroy()
if r:FindFirstChild("_FlyBG") then r._FlyBG:Destroy() end
drop("flyHB")
toast("Fly OFF", C.txtSec)
return
end
local bg = Instance.new("BodyGyro", r)
bg.Name = "_FlyBG"
bg.MaxTorque = Vector3.new(4e5, 4e5, 4e5)
bg.CFrame = r.CFrame
local bf = Instance.new("BodyVelocity", r)
bf.Name = "_FlyBF"
bf.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
bf.Velocity = Vector3.new(0, 0, 0)
toast("Fly ON · Shift = boost", C.green)
conns.flyHB = RunService.Heartbeat:Connect(function()
if not r or not r.Parent then drop("flyHB"); return end
local spd = UIS:IsKeyDown(Enum.KeyCode.LeftShift) and 180 or 60
local vel = Vector3.new(0, 0, 0)
if UIS:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0, spd, 0) end
if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then vel = vel + Vector3.new(0, -spd, 0) end
if UIS:IsKeyDown(Enum.KeyCode.W) then vel = vel + r.CFrame.LookVector * spd end
if UIS:IsKeyDown(Enum.KeyCode.S) then vel = vel - r.CFrame.LookVector * spd end
if UIS:IsKeyDown(Enum.KeyCode.A) then vel = vel - r.CFrame.RightVector * spd end
if UIS:IsKeyDown(Enum.KeyCode.D) then vel = vel + r.CFrame.RightVector * spd end
bf.Velocity = vel
end)
end)

mkBtn(selfC, 11, "Teleport to Spawn", "Warp to SpawnLocation", function()
local r = hrp()
if not r then return end
local sp = workspace:FindFirstChildOfClass("SpawnLocation")
if sp then
r.CFrame = sp.CFrame + Vector3.new(0, 5, 0)
toast("Teleported to spawn")
else
r.CFrame = CFrame.new(0, 60, 0)
toast("Teleported to origin")
end
end)

-- ══════════════════════════════════════════════════
-- VISUAL TAB
-- ══════════════════════════════════════════════════
mkSect(visC, 1, "ESP")

mkToggle(visC, 2, "Selection Box ESP", "Glowing boxes around all players", function(on)
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
local sb = Instance.new("SelectionBox")
sb.Name = "_ESP"
sb.Color3 = C.accent
sb.LineThickness = 0.05
sb.SurfaceTransparency = 0.86
sb.SurfaceColor3 = C.accentDim
sb.Adornee = c
sb.Parent = c
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

mkToggle(visC, 3, "Killer ESP", "Highlights killer with red box", function(on)
drop("killerESP")
if not on then return end
conns.killerESP = RunService.Heartbeat:Connect(function()
local _, kChar = findKiller()
if kChar then
if not kChar:FindFirstChild("_KillerESP") then
pcall(function()
local sb = Instance.new("SelectionBox")
sb.Name = "_KillerESP"
sb.Color3 = C.danger
sb.LineThickness = 0.08
sb.SurfaceTransparency = 0.75
sb.SurfaceColor3 = Color3.fromRGB(100, 0, 0)
sb.Adornee = kChar
sb.Parent = kChar
end)
end
end
end)
end)

mkToggle(visC, 4, "Name + Distance Billboard", "Floating name/dist label above players", function(on)
drop("billESP")
for _, plr in ipairs(Players:GetPlayers()) do
if plr.Character then
local h = plr.Character:FindFirstChild("_BillESP")
if h then h:Destroy() end
end
end
if not on then return end
local function applyBill(plr)
if plr == LP then return end
local function doChar(c)
pcall(function()
local hrpC = c:FindFirstChild("HumanoidRootPart")
if not hrpC then return end
local ex = c:FindFirstChild("_BillESP"); if ex then ex:Destroy() end
local bg = Instance.new("BillboardGui", hrpC)
bg.Name = "_BillESP"
bg.AlwaysOnTop = true
bg.Size = UDim2.new(0, 130, 0, 44)
bg.StudsOffset = Vector3.new(0, 3.8, 0)
bg.LightInfluence = 0
local lbl = Instance.new("TextLabel", bg)
lbl.Size = UDim2.new(1, 0, 1, 0)
lbl.BackgroundTransparency = 1
lbl.TextColor3 = C.accent
lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
lbl.TextStrokeTransparency = 0.2
lbl.TextSize = 13
lbl.Font = Enum.Font.GothamBold
lbl.Text = plr.Name
task.spawn(function()
while bg.Parent do
task.wait(0.4)
local r1 = hrp()
if r1 and hrpC and hrpC.Parent then
local d = math.floor((hrpC.Position - r1.Position).Magnitude)
lbl.Text = plr.Name .. "\n[" .. d .. " m]"
end
end
end)
end)
end
if plr.Character then task.spawn(doChar, plr.Character) end
plr.CharacterAdded:Connect(function(chr) task.wait(0.2); doChar(chr) end)
end
for _, plr in ipairs(Players:GetPlayers()) do applyBill(plr) end
Players.PlayerAdded:Connect(applyBill)
end)

mkSect(visC, 5, "Lighting")

mkBtn(visC, 6, "Remove Fog", "Clears all fog from Lighting", function()
Lighting.FogStart = 0
Lighting.FogEnd = 9e9
Lighting.FogColor = Color3.fromRGB(0, 0, 0)
toast("Fog removed", C.accent)
end)

mkBtn(visC, 7, "Fullbright", "Max ambient + brightness", function()
Lighting.Ambient = Color3.fromRGB(255, 255, 255)
Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
Lighting.Brightness = 5
Lighting.ClockTime = 14
toast("Fullbright ON", C.gold)
end)

mkBtn(visC, 8, "Pitch Black", "Zero ambient, midnight", function()
Lighting.Ambient = Color3.fromRGB(0, 0, 0)
Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
Lighting.Brightness = 0
Lighting.ClockTime = 0
toast("Dark Mode ON", C.txtMuted)
end)

mkToggle(visC, 9, "Rainbow Ambient", "Cycles ambient color continuously", function(on)
drop("rbAmb")
if not on then return end
local hue = 0
conns.rbAmb = RunService.Heartbeat:Connect(function()
hue = (hue + 0.0015) % 1
local col = Color3.fromHSV(hue, 0.85, 1)
Lighting.Ambient = col
Lighting.OutdoorAmbient = col
end)
end)

-- ══════════════════════════════════════════════════
-- DRAGGABLE
-- ══════════════════════════════════════════════════
do
local drag, ds, sp
TBar.InputBegan:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 then
drag = true
ds = i.Position
sp = M.Position
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

-- ══════════════════════════════════════════════════
-- MINIMIZE / CLOSE
-- ══════════════════════════════════════════════════
local minimized = false
BtnMin.MouseButton1Click:Connect(function()
minimized = not minimized
Side.Visible = not minimized
SideSep.Visible = not minimized
CA.Visible = not minimized
Sep0.Visible = not minimized
BtnMin.Text = minimized and "+" or "−"
tw(M, {Size = UDim2.new(0, 625, 0, minimized and 56 or 445)})
end)

BtnClose.MouseButton1Click:Connect(function()
for _, c in pairs(conns) do
if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
end
for _, c in ipairs(espConns) do c:Disconnect() end
SG:Destroy()
end)

-- ══════════════════════════════════════════════════
-- BOOT
-- ══════════════════════════════════════════════════
setTab("Players")
toast("🔇 Void v1.0 loaded", C.accent)
print("[QoD Void v1.0] loaded — " .. LP.Name)
