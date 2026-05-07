-- Trigger: men-only
-- Zone: 103, ID: 6
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #10306
-- Block women below level 100 from entering. PREENTRY returns
-- false to veto the move; true allows it.

if actor.level < 100 and actor.gender == "female" then
    actor:send("That room is for men only!")
    return false
end
return true
