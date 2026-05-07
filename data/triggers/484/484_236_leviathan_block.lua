-- Trigger: leviathan block
-- Zone: 484, ID: 236
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #48636

-- Converted from DG Script #48636: leviathan block
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
-- TODO(parity): self:get_people("48635") was DG's "is mob 48635 in this
--   room"; replace with `world.count_mobiles(484, 235) > 0` (Leviathan,
--   converted-zone form) or a room-scoped query once available. As-is
--   this call will likely raise; the gate fails open.
local _return_value = true  -- Default: allow action
if actor and (actor.is_player) and (world.count_mobiles(484, 235) > 0) and (actor.level < 100) then
    actor:send("The colossal body of the Leviathan blocks your passage, throwing you back.")
    _return_value = true
end
return _return_value