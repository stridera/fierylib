-- Trigger: fastrada_book
-- Zone: 43, ID: 27
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4327

-- Converted from DG Script #4327: fastrada_book
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:emote("thumbs through a book on her shelf.")
wait(2)
self:emote("looks thoroughly bored.")
wait(2)
self:command("sigh")
wait(5)
self.room:send(tostring(self.name) .. " says, 'If only I had one of those trashy harlequin novels to help pass")
self.room:send("</>the time.'")
wait(3)
self:command("grin")
wait(3)
self:say("Or a trashy harlequin man.")
wait(4)
self:command("cackle")
wait(2)
self:command("sigh")