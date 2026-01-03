--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/30

-------------------------------------
-- Services
-------------------------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-------------------------------------
-- Modules
-------------------------------------

local libraries = ReplicatedStorage.Shared.Libraries

local Maid = require(libraries.Maid)
local Signal = require(libraries.Signal)

-------------------------------------
-- Variables
-------------------------------------

local BetterTweenService = {}

-------------------------------------
-- Methods
-------------------------------------

--[[
    Runs a classic tween which cleans up automatically once it is finished
    @param instance Instance to tween
    @param tweenInfo Tween properties
    @param properties Instance's properties
]]
function BetterTweenService.doClassicTween(instance : Instance, tweenInfo : TweenInfo, properties : {[string] : any})
    if RunService:IsServer() then
        warn("This method should be executed on the client")
    end

    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    tween.Completed:Once(function()
        tween:Destroy()
    end)
end



function BetterTweenService.doTween(speed : number, easing : ((number) -> number)?, move : (number) -> ())
    if RunService:IsServer() then
        warn("This method should be executed on the client")
    end

    local t = 0

    while t <= 1 do
        local deltaTime = RunService.Heartbeat:Wait()
        t += deltaTime * speed

        local alpha = easing and easing(t) or t

        move(alpha)
    end

    move(1)
end



return table.freeze(BetterTweenService)