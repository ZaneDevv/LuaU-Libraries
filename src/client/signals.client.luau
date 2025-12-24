task.wait(5)


local Signal = require(game:GetService("ReplicatedStorage").Shared.Libraries.Signal)


local signal = Signal.new()

local connection = signal:connect(function()
    print("Connection1")
end)

signal:connect(function()
    print("Connection2")
end)

signal:once(function()
    print("Connection3")
end)


signal:fire()
signal:fire()

connection:disconnect()

signal:fire()