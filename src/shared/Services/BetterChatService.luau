--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/22

-------------------------------------
-- Constants
-------------------------------------

local DEFAULT_CHAT_COLOR = "#fff"

local TAG_FORMAT = "<font color=\"%s\">[%s]</font> %s"
local MESSAGE_FORMAT = "<font color=\"%s\">%s</font>"

local MAX_TAG_CHARACTERS = 8

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

        messageProperties.PrefixText = string.format(TAG_FORMAT, tagData.color, tagData.name, message.PrefixText)
    end

    return messageProperties
end


--[[
    Adds a tag to a specific user with the given id
    @param color Tag's hexadecimal color
    @param tagName Tag's name
    @param id User's id to give the tag
]]
function BetterChatService.addTagByPlayerId(color : string, tagName : string, id : number)
    assert(RunService:IsClient(), "This methos can only be utilized on client-side")
    assert(Color.isHexadecimalColor(color), "Unrecognizable color for the tag")
    assert(utf8.len(tagName) <= MAX_TAG_CHARACTERS, "The set tag name is too long")

    table.insert(tags, {
        color = color,
        name = tagName,
        condition = function(texterId : number)
            return texterId == id
        end
    })

    TextChatService.OnIncomingMessage = onMessageSent
end


--[[
    Adds a tag to the user which satisfies the given condition
    @param color Tag's hexadecimal color
    @param tagName Tag's name
    @param condition Condition to give the tag to the user
]]
function BetterChatService.addTagByCondition(color : string, tagName : string, condition : tagCondition)
    assert(RunService:IsClient(), "This methos can only be utilized on client-side")
    assert(Color.isHexadecimalColor(color), "Unrecognizable color for the tag")
    assert(utf8.len(tagName) <= MAX_TAG_CHARACTERS, "The set tag name is too long")

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
    @param message Message color
]]
function BetterChatService.sendMessage(message : string, color : string?)
    assert(RunService:IsClient(), "This method can only be utilized on client-side")

    if color == nil then
        color = DEFAULT_CHAT_COLOR
    else
        assert(Color.isHexadecimalColor(color), "Unrecognizable color for the tag")
    end

    message = string.format(MESSAGE_FORMAT, color, message)
    Channel:DisplaySystemMessage(message)
end



return BetterChatService