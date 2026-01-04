--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/24

-------------------------------------
-- Variables
-------------------------------------

local Spring = {}

-------------------------------------
-- Types
-------------------------------------

type springableType = number | Vector3 | Vector3int16 | Vector2 | vector

-- Spring instance's attributes
type self = {k : number, mass : number, damping : number, position : springableType, target : springableType, velocity : springableType}

-- Spring instance type
export type Spring = typeof(setmetatable({} :: self, Spring))

-------------------------------------
-- Metamethods
-------------------------------------

Spring.__index = Spring

-------------------------------------
-- Constructors
-------------------------------------

function Spring.new(k : number, mass : number, damping : number, position : springableType, target : springableType?) : Spring
    local self = setmetatable({}, Spring) :: Spring
    
    self.k = k
    self.mass = mass
    self.damping = damping

    self.position = position
    self.target = target or position
    self.velocity = (position :: any) * 0

    return self
end

-------------------------------------
-- Methods
-------------------------------------

function Spring:update(deltaTime : number)
    self.velocity = (self.velocity :: any) ((-self.k * (self.target :: any - self.position :: any) / self.mass) - (self.damping :: any * self.velocity :: any)) * deltaTime
    self.position = self.position :: any + self.velocity * deltaTime
end



return table.freeze(Spring)