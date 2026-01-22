-- Trigger: monk_subclass_quest_arre_speech4
-- Zone: 51, ID: 9
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5109

-- Converted from DG Script #5109: monk_subclass_quest_arre_speech4
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: quest quest?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "quest") or string.find(string.lower(speech), "quest?")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("monk_subclass") == 1 then
    actor.name:advance_quest("monk_subclass")
    actor:send(tostring(self.name) .. " says, 'Alright, well sit back.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Usually people come in here promising me the return of something long lost of mine.'")
    self:command("scratch")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'The thing is, I have not always led this life.  When I was young I was quite the rabble-rouser.'")
    self:emote("looks wistfully for a moment.")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Well, it is rather embarrassing, but...  I miss my old sash, and I want it back.'")
    wait(2)
    self:emote("shakes her head.")
    actor:send(tostring(self.name) .. " says, 'I was told it looked wonderful on me.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, '" .. tostring(actor.name) .. ", can you recover it?'")
    wait(1)
    actor:send(tostring(self.name) .. " whispers to you, 'Please?'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Long ago some ruthless <b:cyan>fiends</> made off with it.'")
end