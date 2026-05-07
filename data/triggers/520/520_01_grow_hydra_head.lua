-- Trigger: grow_hydra_head
-- Zone: 520, ID: 1
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #52001

-- Converted from DG Script #52001: grow_hydra_head
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- Only do this if killer %actor% exists, otherwise they were killed by death of body!
if actor then
    -- If killer holds a lit branch (obj 520:34) or burning branch (520:35),
    -- the wound cauterises and no new head grows.
    local no_head = actor:has_equipped(520, 35)
    if not no_head then
        no_head = actor:has_equipped(520, 34)
    end
    if no_head then
        self.room:send_except(actor, tostring(actor.name) .. " seals the Hydra's neck with " .. tostring(no_head.shortdesc) .. ", preventing another head from growing!")
        actor:send("You cauterize the wound with " .. tostring(no_head.shortdesc) .. " - no more heads from there!")
    elseif random(1, 100) > 65 then
        self.room:send_except(actor, "As soon as " .. tostring(actor.name) .. " strikes the head from the body a new one grows!")
        actor:send("As soon as you chop the head off, another one starts to grow!")
        self.room:spawn_mobile(520, 9)
    else
        self.room:send_except(actor, "As soon as " .. tostring(actor.name) .. " strikes the head from the body TWO new ones grow!")
        actor:send("As soon as you chop the head off, TWO new ones appear!")
        self.room:spawn_mobile(520, 9)
        self.room:spawn_mobile(520, 9)
    end
    if world.count_mobiles(520, 9) >= 30 then
        self.room:send("The heads begin to scream and fly in all directions, and COMPLETELY ANNIHILATE YOU!")
    end
end
return true