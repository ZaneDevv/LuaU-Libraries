task.wait(5)


local ObjectPooling = require(game:GetService("ReplicatedStorage").Shared.Utils.Libraries.ObjectPooling)
local Quaternion = require(game:GetService("ReplicatedStorage").Shared.Utils.Libraries.Quaternion)
local objectPool = ObjectPooling.new(game:GetService("ReplicatedStorage").Duck, 5)

objectPool.OnPoolObject:connect(function(instance : BasePart)
    instance.Size /= 4
    instance.CFrame *= CFrame.new(math.random(-10, 10), 0, 0) * Quaternion.fromAxisAngle(Vector3.xAxis, math.pi / 2):toCFrame()
end)

objectPool.OnWithdrawObject:connect(function()
    print("Withdrawn!")
end)

while true do
    objectPool:spawn(5)
    task.wait(1)
end