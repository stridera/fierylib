-- Trigger: young_witch_greet1
-- Zone: 480, ID: 5
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #48005

-- Converted from DG Script #48005: young_witch_greet1
-- Original: MOB trigger, flags: GREET, probability: 75%

-- 75% chance to trigger
if not percent_chance(75) then
    return true
end
if actor.id == -1 then
    if actor.level < 60 then
        actor.name:send("The young witch says, 'I may still be learning, but I know enough to destroy you.'")
    else
        actor.name:send("The young witch says, 'At last a chance to test myself on a worthy opponent.'")
    end
end