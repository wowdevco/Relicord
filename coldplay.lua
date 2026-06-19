-- Murder Mystery 2 Global Server Message GUI (One Script)
-- For executors like Delta, Solara, etc. - Improved Global Reach

local player = game.Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2GlobalMsgGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 420, 0, 320)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Text = "Murder Mystery 2 - Global Server Message"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-- Message Input
local messageLabel = Instance.new("TextLabel")
messageLabel.Size = UDim2.new(0.9, 0, 0, 25)
messageLabel.Position = UDim2.new(0.05, 0, 0.15, 0)
messageLabel.BackgroundTransparency = 1
messageLabel.Text = "Global Message (Everyone will see it)"
messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
messageLabel.TextXAlignment = Enum.TextXAlignment.Left
messageLabel.Font = Enum.Font.Gotham
messageLabel.TextSize = 14
messageLabel.Parent = mainFrame

local messageBox = Instance.new("TextBox")
messageBox.Size = UDim2.new(0.9, 0, 0, 120)
messageBox.Position = UDim2.new(0.05, 0, 0.23, 0)
messageBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
messageBox.Text = "Server Announcement: Be respectful or you will be banned."
messageBox.TextColor3 = Color3.fromRGB(255, 255, 255)
messageBox.TextSize = 15
messageBox.Font = Enum.Font.Gotham
messageBox.TextWrapped = true
messageBox.PlaceholderText = "Type message here..."
messageBox.Parent = mainFrame

local msgCorner = Instance.new("UICorner")
msgCorner.CornerRadius = UDim.new(0, 8)
msgCorner.Parent = messageBox

-- Send Button
local sendBtn = Instance.new("TextButton")
sendBtn.Size = UDim2.new(0.9, 0, 0, 55)
sendBtn.Position = UDim2.new(0.05, 0, 0.68, 0)
sendBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sendBtn.Text = "SEND GLOBAL MESSAGE"
sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sendBtn.Font = Enum.Font.GothamBold
sendBtn.TextSize = 18
sendBtn.Parent = mainFrame

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0, 10)
sendCorner.Parent = sendBtn

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

-- Improved Global Message Function
local function sendGlobalMessage()
    local msg = messageBox.Text
    if msg == "" or msg == messageBox.PlaceholderText then
        warn("Please enter a message!")
        return
    end

    -- 1. Local methods (visible to you)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "🌐 SERVER ANNOUNCEMENT";
            Text = msg;
            Duration = 15;
        })
    end)

    pcall(function()
        game.StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[SERVER]: " .. msg;
            Color = Color3.fromRGB(255, 100, 100);
            Font = Enum.Font.GothamBold;
        })
    end)

    -- 2. Aggressive remote firing for MM2 (common in leaked versions)
    pcall(function()
        local replicated = game:GetService("ReplicatedStorage")
        local candidates = {}

        for _, v in ipairs(replicated:GetDescendants()) do
            if v:IsA("RemoteEvent") then
                local name = v.Name:lower()
                if name:find("chat") or name:find("message") or name:find("say") or name:find("announce") or name:find("system") then
                    table.insert(candidates, v)
                end
            end
        end

        for _, remote in ipairs(candidates) do
            pcall(function()
                remote:FireServer(msg)
                remote:FireServer("[SERVER] " .. msg)
                remote:FireServer(player, msg)
                remote:FireServer("Server", msg)
            end)
        end

        print("Fired " .. #candidates .. " potential chat remotes")
    end)

    print("✅ Global message broadcast attempt sent: " .. msg)
end

-- Connections
sendBtn.MouseButton1Click:Connect(sendGlobalMessage)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

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

print("Murder Mystery 2 Global Message GUI loaded! Type your message and click SEND.")