-- Trigger: leviathan block
-- Zone: 484, ID: 236
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #48636

-- Converted from DG Script #48636: leviathan block
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
local _return_value = true  -- Default: allow action
if actor and (actor.is_player) and self:get_people("48635") and (actor.level < 100) then
    actor:send("The colossal body of the Leviathan blocks your passage, throwing you back.")
    _return_value = true
end
return _return_value