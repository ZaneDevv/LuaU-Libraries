--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/22

-------------------------------------
-- Constants
-------------------------------------

local RESOURCE_FORMAT = "rbxassetid://%s"

-------------------------------------
-- Services
-------------------------------------

local SoundService = game:GetService("SoundService")

-------------------------------------
-- Variables
-------------------------------------

local SFXService = {}

-------------------------------------
-- Methods
-------------------------------------

--[[
    Plays the sound with the given id and the given parameters
    @param id Sound's id
    @param pitch Sound's pitch
]]
function SFXService.PlaySound(id : number, parent: Instance?, volume: number?, speed : number?, pitch : number?)
    local sound : Sound = Instance.new("Sound")
    sound.SoundId = string.format(RESOURCE_FORMAT, id)
    sound.Volume = volume or 0.5
    sound.PlaybackSpeed = speed or 1
    sound.Parent = parent or SoundService

    if pitch then
        local pitchEffect : PitchShiftSoundEffect = Instance.new("PitchShiftSoundEffect")
        pitchEffect.Octave = pitch
        pitchEffect.Parent = sound
    end

    sound:Play()
    sound.Ended:Wait()
    sound:Destroy()
end


return SFXService