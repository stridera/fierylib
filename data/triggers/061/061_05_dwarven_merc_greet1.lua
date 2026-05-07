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
-- The original DG had a typo on the actor-is-player check
-- (used the name field instead of the player-detection field).
-- Restored as actor.is_player.
if actor.is_player then
    self:command("nudge " .. tostring(actor.name))
    self:say("Hey " .. tostring(actor.name) .. ", did I tell you about the part I played in the Great Duergar Wars?")
    self:command("strut")
    self:say("I captured three duergar captains single-handedly.")
end