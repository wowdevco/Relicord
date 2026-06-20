-- Advanced Local God Mode with Fall Damage Immunity
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local oldHumanoid = character:WaitForChild("Humanoid")

-- 1. Create the detached clone to trick server replication
local newHumanoid = oldHumanoid:Clone()
newHumanoid.Parent = character
player.Character = nil

-- Remove the original tracked humanoid object
oldHumanoid:Destroy()
player.Character = character

-- Reset camera focus to the new model structure
local cam = workspace.CurrentCamera
cam.CameraSubject = character:WaitForChild("Humanoid")

-- 2. Target the new Humanoid for configuration
local humanoid = character:FindFirstChildOfClass("Humanoid")

if humanoid then
    -- Set local properties to absolute maximums
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    
    -- Continuous Infinite Health loop (Anti-Death/No Kill)
    -- Forces health to remain infinite every single frame
    game:GetService("RunService").RenderStepped:Connect(function()
        if humanoid and humanoid.Parent then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
    end)

    -- 3. Fall Damage / Drop Damage / Jump Damage Disabler
    -- Listens for physics state changes to intercept hard landings
    humanoid.StateChanged:Connect(function(oldState, newState)
        if newState == Enum.HumanoidStateType.Landed then
            -- Force the vertical velocity of the root part to 0 on impact
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.AssemblyLinearVelocity = Vector3.new(rootPart.AssemblyLinearVelocity.X, 0, rootPart.AssemblyLinearVelocity.Z)
            end
        end
    end)
end