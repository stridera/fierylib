-- Trigger: Ranger greetings
-- Zone: 502, ID: 10
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #50210

-- Converted from DG Script #50210: Ranger greetings
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 and actor.level < 100 then
    wait(6)
    if world.count_mobiles("50209") < 1 then
        self:emote("discreetly takes note of your passage.")
        wait(3)
        self:emote("notices you looking at him, and bows before you with a wry grin.")
    else
        self:emote("watches you with some interest.")
        wait(2)
        self:say("Looking for someone?")
    end
end