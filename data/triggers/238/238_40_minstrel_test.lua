-- Trigger: minstrel_test
-- Zone: 238, ID: 40
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #23840

-- Converted from DG Script #23840: minstrel_test
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: test
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "test")) then
    return true  -- No matching keywords
end
self.room:send("Wheeeeeeee")
if self:get_worn("12") == 48924 then
    self:command("remove instrument-case")
    self:command("open instrument-case")
    self:command("get mandolin instrument-case")
    self:command("hold mandolin")
    self:command("sit")
    wait(2)
    self.room:send(tostring(self.name) .. " begins to play a mandolin softly.")
    wait(2)
    self.room:send("The music builds into a swelling crescendo.")
    self.room:send_to_adjacent("Beautiful music floats in from somewhere nearby.")
    wait(4)
    self.room:send("The music begins to fade as " .. tostring(self.name) .. " wraps up the piece.")
    self.room:send_to_adjacent("The music fades away.")
    wait(2)
    self.room:send(tostring(self.name) .. " stops playing.")
    self:command("stand")
    self:command("bow")
    wait(2)
    self:command("put mandolin instrument-case")
    self:command("close instrument-case")
    self:command("wear instrument-case")
else
    self:say("I'm not wearing that")
end