--!strict
--@author Álvaro Fernández Barrero
--@date 2026/01/05

-------------------------------------
-- Variables
-------------------------------------

local Spring = {}

-------------------------------------
-- Types
-------------------------------------

-- All the possible types for springs
type springable = Vector2 | Vector2int16 | Vector3 | Vector3int16 | vector | CFrame | number

-- Spring instance attributes
type self = {k : number, mass : number, beta : number, omega : number, zeta : number, omegaZeta : number, targetPoint : springable?, velocity : springable?, point : springable?}

-- Spring instance type
export type Spring = typeof(setmetatable({} :: self, Spring))

-------------------------------------
-- Metamethods
-------------------------------------

Spring.__index = Spring

-------------------------------------
-- Constructors
-------------------------------------

function Spring.new(k : number, mass : number, beta : number) : Spring
    local self = setmetatable({} :: self, Spring)

    self.targetPoint = nil
    self.velocity = nil
    self.point = nil

    self.k = k
    self.mass = mass
    self.beta = beta
    self.omega = math.sqrt(self.k / self.mass)
    self.zeta = math.clamp(self.beta / (2 * math.sqrt(self.k * self.mass)), 0, 0.99)
    self.omegaZeta = self.omega * self.zeta; 

    return self
end

-------------------------------------
-- Methods
-------------------------------------

function Spring:update(deltaTime : number)
    if self.targetPosition == nil then
        warn("Cannot update a spring with no starting values!")
        return
    end

    local springType = typeof(self.targetPosition)

    if springType == "Vector3" or springType == "Vector2" or springType == "Vector3int16" or springType == "Vector2int16" or springType == "vector" or springType == "number" then
        local omegaRoot = (self :: self).omega * math.sqrt(1 - (self :: self).zeta * (self :: self).zeta)

        local exponential = math.exp(-self.zeta * self.omega * deltaTime)
        local cosine = math.cos(omegaRoot * deltaTime)
        local sine = math.sin(omegaRoot * deltaTime)

        local a = self.point :: any - self.targetPosition :: any
        local b = ((self.velocity :: Vector3) - (self.point :: Vector3) * self.omega * self.zeta) / omegaRoot

        self.point = exponential * (a * cosine + b * sine) + self.targetPosition
        self.velocity = -exponential * (cosine * (a * self.omega * self.zeta - b * omegaRoot) + sine * (a * omegaRoot + b * self.omega * self.zeta))

        return
    end
end



function Spring:setTargetPosition(target : springable)
    self.targetPosition = target

    if self.point == nil then
        local type = typeof(target)
        if type == "Vector3" or type == "Vector2" or type == "Vector3int16" or type == "Vector2int16" or type == "vector" or type == "number" then
            self.velocity = target :: number * 0;
            self.point = target :: number * 0
        end
    end
end



return table.freeze(Spring)