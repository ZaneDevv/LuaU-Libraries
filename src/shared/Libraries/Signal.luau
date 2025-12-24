--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/24

-------------------------------------
-- Variables
-------------------------------------

local Signal = {}
local Connection = {}

-------------------------------------
-- Types
-------------------------------------

-- Methods type
type method = (...any) -> ()

-- Signal instance's attributes
type signalSelf = {_connectedMethods : {[Connection] : method}, _onceConnectedMethods : {method}}

-- Connection instance's attributes
type connectionSelf = {_signal : Signal}

-- Connection instance type
export type Connection = typeof(setmetatable({} :: connectionSelf, Connection))

-- Signal instance type
export type Signal = typeof(setmetatable({} :: signalSelf, Signal))

-------------------------------------
-- Metamethods
-------------------------------------

Signal.__index = Signal

Connection.__index = Connection
Connection.__type = "Connection"

-------------------------------------
-- Constructors
-------------------------------------

function Signal.new() : Signal
    local self = setmetatable({}, Signal) :: Signal

    self._connectedMethods = {}
    self._onceConnectedMethods = {}

    return self
end

-------------------------------------
-- Methods
-------------------------------------

--[[
    Fires all the methods connected to this signal
]]
function Signal:fire(... : any)
    local onceConnectedMethods = self._onceConnectedMethods
    table.clear(self._onceConnectedMethods)

    for _, method in self._connectedMethods do
        task.defer(method, ...)
    end

    for _, method in ipairs(onceConnectedMethods) do
        task.defer(method, ...)
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
    local connection = setmetatable(
        {
            _signal = self
        } :: connectionSelf,
        Connection
    )

    self._connectedMethods[connection :: Connection] = method

    return connection
end


--[[
    Disconnects the current connection from the signal
]]
function Connection:disconnect()
    self._signal._connectedMethods[self] = nil
end


return Signal