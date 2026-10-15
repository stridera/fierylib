-- Trigger: Smugg_guard_greet1
-- Zone: 363, ID: 4
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #36304

-- Converted from DG Script #36304: Smugg_guard_greet1
-- Original: MOB trigger, flags: GREET, probability: 40%

-- 40% chance to trigger
if not percent_chance(40) then
    return true
end
-- This is a cute lil greet for the chief guard.
-- 36306 -> (zone_id 363, local_id 6) chief guard
if actor.zone_id == 363 and actor.local_id == 6 then
    self:emote("snaps to attention.")
else
    -- switch on actor:get_quest_stage("illusionist_subclass")
    do
        local _sw1 = string.lower(tostring(actor:get_quest_stage("illusionist_subclass") or ""))
        if tonumber(_sw1) == 0 then
        elseif tonumber(_sw1) == 1 or tonumber(_sw1) == 2 then
            wait(2)
            self:command("gasp")
            wait(2)
            self:say("Cestia!  How nice it is to see you again.")
            wait(3)
            self:command("smile " .. tostring(actor.name))
        elseif tonumber(_sw1) == 3 then
            wait(2)
            self:command("look " .. tostring(actor.name))
            wait(3)
            self:command("ponder")
        elseif tonumber(_sw1) == 4 then
            wait(1)
            self:emote("looks rather worried.")
            wait(3)
            self:say("I hope they don't make it this far.  I'm not that good at fighting!")
        elseif tonumber(_sw1) == 5 then
            wait(1)
            self:command("glare " .. tostring(actor.name))
            wait(2)
            self:say("Cestia, I heard you brought a posse from Mielikki with you!")
            wait(4)
            self:say("We ought to offer you up to them!")
        elseif tonumber(_sw1) == 6 then
            wait(1)
            self:say("Aha!  If it isn't the little thief herself!")
            wait(0.4)
            combat.engage(actor)
        end
    end
end