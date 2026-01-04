--!strict
--@author Álvaro Fernández Barrero
--@date 2026/01/04

-------------------------------------
-- Variables
-------------------------------------

local timer = 0

-------------------------------------
-- Methods
-------------------------------------

local function load(folder : Folder)
    timer = os.clock()

    for _, child : Instance in ipairs(folder:GetChildren()) do
        if os.clock() - timer >= 0.1 then
            task.wait()
            timer = os.clock()
        end

        if child:IsA("ModuleScript") then
            local successOnLoad, module = pcall(require, child :: ModuleScript)

            if successOnLoad then
                if module.init then
                    module.init()
                end
            else
                warn(`[MODULE LOADER]: The module {child:GetFullName()} could now be loaded, {module}`)
            end

        elseif child:IsA("Folder") and child:GetAttribute("Load") == true then
            load(child)
        end
    end
end

return load