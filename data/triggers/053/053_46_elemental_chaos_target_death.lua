-- Trigger: Elemental Chaos target death
-- Zone: 53, ID: 46
-- Type: MOB, Flags: DEATH
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #5346

-- Converted from DG Script #5346: Elemental Chaos target death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- switch on self.id
if self.id == 58808 then
    -- imp
    local stage = 1
    local target1 = "imp"
elseif self.id == 4399 then
    -- Leading Player
    local target1 = "Leading_player"
    local stage = 2
elseif self.id == 17306 then
    -- the Chaos
    local target1 = "Chaos"
    local stage = 3
elseif self.id == 17811 then
    -- the Fetch
    local target1 = "Fetch"
    local stage = 4
elseif self.id == 46206 then
    -- shaman Fang
    local target1 = "shaman_Fang"
    local stage = 5
elseif self.id == 46207 then
    -- necro Fang
    local target2 = "necro_Fang"
    local stage = 5
elseif self.id == 46208 then
    -- dia Fang
    local target3 = "dia_Fang"
    local stage = 5
elseif self.id == 12523 then
    -- fire lord
    local target1 = "fire_lord"
    local stage = 6
elseif self.id == 8509 then
    -- acolyte
    local target1 = "acolyte"
    local stage = 7
elseif self.id == 43017 then
    -- Cyprianum the Reaper
    local target1 = "Cyprianum"
    local stage = 8
elseif self.id == 53417 then
    -- chaos demon
    local target1 = "Chaos_Demon"
    local stage = 9
elseif self.id == 4009 then
    -- Norhamen
    local target1 = "Norhamen"
    local stage = 10
end
local person = actor
local i = person.group_size
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    local person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("elemental_chaos") == "stage" and person:get_quest_var("elemental_chaos:bounty") == "running" then
            if target1 then
                person:set_quest_var("elemental_chaos", "target1", target1)
                person:send("<b:red>You cross " .. tostring(self.name) .. " off your list.</>")
            elseif target2 then
                person:set_quest_var("elemental_chaos", "target2", target2)
                person:send("<b:red>You cross " .. tostring(self.name) .. " off your list.</>")
            elseif target3 then
                person:set_quest_var("elemental_chaos", "target3", target3)
                person:send("<b:red>You cross " .. tostring(self.name) .. " off your list.</>")
            end
            if stage == 5 then
                if person:get_quest_var("elemental_chaos:target1") and person:get_quest_var("elemental_chaos:target2") and person:get_quest_var("elemental_chaos:target3") then
                    person:set_quest_var("elemental_chaos", "bounty", "dead")
                end
            else
                person:set_quest_var("elemental_chaos", "bounty", "dead")
            end
        end
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end