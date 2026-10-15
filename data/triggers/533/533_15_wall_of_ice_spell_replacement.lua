-- Trigger: wall_of_ice_spell_replacement
-- Zone: 533, ID: 15
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #53315
--
-- If a player on the wall_ice quest says "please replace the spell",
-- the sculptor spawns and gives them another copy of the spell notes
-- (object 533, 26).
--
-- Original DG had probability 0% (synthetic gate); removed.
-- Original keyword filter was OR'd across each word; tightened to a
-- phrase match so casual mentions of "the" or "spell" don't fire it.

-- Speech phrase: please replace the spell (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]please replace the spell[%s%p]") then
    return true  -- Not the phrase
end
wait(0.2)
if actor:get_quest_stage("wall_ice") > 0 then
    self:say("Oh sure.  But be careful.  Don't lose this spell again.")
    self.room:spawn_object(533, 26)
    self:command("give spell-living-ice " .. tostring(actor.name))
end