--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/27

-------------------------------------
-- Variables
-------------------------------------

local throttleTimer : {[any] : number} = {}

-------------------------------------
-- Methods
-------------------------------------

--[[
    Runs the given method if the delayed time has passed by already from the last time the method with the given identifier ran
    @param identifier Method's identifier
    @param delay Time delay to allow the method to run again
    @param method Method to run if the time passed by
    @param ... Method's parameters
    @return True if the method could be executed, false otherwise 
]]
return function<T, U...>(identifier : T, delay : number, method : (T, U...) -> (), ... : U...) : boolean
    local now = os.clock()
    local last = throttleTimer[identifier]

    if last then
        if last - now <= delay then
            return false
        end
    end

    throttleTimer[identifier] = now
    task.defer(method, identifier, ...)

    return true
end