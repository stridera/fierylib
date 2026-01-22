-- Trigger: group_armor_forgemaster_greet
-- Zone: 590, ID: 44
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #59044

-- Converted from DG Script #59044: group_armor_forgemaster_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
local stage = actor:get_quest_stage("group_armor")
if ((string.find(actor.class, "Cleric") and actor.level > 72) or (string.find(actor.class, "Priest") and actor.level > 56)) and stage == 0 then
    self.room:send(tostring(self.name) .. " says, 'Well hello and welcome to the Sacred Haven's forge!")
    self.room:send("</>My name's Galen, son of Thorgrim, of the clan Grugnir.  I'm the resident")
    self.room:send("</>Forgemaster of the Sacred Haven.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'I'm working to prepare the paladins of the Haven")
    self.room:send("</>for their campaign against the evil races staking out Bluebonnet Pass by")
    self.room:send("</>forging an icon that will cast Group Armor.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Are you interested in helping out?'")
    -- (empty room echo)
    self.room:send(tostring(self.name) .. " says, 'You'll be able to learn the spell for yourself in the")
    self.room:send("</>process.'")
elseif stage == 1 then
    self:say("Have you returned with items that cast armor?")
elseif stage == 2 then
    self:say("I hope you've sourced a new forging hammer!")
elseif stage == 3 or stage == 4 then
    self:say("Any luck communing with the spirits of the forge?")
elseif stage == 5 then
    self:say("How goes the search for a protective amulet?")
elseif stage == 6 then
    self.room:send(tostring(self.name) .. " says, 'Welcome back!  I see the ghosts haven't eaten you yet!")
    self.room:send("</>Have you brought any ethereal armor?'")
end