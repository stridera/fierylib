-- Trigger: Nukreth Spire chieftain death
-- Zone: 462, ID: 4
-- Type: MOB, Flags: DEATH
--
-- Original DG Script: #46204

-- Converted from DG Script #46204: Nukreth Spire chieftain death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- TODO(parity): legacy DG had a "pathrnd" reroll loop that never updated the
-- quest var (would loop forever). We just roll once. Group iteration also
-- skipped non-present members by incrementing `i`; in Lua we just continue.
local rnd = random(1, 4)
if actor and actor.is_player then
    local i = actor.group_size
    if i then
        local a = 1
        while i >= a do
            local person = actor.group_member[a]
            if person and person.room == self.room then
                if not person:get_quest_stage("nukreth_spire") then
                    person:start_quest("nukreth_spire")
                end
            end
            a = a + 1
        end
    elseif not actor:get_quest_stage("nukreth_spire") then
        actor:start_quest("nukreth_spire")
    end
end
if rnd == 1 then
    run_room_trigger(462, 0)
elseif rnd == 2 then
    run_room_trigger(462, 1)
elseif rnd == 3 then
    run_room_trigger(462, 2)
elseif rnd == 4 then
    run_room_trigger(462, 3)
end