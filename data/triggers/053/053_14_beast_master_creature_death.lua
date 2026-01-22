-- Trigger: Beast Master creature death
-- Zone: 53, ID: 14
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #5314

-- Converted from DG Script #5314: Beast Master creature death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- switch on self.id
if self.id == 3133 then
    -- abominable slime creature
    local stage = 1
    local target1 = "abominable_slime_creature"
elseif self.id == 12003 then
    -- a large buck
    local target1 = "buck"
    local stage = 2
elseif self.id == 16105 then
    -- giant scorpion
    local target1 = "giant_scorpion"
    local stage = 3
elseif self.id == 2308 then
    -- monstrous canopy spider
    local target1 = "monstrous_canopy_spider"
    local stage = 4
elseif self.id == 48120 then
    -- chimera
    local target1 = "chimera"
    local stage = 5
elseif self.id == 23730 then
    -- drider king
    local target1 = "drider_king"
    local stage = 6
elseif self.id == 53305 then
    -- beholder
    local target1 = "beholder"
    local stage = 7
elseif self.id == 53003 then
    -- banshee
    local target1 = "banshee"
    local stage = 8
elseif self.id == 58401 then
    -- Baba Yaga
    local target1 = "baba_yaga"
    local stage = 9
elseif self.id == 52006 then
    -- medusa
    local target1 = "medusa"
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
    local person = person.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("beast_master") == "stage" and person:get_quest_var("beast_master:hunt") == "running" then
            person:set_quest_var("beast_master", "target1", target1)
            person:set_quest_var("beast_master", "hunt", "dead")
            person:send("<b:red>You cross " .. tostring(self.name) .. " off your list.</>")
        end
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end