--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/20

-------------------------------------
-- Services
-------------------------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-------------------------------------
-- Class
-------------------------------------

local AABB = {}

-------------------------------------
-- Types
-------------------------------------

-- AABB bounds
export type BoundAABB = {min : number, max : number}

-- AABB class attributes
export type self = {bounds : {BoundAABB}}

-- AABB instance type
export type AABB = typeof(setmetatable({} :: self, AABB))

-------------------------------------
-- Modules
-------------------------------------

local Math = require(ReplicatedStorage.Shared.Libraries.Math)

-------------------------------------
-- Constructor
-------------------------------------

--[[
	Creates a new AABB instance
	@param essentialBound First AABB bounds
	@param ... AABB bounds
    @return The new AABB instance
]]
function AABB.new(essentialBound : BoundAABB, ... : BoundAABB) : AABB
	return setmetatable({bounds = {essentialBound, ...}}, AABB) :: AABB
end

-------------------------------------
-- Metamethods
-------------------------------------

AABB.__index = AABB
function AABB:__tostring(aabb : AABB) : string
	local result = "AABB(\n"

	for _, bound : BoundAABB in ipairs(aabb.bounds) do
		result ..= `min: {bound.min}, max: {bound.max}\n`
	end

	result ..= ")"

	return result
end

-------------------------------------
-- Methods
-------------------------------------

--[[
	Checks if the two given bounds are overlapping
	@param bound1 First bounds to check
	@param bound2 Other bounds to check
	@return True if they are overlapping, false otherwise
]]
local function areBoundsOverlapping(bound1 : BoundAABB, bound2 : BoundAABB) : boolean
	return Math.isNumberInRange(bound1.min, bound2.min, bound2.max)
end


--[[
	Obtains the amount of dimensions the current AABB instance has
	@return The current AABB instance's dimensions
]]
function AABB:getDimensionsAmount() : number
	return #self.bounds
end


--[[
	Checks if the current and the given AABB instances have the same amount of dimensions
	@param aabb The other AABB instance to check
	@return True if both AABB instances ahve the same dimensions, false otherwise
]]
function AABB:hasSameDimensions(aabb : AABB) : boolean
	return self:getDimensionsAmount() == aabb:getDimensionsAmount()
end


--[[
    Checks if the given point is over the current AABB
    @param point Point to check
    @return True if the point is within the current AABB, false otherwise
	@error If AABB is 3D, the given point must be a Vector3
]]
function AABB:isPointOver(point : Vector3 | Vector2) : boolean
	local aabbDimensions = self:getDimensionsAmount()
	assert(typeof(point) == `Vector{aabbDimensions}`, "The point and the AABB must have the same amount of dimensions!")

	local result = Math.isNumberInRange(point.X, self.bounds[1].min, self.bounds[1].max) and Math.isNumberInRange(point.Y, self.bounds[2].min, self.bounds[2].max)

	if aabbDimensions == 3 then
		result = result and Math.isNumberInRange((point :: Vector3).Z, self.bounds[2].min, self.bounds[2].max)
	end

	return result
end


--[[
	Checks if the current AABB instance and the given one are overlapping
	@param aabb The other AABB instance to check
	@return True if they are overlapping, false otherwise
]]
function AABB:isAABBOver(aabb : AABB) : boolean
	assert(self:hasSameDimensions(aabb), "Both AABB instances must have the same amount of dimensions!")

	for i : number = 1, aabb:getDimensionsAmount() do
		if areBoundsOverlapping(self.bounds[i], aabb.bounds[i]) then
			continue
		end

		return false
	end
	
	return true
end



return AABB