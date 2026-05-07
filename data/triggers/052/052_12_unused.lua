-- Trigger: **UNUSED**
-- Zone: 52, ID: 12
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #5212
--
-- Stub. Original intercepted "se" command on a hidden room and was
-- superseded by trigger 52:0 (quest_pyro_dooropen). Kept as a no-op so
-- the trigger ID stays reserved.

if cmd ~= "se" then
    return true
end
return true
