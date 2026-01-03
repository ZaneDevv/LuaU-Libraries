--!strict
--@author Álvaro Fernández Barrero
--@date 2026/12/02

-------------------------------------
-- Types
-------------------------------------

type AdminUi = ScreenGui & {
    Frame : Frame & {
        CommandText : TextLabel & {
            UIPadding : UIPadding
        },
        Command : TextBox & {
            UIPadding : UIPadding
        }
    }
}

-------------------------------------
-- Services
-------------------------------------

local Players = game:GetService("Players")

-------------------------------------
-- Variables
-------------------------------------

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-------------------------------------
-- Methods
-------------------------------------

return function(commandPrefix : string) : AdminUi
    local screenUi = Instance.new("ScreenGui") :: AdminUi do
        screenUi.Name = "ADMIN"
        screenUi.ResetOnSpawn = false
        screenUi.DisplayOrder = math.huge
        screenUi.Parent = playerGui

        local frame = Instance.new("Frame") do
            frame.BackgroundColor3 = Color3.fromHex("#202227")
            frame.Size = UDim2.fromScale(0.6, 0.6)
            
            frame.Parent = screenUi

            local uiCorner = Instance.new("UICorner") do
                uiCorner.Parent = frame
            end

            local uiAspectRatioConstraint = Instance.new("UIAspectRatioConstraint") do
                uiAspectRatioConstraint.AspectRatio = 2
                uiAspectRatioConstraint.Parent = frame
            end
        end

        local textBox = Instance.new("TextBox") do
            textBox.Size = UDim2.fromScale(1, 0.1)
            textBox.Position = UDim2.fromScale(0, 1)
            textBox.AnchorPoint = Vector2.yAxis
            textBox.Name = "Command"
            textBox.Text = commandPrefix
            textBox.ClearTextOnFocus = false
            textBox.TextXAlignment = Enum.TextXAlignment.Left
            textBox.Parent = frame

            local uiPadding = Instance.new("UIPadding") do
                uiPadding.PaddingLeft = UDim.new(0.01, 0)
                uiPadding.PaddingRight = UDim.new(0.01, 0)
                uiPadding.Parent = textBox
            end
        end

        local commandTextLabel = Instance.new("TextLabel") do
            commandTextLabel.RichText = true
            commandTextLabel.Size = textBox.Size
            commandTextLabel.Position = textBox.Position
            commandTextLabel.AnchorPoint = textBox.AnchorPoint
            commandTextLabel.TextXAlignment = textBox.TextXAlignment
            commandTextLabel.TextScaled = true
            commandTextLabel.Text = textBox.Text
            commandTextLabel.Name = "CommandText"
            commandTextLabel.Parent = frame

            local uiPadding = Instance.new("UIPadding") do
                uiPadding.PaddingLeft = (textBox :: TextBox & {UIPadding : UIPadding}).UIPadding.PaddingLeft
                uiPadding.PaddingRight = (textBox :: TextBox & {UIPadding : UIPadding}).UIPadding.PaddingRight
                uiPadding.Parent = commandTextLabel
            end
        end
    end

    return screenUi
end