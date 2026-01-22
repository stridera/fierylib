-- Trigger: wall_of_ice_spell_replacement
-- Zone: 533, ID: 15
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #53315

-- Converted from DG Script #53315: wall_of_ice_spell_replacement
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: please replace the spell
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "please") or string.find(string.lower(speech), "replace") or string.find(string.lower(speech), "the") or string.find(string.lower(speech), "spell")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("wall_ice") then
    self:say("Oh sure.  But be careful.  Don't lose this spell again.")
    self.room:spawn_object(533, 26)
    self:command("give spell-living-ice " .. tostring(actor))
end