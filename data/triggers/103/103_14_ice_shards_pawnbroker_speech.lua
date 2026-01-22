-- Trigger: ice_shards_pawnbroker_speech
-- Zone: 103, ID: 14
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #10314

-- Converted from DG Script #10314: ice_shards_pawnbroker_speech
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: butcher
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "butcher")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("ice_shards") == 4 then
    self:say("Sorry, never heard of 'im.")
    wait(1)
    self:command("cough")
    self:emote("very conspicuously lays his open hand on the counter.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'I have some great old boots for sale though.")
    self.room:send("</>Only <b:white>100 platinum</>.'")
else
    self:say("Ya might not wanna be so loud with that name round 'ere.")
end