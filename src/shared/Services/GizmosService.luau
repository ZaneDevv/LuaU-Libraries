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
function GizmosServices.createCube(position : vector | Vector3, size : vector | Vector3, transparency : number?, color : Color3?, hightlight : boolean?) : Part?
    if not RunService:IsStudio() then
        return
    end

    local parent = workspace:FindFirstChild("Gizmos")
    if not parent then
        parent = Instance.new("Folder")
        parent.Name = "Gizmos"
        parent.Parent = workspace
    end

    local cube = Instance.new("Part")
    cube.Material = Enum.Material.SmoothPlastic
    cube.CastShadow = false
    cube.CanCollide = false
    cube.CanQuery = false
    cube.CanTouch = false
    cube.Anchored = true
    cube.Transparency = hightlight == false and (transparency or 0.5) or 0
    cube.Color = color or DEFAULT_GIZMO_COLOR
    cube.Position = position :: Vector3
    cube.Size = size :: Vector3
    cube.Name = "Cube"
    cube.Parent = parent

    if hightlight ~= false then
        local hightlightEffect = Instance.new("Highlight")
        hightlightEffect.FillColor = cube.Color
        hightlightEffect.OutlineTransparency = 1
        hightlightEffect.FillTransparency = transparency or 0
        hightlightEffect.Parent = cube
    end


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
function GizmosServices.createSphere(position : vector | Vector3, radius : number, transparency : number?, color : Color3?, hightlight : boolean?) : Part?
    local sphere = GizmosServices.createCube(position, vector.one * radius, transparency, color, hightlight)
    
    if sphere then
        sphere.Shape = Enum.PartType.Ball
        sphere.Name = "Sphere"
    end

    return sphere
end


--[[
    Creates a new gizmo in the shape of a ray
    @param origin Ray's origin
    @param finish Ray's ending
    @param transparency Gizmo's transparency
    @param color Gizmo's color
    @return Gizmo created as a part
]]
function GizmosServices.createRay(origin : Vector3, finish : Vector3, transparency : number?, color : Color3?, hightlight : boolean?) : Part?
    local ray = GizmosServices.createCube(vector.zero, vector.one, transparency, color, hightlight)

    if ray then
        ray.Size = Vector3.new(0.2, 0.2, (origin - finish).Magnitude)
        ray.CFrame = CFrame.new((origin + finish) * 0.5, finish)
        ray.Name = "Ray"
    end

    return ray
end



return GizmosServices