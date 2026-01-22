-- Trigger: red_blood_cell_pillow
-- Zone: 12, ID: 75
-- Type: OBJECT, Flags: GLOBAL, GIVE
-- Status: CLEAN
--
-- Original DG Script: #1275

-- Converted from DG Script #1275: red_blood_cell_pillow
-- Original: OBJECT trigger, flags: GLOBAL, GIVE, probability: 100%
local _return_value = true  -- Default: allow action
if (actor.name == "Laoris") and (victim.level <= 99) then
    _return_value = true
    wait(1)
    victim:command("wear red-blood-cell-pillow")
end
return _return_value