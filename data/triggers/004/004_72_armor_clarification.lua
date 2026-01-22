-- Trigger: Armor clarification
-- Zone: 4, ID: 72
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #472

-- Converted from DG Script #472: Armor clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "armor" then
    _return_value = false
    actor:send("Please specify:")
    actor:send("Guild Armor Phase One")
    actor:send("Guild Armor Phase Two")
    actor:send("Guild Armor Phase Three")
    if (string.find(actor.class, "Priest") and actor.level >= 50) or (string.find(actor.class, "Cleric") and actor.level >= 65) then
        actor:send("Group Armor")
    end
end
return _return_value