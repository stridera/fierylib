-- Trigger: berserker_hjordis_speech4
-- Zone: 364, ID: 12
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #36412

-- Converted from DG Script #36412: berserker_hjordis_speech4
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: beast beast?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "beast") or string.find(string.lower(speech), "beast?")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("berserker_subclass") == 2 then
    actor:advance_quest("berserker_subclass")
    actor:send(tostring(self.name) .. " says, 'The target of our Wild Hunt is always left to the Spirits to determine.  It is always a ferocious predator.  But it could be just about anything.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'The task, however, is always the same: Hunt down your quarry and slay it in <b:red>single combat</>.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'If you do, the Spirits will herald you as a berserker.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'When you are ready, <b:red>howl</> to the spirits and make your song known!'")
end