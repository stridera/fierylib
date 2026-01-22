-- Trigger: berserker_hjordis_speech3
-- Zone: 364, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #36411

-- Converted from DG Script #36411: berserker_hjordis_speech3
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: wild hunt
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "wild") or string.find(string.lower(speech), "hunt")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("berserker_subclass") == 1 then
    actor:advance_quest("berserker_subclass")
    self:command("nod")
    actor:send(tostring(self.name) .. " says, 'It is a tradition passed down through the generations.  We challenge the Spirits for the right to prove ourselves.  If they deem you worthy, the Spirits send you a vision of a mighty <b:cyan>beast</>.'")
end