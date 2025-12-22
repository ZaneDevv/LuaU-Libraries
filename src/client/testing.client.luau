local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local interface = PlayerGui:WaitForChild("ScreenGui")

local HoverService = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared").Services.HoverService)


HoverService.setDefaultHoverMethod(function(ui)
    ui.Transparency = 0.5
end)

HoverService.setDefaultUnhoverMethod(function(ui)
    ui.Transparency = 0
end)


HoverService.connect(interface.B)
HoverService.connect(interface.Frame0)
HoverService.connect(interface.A)
HoverService.connect(interface.TextButton)

task.wait(3)
print("Disconnect")

HoverService.disconnect(interface.Frame0)
HoverService.disconnect(interface.TextButton)

task.wait(3)
print("Connect")

HoverService.connect(interface.Frame0)
HoverService.connect(interface.TextButton)