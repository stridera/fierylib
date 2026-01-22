-- Trigger: Dragon Slayer dragon death
-- Zone: 30, ID: 84
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #3084

-- Converted from DG Script #3084: Dragon Slayer dragon death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- switch on self.id
if self.id == 18004 then
    -- Dragon Hedge
    local stage = 1
    local target1 = "dragon_hedge"
elseif self.id == 13626 then
    -- Green Wyrmling
    local target1 = "green_wyrmling"
    local stage = 2
elseif self.id == 8034 then
    -- Wug
    local target1 = "wug"
    local stage = 3
elseif self.id == 12500 then
    -- young blue dragon
    local target1 = "young_blue_dragon"
    local stage = 4
elseif self.id == 12322 then
    -- faerie dragon
    local target1 = "faerie_dragon"
    local stage = 5
elseif self.id == 16309 then
    -- wyvern
    local target1 = "wyvern"
    local stage = 6
elseif self.id == 53410 then
    -- ice lizard
    local target1 = "ice_lizard"
    local stage = 7
elseif self.id == 4013 then
    -- Beast of Borgan
    local target1 = "borgan"
    local stage = 8
elseif self.id == 53300 then
    -- Tri-Aszp
    local target1 = "tri-aszp"
    local stage = 9
elseif self.id == 52010 then
    -- Hydra
    local target1 = "hydra"
    local stage = 10
end
local person = actor
local i = actor.group_size
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    local person = person.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("dragon_slayer") == "stage" and person:get_quest_var("dragon_slayer:hunt") == "running" then
            person:set_quest_var("dragon_slayer", "target1", target1)
            person:set_quest_var("dragon_slayer", "hunt", "dead")
            person:send("<b:red>You cross " .. tostring(self.name) .. " off your list.</>")
        end
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end