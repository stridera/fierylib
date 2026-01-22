-- Trigger: Nukreth Spire chieftain death
-- Zone: 462, ID: 4
-- Type: MOB, Flags: DEATH
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #46204

-- Converted from DG Script #46204: Nukreth Spire chieftain death
-- Original: MOB trigger, flags: DEATH, probability: 100%
if not actor then
    local rnd = random(1, 4)
end
if actor.id == -1 then
    local person = actor
    local i = person.group_size
    if i then
        local a = 1
        while i >= a do
            local person = actor.group_member[a]
            if person.room == self.room then
                if not person:get_quest_stage("nukreth_spire") then
                    person:start_quest("nukreth_spire")
                end
            elseif person then
                local i = i + 1
            end
            local a = a + 1
        end
    elseif not person:get_quest_stage("nukreth_spire") then
        person:start_quest("nukreth_spire")
    end
    local rnd = random(1, 4)
    if actor.quest_variable[nukreth_spire:pathrnd] == 1 then
        while actor.quest_variable[nukreth_spire:pathrnd] == 1 do
            local rnd = random(1, 4)
        end
        local start = rnd
    end
end
if rnd == 1 then
    run_room_trigger(46200)
elseif rnd == 2 then
    run_room_trigger(46201)
elseif rnd == 3 then
    run_room_trigger(46202)
elseif rnd == 4 then
    run_room_trigger(46203)
end