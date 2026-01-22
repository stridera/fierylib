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
local minlevel = (wandstep - 1) * 10
wait(2)
if actor.quest_stage[type_wand] == "wandstep" and actor.level >= minlevel then
    if actor.quest_variable[type_wand:greet] == 0 then
        self.room:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
    else
        self:say("Do you have what I need?")
    end
else
    self:say("Have you come to face your greatest fear?")
end