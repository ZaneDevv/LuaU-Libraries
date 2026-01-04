local remote = workspace:WaitForChild("RemoteEvent")
local SerializationService = require(game:GetService("ReplicatedStorage").Shared.Utils.Services.SerializationService)

remote.OnClientEvent:Connect(function(data)
    --print(data)
end)