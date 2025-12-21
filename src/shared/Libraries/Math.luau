--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/20

-------------------------------------
-- Constants
-------------------------------------

local SET_COMMAS_TO_NUMBER_REGEX_DETECTION = "^(-?%d+)(%d%d%d)"
local SET_COMMAS_TO_NUMBER_REGEX = '%1,%2'

local ABBREVIATIONS : {[string] : number} = {
	K = 1e3,
	M = 1e6,
	B = 1e9,
	T = 1e12,
	Qa = 1e15,
	Qi = 1e18,
	Sx = 1e21,
	Sp = 1e24,
	Oc = 1e27,
	No = 1e30,
	Dc = 1e33,
}

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
    Checks if the given number is within the given range
    @param x Number to check
    @param min Minimum number in the range
    @param max Maximum number in the range
    @return True if the given number is within the given range, false otherwise
]]
function Math.isNumberInRange(x : number, min : number, max : number) : boolean
    return x >= min and x <= max
end


--[[
    Checks if the given number is even
    @param x Number to check
    @return True if the given number is even, false otherwise
]]
function Math.isEven(x : number) : boolean
    return bit32.band(x, 1) == 0
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
        formatted, k = string.gsub(formatted, SET_COMMAS_TO_NUMBER_REGEX_DETECTION, SET_COMMAS_TO_NUMBER_REGEX)
        
        if k == 0 then
            break
        end
    end

    return formatted
end


--[[
    Abbreviates the given number
    @param x Number to abbreviate
    @return The number abbreviated
]]
function Math.Abbreviate(x : number) : string
	if x >= math.huge then
		return "∞"
	end
	
	if x < 1e3 then
		return tostring(x)
	end

	local chosenAbbreviationSubfix: string = ""
	local chosenAbbreviationMinNumber: number = 0

	for subfix : string, minToAbbreviate : number in ABBREVIATIONS do
		if minToAbbreviate > x or minToAbbreviate < chosenAbbreviationMinNumber then
			continue
		end

		chosenAbbreviationSubfix = subfix;
		chosenAbbreviationMinNumber = minToAbbreviate;
	end

	local prefixNumber: number = math.floor(x / chosenAbbreviationMinNumber * 10) / 10
	
	return `{tostring(prefixNumber)} {chosenAbbreviationSubfix}+`
end


return Math