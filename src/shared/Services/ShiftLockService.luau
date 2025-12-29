--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/20

-------------------------------------
-- Constants
-------------------------------------

local CAMERA_OFFSET = Vector3.xAxis * 2
local RENDER_STEP_NAME = "ShiftLock"

-------------------------------------
-- Services
-------------------------------------

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-------------------------------------
-- Variables
-------------------------------------

local ShiftLockService = {}

-------------------------------------
-- Methods
-------------------------------------

--[[
	Calculates the looking angle.
	@param camera The camera to calculate the looking angle from.
	@return The looking angle.
]]
local function getLookingAngle(camera : Camera): number
	local LookingTowards = camera.CFrame.LookVector
	return math.atan2(-LookingTowards.X, -LookingTowards.Z)
end


--[[
	Activates the "forced" shift lock.
	@param humanoid: Player's humanoid affected.
]]
function ShiftLockService.activate(humanoid: Humanoid)
    assert(RunService:IsClient(), "This method can only be ran on client-side!")

	local rootPart : Part = humanoid.RootPart :: Part
	local camera : Camera = workspace.CurrentCamera
	
	humanoid.CameraOffset = CAMERA_OFFSET
	humanoid.AutoRotate = false
	
	UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
	
	RunService:BindToRenderStep(RENDER_STEP_NAME, Enum.RenderPriority.Character.Value, function()
		local CFramePosition = CFrame.new(rootPart.Position)
		local CFrameRotation = CFrame.fromAxisAngle(Vector3.yAxis, getLookingAngle(camera))
		
		rootPart.CFrame = CFramePosition * CFrameRotation
	end)
end


--[[
	Desactivates the "forced" shift lock.
	@param humanoid: Player"s humanoid affected.
]]
function ShiftLockService.desactivate(humanoid: Humanoid)
    assert(RunService:IsClient(), "This method can only be ran on client-side!")

	UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	
	humanoid.CameraOffset = Vector3.zero
	humanoid.AutoRotate = true
	
	RunService:UnbindFromRenderStep(RENDER_STEP_NAME)
end



return table.freeze(ShiftLockService)