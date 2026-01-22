-- Trigger: Monk Chants progress journal
-- Zone: 4, ID: 85
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #485

-- Converted from DG Script #485: Monk Chants progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(actor.class, "Monk") then
    if string.find(arg, "tremors") or string.find(arg, "tremors") of saint augustine or string.find(arg, "tremors_of_saint_augustine") then
        local read = "yes"
        local title = "Tremors of Saint Augustine"
        local level = 30
        local minstage = 1
        local clue1 = "a book surrounded by trees and shadows."
        local clue2 = "in a place that is both natural and urban, serenely peaceful and profoundly sorrowful."
    elseif string.find(arg, "tempest") or string.find(arg, "tempest") of saint augustine or string.find(arg, "tempest_of_saint_augustine") then
        local read = "yes"
        local title = "Tempest of Saint Augustine"
        local level = 40
        local minstage = 2
        local clue1 = "a scroll, dedicated to this particular chant, guarded by a creature of the same elemental affinity."
        local clue2 = "on the peak of Urchet Pass."
    elseif string.find(arg, "blizzards") or string.find(arg, "blizzards") of saint augustine or string.find(arg, "blizzards_of_saint_augustine") then
        local read = "yes"
        local title = "Blizzards of Saint Augustine"
        local level = 50
        local minstage = 3
        local clue1 = "a book held by a master who in turn is a servant of a beast of winter."
        local clue2 = "in a temple shrouded in mists."
    elseif string.find(arg, "aria") or string.find(arg, "dissonance") or string.find(arg, "aria") of dissonance then
        local read = "yes"
        local title = "Aria of Dissonance"
        local level = 60
        local minstage = 4
        local clue1 = "a book on war, held by a banished war god."
        local clue2 = "in a dark cave before a blasphemous book, near an unholy fire."
    elseif string.find(arg, "apocalyptic") or string.find(arg, "Anthem") then
        local read = "yes"
        local title = "Apocalyptic Anthem"
        local level = 75
        local minstage = 5
        local clue1 = "a scroll where illusion is inscribed over and over held by a brother who thirsts for escape."
        local clue2 = "in a chapel of the walking dead."
    elseif string.find(arg, "fires") or string.find(arg, "fires") of saint augustine or string.find(arg, "fires_of_saint_augustine") then
        local read = "yes"
        local title = "Fires of Saint Augustine"
        local level = 80
        local minstage = 6
        local clue1 = "a scroll of curses, carried by children of air in a floating fortress."
        local clue2 = "at an altar dedicated to fire's destructive forces."
    elseif string.find(arg, "seed") or string.find(arg, "destruction") or string.find(arg, "seed") of destruction then
        local read = "yes"
        local title = "Seed of Destruction"
        local level = 99
        local minstage = 7
        local clue1 = "the eye of one caught in an eternal feud."
        local clue2 = "at an altar deep in the outer realms surrounded by those who's vengeance was never satisfied."
    end
    if read == "yes" then
        _return_value = false
        local chantstage = actor:get_quest_stage("monk_chants")
        local visionstage = actor:get_quest_stage("monk_vision")
        local master = mobiles.template(53, 8).name
        actor:send("<b:green>&u" .. tostring(title) .. "</>")
        actor:send("Minimum Level: " .. tostring(level))
        if chantstage > minstage then
            local status = "Completed!"
        elseif chantstage == "minstage" and (chantstage < (visionstage - 2)) then
            local status = "In Progress"
        else
            local status = "Not Started"
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