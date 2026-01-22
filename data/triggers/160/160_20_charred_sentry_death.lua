-- Trigger: charred_sentry_death
-- Zone: 160, ID: 20
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #16020

-- Converted from DG Script #16020: charred_sentry_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
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
            person.name:set_quest_var("mystwatch_quest", "step", "warlord")
            person:send("<b:white>You have advanced the quest!</>")
        end
    elseif person then
        local i = i + 1
    end
    local a = a + 1
end
-- load charred warlord and maybe equip
if world.count_mobiles("16018") < 1 then
    local rnd_range = random(1, 78)
    local rnd_room = rnd_range + 15999
    get_room(160, 95):at(function()
        self.room:spawn_mobile(160, 18)
    end)
    local rnd = random(1, 100)
    if rnd <= 75 then
        get_room(160, 95):at(function()
            self.room:find_actor("warlord"):spawn_object(160, 33)
        end)
        get_room(160, 95):at(function()
            self.room:find_actor("warlord"):command("wear all")
        end)
        get_room(160, 95):at(function()
            self.room:find_actor("warlord"):teleport(find_room_by_name("%rnd_room%"))
        end)
    else
        get_room(160, 95):at(function()
            self.room:find_actor("warlord"):teleport(find_room_by_name("%rnd_room%"))
        end)
    end
    -- Sometimes creatures don't get teleported out of the loading
    -- room so we're gonna go back and purge it just incase.
    get_room(160, 95):at(function()
        self.room:purge()
    end)
end