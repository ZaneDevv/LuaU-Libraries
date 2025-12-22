--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/22

-------------------------------------
-- Constants
-------------------------------------

local DEFAULT_GIZMO_COLOR = Color3.new(1, 1, 1)

-------------------------------------
-- Services
-------------------------------------

local RunService = game:GetService("RunService")

-------------------------------------
-- Variables
-------------------------------------

local GizmosServices = {}

-------------------------------------
-- Methods
-------------------------------------

--[[
    Creates a new gizmo in the shape of a cube
    @param position Gizmo's position
    @param size Cube's size
    @param transparency Gizmo's transparency
    @param color Gizmo's color
    @return Gizmo created as a part
]]
function GizmosServices.createCube(position : vector | Vector3, size : vector | Vector3, transparency : number?, color : Color3?) : Part?
    if not RunService:IsStudio() then
        return
    end

    local cube = Instance.new("Part")
    cube.Material = Enum.Material.SmoothPlastic
    cube.CastShadow = false
    cube.CanCollide = false
    cube.CanQuery = false
    cube.CanTouch = false
    cube.Anchored = true
    cube.Transparency = transparency or 0.5
    cube.Color = color or DEFAULT_GIZMO_COLOR
    cube.Position = position :: Vector3
    cube.Size = size :: Vector3
    cube.Parent = workspace

    return cube
end


--[[
    Creates a new gizmo in the shape of a sphere
    @param position Gizmo's position
    @param radius Sphere's radius
    @param transparency Gizmo's transparency
    @param color Gizmo's color
    @return Gizmo created as a part
]]
function GizmosServices.createSphere(position : vector | Vector3, radius : number, transparency : number?, color : Color3?) : Part?
    local sphere = GizmosServices.createCube(position, vector.one * radius, transparency, color)
    
    if sphere then
        sphere.Shape = Enum.PartType.Ball
    end

    return sphere
end



return GizmosServices