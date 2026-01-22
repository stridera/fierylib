-- Trigger: ice_shards_khysan_speech1
-- Zone: 103, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #10310

-- Converted from DG Script #10310: ice_shards_khysan_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: spell spell? powerful powerful?  Ever ever?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "spell") or string.find(string.lower(speech), "spell?") or string.find(string.lower(speech), "powerful") or string.find(string.lower(speech), "powerful?") or string.find(string.lower(speech), "ever") or string.find(string.lower(speech), "ever?")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "Cryomancer") then
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'The spell was called Ice Shards.  Supreme cryomancers")
    self.room:send("</>could conjure a multitude of glistening ice fragments to annihilate their")
    self.room:send("</>foes.'")
    wait(2)
    self:say("But that magic is lost to us now.")
end