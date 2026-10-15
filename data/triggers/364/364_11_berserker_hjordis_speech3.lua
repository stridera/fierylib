-- Trigger: berserker_hjordis_speech3
-- Zone: 364, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- On stage 1 of berserker_subclass, hearing "wild" or "hunt" advances the
-- quest to stage 2 and explains the Wild Hunt. (Legacy probability was 0%,
-- which is a converter artefact: the gate is purely keyword-driven.)
--
-- Original DG Script: #36411

-- Speech phrase: wild hunt (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]wild hunt[%s%p]") then
    return true  -- Not the phrase
end
wait(0.2)
if actor:get_quest_stage("berserker_subclass") == 1 then
    actor:advance_quest("berserker_subclass")
    self:command("nod")
    actor:send(tostring(self.name) .. " says, 'It is a tradition passed down through the generations.  We challenge the Spirits for the right to prove ourselves.  If they deem you worthy, the Spirits send you a vision of a mighty <b:cyan>beast</>.'")
end