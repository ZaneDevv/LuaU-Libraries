local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local frame = playerGui:WaitForChild("ScreenGui").Frame
local button = playerGui:WaitForChild("ScreenGui").TextButton

local HoverService = require(game:GetService("ReplicatedStorage").Shared.Services.HoverService)


HoverService.connect(frame, function()
    frame.Transparency = 0.5
end, function()
    frame.Transparency = 0
end)

HoverService.connect(button, function()
    button.Transparency = 0.5
end, function()
    button.Transparency = 0
end)


task.wait(10)

print("Disconnect")

HoverService.disconnect(button)