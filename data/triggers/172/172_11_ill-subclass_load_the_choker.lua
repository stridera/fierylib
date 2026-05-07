-- Trigger: Ill-subclass: Load the choker
-- Zone: 172, ID: 11
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Player at quest stage 4 (knows the incantation but hasn't crossed the
-- waterfall) is about to enter Gannigan's safe room. Advance them past
-- the cross-the-walkway / arrive-in-safe-room stages and ensure the
-- choker (172:14) is here for them to pick up.
--
-- Original DG Script: #17211

if actor:get_quest_stage("illusionist_subclass") ~= 4 then
    return true
end

actor:advance_quest("illusionist_subclass")
actor:advance_quest("illusionist_subclass")

if not self.room:find_object("choker") then
    self.room:spawn_object(172, 14)
end