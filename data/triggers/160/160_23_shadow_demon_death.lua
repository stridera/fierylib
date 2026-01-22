-- Trigger: shadow_demon_death
-- Zone: 160, ID: 23
-- Type: MOB, Flags: DEATH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #16023

-- Converted from DG Script #16023: shadow_demon_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
if world.count_mobiles("16008") < 1 then
    -- load storm demon and maybe equip orb
    -- but definitely load key
    get_room(160, 95):at(function()
        self.room:spawn_mobile(160, 8)
    end)
    local rnd = random(1, 100)
    if rnd <= 33 then
        get_room(160, 95):at(function()
            self.room:find_actor("storm"):spawn_object(160, 6)
        end)
        get_room(160, 95):at(function()
            self.room:find_actor("storm"):spawn_object(160, 22)
        end)
        get_room(160, 95):at(function()
            self.room:find_actor("storm"):command("wear all")
        end)
        get_room(160, 95):at(function()
            self.room:find_actor("storm"):teleport(get_room(160, 76))
        end)
    else
        -- The orb is required for Druids on the Moonwell quest and for Sorcerers on the Wizard Eye quest
        local i = actor.group_size
        if i then
            local a = 1
        else
            local a = 0
        end
        while i >= a do
            local person = actor.group_member[a]
            if person.room == self.room then
                if person:get_quest_stage("moonwell_spell_quest") > 0 or person:get_quest_stage("wizard_eye") > 0 then
                    get_room(160, 95):at(function()
                        self.room:find_actor("storm"):spawn_object(160, 6)
                    end)
                    get_room(160, 95):at(function()
                        self.room:find_actor("storm"):command("wear all")
                    end)
                end
                if person:get_quest_stage("mystwatch_quest") then
                    person.name:set_quest_var("mystwatch_quest", "step", "storm")
                    person:send("<b:white>You have advanced the quest!</>")
                end
            elseif person then
                local i = i + 1
            end
            local a = a + 1
        end
        get_room(160, 95):at(function()
            self.room:find_actor("storm"):spawn_object(160, 22)
        end)
        get_room(160, 95):at(function()
            self.room:find_actor("storm"):teleport(get_room(160, 76))
        end)
    end
end
-- Sometimes creatures don't get teleported out of the loading
-- room so we're gonna go back and purge it just in case.
get_room(160, 95):at(function()
    self.room:purge()
end)
self.room:send("A violent lightning storm continues outside...")