local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Quaternion = require(Shared.Libraries.Quaternion)

local duck = workspace:WaitForChild("Duck")

local q0 = Quaternion.fromAxisAngle(Vector3.yAxis, 0)
local q1 = q0 * Quaternion.fromAxisAngle(Vector3.xAxis, math.pi)

task.wait(5)

local t = 0
while t <= 1 do
    t += RunService.Heartbeat:Wait()
    duck.CFrame = CFrame.new(duck.Position) * Quaternion.clampedSlerp(q0, q1, t):toCFrame()
end
duck.CFrame = CFrame.new(duck.Position) * Quaternion.clampedSlerp(q0, q1, 1):toCFrame()