-- Murder Mystery 2 Kick / Message GUI (One Script)
-- For executors like Delta, Solara, etc.

local player = game.Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2KickGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 420, 0, 460)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -230)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Text = "Murder Mystery 2 - Kick / Message"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-- Mode Toggle
local modeFrame = Instance.new("Frame")
modeFrame.Size = UDim2.new(0.9, 0, 0, 40)
modeFrame.Position = UDim2.new(0.05, 0, 0.08, 0)
modeFrame.BackgroundTransparency = 1
modeFrame.Parent = mainFrame

local kickModeBtn = Instance.new("TextButton")
kickModeBtn.Size = UDim2.new(0.48, 0, 1, 0)
kickModeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
kickModeBtn.Text = "KICK MODE"
kickModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
kickModeBtn.Font = Enum.Font.GothamBold
kickModeBtn.TextSize = 14
kickModeBtn.Parent = modeFrame

local msgModeBtn = Instance.new("TextButton")
msgModeBtn.Size = UDim2.new(0.48, 0, 1, 0)
msgModeBtn.Position = UDim2.new(0.52, 0, 0, 0)
msgModeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
msgModeBtn.Text = "MESSAGE MODE"
msgModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
msgModeBtn.Font = Enum.Font.GothamBold
msgModeBtn.TextSize = 14
msgModeBtn.Parent = modeFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = kickModeBtn
btnCorner:Clone().Parent = msgModeBtn

-- Player List (Left)
local listFrame = Instance.new("Frame")
listFrame.Size = UDim2.new(0.45, 0, 0.52, 0)
listFrame.Position = UDim2.new(0.05, 0, 0.18, 0)
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

-- Target Input
local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(0.45, 0, 0, 20)
targetLabel.Position = UDim2.new(0.53, 0, 0.18, 0)
targetLabel.BackgroundTransparency = 1
targetLabel.Text = "Target Name"
targetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Font = Enum.Font.Gotham
targetLabel.TextSize = 14
targetLabel.Parent = mainFrame

local targetBox = Instance.new("TextBox")
targetBox.Size = UDim2.new(0.45, 0, 0, 35)
targetBox.Position = UDim2.new(0.53, 0, 0.23, 0)
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

-- Message Input
local messageLabel = Instance.new("TextLabel")
messageLabel.Size = UDim2.new(0.45, 0, 0, 20)
messageLabel.Position = UDim2.new(0.53, 0, 0.38, 0)
messageLabel.BackgroundTransparency = 1
messageLabel.Text = "Custom Message"
messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
messageLabel.TextXAlignment = Enum.TextXAlignment.Left
messageLabel.Font = Enum.Font.Gotham
messageLabel.TextSize = 14
messageLabel.Parent = mainFrame

local messageBox = Instance.new("TextBox")
messageBox.Size = UDim2.new(0.45, 0, 0, 90)
messageBox.Position = UDim2.new(0.53, 0, 0.43, 0)
messageBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
messageBox.Text = "You have been kicked for violating rules."
messageBox.TextColor3 = Color3.fromRGB(255, 255, 255)
messageBox.TextSize = 14
messageBox.Font = Enum.Font.Gotham
messageBox.TextWrapped = true
messageBox.PlaceholderText = "Enter message here..."
messageBox.Parent = mainFrame

local msgCorner = Instance.new("UICorner")
msgCorner.CornerRadius = UDim.new(0, 8)
msgCorner.Parent = messageBox

-- Action Button
local actionBtn = Instance.new("TextButton")
actionBtn.Size = UDim2.new(0.45, 0, 0, 55)
actionBtn.Position = UDim2.new(0.53, 0, 0.72, 0)
actionBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
actionBtn.Text = "KICK PLAYER"
actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
actionBtn.Font = Enum.Font.GothamBold
actionBtn.TextSize = 18
actionBtn.Parent = mainFrame

local actionCorner = Instance.new("UICorner")
actionCorner.CornerRadius = UDim.new(0, 10)
actionCorner.Parent = actionBtn

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

-- Variables
local currentMode = "kick"

-- Functions
local playerButtons = {}

local function updatePlayerList()
    for _, btn in pairs(playerButtons) do btn:Destroy() end
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

local function executeAction()
    local targetName = targetBox.Text:gsub("%s+", "")
    local msg = messageBox.Text or "You have been kicked."

    if targetName == "" then
        warn("Enter a target name!")
        return
    end

    local targetPlayer = game.Players:FindFirstChild(targetName)
    if not targetPlayer then
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr.DisplayName == targetName or plr.Name == targetName then
                targetPlayer = plr
                break
            end
        end
    end

    if not targetPlayer then
        warn("Player not found: " .. targetName)
        return
    end

    if currentMode == "kick" then
        pcall(function()
            targetPlayer:Kick(msg)
            print("✅ Kicked " .. targetPlayer.Name .. " | Message: " .. msg)
        end)
    else
        -- Message Mode (visible system message + notification attempt)
        pcall(function()
            game.StarterGui:SetCore("SendNotification", {
                Title = "Server Message";
                Text = msg;
                Duration = 10;
            })
        end)
        pcall(function()
            game.StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "[Server]: " .. msg;
                Color = Color3.fromRGB(255, 80, 80);
                Font = Enum.Font.GothamBold;
            })
        end)
        print("📨 Sent message to " .. targetPlayer.Name)
    end
end

-- Mode Buttons
kickModeBtn.MouseButton1Click:Connect(function()
    currentMode = "kick"
    kickModeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    msgModeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    actionBtn.Text = "KICK PLAYER"
    actionBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
end)

msgModeBtn.MouseButton1Click:Connect(function()
    currentMode = "message"
    msgModeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    kickModeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    actionBtn.Text = "SEND MESSAGE"
    actionBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
end)

-- Connections
actionBtn.MouseButton1Click:Connect(executeAction)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Update player list
updatePlayerList()
game.Players.PlayerAdded:Connect(updatePlayerList)
game.Players.PlayerRemoving:Connect(updatePlayerList)

-- Draggable (unchanged)
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

print("Murder Mystery 2 Kick/Message GUI loaded! Switch modes and select a player.")