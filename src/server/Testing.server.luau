local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GizmosService = require(ReplicatedStorage:WaitForChild("Shared").Services.GizmosService)


GizmosService.createSphere(Vector3.new(0, 3, 0), 0.6, 0.4)
GizmosService.createSphere(Vector3.new(2, 5, 0), 0.6, 0.4)
GizmosService.createRay(Vector3.new(0, 3, 0), Vector3.new(2, 5, 0), 0.4)