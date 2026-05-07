-- Trigger: minstrel_test
-- Zone: 238, ID: 40
-- Type: MOB, Flags: SPEECH
--
-- Saying "test" within earshot of the minstrel makes her remove her instrument
-- case (489:24, worn about body), play a mandolin piece, and pack everything
-- back up. If she isn't wearing the case, she just complains.

-- Speech keywords: test
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "test") then
    return true  -- No matching keywords
end
self.room:send("Wheeeeeeee")
if self:has_equipped(489, 24) then
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
