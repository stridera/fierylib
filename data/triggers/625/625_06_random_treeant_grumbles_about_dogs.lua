-- Trigger: random treeant grumbles about dogs
-- Zone: 625, ID: 6
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #62506

-- Converted from DG Script #62506: random treeant grumbles about dogs
-- Original: MOB trigger, flags: RANDOM, probability: 100%
if random(1, 10) > 6 then
    self:command("grumble")
    self.room:send(tostring(self.name) .. " says, 'I've kept my trees for an age, and I've never had pests quite")
    self.room:send("</>like these before.'")
end