--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/29

-------------------------------------
-- Constants
-------------------------------------

local TIME_FORMAT = "%02i:%02i:%02i"
local TIME_FORMAT_WITH_DAYS = "%02i:%02i:%02i:%02i"

-------------------------------------
-- Variables
-------------------------------------

local Time = {}

-------------------------------------
-- Public constants
-------------------------------------

Time.SECONDS_IN_HOUR = 3600
Time.SECONDS_IN_DAY = 86400

-------------------------------------
-- Methods
-------------------------------------

--[[
    Formats the given time
    @param seconds Time to format in seconds
    @return The formatted time
]]
function Time.formatTimeFromSeconds(seconds : number) : string
    return string.format(TIME_FORMAT, seconds // Time.SECONDS_IN_HOUR, (seconds // 60) % 60, seconds % 60)
end


--[[
    Formats the given time adding days
    @param seconds Time to format in seconds
    @return The formatted time
]]
function Time.formatTimeFromSecondsWithDays(seconds : number) : string
    return string.format(TIME_FORMAT_WITH_DAYS, seconds // Time.SECONDS_IN_HOUR, (seconds // Time.SECONDS_IN_HOUR) % 24, (seconds // 60) % 60, seconds % 60)
end


return table.freeze(Time)