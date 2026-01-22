-- Trigger: Ziijhan forgets someone
-- Zone: 85, ID: 8
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #8508

-- Converted from DG Script #8508: Ziijhan forgets someone
-- Original: MOB trigger, flags: RANDOM, probability: 100%
if start_q == 1 then
    local counter = 0
    local questerhere = 0
    local room = get.room[self.room]
    local person = room.people
    while person do
        if string.find(person.name, "q_plyr") then
            local questerhere = 1
        end
        local person = person.next_in_room
    end
    if questerhere == 0 then
        self:say("Hmm, where did " .. tostring(q_plyr) .. " go?")
        local start_q = 0
        globals.start_q = globals.start_q or true
    end
end