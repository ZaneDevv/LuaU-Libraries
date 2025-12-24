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

local Quaternion = {}

-------------------------------------
-- Types
-------------------------------------

-- Quaternion class attributes
type self = {w : number, x : number, y : number, z : number}

-- Quaternion instance type
export type Quaternion = typeof(setmetatable({} :: self, Quaternion))

-------------------------------------
-- Modules
-------------------------------------

local Math = require(ReplicatedStorage.Shared.Libraries.Math)

-------------------------------------
-- Constructor
-------------------------------------

--[[
    Creates a new quaternion instance with the given coordinates
    @param w W-coordinate
    @param x X-coordinate
    @param y Y-coordinate
    @param z Z-coordinate
]]
function Quaternion.new(w : number?, x : number?, y : number?, z : number?) : Quaternion
    local self = setmetatable({} :: self, Quaternion) :: Quaternion

    self.w = w or 0
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0

    return self
end


--[[
    Creates a new quaternion with the given angle and rotation axis
    @param axis Rotation axis
    @param angle Rotation angle
    @return The new quaternion
]]
function Quaternion.fromAxisAngle(axis : Vector3, angle : number) : Quaternion
    if angle == 0 then
        return Quaternion.identity
    end

    angle *= 0.5

    local cos = math.cos(angle)
    local sin = math.sin(angle)

    return Quaternion.new(cos, sin * axis.X, sin * axis.Y, sin * axis.Z)
end


--[[
    Creates a new quaternion with the angles x, y and z
    @param x Rotation on the x-axis
    @param y Rotation on the y-axis
    @param z Rotation on the z-axis
    @return Quaternion rotated x on the x-axis, y on the y-axis and z on the z-axis
]]
function Quaternion.fromEulerAnglesXYZ(x : number?, y : number?, z : number?) : Quaternion
    if x == y and y == z and z == 0 then
        return Quaternion.identity
    end

    return Quaternion.fromAxisAngle(Vector3.xAxis, x or 0) * Quaternion.fromAxisAngle(Vector3.yAxis, y or 0) * Quaternion.fromAxisAngle(Vector3.zAxis, z or 0)
end


--[[
    Clones the given quaternion
    @param quaternion Quaternion to clone
    @return Cloned quaternion
]]
function Quaternion.clone(quaternion : Quaternion)
    return Quaternion.new(quaternion.w, quaternion.x, quaternion.y, quaternion.z)
end


-- Offitial method
--[[
    Creates a new quaternion with the given CFrame
    @param cframe CFrame to create the quaternion from
]]
function Quaternion.fromCFrame(cframe: CFrame) : Quaternion
    local w, x, y, z = 0, 0, 0, 0

    local _, _, _, m00, m01, m02, m10, m11, m12, m20, m21, m22 = cframe:GetComponents()
    local trace = m00 + m11 + m22

    local s = 0
    local r = 0

    if trace > 0 then
		s = math.sqrt(1 + trace)
		r = 0.5 / s

		w = s * 0.5
        x = (m21 - m12) * r
        y = (m02 - m20) * r
        z = (m10 - m01) * r
    else
        local big = math.max(m00, m11, m22)

		if big == m00 then
			s = math.sqrt(1 + m00 - m11 - m22)
			r = 0.5 / s

			w = (m21 - m12) * r
            x = 0.5 * s
            y = (m10 + m01) * r
            z = (m02 + m20) * r
    
		elseif big == m11 then
			s = math.sqrt(1 - m00 + m11 - m22)
			r = 0.5 / s

			w = (m02 - m20) * r
            x = (m10 + m01) * r
            y = 0.5 * s
            z = (m21 + m12) * r

		elseif big == m22 then
			s = math.sqrt(1 - m00 - m11 + m22)
			r = 0.5 / s
			
            w = (m10 - m01) * r
            x = (m02 + m20) * r
            y = (m21 + m12) * r
            z = 0.5 * s
		end
    end


    return Quaternion.new(w, x, y, z)
end

-------------------------------------
-- Static constants
-------------------------------------

Quaternion.identity = Quaternion.new(1, 0, 0, 0)

-------------------------------------
-- Metamethods
-------------------------------------

Quaternion.__index = Quaternion

Quaternion.__add = function(quaternion0 : Quaternion, quaternion1 : Quaternion) : Quaternion
    return Quaternion.new(quaternion0.w + quaternion1.w, quaternion0.x + quaternion1.x, quaternion0.y + quaternion1.y, quaternion0.z + quaternion1.z)
