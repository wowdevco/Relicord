-- Simple Roblox Leaderstats Editor GUI (One Script)
-- For executors like Delta, Solara, etc.

local player = game.Players.LocalPlayer
local leaderstats = player:WaitForChild("leaderstats", 10)

if not leaderstats then
    warn("Leaderstats not found!")
    return
end

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LeaderstatsEditor"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 280)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Text = "Leaderstats Editor"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-- Currency Name Input
local currencyLabel = Instance.new("TextLabel")
currencyLabel.Size = UDim2.new(0.9, 0, 0, 20)
currencyLabel.Position = UDim2.new(0.05, 0, 0, 50)
currencyLabel.BackgroundTransparency = 1
currencyLabel.Text = "Currency Name (e.g. Coins)"
currencyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
currencyLabel.TextXAlignment = Enum.TextXAlignment.Left
currencyLabel.Font = Enum.Font.Gotham
currencyLabel.TextSize = 14
currencyLabel.Parent = mainFrame

local currencyBox = Instance.new("TextBox")
currencyBox.Size = UDim2.new(0.9, 0, 0, 35)
currencyBox.Position = UDim2.new(0.05, 0, 0, 70)
currencyBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
currencyBox.Text = "Coins"
currencyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
currencyBox.TextSize = 16
currencyBox.Font = Enum.Font.Gotham
currencyBox.PlaceholderText = "Enter currency name..."
currencyBox.Parent = mainFrame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 8)
boxCorner.Parent = currencyBox

-- Amount Input
local amountLabel = Instance.new("TextLabel")
amountLabel.Size = UDim2.new(0.9, 0, 0, 20)
amountLabel.Position = UDim2.new(0.05, 0, 0, 115)
amountLabel.BackgroundTransparency = 1
amountLabel.Text = "Amount"
amountLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
amountLabel.TextXAlignment = Enum.TextXAlignment.Left
amountLabel.Font = Enum.Font.Gotham
amountLabel.TextSize = 14
amountLabel.Parent = mainFrame

local amountBox = Instance.new("TextBox")
amountBox.Size = UDim2.new(0.9, 0, 0, 35)
amountBox.Position = UDim2.new(0.05, 0, 0, 135)
amountBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
amountBox.Text = "1000"
amountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
amountBox.TextSize = 16
amountBox.Font = Enum.Font.Gotham
amountBox.PlaceholderText = "Enter amount..."
amountBox.Parent = mainFrame

local amountCorner = Instance.new("UICorner")
amountCorner.CornerRadius = UDim.new(0, 8)
amountCorner.Parent = amountBox

-- Presets
local presetFrame = Instance.new("Frame")
presetFrame.Size = UDim2.new(0.9, 0, 0, 40)
presetFrame.Position = UDim2.new(0.05, 0, 0, 180)
presetFrame.BackgroundTransparency = 1
presetFrame.Parent = mainFrame

local coinsBtn = Instance.new("TextButton")
coinsBtn.Size = UDim2.new(0.48, 0, 1, 0)
coinsBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
coinsBtn.Text = "Coins"
coinsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
coinsBtn.Font = Enum.Font.GothamBold
coinsBtn.TextSize = 14
coinsBtn.Parent = presetFrame

local winsBtn = Instance.new("TextButton")
winsBtn.Size = UDim2.new(0.48, 0, 1, 0)
winsBtn.Position = UDim2.new(0.52, 0, 0, 0)
winsBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
winsBtn.Text = "Wins"
winsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
winsBtn.Font = Enum.Font.GothamBold
winsBtn.TextSize = 14
winsBtn.Parent = presetFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = coinsBtn
btnCorner:Clone().Parent = winsBtn

-- Done Button
local doneBtn = Instance.new("TextButton")
doneBtn.Size = UDim2.new(0.9, 0, 0, 45)
doneBtn.Position = UDim2.new(0.05, 0, 0, 225)
doneBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
doneBtn.Text = "UPDATE LEADERSTAT"
doneBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
doneBtn.Font = Enum.Font.GothamBold
doneBtn.TextSize = 16
doneBtn.Parent = mainFrame

local doneCorner = Instance.new("UICorner")
doneCorner.CornerRadius = UDim.new(0, 10)
doneCorner.Parent = doneBtn

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame

-- ==================== IMPROVED LOGIC ====================

local lockedStats = {}

local function lockStat(statName, value)
    if lockedStats[statName] then
        lockedStats[statName]:Disconnect()
    end
    
    local stat = leaderstats:FindFirstChild(statName)
    if not stat then 
        warn("Stat " .. statName .. " not found!")
        return 
    end
    
    stat.Value = value
    
    local connection
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        if stat and stat.Parent then
            stat.Value = value
        else
            connection:Disconnect()
            lockedStats[statName] = nil
        end
    end)
    
    lockedStats[statName] = connection
    print("Locked " .. statName .. " at " .. value)
end

local function updateLeaderstat()
    local currencyName = currencyBox.Text:gsub("%s+", "")
    local amountStr = amountBox.Text:gsub("%s+", "")
    local amount = tonumber(amountStr)
    
    if currencyName == "" or not amount then
        warn("Invalid input!")
        return
    end
    
    local stat = leaderstats:FindFirstChild(currencyName)
    if stat then
        lockStat(currencyName, amount)
    else
        warn("Leaderstat '" .. currencyName .. "' not found!")
    end
end

-- Connections
doneBtn.MouseButton1Click:Connect(updateLeaderstat)

closeBtn.MouseButton1Click:Connect(function()
    -- Cleanup loops
    for _, conn in pairs(lockedStats) do
        if conn then conn:Disconnect() end
    end
    screenGui:Destroy()
end)

coinsBtn.MouseButton1Click:Connect(function()
    currencyBox.Text = "Coins"
end)

winsBtn.MouseButton1Click:Connect(function()
    currencyBox.Text = "Wins"
end)

-- Make draggable (unchanged)
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateInput(input)
    end
end)

print("Leaderstats Editor GUI loaded with persistence!")
