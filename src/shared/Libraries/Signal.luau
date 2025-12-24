--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/24

-------------------------------------
-- Variables
-------------------------------------

local Signal = {}
local Connection = {}

-------------------------------------
-- Variables
-------------------------------------

-- Methods type
type method = () -> ()

-- Signal instance's attributes
type signalSelf = {_connectedMethods : {method}}

-- Signal instance type
export type Signal = typeof(setmetatable({} :: signalSelf, Signal))

-- Connection instance's attributes
type connectionSelf = {_index : any, _signal : Signal}

-- Connection instance type
export type Connection = typeof(setmetatable({} :: connectionSelf, Connection))

-------------------------------------
-- Metamethods
-------------------------------------

Signal.__index = Signal
Connection.__index = Connection

-------------------------------------
-- Constructors
-------------------------------------

function Signal.new() : Signal
    return setmetatable(
        {
            _connectedMethods = {},
            _onceConnectedMethods = {}
        }, 
        Signal
    ) :: Signal
end

-------------------------------------
-- Methods
-------------------------------------

--[[
    Fires all the methods connected to this signal
]]
function Signal:fire()
    for _, method in self._connectedMethods do
        task.defer(method)
    end

    for index, method in ipairs(self._onceConnectedMethods) do
        task.defer(method)
        table.remove(self._onceConnectedMethods, index)
    end
end


--[[
    Connects a method to the current signal to be fired. Once it is fired for the first time, it will never be fired again
    @param method Method to fire according to the signal
]]
function Signal:once(method : method)
    table.insert(self._onceConnectedMethods, method)
end


--[[
    Connects a method to the current signal to be fired
    @param method Method to fire according to the signal
    @return A new connection instance
]]
function Signal:connect(method : method) : Connection
    local connectionIndex = newproxy()
    self._connectedMethods[connectionIndex] = method

    return setmetatable({_index = connectionIndex, _signal = self}, Connection)
end


--[[
    Disconnects the current connection from the signal
]]
function Connection:disconnect()
    self._signal._connectedMethods[self._index] = nil
end


return Signal