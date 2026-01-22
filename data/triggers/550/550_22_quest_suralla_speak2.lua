-- Trigger: quest_suralla_speak2
-- Zone: 550, ID: 22
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55022

-- Converted from DG Script #55022: quest_suralla_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: quest reward
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "quest") or string.find(string.lower(speech), "reward")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("cryomancer_subclass") == 1 then
    actor.name:advance_quest("cryomancer_subclass")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'It is quite simple.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'My counterpart, the great Emmath Firehand, long ago battled with me once.'")
    self:emote("reminisces for a brief moment, looking thoughtful.")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'It was not serious by any means, but it did end in a stalemate.  The catch however...'")
    wait(1)
    self:command("sigh")
    wait(1)
    actor:send(tostring(self.name) .. " says, '... is that what we battled over may still be <b:cyan>suffering</>.'")
    self:emote("sighs deeply again.")
end