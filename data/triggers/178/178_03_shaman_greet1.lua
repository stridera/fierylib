-- Trigger: shaman_greet1
-- Zone: 178, ID: 3
-- Type: MOB, Flags: GREET
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #17803

-- Converted from DG Script #17803: shaman_greet1
-- Original: MOB trigger, flags: GREET, probability: 100%
-- Add: Kourrya 6-06 for the troll mask quest in Minithawkin
--
-- TODO(parity): converter dropped the actual quest-stage lookup. The variable
-- `wandstep` is undefined here (was a DG `%self.wandstep%` or `%actor.wandstep%`
-- field), and the `get_quest_stage(...) == "wandstep"` comparison compares to
-- the literal string "wandstep" instead of a stage number. Needs rewrite once
-- the type_wand quest stages are confirmed.
if string.find(actor.race, "troll") then
    self:destroy_item("red-dye")
    self.room:spawn_object(370, 81)
end
wait(2)
self:say("Have you come to face your greatest fear?")