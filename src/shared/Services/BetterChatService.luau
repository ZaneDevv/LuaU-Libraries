--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/22

-------------------------------------
-- Constants
-------------------------------------

-------------------------------------
-- Types
-------------------------------------

-- Tag conditions type
type tagCondition = (number) -> boolean

-- Type for tags data
type tagsData = {color : string, name : string, condition : tagCondition?}

-------------------------------------
-- Services
-------------------------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService('TextChatService')
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-------------------------------------
-- Variables
-------------------------------------

local BetterChatService = {}

local tags : {tagsData} = {}

local Channel = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")

-------------------------------------
-- Modules
-------------------------------------

local libraries = ReplicatedStorage.Shared.Libraries
local Color = require(libraries.Color)

-------------------------------------
-- Methods
-------------------------------------

--[[
    Method to run when something in the chat in written
    @param message Sent message data
    @return Message properties
]]
local function onMessageSent(message: TextChatMessage) : TextChatMessageProperties?
    if not message.TextSource then
		return
	end

    local playerId = message.TextSource.UserId
    local player = Players:GetPlayerByUserId(playerId)
    if not player then
		return
	end

    local messageProperties = Instance.new("TextChatMessageProperties")

    for _, tagData : tagsData in ipairs(tags) do
        local canSetTag = true

        if tagData.condition then
            canSetTag = tagData.condition(playerId)
        end 

        if not canSetTag then
            continue
        end
    end

    return messageProperties
end


--[[
    Adds a tag to a specific user with the given id
    @param color Tag's color
    @param tagName Tag's name
    @param id User's id to give the tag
]]
function BetterChatService.addTagByPlayerId(color : string, tagName : string, id : number)
    assert(RunService:IsClient(), "This methos can only be utilized on client-side")
    assert(Color.isHexadecimalColor(color), "Unrecognizable color for the tag")

    table.insert(tags, {
        color = color,
        name = tagName,
        condition = function(texterId : number)
            return texterId == id
        end
    })

    if TextChatService.OnIncomingMessage == nil then
        TextChatService.OnIncomingMessage = onMessageSent
    end    
end


--[[
    Adds a tag to the user which satisfies the given condition
    @param color Tag's color
    @param tagName Tag's name
    @param condition Condition to give the tag to the user
]]
function BetterChatService.addTagByCondition(color : string, tagName : string, condition : tagCondition)
    assert(RunService:IsClient(), "This methos can only be utilized on client-side")
    assert(Color.isHexadecimalColor(color), "Unrecognizable color for the tag")

    table.insert(tags, {
        color = color,
        name = tagName,
        condition = condition
    })

    if TextChatService.OnIncomingMessage == nil then
        TextChatService.OnIncomingMessage = onMessageSent
    end    
end


--[[
    Sends the given message to the chat
    @param message Message to send
]]
function BetterChatService.sendMessage(message : string)
    assert(RunService:IsClient(), "This methos can only be utilized on client-side")
    Channel:DisplaySystemMessage(message)
end



return BetterChatService