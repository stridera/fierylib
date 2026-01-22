-- Trigger: illusory_wall_lyara_speech1
-- Zone: 364, ID: 1
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #36401

-- Converted from DG Script #36401: illusory_wall_lyara_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: reinforcements reinforcements? guard guard?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "reinforcements") or string.find(string.lower(speech), "reinforcements?") or string.find(string.lower(speech), "guard") or string.find(string.lower(speech), "guard?")) then
    return true  -- No matching keywords
end
if (string.find(actor.class, "illusionist") or string.find(actor.class, "bard")) and actor.level > 56 then
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Yes, they still send requests for reinforcements")
    self.room:send("</>from time to time.'")
    wait(4)
    self:say("Wait, do you not know who I am?")
    wait(4)
    self:command("laugh")
    self:say("The name's Lyara.  Post Commander Ruzhana Lyara.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'I served with the Eldorian Guard for many years as")
    self.room:send("</>Post Commander, the master of fortifications.  My speciality is magical walls")
    self.room:send("</>and barriers, particularly <b:magenta>I<cyan>l<magenta>l<cyan>u<magenta>s<cyan>o<magenta>r<cyan>y <magenta>W<cyan>a<magenta>l<cyan>l</>.  Even after my retirement, many have")
    self.room:send("</>sought me out asking me to teach them.'")
end