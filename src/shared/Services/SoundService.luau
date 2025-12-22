--!strict
--@author Álvaro Fernández Barrero
--@date 2025/12/22

-------------------------------------
-- Constants
-------------------------------------

local RESOURCE_FORMAT = "rbxassetid://%s"

-------------------------------------
-- Variables
-------------------------------------

local SoundService = {}

-------------------------------------
-- Methods
-------------------------------------

--[[
    Plays the sound with the given id and the given parameters
    @param id Sound's id
    @param pitch Sound's pitch
]]
function SoundService.PlaySound(id : number, volume: number?, speed : number?, pitch : number?)
    local sound : Sound = Instance.new("Sound")
    sound.SoundId = string.format(RESOURCE_FORMAT, id)
    sound.Volume = volume or 0.5
    sound.PlaybackSpeed = speed or 1

    if pitch then
        local pitchEffect : PitchShiftSoundEffect = Instance.new("PitchShiftSoundEffect")
        pitchEffect.Octave = pitch
        pitchEffect.Parent = sound
    end

    sound:Play()
    sound.Ended:Wait()
    sound:Destroy()
end


return SoundService