local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Core God Mode (Infinite Health + Anti-Death)
humanoid.MaxHealth = math.huge
humanoid.Health = math.huge

-- Strong health loop (catches server damage attempts)
RunService.Heartbeat:Connect(function()
    if humanoid and humanoid.Parent then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        humanoid.PlatformStand = false  -- Prevent ragdoll issues
    end
end)

-- Anti-Fall Damage / Velocity Reset on Land
humanoid.StateChanged:Connect(function(_, newState)
    if newState == Enum.HumanoidStateType.Landed then
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            local vel = root.AssemblyLinearVelocity
            root.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z)  -- Zero out vertical velocity
        end
    end
end)

-- Extra anti-damage / anti-ragdoll
humanoid.Died:Connect(function()
    -- Respawn protection if somehow triggered
    task.wait(0.1)
    if player.Character then
        player.Character:BreakJoints() -- or handle respawn
    end
end)

-- Prevent death from other sources
character.ChildAdded:Connect(function(child)
    if child.Name == "Humanoid" and child ~= humanoid then
        task.defer(function()
            if child.Parent then child:Destroy() end
        end)
    end
end)

print("✅ God Mode + No Fall Damage Loaded for Natural Disaster Survival")