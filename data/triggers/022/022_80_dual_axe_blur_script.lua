-- Trigger: dual_axe_blur_script
-- Zone: 22, ID: 80
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #2280

-- Converted from DG Script #2280: dual_axe_blur_script
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command filter: Niamh
if not (cmd == "Niamh") then
    return true  -- Not our command
end
self:say("My trigger commandlist is not complete!")