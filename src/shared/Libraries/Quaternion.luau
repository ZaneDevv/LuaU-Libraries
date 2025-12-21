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
function Quaternion.new(w : number, x : number, y : number, z : number) : Quaternion
    return setmetatable(
        {
            w = w,
            x = x,
            y = y,
            z = z
        },
        Quaternion
    ) :: Quaternion
end


--[[
    Creates a new quaternion with the given angle and rotation axis
    @param angle Rotation angle
    @param axis Rotation axis
    @return The new quaternion
]]
function Quaternion.fromAxisAngle(axis : Vector3, angle : number) : Quaternion
    angle *= 0.5

    local cos = math.cos(angle)
    local sin = math.sin(angle)

    return Quaternion.new(cos, sin * axis.X, sin * axis.Y, sin * axis.Z)
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
-- Metamethods
-------------------------------------

Quaternion.__index = Quaternion

Quaternion.__mul = function(q : Quaternion | number | CFrame, s : number | Quaternion | CFrame) : Quaternion | CFrame
    local quaternion : Quaternion = ((type(s) == "number" or typeof(s) == "CFrame") and q or s) :: Quaternion
    local multiplier : CFrame | number = (quaternion == q and s or q) :: CFrame | number

    if type(multiplier) == "number" then
        return Quaternion.new(quaternion.w * multiplier, quaternion.x * multiplier, quaternion.y * multiplier, quaternion.z * multiplier)
    end

    return multiplier * quaternion:toCFrame()
end

Quaternion.__div = function(quaternion : Quaternion, scalar : number) : Quaternion
    assert(scalar ~= 0, "Cannot divide a quaternion by 0!")
    return Quaternion.new(quaternion.w / scalar, quaternion.x / scalar, quaternion.y / scalar, quaternion.z / scalar)
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
    local theta1 = quaternion1:getAngle()
    local theta2 = quaternion2:getAngle()

    local axis1 = quaternion1:getAxisAsVector3()
    local axis2 = quaternion2:getAxisAsVector3()

    local theta = Math.lerp(theta1, theta2, t)
    local axis = axis1:Lerp(axis2, t)

    return Quaternion.fromAxisAngle(axis, theta)
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
    Computes the magnitude of the current quaternion
    @return The current quaternion's magnitude
]]
function Quaternion:magnitude() : number
    return ((self.w :: number) * self.w + (self.x :: number) * self.x + (self.y :: number) * self.y + (self.z :: number) * self.z) ^ 0.5
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
    Obtains the current quaternion's axis rotation as a vector
    @return Quaternion's axis rotation as a vector
]]
function Quaternion:getAxis() : vector
    return vector.create(self.x, self.y, self.z)
end


--[[
    Obtains the current quaternion's axis rotation as a Vector3
    @return Quaternion's axis rotation as a Vector3
]]
function Quaternion:getAxisAsVector3() : Vector3
    return Vector3.new(self.x, self.y, self.z)
end


--[[
    Obtains the current quaternion's angle rotation
    @return Quaternion's angle rotation
]]
function Quaternion:getAngle() : number
    return 2 * math.acos(self.w)
end



return Quaternion