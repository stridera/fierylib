-- Trigger: storm_deamon_death
-- Zone: 160, ID: 24
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #16024

-- Converted from DG Script #16024: storm_deamon_death
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
            person.name:set_quest_var("mystwatch_quest", "step", "lord")
            person:send("<b:white>You have advanced the quest!</>")
        end
    elseif person then
        local i = i + 1
    end
    local a = a + 1
end
if world.count_mobiles("16011") < 1 then
    -- load demon lord and maybe equip shield
    -- but definitely load shard
    get_room(160, 95):at(function()
        self.room:spawn_mobile(160, 11)
    end)
    local rnd = random(1, 100)
    if rnd <= 50 then
        get_room(160, 95):at(function()
            self.room:find_actor("lord"):spawn_object(160, 9)
        end)
        get_room(160, 95):at(function()
            self.room:find_actor("lord"):spawn_object(160, 23)
        end)
        get_room(160, 95):at(function()
            self.room:find_actor("lord"):command("wear all")
        end)
        get_room(160, 95):at(function()
            self.room:find_actor("lord"):teleport(get_room(164, 6))
        end)
    end
    get_room(160, 95):at(function()
        self.room:find_actor("lord"):spawn_object(160, 23)
    end)
    get_room(160, 95):at(function()
        self.room:find_actor("lord"):teleport(get_room(164, 6))
    end)
    get_room(160, 95):at(function()
        run_room_trigger(16050)
    end)
end