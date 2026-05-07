-- Trigger: Treant refuse
-- Zone: 625, ID: 5
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62505

-- Converted from DG Script #62505: Treant refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%
--
-- TODO(parity): The legacy script's RECEIVE filter referenced three
-- variable IDs (%wandgem%, %wand_id%, %wandtask3%) that came from a
-- separate phase-wand quest's load script and are not in scope here.
-- The original ran at 0% probability so the body was effectively
-- dead. Left as a no-op until the treant's accept-list is decided.

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
wait(1)
self:command("grumble")
self:command("drop " .. tostring(object))
