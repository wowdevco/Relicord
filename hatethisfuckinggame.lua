-- Improved GOD MODE GUI v2.1 for NDS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

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

-- === Better Infinite Health + Damage Hook ===
local function applyInfHealth(on)
    drop("infH")
    if not on then return end
    
    local hum = H()
    if hum then 
        hum.MaxHealth = math.huge 
        hum.Health = math.huge 
    end
    
    conns.infH = RunService.Heartbeat:Connect(function()
        local h = H()
        if h then 
            h.MaxHealth = math.huge 
            h.Health = math.huge 
            -- Hook TakeDamage
            if not h._originalTakeDamage then
                h._originalTakeDamage = h.TakeDamage
                h.TakeDamage = function(self, amount)
                    -- Optionally log or block
                    -- self._originalTakeDamage(self, 0) -- block
                end
            end
        end
    end)
end

-- === Anti-Death ===
local function applyAntiDeath(on)
    drop("adLoop"); drop("adDied")
    if not on then return end
    conns.adLoop = RunService.Heartbeat:Connect(function()
        local h = H()
        if h and h.Health < 1 then
            h.MaxHealth = math.huge; h.Health = math.huge
        end
    end)
    
    player.CharacterAdded:Connect(function()
        task.wait(0.1)
        local h = H()
        if h then
            h.MaxHealth = math.huge; h.Health = math.huge
        end
    end)
end

-- === Anti-Ragdoll ===
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

-- === Improved No Fall Damage (velocity clamp + pre-land) ===
local function applyNoFall(on)
    drop("nf")
    if not on then return end
    
    conns.nf = RunService.Heartbeat:Connect(function()
        local root = R()
        local hum = H()
        if root and hum then
            local vel = root.AssemblyLinearVelocity
            if vel.Y < -40 then  -- Clamp excessive downward speed
                root.AssemblyLinearVelocity = Vector3.new(vel.X, math.max(vel.Y, -20), vel.Z)
            end
            if hum:GetState() == Enum.HumanoidStateType.Freefall and vel.Y < -50 then
                hum:ChangeState(Enum.HumanoidStateType.Jumping) -- Disrupt fall state early
            end
        end
    end)
    
    -- State-based backup
    local hum = H()
    if hum then
        conns.nfState = hum.StateChanged:Connect(function(old, new)
            if new == Enum.HumanoidStateType.Landed then
                local root = R()
                if root then
                    local vel = root.AssemblyLinearVelocity
                    root.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z)
                end
                local h2 = H()
                if h2 then h2.Health = h2.MaxHealth end
            end
        end)
    end
end

-- God Mode master
local function applyGodMode(on)
    applyInfHealth(on)
    applyAntiDeath(on)
    applyAntiRagdoll(on)
    applyNoFall(on)
    for _, n in ipairs({"Infinite Health", "Anti-Death", "Anti-Ragdoll", "No Fall Damage"}) do
        if btnSetters[n] then btnSetters[n](on, true) end
    end
end

-- (Rest of your GUI code remains the same: newButton calls, draggable, etc.)
-- Just replace the feature functions with the above.

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if btnStates["Infinite Health"] then applyInfHealth(true) end
    if btnStates["Anti-Death"] then applyAntiDeath(true) end
    if btnStates["Anti-Ragdoll"] then applyAntiRagdoll(true) end
    if btnStates["No Fall Damage"] then applyNoFall(true) end
end)

print("✅ Improved GodMode GUI v2.1 loaded — better NDS compatibility")