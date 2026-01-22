-- Trigger: Message about planking
-- Zone: 120, ID: 20
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #12020

-- Converted from DG Script #12020: Message about planking
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if direction == "south" and planking_open ~= 1 then
    wait(3)
    actor:send("As you enter, a bit of planking falls back, obscuring the opening to the south.")
    actor:send("It looks like you could push it aside, should the need arise.")
end