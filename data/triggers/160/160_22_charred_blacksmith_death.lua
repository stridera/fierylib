-- Trigger: charred_blacksmith_death
-- Zone: 160, ID: 22
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #16022

-- Converted from DG Script #16022: charred_blacksmith_death
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
            person.name:set_quest_var("mystwatch_quest", "step", "shadow")
            person:send("<b:white>You have advanced the quest!</>")
        end
    elseif person then
        local i = i + 1
    end
    local a = a + 1
end
if world.count_mobiles("16010") < 1 then
    -- load shadow demon and equip keys
    -- It would be nice to check to see if the keys
    -- are already in the game and not load them.
    -- There is a pending coding request for this.
    get_room(160, 95):at(function()
        self.room:spawn_mobile(160, 10)
    end)
    get_room(160, 95):at(function()
        self.room:find_actor("demon"):spawn_object(160, 20)
    end)
    get_room(160, 95):at(function()
        self.room:find_actor("demon"):spawn_object(160, 21)
    end)
    get_room(160, 95):at(function()
        self.room:find_actor("demon"):teleport(get_room(160, 52))
    end)
end
self.room:send(tostring(self.name) .. " rasps, 'You think you have won, but the demons have taken notice of you now..'")
-- Sometimes creatures don't get teleported out of the loading
-- room so we're gonna go back and purge it just incase.
get_room(160, 95):at(function()
    self.room:purge()
end)