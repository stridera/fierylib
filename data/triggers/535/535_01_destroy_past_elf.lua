-- Trigger: Destroy past elf
-- Zone: 535, ID: 1
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #53501

-- Converted from DG Script #53501: Destroy past elf
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
local _return_value = true  -- Default: allow action
if (actor.id >= 53500) & (actor.id <= 53508) then
    _return_value = false
    actor:send("You can't go that way!")
end
return _return_value