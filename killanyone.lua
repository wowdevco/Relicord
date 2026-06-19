-- Quiet or Die Kill GUI (One Script)
-- For executors like Delta, Solara, etc.

local player = game.Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KillGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 420, 0, 380)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Text = "Quiet or Die - Kill Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-- Player List (Left Side)
local listFrame = Instance.new("Frame")
listFrame.Size = UDim2.new(0.45, 0, 0.65, 0)
listFrame.Position = UDim2.new(0.05, 0, 0.12, 0)
listFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
listFrame.Parent = mainFrame

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 8)
listCorner.Parent = listFrame

local listLabel = Instance.new("TextLabel")
listLabel.Size = UDim2.new(1, 0, 0, 25)
listLabel.BackgroundTransparency = 1
listLabel.Text = "Players"
listLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
listLabel.TextSize = 14
listLabel.Font = Enum.Font.Gotham
listLabel.Parent = listFrame

local scrollingList = Instance.new("ScrollingFrame")
scrollingList.Size = UDim2.new(1, -10, 1, -35)
scrollingList.Position = UDim2.new(0, 5, 0, 30)
scrollingList.BackgroundTransparency = 1
scrollingList.ScrollBarThickness = 6
scrollingList.Parent = listFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.Name
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = scrollingList

-- Search / Target Input
local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(0.45, 0, 0, 20)
targetLabel.Position = UDim2.new(0.53, 0, 0.12, 0)
targetLabel.BackgroundTransparency = 1
targetLabel.Text = "Target Name"
targetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Font = Enum.Font.Gotham
targetLabel.TextSize = 14
targetLabel.Parent = mainFrame

local targetBox = Instance.new("TextBox")
targetBox.Size = UDim2.new(0.45, 0, 0, 35)
targetBox.Position = UDim2.new(0.53, 0, 0.18, 0)
targetBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
targetBox.Text = ""
targetBox.TextColor3 = Color3.fromRGB(255, 255, 255)
targetBox.TextSize = 16
targetBox.Font = Enum.Font.Gotham
targetBox.PlaceholderText = "Username or DisplayName..."
targetBox.Parent = mainFrame

local targetCorner = Instance.new("UICorner")
targetCorner.CornerRadius = UDim.new(0, 8)
targetCorner.Parent = targetBox

-- Kill Button
local killBtn = Instance.new("TextButton")
killBtn.Size = UDim2.new(0.45, 0, 0, 50)
killBtn.Position = UDim2.new(0.53, 0, 0.32, 0)
killBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
killBtn.Text = "KILL TARGET"
killBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
killBtn.Font = Enum.Font.GothamBold
killBtn.TextSize = 18
killBtn.Parent = mainFrame

local killCorner = Instance.new("UICorner")
killCorner.CornerRadius = UDim.new(0, 10)
killCorner.Parent = killBtn

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

-- Functions
local playerButtons = {}

local function updatePlayerList()
    for _, btn in pairs(playerButtons) do
        btn:Destroy()
    end
    playerButtons = {}

    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            btn.Text = plr.DisplayName .. " (" .. plr.Name .. ")"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 13
            btn.Font = Enum.Font.Gotham
            btn.Parent = scrollingList

            local bCorner = Instance.new("UICorner")
            bCorner.CornerRadius = UDim.new(0, 6)
            bCorner.Parent = btn

            btn.MouseButton1Click:Connect(function()
                targetBox.Text = plr.Name
            end)

            table.insert(playerButtons, btn)
        end
    end
end

local function killPlayer(target)
    if not target then return end
    
    local targetPlayer = game.Players:FindFirstChild(target) or 
                         game.Players:GetPlayers():Find(function(p) return p.DisplayName == target or p.Name == target end)
    
    if not targetPlayer then
        warn("Player not found: " .. target)
        return
    end

    local character = targetPlayer.Character
    if not character then
        warn("No character found for " .. target)
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = 0
        print("Killed " .. targetPlayer.Name)
    else
        -- Fallback: destroy parts
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part:Destroy()
            end
        end
        print("Destroyed character of " .. targetPlayer.Name)
    end
end

-- Connections
killBtn.MouseButton1Click:Connect(function()
    local targetName = targetBox.Text:gsub("%s+", "")
    if targetName == "" then
        warn("Enter a target name!")
        return
    end
    killPlayer(targetName)
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Update list periodically
updatePlayerList()
game.Players.PlayerAdded:Connect(updatePlayerList)
game.Players.PlayerRemoving:Connect(updatePlayerList)

-- Make draggable
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

print("Quiet or Die Kill GUI loaded! Click players on the left or type a name.")