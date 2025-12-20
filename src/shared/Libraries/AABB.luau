--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/20

-------------------------------------
-- Class
-------------------------------------

local AABB = {}

-------------------------------------
-- Types
-------------------------------------

-- AABB class attributes
type self = {_minX: number, _maxX: number, _minY: number, _maxY: number, _minZ: number?, _maxZ: number?}

-- AABB instance type
export type AABB = typeof(setmetatable({} :: self, AABB))

-------------------------------------
-- Constructor
-------------------------------------

--[[
	Creates a new AABB instance
	@param minX Minimum x coordinate
	@param maxX Maximum x coordinate
	@param minY Minimum y coordinate
	@param maxY Maximum y coordinate
	@param minZ Minimum z coordinate
	@param maxZ Maximum z coordinate
    @return The new AABB instance
]]
function AABB.new(minX : number, maxX : number, minY : number, maxY : number, minZ : number?, maxZ : number?) : AABB
	assert((minZ == nil and maxZ == nil) or (minZ ~= nil and maxZ ~= nil), "Axis Z must be fully defined or fully omitted")
	assert(minX <= maxX, "minX must be <= maxX")
	assert(minY <= maxY, "minY must be <= maxY")

	if minZ ~= nil and maxZ ~= nil then
		assert(minZ <= maxZ, "minZ must be <= maxZ")
	end

	return setmetatable(
        {
            _minX = minX,
            _maxX = maxX,
            _minY = minY,
            _maxY = maxY,
            _minZ = minZ,
            _maxZ = maxZ
        },
        AABB
    )
end

-------------------------------------
-- Metamethods
-------------------------------------

AABB.__index = AABB
function AABB:__tostring() : string
	if self._minZ ~= nil and self._maxZ ~= nil then
		return string.format("AABB3D(min=(%f,%f,%f), max=(%f,%f,%f))", self._minX, self._minY, self._minZ, self._maxX, self._maxY, self._maxZ)
	end

	return string.format("AABB2D(min=(%f,%f), max=(%f,%f))", self._minX, self._minY, self._maxX, self._maxY)
end

-------------------------------------
-- Methods
-------------------------------------

function AABB:hasThreeDimensions() : boolean
	return self._minZ ~= nil and self._maxZ ~= nil
end


--[[
    Checks if the given point is over the current AABB
    @param point Point to check
    @return True if the point is within the current AABB, false otherwise
	@error If AABB is 3D, the given point must be a Vector3
]]
function AABB:isPointOver(point : Vector3 | Vector2) : boolean
	if point.X < self._minX or point.X > self._maxX then
		return false
	end

	if point.Y < self._minY or point.Y > self._maxY then
		return false
	end

	if self:hasThreeDimensions() then
        assert(typeof(point) == "Vector3", "Vector3 expected!")

		if point.Z < self._minZ or point.Z > self._maxZ then
			return false
		end
	end

	return true
end



function AABB:isAABBOver(aabb : AABB) : boolean
	assert(self:hasThreeDimensions() == aabb:hasThreeDimensions(), "Both AABB instances must have the same amount of dimensions!")

	-- TODO this
	return true
end



return AABB