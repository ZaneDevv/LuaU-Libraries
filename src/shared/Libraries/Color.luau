--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/20

-------------------------------------
-- Constants
-------------------------------------

local HEXADECIMAL_COLOR_PATTER0 = "^#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]$"
local HEXADECIMAL_COLOR_PATTER1 = "^#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]$"

-------------------------------------
-- Services
-------------------------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-------------------------------------
-- Class
-------------------------------------

local Color = {}

-------------------------------------
-- Modules
-------------------------------------

local Math = require(ReplicatedStorage.Shared.Libraries.Math)

-------------------------------------
-- Methods
-------------------------------------

--[[
    Interpolates the two given numbers
    @param color1 Color to start interpolating from
    @param color2 Color to reach in the interpolation
    @param t Progression
    @return A color interpolated between color1 and color2
]]
function Color.slerp(color1 : Color3, color2 : Color3, t : number) : Color3
    local hue1, saturation1, value1 = color1:ToHSV()
    local hue2, saturation2, value2 = color2:ToHSV()

    local differentialHue = hue2 - hue1

    if differentialHue > 0.5 then
		differentialHue -= 1
	elseif differentialHue < -0.5 then
		differentialHue += 1
	end

    return Color3.fromHSV(
        (hue1 + differentialHue * t) % 1,
        saturation1 + (saturation2 - saturation1) * t,
        value1 + (value2 - value1) * t
    )
end


--[[
    Interpolates the two given numbers
    @param color1 Color to start interpolating from
    @param color2 Color to reach in the interpolation
    @param t Progression 0 <= t <= 1
    @return A color interpolated between color1 and color2
]]
function Color.clampedSlerp(color1 : Color3, color2 : Color3, t : number) : Color3
    return Color.slerp(color1, color2, Math.clamp01(t))
end


--[[
    Check whether the given string is an hexadecimal color
    @param color String to check
    @return True if the given string is an hexadecimal color, false otherwise 
]]
function Color.isHexadecimalColor(color : string) : boolean
    return string.match(color, HEXADECIMAL_COLOR_PATTER0) ~= nil or string.match(color, HEXADECIMAL_COLOR_PATTER1) ~= nil
end



return Color