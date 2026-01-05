--!strict
--@author Álvaro Fernández Barrero
--@date 2026/01/04

-------------------------------------
-- Services
-------------------------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-------------------------------------
-- Load
-------------------------------------

require(ReplicatedStorage.Shared.Utils.ModuleLoader)(ServerScriptService.Scripts)