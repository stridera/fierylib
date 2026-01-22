-- Trigger: shaman_greet1
-- Zone: 178, ID: 3
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #17803

-- Converted from DG Script #17803: shaman_greet1
-- Original: MOB trigger, flags: GREET, probability: 100%
-- Add: Kourrya 6-06 for the troll mask quest in Minithawkin
if string.find(actor.race, "troll") then
    self:destroy_item("red-dye")
    self.room:spawn_object(370, 81)
end
-- TODO: Phase wand quest integration needs proper variable names
-- Original used undefined variables: wandstep, type_wand
wait(2)
self:say("Have you come to face your greatest fear?")