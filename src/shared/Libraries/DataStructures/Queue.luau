--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/20

-------------------------------------
-- Classes
-------------------------------------

local Queue = {}

-------------------------------------
-- Types
-------------------------------------

-- Queue class attributes
type self = {_table: {any}}

-- Queue instance type
export type Queue = typeof(setmetatable({} :: self, Queue))

-------------------------------------
-- Constructors
-------------------------------------

--[[
    Create a new empty queue
]]
function Queue.new(): Queue
    return setmetatable(
        {
            _table = {}
        },
        Queue
    ) :: Queue
end

-------------------------------------
-- Metamethods
-------------------------------------

Queue.__index = Queue
Queue.__tostring = function(queue : Queue) : string
    local result = "{\n"

    for index, data in ipairs(queue._table) do
        result ..= `\t[{index}] = {data}\n`
    end

    result ..= "}"

    return result
end

-------------------------------------
-- Methods
-------------------------------------

--[[
    Obtains the first element in the queue
    @return The first element in the queue
]]
function Queue:peek()
    return self._table[1]
end


--[[
    Sets the given data at the ending of the queue
    @param ... Data to add to the queue
]]
function Queue:enqueue(... : any)
    local queueSize : number = self:size() 

    local i : number = 1
    local item : any = select(i, ...)

    while item ~= nil do
        self._table[queueSize + i] = item

        i += 1
        item = select(i, ...)
    end
end


--[[
    Removes and returns the first element in the queue
    @return The first element in the queue
]]
function Queue:dequeue() : any?
    if self:isEmpty() then
        return nil
    end

    return table.remove(self._table, 1)
end


--[[
    Gives the amount of element in the queue
    @return The amount of elements in the queue
]]
function Queue:size() : number
    return #self._table
end


--[[
    Checks if the queue is empty
    @return True if the queue is empty, false otherwise
]]
function Queue:isEmpty()
    return self:size() == 0
end


--[[
    Clears all the elements in the queue
]]
function Queue:clear()
    table.clear(self._table)
end


--[[
    Checks if the given item is in the queue
    @param item Item to check in the queue
    @return True if the item is found in the queue, false otherwise
]]
function Queue:contains(item : any) : boolean
    for _, currentItem in ipairs(self._table) do
        if currentItem ~= item then
            continue
        end

        return true
    end

    return false
end


--[[
    Obtains the ith element in the queue
    @param i Position in the queue to obtain the element from
    @return The ith elemenr in the queue
]]
function Queue:getItem(i : number) : any?
    assert(i < self:size(), "Index out of bounds!")
    return self._table[i]
end


--[[
    Changes the value in the ith position in the queue
    @param i Queue position to store the new item
    @param item Item to add in the given positiom
]]
function Queue:setItem(i : number, item : any)
    self._table[i] = item
end


--[[
    Gives the current queue as a table
    @return The current queue as a table
]]
function Queue:toTable()
    return self._table
end


--[[
    Runs the given method for every element in the current queue
    @param method Method to run
]]
function Queue:forEach(method : (any) -> ()) : ()
    for _, item in ipairs(self._table) do
        method(item)
    end
end



return Queue