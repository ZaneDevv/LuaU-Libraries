local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ObjectPooling = require(ReplicatedStorage:WaitForChild("Shared").Libraries.ObjectPooling)


local duck = ReplicatedStorage:WaitForChild("Duck")
duck.CanCollide = false
duck.Anchored = true
duck.Size /= 10

local objects = ObjectPooling.new(duck, 20)


task.wait(10)
print("AAAAAAA")

while true do
    local newDuck = objects:spawn(2)
    newDuck.Position = vector.create(math.random(-10, 10), 5, 0)

    task.wait(0.3)
end