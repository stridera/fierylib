-- Trigger: LP2_bard_subclass_speech2
-- Zone: 43, ID: 59
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4359

-- Converted from DG Script #4359: LP2_bard_subclass_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: borrow borrow? someone someone? who who?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "borrow") or string.find(string.lower(speech), "borrow?") or string.find(string.lower(speech), "someone") or string.find(string.lower(speech), "someone?") or string.find(string.lower(speech), "who") or string.find(string.lower(speech), "who?")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("bard_subclass") == 2 then
    self:command("roll")
    actor:send(tostring(self.name) .. " says, 'I mean go beat up an actor and take their shoes!'")
elseif actor:get_quest_stage("bard_subclass") == 3 then
    self:command("nod")
    actor:send(tostring(self.name) .. " says, 'She used to play Berthe, the granddam of our little show.  Retired some years back to a big house on a hill just west of Mielikki.  Heard she passed away, but all her stuff is still just sitting in the house.'")
    wait(6)
    actor:send(tostring(self.name) .. " says, 'I'd go get back the script, but...'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I can't go back to Mielikki, I'm a bad bad man.'")
    self:command("grin")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Really though, those guards are not joking around!'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Why don't you go see if you can find her <b:yellow>script</>.  She would probably have kept it with her most prized possessions.  When you find it, look through it and see if any lines stick with you.'")
    wait(6)
    actor:send(tostring(self.name) .. " says, 'Come back, give me the script, and <b:cyan>say a line or two</> for me.'")
end