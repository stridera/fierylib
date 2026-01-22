-- Trigger: wiseman speech
-- Zone: 489, ID: 24
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #48924

-- Converted from DG Script #48924: wiseman speech
-- Original: MOB trigger, flags: GREET, probability: 100%
local chance = random(1, 10)
if chance > 5 then
    wait(1)
    self:command("grumble")
    self:emote("protests, 'I'm not a well man.'")
    self:emote("says slowly, 'I shouldn't have to be doing this.'")
end