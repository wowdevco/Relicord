local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local InsertService = game:GetService("InsertService")  -- Better than GetObjects for tools

local player = Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

local function giveTool(toolId)
    if not toolId or toolId == "" then
        warn("❌ Please enter a valid Tool ID")
        return false
    end
   
    local success, result = pcall(function()
        local assetId = tonumber(toolId)
        if not assetId then
            warn("❌ Invalid numeric Tool ID")
            return false
        end
        
        -- Use InsertService for more reliable asset loading
        local objects = InsertService:LoadAsset(assetId)
        local item = objects:FindFirstChildWhichIsA("Tool") or objects:FindFirstChildOfClass("Model") or objects[1]
       
        if not item then
            warn("❌ Failed to load asset or no Tool/Model found")
            objects:Destroy()
            return false
        end
       
        -- Extract the Tool (handles wrapped models too)
        local tool = item:IsA("Tool") and item or item:FindFirstChildWhichIsA("Tool", true)
        if not tool then
            warn("❌ No Tool found in asset " .. toolId)
            objects:Destroy()
            return false
        end
       
        tool = tool:Clone()
        objects:Destroy()  -- Clean up original
        
        -- === CRITICAL FIXES FOR GUNS/TOOLS ===
        -- Handle setup (most guns fail here)
        local handle = tool:FindFirstChild("Handle") 
                     or tool:FindFirstChildWhichIsA("BasePart", true)
        if handle then
            if handle.Name ~= "Handle" then
                handle.Name = "Handle"  -- Many tools expect exact name
            end
            tool.RequiresHandle = true
            -- Ensure it's not CanCollide/Anchored in bad ways
            handle.CanCollide = false
            handle.Anchored = false
        else
            tool.RequiresHandle = false  -- For tool-less tools
        end
        
        -- Fix common script issues (LocalScripts inside tools often break on client clone)
        for _, script in ipairs(tool:GetDescendants()) do
            if script:IsA("LocalScript") then
                script.Disabled = false  -- Ensure enabled
            elseif script:IsA("Script") then
                -- Server Scripts won't run client-side; warn or handle
                warn("⚠️ Server Script found in tool: " .. script.Name .. " - may not function fully")
            end
        end
        
        -- Parent to Backpack
        tool.Parent = player:WaitForChild("Backpack")
       
        print("🔧 Tool cloned to Backpack: " .. tool.Name)
       
        -- Wait for character
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid", 5)
       
        if humanoid then
            -- Small delay for replication
            task.wait(0.2)
            
            -- Equip
            humanoid:EquipTool(tool)
            print("✅ Equipped: " .. tool.Name)
            
            -- Activation for guns (simulate click)
            task.wait(0.3)
            pcall(function()
                tool:Activate()
            end)
            
            -- Extra attempts for stubborn tools
            task.delay(0.5, function()
                if tool.Parent and tool.Parent == character then
                    pcall(function() tool:Activate() end)
                end
            end)
            
            -- Optional: Force grip/animation refresh
            if handle then
                task.delay(0.1, function()
                    pcall(function()
                        local grip = tool:FindFirstChild("Grip") or Instance.new("Motor6D")
                        -- You can tweak grip C0/C1 here if needed for custom hold
                    end)
                end)
            end
        end
       
        print("✅ Tool given & equipped: " .. tool.Name .. " (ID: " .. toolId .. ")")
        return true
    end)
   
    if not success then
        warn("❌ Tool failed to load: " .. tostring(result))
        return false
    end
end