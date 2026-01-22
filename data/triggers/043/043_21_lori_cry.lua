-- Trigger: lori_cry
-- Zone: 43, ID: 21
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4321

-- Converted from DG Script #4321: lori_cry
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:emote("breaks down crying.")
wait(5)
self:emote("forces herself to stand up straight.")
self:say("I will NOT let this get to me.  I am better than this!")
wait(3)
self:command("sniff")
wait(3)
self.room:send(tostring(self.name) .. " says, 'If I can dance well enough, I'll win him back.  This show must")
self.room:send("</>be PERFECT!'")
wait(2)
self:emote("nods with conviction.")