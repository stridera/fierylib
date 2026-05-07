-- Trigger: women-only
-- Zone: 103, ID: 7
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #10307
-- Block men below level 100 from entering. PREENTRY returns
-- false to veto the move; true allows it.

if actor.level < 100 and actor.gender == "male" then
    actor:send("That room is for women only!")
    return false
end
return true
