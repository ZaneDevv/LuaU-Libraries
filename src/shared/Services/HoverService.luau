--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/20

-------------------------------------
-- Types
-------------------------------------

-- Type which stores the needed information about the connections of a ui object
type savedInterfaces = {ui : GuiBase, hoverMethod : RBXScriptConnection?, unhoverMethod : RBXScriptConnection?, isButton : boolean}

-------------------------------------
-- Services
-------------------------------------

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-------------------------------------
-- Variables
-------------------------------------

local HoverService = {}


local connectedInterfaces : {[Instance]: savedInterfaces} = {} :: savedInterfaces
local isHoveredInterface : {[Instance] : boolean} = {}

local mouseMoveEvent : RBXScriptConnection? = nil
local noButtonConnectionsAmount : number = 0

-------------------------------------
-- Modules
-------------------------------------

local AABB = require(ReplicatedStorage.Shared.Libraries.AABB)

-------------------------------------
-- Player related variables
-------------------------------------

local localPlayer : Player = Players.LocalPlayer
local mouse : Mouse = localPlayer:GetMouse()

-------------------------------------
-- Methods
-------------------------------------

--[[
    Connects a new interface instance to add hover/unhover behaviour
    @param interface Interface to connect
    @param hoverMethod Hover method to run
    @param unhoverMethod Unhover method to run
    @error This method can only be used on client-side
]]
function HoverService.connect(interface : GuiBase2d, hoverMethod : (() -> ())?, unhoverMethod : (() -> ())?)
    assert(RunService:IsClient(), "This method can be only used in the client!")

    if interface:IsA("GuiButton") then
        if connectedInterfaces[interface] then
            HoverService.disconnect(interface)
        end

        connectedInterfaces[interface] = {
            ui = interface,
            hoverMethod = if hoverMethod then interface.MouseEnter:Connect(hoverMethod) else nil,
            unhoverMethod = if unhoverMethod then interface.MouseLeave:Connect(unhoverMethod) else nil,
            isButton = true
        }

        return
    end


    local aabb : AABB.AABB = AABB.new(
        interface.AbsolutePosition.X, interface.AbsolutePosition.X + interface.AbsoluteSize.X,
        interface.AbsolutePosition.Y, interface.AbsolutePosition.Y + interface.AbsoluteSize.Y
    )

    noButtonConnectionsAmount += 1

    isHoveredInterface[interface] = aabb:isPointOver(Vector2.new(mouse.X, mouse.Y))
    connectedInterfaces[interface] = {
        ui = interface,
        hoverMethod = nil,
        unhoverMethod = nil,
        isButton = false
    }

    if mouseMoveEvent == nil then
        mouseMoveEvent = mouse.Move:Connect(function()
            local mousePosition = Vector2.new(mouse.X, mouse.Y)

            if aabb:isPointOver(mousePosition) then
                if hoverMethod and not isHoveredInterface[interface] then
                    hoverMethod()
                    isHoveredInterface[interface] = true
                end

                return
            end

            if unhoverMethod and isHoveredInterface[interface] then
                unhoverMethod()
                isHoveredInterface[interface] = false
            end
        end)
    end
end



--[[
    Disconnects the given interface from the hover and unhover events
    @error This method can only be used on client-side
]]
function HoverService.disconnect(interface : GuiBase2d)
    assert(RunService:IsClient(), "This method can be only used in the client!")

    local connectionData = connectedInterfaces[interface]

    if connectionData == nil then
        return
    end

    if connectionData.hoverMethod then
        connectionData.hoverMethod:Disconnect()
    end

    if connectionData.unhoverMethod then
        connectionData.unhoverMethod:Disconnect()
    end

    if not connectionData.isButton and noButtonConnectionsAmount > 0 then
        noButtonConnectionsAmount -= 1

        if noButtonConnectionsAmount <= 0 and mouseMoveEvent then
            mouseMoveEvent:Disconnect()
            mouseMoveEvent = nil
        end
    end
end



return HoverService