--[[local SerializationService = require(game:GetService("ReplicatedStorage").Shared.Services.SerializationService)

local remote = workspace:WaitForChild("RemoteEvent")

local color = Color3.new(1, 0, 1)
local vector = Vector3int16.new(1, 1, 1)
local number = 5
local cframe = CFrame.new(10, 10, 10) * CFrame.Angles(math.pi, math.pi, math.pi)


while task.wait(1) do
    print("Send")
    remote:FireAllClients{
        Normal = {
            Color = color,
            Vector = vector,
            Number = number,
            CFrame = cframe
        },
        Serialized = {
            Color = SerializationService.serializeColor3(color),
            Vector = vector,
            Number = SerializationService.serializeUbyte(number),
            CFrame = cframe
        }
    }
end]]