end

Quaternion.__sub = function(quaternion0 : Quaternion, quaternion1 : Quaternion) : Quaternion
    return Quaternion.new(quaternion0.w - quaternion1.w, quaternion0.x - quaternion1.x, quaternion0.y - quaternion1.y, quaternion0.z - quaternion1.z)
end

Quaternion.__mul = function(q : number | Quaternion, s : number | Quaternion) : Quaternion
    -- Quaternion * quaternion multiplication
    if typeof(q) == "table" and typeof(s) == "table" then
        local quaternion0 : Quaternion = q :: Quaternion
        local quaternion1 : Quaternion = s :: Quaternion

        return Quaternion.new(
            quaternion0.w * quaternion1.w - quaternion0.x * quaternion1.x - quaternion0.y * quaternion1.y - quaternion0.z * quaternion1.z,
            quaternion0.w * quaternion1.x + quaternion0.y * quaternion1.z - quaternion0.z * quaternion1.y + quaternion0.x * quaternion1.w,
            quaternion0.w * quaternion1.y - quaternion0.x * quaternion1.z + quaternion0.z * quaternion1.x + quaternion0.y * quaternion1.w,
            quaternion0.w * quaternion1.z + quaternion0.x * quaternion1.y - quaternion0.y * quaternion1.x + quaternion0.z * quaternion1.w
        )
    end

    -- Quaternion * scalar
    if type(q) == "table" and type(s) == "number" then
        return Quaternion.new(q.w * s, q.x * s, q.y * s, q.z * s)
    end

    -- Scalar * quaternion
    if type(q) == "number" and type(s) == "table" then
        return Quaternion.new(s.w * q, s.x * q, s.y * q, s.z * q)
    end

    error("Invalid operation!")
end

Quaternion.__div = function(quaternion : Quaternion, scalar : number) : Quaternion
    assert(scalar ~= 0, "Cannot divide a quaternion by 0!")
    return Quaternion.new(quaternion.w / scalar, quaternion.x / scalar, quaternion.y / scalar, quaternion.z / scalar)
end

