-- Trigger: Domain_Newbie_Guard
-- Zone: 40, ID: 3
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #4003
-- A guardian mob warns players below level 30 away from descending
-- deeper into the domain. Higher-level players and NPCs pass freely.
-- TODO: the original DG script likely returned 0 (block) on the
-- low-level branch; the converter currently returns true (allow)
-- and merely emits whisper + wink. Confirm intended block semantics
-- and switch the warn branch to `return false` if it should hold the
-- player back.

-- Command filter: down
if cmd ~= "down" then
    return true  -- Not our command
end

if actor.is_player and actor.level < 30 then
    self:whisper(actor.name, "Greetings young one, thou art brave but not strong enough to stride forth into these depths.")
    wait(1)
    self:whisper(actor.name, "Move towards the blackened sands to find battle for now.")
    self:command("wink " .. tostring(actor.name))
end

return true
