--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/20

-------------------------------------
-- Classes
-------------------------------------

local Set = {}

-------------------------------------
-- Types
-------------------------------------

-- Set class attributes
type self = {_table: {any}}

-- Set instance type
export type Set = typeof(setmetatable({} :: self, Set))

-------------------------------------
-- Metamethods
-------------------------------------

Set.__index = Set
Set.__tostring = function(set : Set) : string
    local result = "{\n"

    for index, data in ipairs(set._table) do
        result ..= `\t[{index}] = {data}\n`
    end

    result ..= "}"

    return result
end

-------------------------------------
-- Constructors
-------------------------------------

--[[
    Create a new empty set
]]
function Set.new(): Set
    local self = setmetatable({}, Set) :: Set

    self._table = {}

    return self
end

-------------------------------------
-- Static methods
-------------------------------------

--[[
    Mix the two given sets. It corresponds to the union operation ∪ in set theory
    @param set1 First set
    @param set2 Second set
    @return set1 ∪ set2
]]
function Set.union(set1 : Set, set2 : Set) : Set
    local result = Set.new()

    for _, item in ipairs(set1:toTable()) do
        result.insert(item)
    end

    for _, item in ipairs(set2:toTable()) do
        result.insert(item)
    end

    return result
end


--[[
    Create a set with the items that the two given sets share. It corresponds to the intersection operation ∩ in set theory
    @param set1 First set
    @param set2 Second set
    @return set1 ∩ set2
]]
function Set.intersection(set1 : Set, set2 : Set) : Set
    local result = Set.new()

    for _, item in ipairs(set1:toTable()) do
        if set2:contains(item) then
            result.insert(item)
        end
    end

    return result
end

-------------------------------------
-- Methods
-------------------------------------

--[[
    Adds a new item to the current set
    @param item Item to add
]]
function Set:insert(item : any)
    if table.insert(self._table, item) ~= nil then
        return
    end

    table.insert(self._table, item)
end


--[[
    Removes the given item from the current set
    @param item Item to remove
]]
function Set:erase(item : any)
    local index = table.find(self._table, item)

    if index == nil then
        return
    end

    table.remove(self._table, index)
end


--[[
    Checks if the given item is in the current set
    @param item Item to check if it is in the current set
    @return True if the item was found in the current set, false otherwise
]]
function Set:contains(item : any) : boolean
    return table.find(self._table, item) ~= nil
end


--[[
    Gives the amount of element in the set
    @return The amount of elements in the set
]]
function Set:size() : number
    return #self._table
end


--[[
    Checks if the set is empty
    @return True if the set is empty, false otherwise
]]
function Set:isEmpty() : boolean
    return self:size() == 0
end


--[[
    Clears all the elements in the set
]]
function Set:clear()
    table.clear(self._table)
end


--[[
    Gives the current set as a table
    @return The current set as a table
]]
function Set:toTable()
    return self._table
end


--[[
    Runs the given method for every element in the current set
    @param method Method to run
]]
function Set:forEach(method : (any) -> ()) : ()
    for _, item in ipairs(self._table) do
        method(item)
    end
end



return table.freeze(Set)