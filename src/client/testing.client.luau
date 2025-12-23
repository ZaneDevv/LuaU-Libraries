local SerializationService = require(game:GetService("ReplicatedStorage").Shared.Services.SerializationService)

local colorBuffer = SerializationService.serializeColor3(Color3.fromRGB(100, 209, 106))
print(buffer.readu8(colorBuffer, 0), buffer.readu8(colorBuffer, 1), buffer.readu8(colorBuffer, 2))