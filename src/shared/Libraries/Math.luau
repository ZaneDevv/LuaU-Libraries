--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/20

-------------------------------------
-- Variables
-------------------------------------

local Math = {}

-------------------------------------
-- Methods
-------------------------------------

--[[
    Clamps the given number between 0 and 1
    @param x Number to clamp
    @return Clamped number
]]
function Math.clamp01(x : number) : number
    return math.clamp(x, 0, 1)
end


--[[
    Interpolates the number a to the number b
    @param a Number to begin from
    @param b Number to reach
    @param t Progression
    @return A number between a and b according to t
]]
function Math.lerp(a : number, b : number, t : number) : number
    return a + (b - a) * t
end


--[[
    Interpolates the number a to the number b
    @param a Number to begin from
    @param b Number to reach
    @param t Progression 0 <= t <= 1
    @return A number between a and b according to t
]]
function Math.clampedLerp(a : number, b : number, t : number) : number
    return a + (b - a) * Math.clamp01(t)
end


--[[
    Sets the commas to the given number
    @param Number to set commas
    @return Number with all the needed commas set
]]
function Math.setCommas(x : number) : string
    local formatted = tostring(x)
    local k = 0

    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        
        if k == 0 then
            break
        end
    end

    return formatted
end


return Math