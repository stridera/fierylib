-- Trigger: dwarven_merc_greet1
-- Zone: 61, ID: 5
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #6105

-- Converted from DG Script #6105: dwarven_merc_greet1
-- Original: MOB trigger, flags: GREET, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
-- Original DG: `if %actor.name% == -1` was a typo of `%actor.vnum% == -1`
-- (the DG idiom for "actor is a player"). Restore the player check.
if actor.is_player then
    self:command("nudge " .. tostring(actor.name))
    self:say("Hey " .. tostring(actor.name) .. ", did I tell you about the part I played in the Great Duergar Wars?")
    self:command("strut")
    self:say("I captured three duergar captains single-handedly.")
end