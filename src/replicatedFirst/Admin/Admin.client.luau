--!strict
--@author Álvaro Fernández Barrero
--@date 2026/12/02

-------------------------------------
-- Constants
-------------------------------------

local COMMAND_BAR_PREFIX = "admin > "

local UNEXISTENT_COMMAND_COLOR = "B00"

-------------------------------------
-- Services
-------------------------------------

local Players = game:GetService("Players")

-------------------------------------
-- Variables
-------------------------------------

local localPlayer = Players.LocalPlayer

local adminIds = {807760030}
local isAdmin = table.find(adminIds, localPlayer.UserId) ~= nil

do
    if not isAdmin then
        task.defer(function()
            script.Parent:Destroy()
        end)
        
        return
    end
end


local commands = require(script.Parent:WaitForChild("Commands"))

local ui = require(script.Parent:WaitForChild("GenerateAdminUi"))(COMMAND_BAR_PREFIX)
local commandBar = ui.Frame.CommandText
local commandTextBox = ui.Frame.Command


-------------------------------------
-- Methods
-------------------------------------

--[[

]]
local function ensureCommandPrefix()
    if utf8.len(commandTextBox.Text) < #COMMAND_BAR_PREFIX  then
        commandTextBox.Text = COMMAND_BAR_PREFIX
        commandTextBox.CursorPosition = #COMMAND_BAR_PREFIX + 1
    end
end


--[[

]]
local function onCommandBarChange()
    ensureCommandPrefix()

    local commandText = string.sub(commandTextBox.Text, #COMMAND_BAR_PREFIX)
    commandBar.Text = COMMAND_BAR_PREFIX .. commandText

    local writtenCommandData = string.split(commandText:lower(), " ")
    local commandName = writtenCommandData[1]

    if #commandName == 0 then
        return
    end

    local command = commands[commandName]
    if command == nil then
        commandBar.Text = `{COMMAND_BAR_PREFIX}<font color="#{UNEXISTENT_COMMAND_COLOR}">{commandName}</font> {table.concat(writtenCommandData, " ", 2)}`

        return
    end
end

-------------------------------------
-- Connections
-------------------------------------   

commandTextBox:GetPropertyChangedSignal("Text"):Connect(onCommandBarChange)