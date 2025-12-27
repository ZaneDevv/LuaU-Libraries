--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/24

-------------------------------------
-- Variables
-------------------------------------

local Maid = {}

-------------------------------------
-- Types
-------------------------------------

-- Maid instance's attributes
type self = {_itemsToDestroy : {any}}

-- Maid instance type
export type Maid = typeof(setmetatable({} :: self, Maid))

-------------------------------------
-- Metamethods
-------------------------------------

Maid.__index = Maid

-------------------------------------
-- Constructors
-------------------------------------

--[[
    Creates a new maid instance to clean everything associated to it
]]
function Maid.new()
    return setmetatable(
        {
            _itemsToDestroy = {}
        },
        Maid
    )
end

-------------------------------------
-- Methods
-------------------------------------

--[[
    Adds a new item to the current maid
    @param item Item to add to the current maid
    @return The item set to the current maid
]]
function Maid:add<T>(item : T) : T
    table.insert(self._itemsToDestroy(), item)
    return item
end


--[[
    Cleans everything up in the current maid
]]
function Maid:clean()
    for _, item in ipairs(self._itemsToDestroy) do
        if item.destroy then
            item:destroy()
            continue
        end

        if item.disconnect then
            item:disconnect()
            continue
        end

        if item.Destroy then
            item:Destroy()
            continue
        end

        if item.Disconnect then
            item:Disconnect()
            continue
        end

        if typeof(item) == "thread" then
            task.cancel(item)
        end
    end

    table.clear(self._itemsToDestroy)
end


return Maid