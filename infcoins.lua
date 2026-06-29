--Uploaded On https://youtube.com/AhmedMode
--Published on https://ahmedmode.com
--Credits goes to the devs!
--Scripts Below:

--Script

_G.t = function(state)
if state then
if _G.abilCon then return end
_G.abilCon = game:GetService("RunService").RenderStepped:Connect(function()
game.ReplicatedStorage.AbilityEvent:FireServer(1)
end)
else
if _G.abilCon then
_G.abilCon:Disconnect()
_G.abilCon = nil
end
end
end
_G.t(true) --true(open),false(close)