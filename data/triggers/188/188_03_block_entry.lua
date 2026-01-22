-- Trigger: Block_entry
-- Zone: 188, ID: 3
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #18803

-- Converted from DG Script #18803: Block_entry
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
local _return_value = true  -- Default: allow action
-- 
-- Block-Entry Trigger
-- Checks to see if player is coming from the east and wearing the cloak.
-- If not, doesn't allow entry.
-- 
if direction == "east" then
    if actor.level > 99 or actor.level == then
    elseif actor:get_worn("12") == 18801 then
        actor:send("The TCD-GUARD squints at you and then nods and waves you in.")
        self.room:send_except(actor, "The TCD-GUARD squints at " .. tostring(actor.alias) .. " and waves " .. tostring(actor.possessive) .. " in.")
        _return_value = true
    else
        actor:send("The TCD-GUARD puts his hand out in front of you.")
        actor:send("The TCD-GUARD says, 'Hmmph!  Think again, buddy.'")
        self.room:send_except(actor, "The TCD-GUARD puts his hand up, blocking " .. tostring(actor.alias) .. " from entering the guild.")
        _return_value = false
    end
else
end  -- auto-close block
return _return_value