-- Trigger: Block_entry
-- Zone: 188, ID: 3
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #18803
-- Converted from DG Script #18803: Block_entry
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
--
-- Block-Entry Trigger
-- Checks to see if player is coming from the east and wearing the cloak.
-- If not, doesn't allow entry.
-- TODO(parity): `actor:get_worn("12") == 18801` mixes a slot accessor
--               (slot 12 = chest in legacy) with a legacy 5-digit object
--               vnum. Confirm runtime returns an Object, then compare
--               `obj.zone_id == 188 and obj.local_id == 1`.

if direction ~= "east" then
    return true  -- only east-bound entry is gated
end
if actor.level > 99 then
    return true  -- immortals pass freely
end
if actor:get_worn("12") == 18801 then
    actor:send("The TCD-GUARD squints at you then nods and waves you in.")
    self.room:send_except(actor, "The TCD-GUARD squints at " .. tostring(actor.alias) .. " and waves " .. tostring(actor.possessive) .. " in.")
    return false
end
actor:send("The TCD-GUARD puts his hand out in front of you.")
actor:send("The TCD-GUARD says, 'Hmmph!  Think again, buddy.'")
self.room:send_except(actor, "The TCD-GUARD puts his hand up, blocking " .. tostring(actor.alias) .. " from entering the guild.")
return true