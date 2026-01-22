-- Trigger: ash_crown-get
-- Zone: 481, ID: 6
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #48106

-- Converted from DG Script #48106: ash_crown-get
-- Original: OBJECT trigger, flags: GET, probability: 100%
if actor.id == -1 then
    local stage = 3
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
            if person:get_quest_stage("fieryisle_quest") == "stage" then
                person.name:advance_quest("fieryisle_quest")
                person:send("<b:white>You have advanced your quest!</>")
            end
        elseif person and person.id == -1 then
            local i = i + 1
        end
        local a = a + 1
    end
end