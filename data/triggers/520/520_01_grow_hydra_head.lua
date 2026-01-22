-- Trigger: grow_hydra_head
-- Zone: 520, ID: 1
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #52001

-- Converted from DG Script #52001: grow_hydra_head
-- Original: MOB trigger, flags: DEATH, probability: 100%
local _return_value = true  -- Default: allow action
-- Only do this if killer %actor% exists, otherwise they were killed by death of body!
if actor then
    -- return 0 for no death cry...
    _return_value = false
    -- If killer holds a lit branch (obj 52034) then no new head
    local no_head = 0
    if actor:has_equipped("52035") then
        local no_head = actor:has_equipped("52035")
    elseif actor:has_equipped("52034") then
        local no_head = actor:has_equipped("52034")
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
    if world.count_mobiles("52009") >= 30 then
        self.room:send("The heads begin to scream and fly in all directions, and COMPLETELY ANNIHILATE YOU!")
    end
end
return _return_value