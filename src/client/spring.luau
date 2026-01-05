--!strict
--@author Álvaro Fernández Barrero
--@date 2026/01/04

-------------------------------------
-- Services
-------------------------------------

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-------------------------------------
-- Variables
-------------------------------------

local Printer = {}

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local mouse = localPlayer:GetMouse()

local Spring = require(ReplicatedStorage:WaitForChild("Shared").Utils.Libraries.Spring)

-------------------------------------
-- Methods
-------------------------------------

function Printer.init()
    local screenUi = Instance.new("ScreenGui")
    screenUi.Name = "TestingSpring"
    screenUi.ResetOnSpawn = false
    screenUi.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Name = "Mover"
    frame.Size = UDim2.fromOffset(40, 40)
    frame.AnchorPoint = Vector2.one * 0.5
    frame.BackgroundColor3 = Color3.new(1, 1, 1)
    frame.Parent = screenUi

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(1, 0)
    uiCorner.Parent = frame


    local spring = Spring.new(0.5, 1, 60)

    RunService:BindToRenderStep("Spring", Enum.RenderPriority.Last.Value, function(deltaTime: number)
        spring:setTargetPosition(UserInputService:GetMouseLocation())
        spring:update(deltaTime)

        frame.Position = UDim2.fromOffset((spring.point :: Vector2).X, (spring.point :: Vector2).Y)
    end)
end


return Printer