-- Trigger: Bounty hunt death triggers
-- Zone: 60, ID: 54
-- Type: MOB, Flags: DEATH
--
-- Original DG Script: #6054

-- Converted from DG Script #6054: Bounty hunt death triggers
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- Hoisted: branch-scoped `local` would not be visible to the loop below.
local stage, target1, target2, target3
-- switch on self.id
if self.id == 8608 then
    -- Meer Cat King
    stage = 1
    target1 = "meer_cat_king"
elseif self.id == 18509 then
    -- Noble
    target1 = "Noble"
    stage = 2
elseif self.id == 18500 then
    -- Abbot
    target2 = "Abbot"
    stage = 2
elseif self.id == 16300 then
    -- O'Connor
    target1 = "O'Connor"
    stage = 3
elseif self.id == 16301 then
    -- Cameron
    target3 = "Cameron"
    stage = 3
elseif self.id == 16302 then
    -- McLeod
    target2 = "McLeod"
    stage = 3
elseif self.id == 8316 then
    -- Frakati Leader
    target1 = "Frakati"
    stage = 4
elseif self.id == 59015 then
    -- Cyrus
    target1 = "Cyrus"
    stage = 5
elseif self.id == 2322 then
    -- Lord Venth
    target1 = "Venth"
    stage = 6
elseif self.id == 2330 then
    -- high druid
    target1 = "Anlun_High_Druid"
    stage = 7
elseif self.id == 53009 then
    -- lizard king
    target1 = "Lizard_King"
    stage = 8
elseif self.id == 53309 then
    -- Sorcha
    target1 = "Sorcha"
    stage = 9
elseif self.id == 58411 then
    -- Goblin King
    target1 = "Goblin_King"
    stage = 10
end
local person = actor
local i = actor.group_size
-- Hoisted: branch-scoped `local a` would not be visible to the while below.
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    local person = actor.group_member[a]
    if person.room == self.room then
        -- Bug fix: converter compared to literal "stage" instead of the local `stage`.
        if person:get_quest_stage("bounty_hunt") == stage and person:get_quest_var("bounty_hunt:bounty") == "running" then
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
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end