--!strict
--@author Álvaro Fernández Barrero
--@date 2026/01/04

-------------------------------------
-- Services
-------------------------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-------------------------------------
-- Variables
-------------------------------------

local Printer = {}


local duck = workspace.Duck


local libraries = ReplicatedStorage:WaitForChild("Shared").Utils.Libraries

local Spring = require(libraries.Spring)
local Quaternion = require(libraries.Quaternion)

-------------------------------------
-- Methods
-------------------------------------

function Printer.init()
    local spring = Spring.new(0.5, 1, 20)

    local theta = 0


    task.defer(function()
        while task.wait(3) do
            print("Turn")
            theta += math.pi / 2
        end
    end)

    RunService:BindToRenderStep("Spring", Enum.RenderPriority.Last.Value, function(deltaTime: number)
        spring:setTargetPosition(theta)
        spring:update(deltaTime)

        duck.CFrame = CFrame.new(duck.Position) * Quaternion.fromAxisAngle(Vector3.xAxis, spring.point :: number):toCFrame()
    end)
end




return Printer