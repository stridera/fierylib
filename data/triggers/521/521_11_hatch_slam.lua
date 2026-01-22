-- Trigger: Hatch_Slam
-- Zone: 521, ID: 11
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #52111

-- Converted from DG Script #52111: Hatch_Slam
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if actor.id == -1 then
    if direction == "up" then
        wait(1)
        actor:send("The Hatch slams shut above you, creating a smooth airtight ceiling.")
    end
end