Quaternion.__idiv = function(quaternion : Quaternion, scalar : number) : Quaternion
    assert(scalar ~= 0, "Cannot divide a quaternion by 0!")
    return Quaternion.new(quaternion.w // scalar, quaternion.x // scalar, quaternion.y // scalar, quaternion.z // scalar)
end

Quaternion.__pow = function(quaternion : Quaternion, power : number) : Quaternion
    local angle = quaternion:getAngle()
    local axis = quaternion:getAxisAsVector3()

    angle *= power

    return Quaternion.fromAxisAngle(axis, angle)
end

Quaternion.__unm = function(quaternion : Quaternion) : Quaternion
    return (quaternion * -1) :: Quaternion
end

Quaternion.__eq = function(quaternion0 : Quaternion, quaternion1 : Quaternion) : boolean
    return quaternion0.w == quaternion1.w and quaternion0.x == quaternion1.x and quaternion0.y == quaternion1.y and quaternion0.z == quaternion1.z
end

Quaternion.__lt = function(quaternion0 : Quaternion, quaternion1 : Quaternion) : boolean
    return quaternion0:magnitude() < quaternion1:magnitude()
end

Quaternion.__le = function(quaternion0 : Quaternion, quaternion1 : Quaternion) : boolean
    return quaternion0:magnitude() <= quaternion1:magnitude()
end

Quaternion.__tostring = function(quaternion : Quaternion) : string
    return string.format("<%.5f, %.5f, %.5f, %.5f>", quaternion.w, quaternion.x, quaternion.y, quaternion.z)
end

-------------------------------------
-- Static methods
-------------------------------------

--[[
    Lerps the two given quaternions
    @param quaternion1 Quaternion to start from
    @param quaternion2 Quaternion to reach
    @param t Progress
    @return Quaternion lerped between quaternion1 and quaternion2
]]
function Quaternion.lerp(quaternion1 : Quaternion, quaternion2 : Quaternion, t : number) : Quaternion
	return Quaternion.new(
		Math.lerp(quaternion1.w, quaternion2.w, t),
		Math.lerp(quaternion1.x, quaternion2.x, t),
		Math.lerp(quaternion1.y, quaternion2.y, t),
		Math.lerp(quaternion1.z, quaternion2.z, t)
	)
end


--[[
    Lerps the two given quaternions
    @param quaternion1 Quaternion to start from
    @param quaternion2 Quaternion to reach
    @param t Progress 0 <= t <= 1
    @return Quaternion lerped between quaternion1 and quaternion2
]]
function Quaternion.clampedLerp(quaternion1 : Quaternion, quaternion2 : Quaternion, t : number) : Quaternion
    t = Math.clamp01(t)

	return Quaternion.new(
		Math.lerp(quaternion1.w, quaternion2.w, t),
		Math.lerp(quaternion1.x, quaternion2.x, t),
		Math.lerp(quaternion1.y, quaternion2.y, t),
		Math.lerp(quaternion1.z, quaternion2.z, t)
	)
end


--[[
    Interpolates the two given quaternions
    @param quaternion1 Quaternion to start from
    @param quaternion2 Quaternion to reach
    @param t Progress
    @return Quaternion interpolated
]]
function Quaternion.slerp(quaternion1 : Quaternion, quaternion2 : Quaternion, t : number) : Quaternion
    if quaternion1:dot(quaternion2) < 0 then
        quaternion2 *= -1
    end

    return quaternion1 * (quaternion2 * quaternion1:inverse()) ^ t
end

--[[
    Interpolates the two given quaternions
    @param quaternion1 Quaternion to start from
    @param quaternion2 Quaternion to reach
    @param t Progress 0 <= t <= 1
    @return Quaternion interpolated
]]
function Quaternion.clampedSlerp(quaternion1 : Quaternion, quaternion2 : Quaternion, t : number) : Quaternion
    return Quaternion.slerp(quaternion1, quaternion2, Math.clamp01(t))
end

-------------------------------------
-- Methods
-------------------------------------

--[[
    Inverts the current quaternion. This operation is q^-1 = q* / |q|^2
    @return The inverted quaternion
]]
function Quaternion:inverse() : Quaternion
    return self:conjugate() :: Quaternion / (self:magnitude() :: number ^ 2)
end


--[[
    Conjugates the current quaternion
    @return The conjugated quaternion
]]
function Quaternion:conjugate() : Quaternion
    return Quaternion.new(self.w, -self.x, -self.y, -self.z)
end


--[[
    Computes the dot product between the current quaternion and the given one
    @param other The other quaternion to compute the dot product with
    @return The dot product of the current quaterniona and the given one. q · p
]]
function Quaternion:dot(other : Quaternion) : number
    return self.w :: number * other.w + self.x :: number * other.x + self.y :: number * other.y + self.z :: number * other.z
end


--[[
    Computes the squared magnitude of the current quaternion
    @return The current quaternion's squared magnitude
]]
function Quaternion:squaredMagnitude() : number
    return self:dot(self)
end


--[[
    Computes the magnitude of the current quaternion
    @return The current quaternion's magnitude
]]
function Quaternion:magnitude() : number
    return (self:squaredMagnitude()) ^ 0.5
end


--[[
    Normalizes the current quaternion
    @return The current quaternion normalizated
]]
function Quaternion:normalize() : Quaternion
    return (self :: Quaternion) / (self:magnitude() :: number)
end


--[[
    Converts the current quaternion to a CFrame
    @return The corresponding CFrame to the current quaternion
]]
function Quaternion:toCFrame() : CFrame
    return CFrame.new(0, 0, 0, self.x, self.y, self.z, self.w)
end


--[[
    Obtains the current quaternion's axis rotation as a normalizated vector
    @return Quaternion's axis rotation as a normalizated vector
]]
function Quaternion:getAxis() : vector
    if self.x == 0 and self.y == 0 and self.z == 0 then
        return vector.zero
    end

    return vector.normalize(vector.create(self.x, self.y, self.z))
end


--[[
    Obtains the current quaternion's axis rotation as a normalizated Vector3
    @return Quaternion's axis rotation as a normalizated Vector3
]]
function Quaternion:getAxisAsVector3() : Vector3
    if self.x == 0 and self.y == 0 and self.z == 0 then
        return Vector3.zero
    end

    return Vector3.new(self.x, self.y, self.z).Unit
end


--[[
    Obtains the current quaternion's angle rotation
    @return Quaternion's angle rotation
]]
function Quaternion:getAngle() : number
    return 2 * math.acos(self.w)
end



return Quaternion