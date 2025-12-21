local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Quaternion = require(Shared.Libraries.Quaternion)

local duck = workspace:WaitForChild("Duck")

local q0 = Quaternion.fromAxisAngle(Vector3.yAxis, 0)
local q1 = Quaternion.fromAxisAngle(Vector3.yAxis, math.pi)

task.wait(3)
for t = 0, 1, 0.03 do
    task.wait(0.1)
    duck.CFrame = CFrame.new(duck.Position) * Quaternion.clampedSlerp(q0, q1, t):toCFrame()
end
duck.CFrame = CFrame.new(duck.Position) * Quaternion.clampedSlerp(q0, q1, 1):toCFrame()