local remote = workspace:WaitForChild("RemoteEvent")
local SerializationService = require(game:GetService("ReplicatedStorage").Shared.Services.SerializationService)

remote.OnClientEvent:Connect(function(data)
    print(data.Normal)

    print(data.Serialized.Vector, buffer.len(data.Serialized.Vector))
    local deserialized = {
        Color = SerializationService.deserializeColor3(data.Serialized.Color),
        Vector = SerializationService.deserializeVector3int16(data.Serialized.Vector),
        --Number = SerializationService.deserializeByte(data.Serialized.Number)
    }

    print(deserialized)
end)