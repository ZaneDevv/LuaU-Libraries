local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GizmosService = require(ReplicatedStorage:WaitForChild("Shared").Services.GizmosService)


GizmosService.createSphere(vector.create(0, 5, 0), 5, 0.5)