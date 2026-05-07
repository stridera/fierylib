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

-- Speech keywords: wild, hunt
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "wild") or string.find(speech_lower, "hunt")) then
    return true
end
wait(2)
if actor:get_quest_stage("berserker_subclass") == 1 then
    actor:advance_quest("berserker_subclass")
    self:command("nod")
    actor:send(tostring(self.name) .. " says, 'It is a tradition passed down through the generations.  We challenge the Spirits for the right to prove ourselves.  If they deem you worthy, the Spirits send you a vision of a mighty <b:cyan>beast</>.'")
end