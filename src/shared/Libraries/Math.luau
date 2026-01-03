--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/20

-------------------------------------
-- Private constants
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

local RANDOM_GENERATOR = Random.new()

-------------------------------------
-- Variables
-------------------------------------

local Math = {}

-------------------------------------
-- Public constants
--------------------------------

Math.TAU = 6.283185307179586
Math.E = 2.718281828459045
Math.EPSILON = 2e-4

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
    Given a lerp, computes the corresponding progression (t) between a and b which corresponds to the lerped value
    @param a The starting lerp value
    @param b The final lerp value
    @param lerped value between a and b
    @return Progression t corresponding to the lerped value between a and b
]]
function Math.inverseLerp(a : number, b : number, lerped : number) : number
    if a == b or lerped == a then
        return 0
    end

    if b == lerped then
        return 1
    end

    return (lerped - a) / (b - a)
end


--[[
    Maps the given interpolation into a different one
    @param lerped Lerped value between inputMinimum and inputMaximum
    @param inputMinimum Starting value for the mapped interpolation
    @param inputMaximum Final value for the mapped interpolation
    @param outputMinimum Starting value for the new interpolation to map into
    @param outputMaximum Final value for the new interpolation to map into
    @return A lerped number between outputMinimum and outputMaximum which corresponds to the progression of lerped between inputMinimum and inputMaximum
]]
function Math.map(lerped : number, inputMinimum : number, inputMaximum : number, outputMinimum : number, outputMaximum : number) : number
    return Math.lerp(outputMinimum, outputMaximum, Math.inverseLerp(inputMinimum, inputMaximum, lerped))
end


--[[
    Checks if the two given numbers and close enough to each other
    @param a First value to compare
    @param b Seconds value to compare
    @param epsilon Optional number to check if the two previous numbers are close enough to each other. By default, Ɛ = 2e-4
    @return True if the two numbers are approximate, false otherwise
]]
function Math.isApproximate(a : number, b : number, epsilon : number?) : boolean
    return math.abs(a - b) <= (epsilon or Math.EPSILON)
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
    if not Math.isInteger(x) then
        return false
    end

    return bit32.band(x, 1) == 0
end


--[[
    Checks if the given number is an integer or not
    @param x Number to check
    @return True if the given number is an integer, false otherwise
]]
function Math.isInteger(x : number) : boolean
    return x == math.floor(x)
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


--[[
    Ponderates the given data
    @param data All the items with their respective weight
    @return A random element from the data
]]
function Math.poderate(data : {{weight : number, item : any}}) : any
    local totalWeight: number = 0
	
	for _, item in ipairs(data) do
		totalWeight += item.weight
	end
	
	if totalWeight <= 0 then
		return nil
	end

	local randomNumber: number = RANDOM_GENERATOR:NextNumber(0, totalWeight)
	local result: any? = nil

	for _, item in ipairs(data) do
		if randomNumber <= item.weight then
			result = item
			break
		end

		randomNumber -= item.weight
	end

	return result
end


return table.freeze(Math)