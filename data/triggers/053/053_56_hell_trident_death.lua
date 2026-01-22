-- Trigger: Hell Trident death
-- Zone: 53, ID: 56
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #5356

-- Converted from DG Script #5356: Hell Trident death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- switch on self.id
if self.id == 4001 or self.id == 4005 or self.id == 4010 or self.id == 4015 or self.id == 12307 then
    local phase = 1
    local word = "angels"
elseif self.id == 23810 or self.id == 23811 or self.id == 23812 then
    local phase = 2
    local word = "celestials"
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
        if person:get_quest_stage("hell_trident") == "phase" then
            local kills = person:get_quest_var("hell_trident:celestials") + 1
            person:set_quest_var("hell_trident", "celestials", kills)
            if kills >= 6 then
                person:set_quest_var("hell_trident", "helltask2", 1)
                person:set_quest_var("hell_trident", "celestials", 0)
                person:send("<b:red>You have sufficiently bathed in the blood of the " .. tostring(word) .. "!</>")
            end
        end
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end