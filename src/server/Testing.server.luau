local SerializationService = require(game:GetService("ReplicatedStorage").Shared.Services.SerializationService)

local remote = workspace:WaitForChild("RemoteEvent")


local color = Color3.new(1, 0, 1)
local vector = Vector3int16.new(1, 1, 1)
local number = 5


while task.wait(1) do
    print("Send")
    remote:FireAllClients{
        Normal = {
            Color = color,
            Vector = vector,
            Number = number,
        },
        Serialized = {
            Color = SerializationService.serializeColor3(color),
            Vector = SerializationService.serializeVector3int16(vector),
            Number = SerializationService.serializeUbyte(number)
        }
    }
end