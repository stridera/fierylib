-- Trigger: Monk Chants progress journal
-- Zone: 4, ID: 85
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #485

-- Converted from DG Script #485: Monk Chants progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(actor.class, "Monk") then
    local read
    local title
    local level
    local minstage
    local clue1
    local clue2
    if string.find(arg, "tremors") or string.find(arg, "tremors of saint augustine") or string.find(arg, "tremors_of_saint_augustine") then
        read = "yes"
        title = "Tremors of Saint Augustine"
        level = 30
        minstage = 1
        clue1 = "a book surrounded by trees and shadows."
        clue2 = "in a place that is both natural and urban, serenely peaceful and profoundly sorrowful."
    elseif string.find(arg, "tempest") or string.find(arg, "tempest of saint augustine") or string.find(arg, "tempest_of_saint_augustine") then
        read = "yes"
        title = "Tempest of Saint Augustine"
        level = 40
        minstage = 2
        clue1 = "a scroll, dedicated to this particular chant, guarded by a creature of the same elemental affinity."
        clue2 = "on the peak of Urchet Pass."
    elseif string.find(arg, "blizzards") or string.find(arg, "blizzards of saint augustine") or string.find(arg, "blizzards_of_saint_augustine") then
        read = "yes"
        title = "Blizzards of Saint Augustine"
        level = 50
        minstage = 3
        clue1 = "a book held by a master who in turn is a servant of a beast of winter."
        clue2 = "in a temple shrouded in mists."
    elseif string.find(arg, "aria") or string.find(arg, "dissonance") or string.find(arg, "aria of dissonance") then
        read = "yes"
        title = "Aria of Dissonance"
        level = 60
        minstage = 4
        clue1 = "a book on war, held by a banished war god."
        clue2 = "in a dark cave before a blasphemous book, near an unholy fire."
    elseif string.find(arg, "apocalyptic") or string.find(arg, "Anthem") then
        read = "yes"
        title = "Apocalyptic Anthem"
        level = 75
        minstage = 5
        clue1 = "a scroll where illusion is inscribed over and over held by a brother who thirsts for escape."
        clue2 = "in a chapel of the walking dead."
    elseif string.find(arg, "fires") or string.find(arg, "fires of saint augustine") or string.find(arg, "fires_of_saint_augustine") then
        read = "yes"
        title = "Fires of Saint Augustine"
        level = 80
        minstage = 6
        clue1 = "a scroll of curses, carried by children of air in a floating fortress."
        clue2 = "at an altar dedicated to fire's destructive forces."
    elseif string.find(arg, "seed") or string.find(arg, "destruction") or string.find(arg, "seed of destruction") then
        read = "yes"
        title = "Seed of Destruction"
        level = 99
        minstage = 7
        clue1 = "the eye of one caught in an eternal feud."
        clue2 = "at an altar deep in the outer realms surrounded by those who's vengeance was never satisfied."
    end
    if read == "yes" then
        _return_value = true
        local chantstage = actor:get_quest_stage("monk_chants")
        local visionstage = actor:get_quest_stage("monk_vision")
        local master = mobiles.template(53, 8).name
        actor:send("<b:green>&u" .. tostring(title) .. "</>")
        actor:send("Minimum Level: " .. tostring(level))
        local status
        if chantstage > minstage then
            status = "Completed!"
        elseif chantstage == "minstage" and (chantstage < (visionstage - 2)) then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level and chantstage == "minstage" then
            if chantstage >= (visionstage - 2) then
                actor:send("You must walk further along the Way in service of Balance first.")
                return _return_value
            end
            actor:send("You are looking for " .. tostring(clue1))
            actor:send("Take it and <b:cyan>[meditate]</> " .. tostring(clue2))
        elseif actor.level >= level and not chantstage then
            actor:send("Ask " .. tostring(master) .. " about <b:cyan>[chants]" .. "%0 to get started.")
        end
    end
end
return _return_value