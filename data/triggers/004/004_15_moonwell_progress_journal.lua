-- Trigger: Moonwell progress journal
-- Zone: 4, ID: 15
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
-- TODO(parity): contains literal DG remnants like %get.obj_shortdesc[...]% or %actor.quest_variable[...]% that the converter left as raw text inside actor:send(...) calls. These need to be rewritten as proper Lua splices using objects.template(zone, id).name and actor:get_quest_var(...) before players see correct output.
--
-- Original DG Script: #415

-- Converted from DG Script #415: Moonwell progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "moonwell") or string.find(arg, "moonwell_spell_quest") then
    if string.find(actor.class, "Druid") and actor.level >= 65 then
        _return_value = true
        local stage = actor:get_quest_stage("moonwell_spell_quest")
        local master = mobiles.template(163, 16).name
        actor:send("<b:green>&uMoonwell</>")
        actor:send("Minimum Level: 73")
        local status
        if actor:get_has_completed("moonwell_spell_quest") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("moonwell_spell_quest") then
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            -- switch on stage
            local item
            local place
            if stage == 1 or stage == 2 then
                -- Vine of Mielikki
                item = 16350
                place = "an island of lava and fire"
            elseif stage == 3 then
                -- The Heartstone
                item = 48024
                place = "an ancient burial site far to the north"
            elseif stage == 4 then
                -- Flask of Eleweiss
                item = 16356
                place = "the cult of the ice dragon"
            elseif stage == 5 then
                -- Flask of Eleweiss
                item = 16356
                place = "the cult of the ice dragon"
            elseif stage == 6 then
                -- Glittering ruby ring
                item = 5201
                place = "a temple dedicated to fire"
            elseif stage == 7 then
                -- Orb of Winds
                item = 16006
                place = "a dark fortress to the east"
            elseif stage == 8 then
                -- Jade ring
                item = 49011
                place = "a wood nymph on an island of our brothers beset by beasts"
            elseif stage == 10 then
                -- Chaos Orb
                item = 4003
                place = "a great dragon hidden in a hellish labyrinth"
            elseif stage == 11 then
                -- Granite Ring
                item = 55020
                place = "a large temple hidden in a mountain"
            end
            if stage < 6 or (stage >= 6 and not actor:get_quest_var("moonwell_spell_quest:map")) then
                actor:send("Bring " .. "%get.obj_shortdesc[%item%]% from %place%.")
            else
                actor:send("Bring " .. tostring(master) .. " your bark map.")
            end
            if stage > 6 then
                actor:send("</>")
                actor:send("If you need a new map, return to " .. tostring(master) .. " and say \"<b:green>I lost my map</>\".")
            end
        end
    end
end
return _return_value