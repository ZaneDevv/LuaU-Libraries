--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/22

-------------------------------------
-- Services
-------------------------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-------------------------------------
-- Modules
-------------------------------------

local Signal = require(ReplicatedStorage.Shared.Libraries.Signal)

-------------------------------------
-- Variables
-------------------------------------

local ObjectPooling = {}

-------------------------------------
-- Types
-------------------------------------

-- Object pooling instance's attributes
type self = {_reservedParent : Folder, _objectToPool : Instance, OnPoolObject : Signal.Signal, OnWithdrawObject : Signal.Signal}

-- Object pooling instance type
export type ObjectPooling = typeof(setmetatable({} :: self, ObjectPooling))

-------------------------------------
-- Metamethods
-------------------------------------

ObjectPooling.__index = ObjectPooling

-------------------------------------
-- Constructor
-------------------------------------

--[[
    Creates a new object pooling instance with the given parameters
    @param objectToPool Object(s) to instance
    @param defaultAmount The amount of stored instances ready to be instanciated
    @return A new object pooling instance
]]
function ObjectPooling.new(objectToPool : Instance, defaultAmount : number?) : ObjectPooling
    local folderParent = Instance.new("Folder")
    folderParent.Parent = script

    for _ = 1, defaultAmount or 1 do
        local newInstance = objectToPool:Clone()
        newInstance.Parent = folderParent
    end

    return setmetatable(
        {
            _objectToPool = objectToPool,
            _reservedParent = folderParent,

            OnPoolObject = Signal.new(),
            OnWithdrawObject = Signal.new()
        },
        ObjectPooling
    ) :: ObjectPooling
end

-------------------------------------
-- Methods
-------------------------------------

--[[
    Spawns a new instance. If there is no instances reserved for it, 
    @param unspawnDelay Time since the instance spawned to unspawn it
    @param parent Where to place the new instance. By default, it will be placed in workspace
    @return The spawned instance
]]
function ObjectPooling:spawn(unspawnDelay: number?, parent: Instance?) : Instance
    local availableInstances = self._reservedParent:GetChildren()
    local newInstance = nil

    if #availableInstances == 0 then
        newInstance = self._objectToPool:Clone()
    else
        newInstance = availableInstances[1]
    end

    self.OnPoolObject:fire(newInstance)
    newInstance.Parent = parent or workspace
    
    if unspawnDelay then
        task.delay(unspawnDelay, function()
            newInstance.Parent = self.reservedParent
            self.OnWithdrawObject:fire()
        end)
    end

    return newInstance
end



return ObjectPooling