--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/20

-------------------------------------
-- Types
-------------------------------------

-- Type which stores the needed information about the connections of a ui object
type savedInterfaces = {ui : GuiBase, hoverMethod : (RBXScriptConnection | () -> ())?, unhoverMethod : (RBXScriptConnection | () -> ())?, isButton : boolean}

-------------------------------------
-- Services
-------------------------------------

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-------------------------------------
-- Modules
-------------------------------------

local AABB = require(ReplicatedStorage.Shared.Libraries.AABB)

-------------------------------------
-- Variables
-------------------------------------

local HoverService = {}

local connectedInterfaces : {[GuiBase2d]: savedInterfaces} = {} :: savedInterfaces
local isHoveredInterface : {[GuiBase2d] : {isHovered : boolean, aabb : AABB.AABB}} = {}

local defaultHoverMethod : ((GuiBase2d) -> ())? = nil
local defaultUnhoverMethod : ((GuiBase2d) -> ())? = nil

local mouseMoveEvent : RBXScriptConnection? = nil
local noButtonConnectionsAmount : number = 0

-------------------------------------
-- Player related variables
-------------------------------------

local localPlayer : Player = Players.LocalPlayer
local mouse : Mouse = localPlayer:GetMouse()

-------------------------------------
-- Methods
-------------------------------------

--[[
    Connects the mouse behaviour
    @param hoverMethod Method to run when the mouse is spotted on a interface which is not a button
    @param unhoverMethod Method to run when the mouse releases a interface which is not a button
]]
local function connectMouseEvent(hoverMethod : ((GuiBase2d) -> ())?, unhoverMethod : ((GuiBase2d) -> ())?)
    mouseMoveEvent = mouse.Move:Connect(function()
        local mousePosition = Vector2.new(mouse.X, mouse.Y)

        for interface : GuiBase2d, data in pairs(isHoveredInterface) do
            local isMouseOverInterface = data.aabb:isPointOver(mousePosition)

            if isMouseOverInterface then
                if hoverMethod and not isHoveredInterface[interface].isHovered then
                    hoverMethod(interface)
                    isHoveredInterface[interface].isHovered = true
                end
    
                continue
            end
    
            if unhoverMethod and isHoveredInterface[interface].isHovered then
                unhoverMethod(interface)
                isHoveredInterface[interface].isHovered = false
            end
        end
    end)
end


--[[
    Connects a new interface instance to add hover/unhover behaviour
    @param interface Interface to connect
    @param hoverMethod Hover method to run
    @param unhoverMethod Unhover method to run
    @error This method can only be used on client-side
]]
function HoverService.connect(interface : GuiBase2d, hoverMethod : ((GuiBase2d?) -> ())?, unhoverMethod : ((GuiBase2d?) -> ())?)
    assert(RunService:IsClient(), "This method can be only used in the client!")

    -- Logic for buttons
    if interface:IsA("GuiButton") then
        -- Obtaining the actual methods for buttons
        if hoverMethod == nil and defaultHoverMethod ~= nil then
            hoverMethod = function()
                defaultHoverMethod(interface)
            end
        end

        if unhoverMethod == nil and defaultUnhoverMethod ~= nil then
            unhoverMethod = function()
                defaultUnhoverMethod(interface)
            end
        end

        if connectedInterfaces[interface] then
            HoverService.disconnect(interface)
        end

        connectedInterfaces[interface] = {
            ui = interface,
            hoverMethod = if hoverMethod then interface.MouseEnter:Connect(hoverMethod :: () -> ()) else nil,
            unhoverMethod = if unhoverMethod then interface.MouseLeave:Connect(unhoverMethod :: () -> ()) else nil,
            isButton = true
        }

        return
    end

    -- Logic for no-button instances (frames, labels...)
    local aabb : AABB.AABB = AABB.fromGui(interface)
    noButtonConnectionsAmount += 1

    isHoveredInterface[interface] = {
        isHovered = aabb:isPointOver(Vector2.new(mouse.X, mouse.Y)),
        aabb = aabb,
    }
    connectedInterfaces[interface] = {
        ui = interface,
        hoverMethod = nil,
        unhoverMethod = nil,
        isButton = false
    }

    if mouseMoveEvent == nil then
        connectMouseEvent(hoverMethod or defaultHoverMethod, unhoverMethod or defaultUnhoverMethod)
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

    if connectionData.isButton then
        if connectionData.hoverMethod then
            (connectionData.hoverMethod :: RBXScriptConnection):Disconnect()
        end

        if connectionData.unhoverMethod then
            (connectionData.unhoverMethod :: RBXScriptConnection):Disconnect()
        end
    end

    if not connectionData.isButton and noButtonConnectionsAmount > 0 then
        noButtonConnectionsAmount -= 1
        
        if noButtonConnectionsAmount <= 0 and mouseMoveEvent then
            mouseMoveEvent:Disconnect()
            mouseMoveEvent = nil
        end
    end

    isHoveredInterface[interface] = nil
    connectedInterfaces[interface] = nil
end


--[[
    Sets a default hover method
    @method Method to be fired when a connected interface is hovered by the player's mouse
]]
function HoverService.setDefaultHoverMethod(method : (GuiBase2d) -> ())
    defaultHoverMethod = method
end


--[[
    Sets a default unhover method
    @method Method to be fired when a connected interface is unhovered by the player's mouse
]]
function HoverService.setDefaultUnhoverMethod(method : (GuiBase2d) -> ())
    defaultUnhoverMethod = method
end


return HoverService