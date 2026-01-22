-- Trigger: Bounty hunt death triggers
-- Zone: 60, ID: 54
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--   Complex nesting: 8 if statements
--
-- Original DG Script: #6054

-- Converted from DG Script #6054: Bounty hunt death triggers
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- switch on self.id
if self.id == 8608 then
    -- Meer Cat King
    local stage = 1
    local target1 = "meer_cat_king"
elseif self.id == 18509 then
    -- Noble
    local target1 = "Noble"
    local stage = 2
elseif self.id == 18500 then
    -- Abbot
    local target2 = "Abbot"
    local stage = 2
elseif self.id == 16300 then
    -- O'Connor
    local target1 = "O'Connor"
    local stage = 3
elseif self.id == 16301 then
    -- Cameron
    local target3 = "Cameron"
    local stage = 3
elseif self.id == 16302 then
    -- McLeod
    local target2 = "McLeod"
    local stage = 3
elseif self.id == 8316 then
    -- Frakati Leader
    local target1 = "Frakati"
    local stage = 4
elseif self.id == 59015 then
    -- Cyrus
    local target1 = "Cyrus"
    local stage = 5
elseif self.id == 2322 then
    -- Lord Venth
    local target1 = "Venth"
    local stage = 6
elseif self.id == 2330 then
    -- high druid
    local target1 = "Anlun_High_Druid"
    local stage = 7
elseif self.id == 53009 then
    -- lizard king
    local target1 = "Lizard_King"
    local stage = 8
elseif self.id == 53309 then
    -- Sorcha
    local target1 = "Sorcha"
    local stage = 9
elseif self.id == 58411 then
    -- Goblin King
    local target1 = "Goblin_King"
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
    local person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("bounty_hunt") == "stage" and person:get_quest_var("bounty_hunt:bounty") == "running" then
            if target1 then
                person:set_quest_var("bounty_hunt", "target1", target1)
                person:send("<b:red>You cross " .. tostring(self.name) .. " off your list.</>")
            elseif target2 then
                person:set_quest_var("bounty_hunt", "target2", target2)
                person:send("<b:red>You cross " .. tostring(self.name) .. " off your list.</>")
            elseif target3 then
                person:set_quest_var("bounty_hunt", "target3", target3)
                person:send("<b:red>You cross " .. tostring(self.name) .. " off your list.</>")
            end
            if stage ~= 2 and stage ~= 3 then
                person:set_quest_var("bounty_hunt", "bounty", "dead")
            elseif stage == 2 then
                if person:get_quest_var("bounty_hunt:target1") and person:get_quest_var("bounty_hunt:target2") then
                    person:set_quest_var("bounty_hunt", "bounty", "dead")
                end
            elseif stage == 3 then
                if person:get_quest_var("bounty_hunt:target1") and person:get_quest_var("bounty_hunt:target2") and person:get_quest_var("bounty_hunt:target3") then
                    person:set_quest_var("bounty_hunt", "bounty", "dead")
                end
            end
        end
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end