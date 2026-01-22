-- Trigger: myst_general_death
-- Zone: 160, ID: 17
-- Type: MOB, Flags: DEATH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #16017

-- Converted from DG Script #16017: myst_general_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- Hopefully this can reference a global setting from
-- another trigger or lack there of. This is to check
-- to make sure the quest has been properly initiated
if myst_gen_active == 1 then
    -- advance the quest for everyone involved
    local i = actor.group_size
    if i then
        local a = 1
    else
        local a = 0
    end
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("mystwatch_quest") then
                person.name:set_quest_var("mystwatch_quest", "step", "skeleton")
                person:send("<b:white>You have advanced the quest!</>")
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
    -- Does next mob in spawn cycle already exist?
    if world.count_mobiles("16015") < 1 then
        -- Generate random room number to spawn charred in.
        -- Thanks to the evil Pergus for inspiring me to be
        -- more evil.
        local rnd_range = random(1, 78)
        local rnd_room = rnd_range + 15999
        get_room(160, 95):at(function()
            self.room:spawn_mobile(160, 15)
        end)
        local rnd = random(1, 100)
        if rnd <= 75 then
            get_room(160, 95):at(function()
                self.room:find_actor("charred"):spawn_object(160, 30)
            end)
            get_room(160, 95):at(function()
                self.room:find_actor("charred"):teleport(find_room_by_name("%rnd_room%"))
            end)
        else
            get_room(160, 95):at(function()
                self.room:find_actor("charred"):teleport(find_room_by_name("%rnd_room%"))
            end)
        end
        -- Sometimes creatures don't get teleported out of the loading
        -- room so we're gonna go back and purge it just in case.
        get_room(160, 95):at(function()
            self.room:purge()
        end)
        self.room:send(tostring(self.name) .. " rasps, 'You think you have won but my charred minions will finish you!'")
        self.room:send(tostring(self.name) .. " emits a terrible wail as his spirit is banished from this realm.")
    end
end