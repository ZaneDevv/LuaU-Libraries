--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/20

-------------------------------------
-- Classes
-------------------------------------

local Stack = {}

-------------------------------------
-- Types
-------------------------------------

-- Stack class attributes
type self = {_table: {any}}

-- Stack instance type
export type Stack = typeof(setmetatable({} :: self, Stack))

-------------------------------------
-- Metamethods
-------------------------------------

Stack.__index = Stack
Stack.__tostring = function(stack : Stack) : string
    local result = "{\n"

    for index, data in ipairs(stack._table) do
        result ..= `\t[{index}] = {data}\n`
    end

    result ..= "}"

    return result
end


-------------------------------------
-- Constructors
-------------------------------------

--[[
    Create a new empty stack
]]
function Stack.new(): Stack
    local self = setmetatable({}, Stack) :: Stack

    self._table = {}

    return self
end

-------------------------------------
-- Methods
-------------------------------------

--[[
    Obtains the first element in the stack
    @return The first element in the stack
]]
function Stack:peek()
    return self._table[1]
end


--[[
    Sets the given data to the begining of the stack
    @param ... Data to add to the stack
]]
function Stack:push(...: any)
    local dataList = table.pack(...)

    if self:isEmpty() then
        return
    end
    
    for i = self:size(), 1, -1 do
        self._table[i + #dataList] = self._table[i]
    end

    for i = 1, #dataList do
        self._table[i] = dataList[i]
    end
end


--[[
    Removes and returns the first element in the stack
    @return The first element in the stack
]]
function Stack:pop() : any?
    if self:isEmpty() then
        return nil
    end    

    return table.remove(self._table, 1)
end


--[[
    Gives the amount of element in the stack
    @return The amount of elements in the stack
]]
function Stack:size() : number
    return #self._table
end


--[[
    Checks if the stack is empty
    @return True if the stack is empty, false otherwise
]]
function Stack:isEmpty() : boolean
    return self:size() == 0
end


--[[
    Clears all the elements in the stack
]]
function Stack:clear()
    table.clear(self._table)
end


--[[
    Checks if the given item is in the stack
    @param item Item to check in the stack
    @return True if the item is found in the stack, false otherwise
]]
function Stack:contains(item : any) : boolean
    for _, currentItem in ipairs(self._table) do
        if currentItem ~= item then
            continue
        end

        return true
    end

    return false
end


--[[
    Obtains the ith element in the stack
    @param i Position in the stack to obtain the element from
    @return The ith elemenr in the stack
]]
function Stack:getItem(i : number) : any?
    assert(i < self:size(), "Index out of bounds!")
    return self._table[i]
end


--[[
    Changes the value in the ith position in the stack
    @param i Stack position to store the new item
    @param item Item to add in the given positiom
]]
function Stack:setItem(i : number, item : any)
    self._table[i] = item
end


--[[
    Gives the current stack as a table
    @return The current stack as a table
]]
function Stack:toTable()
    return self._table
end


--[[
    Runs the given method for every element in the current stack
    @param method Method to run
]]
function Stack:forEach(method : (any) -> ()) : ()
    for _, item in ipairs(self._table) do
        method(item)
    end
end



return table.freeze(Stack)