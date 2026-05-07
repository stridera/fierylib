-- Trigger: Dragon Slayer dragon death
-- Zone: 30, ID: 84
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #3084

-- Converted from DG Script #3084: Dragon Slayer dragon death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- switch on self.id
local stage
local target1
if self.id == 18004 then
    -- Dragon Hedge
    stage = 1
    target1 = "dragon_hedge"
elseif self.id == 13626 then
    -- Green Wyrmling
    target1 = "green_wyrmling"
    stage = 2
elseif self.id == 8034 then
    -- Wug
    target1 = "wug"
    stage = 3
elseif self.id == 12500 then
    -- young blue dragon
    target1 = "young_blue_dragon"
    stage = 4
elseif self.id == 12322 then
    -- faerie dragon
    target1 = "faerie_dragon"
    stage = 5
elseif self.id == 16309 then
    -- wyvern
    target1 = "wyvern"
    stage = 6
elseif self.id == 53410 then
    -- ice lizard
    target1 = "ice_lizard"
    stage = 7
elseif self.id == 4013 then
    -- Beast of Borgan
    target1 = "borgan"
    stage = 8
elseif self.id == 53300 then
    -- Tri-Aszp
    target1 = "tri-aszp"
    stage = 9
elseif self.id == 52010 then
    -- Hydra
    target1 = "hydra"
    stage = 10
else
    -- Not a tracked dragon; nothing to do
    return true
end
local person = actor
local i = actor.group_size
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    person = person.group_member[a]
    if person and person.room == self.room then
        -- TODO(parity): legacy DG had `stage` template-replaced; this compares
        -- the quest stage against the literal string "stage" which can never
        -- match. Should be `person:get_quest_stage("dragon_slayer") == stage`.
        if person:get_quest_stage("dragon_slayer") == stage and person:get_quest_var("dragon_slayer:hunt") == "running" then
            person:set_quest_var("dragon_slayer", "target1", target1)
            person:set_quest_var("dragon_slayer", "hunt", "dead")
            person:send("<b:red>You cross " .. tostring(self.name) .. " off your list.</>")
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end