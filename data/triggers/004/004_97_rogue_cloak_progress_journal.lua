-- Trigger: Rogue Cloak progress journal
-- Zone: 4, ID: 97
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
-- TODO(parity): contains literal DG remnants like %get.obj_shortdesc[...]% or %actor.quest_variable[...]% that the converter left as raw text inside actor:send(...) calls. These need to be rewritten as proper Lua splices using objects.template(zone, id).name and actor:get_quest_var(...) before players see correct output.
--
-- Original DG Script: #497

-- Converted from DG Script #497: Rogue Cloak progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "cloak") or string.find(arg, "dagger") or string.find(arg, "cloak and dagger") or string.find(arg, "rogue_cloak") then
    if string.find(actor.class, "Rogue") or string.find(actor.class, "Bard") or actor.class ~= "Thief" then
        _return_value = true
        local huntstage = actor:get_quest_stage("treasure_hunter")
        local cloakstage = actor:get_quest_stage("rogue_cloak")
        local job1 = actor:get_quest_var("rogue_cloak:cloaktask1")
        local job2 = actor:get_quest_var("rogue_cloak:cloaktask2")
        local job3 = actor:get_quest_var("rogue_cloak:cloaktask3")
        local job4 = actor:get_quest_var("rogue_cloak:cloaktask4")
        actor:send("<b:green>&uCloak and Dagger</>")
        local level
        if not cloakstage then
            level = 10
        else
            level = cloakstage * 10
        end
        if not actor:get_has_completed("rogue_cloak") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        local status
        if actor:get_has_completed("rogue_cloak") then
            status = "Completed!"
        elseif cloakstage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level then
            if cloakstage == 0 then
                actor:send("You must <b:cyan>[hunt]</> down more treasure first.")
                return _return_value
            elseif (cloakstage >= huntstage) and not actor:get_has_completed("treasure_hunter") then
                actor:send("Find some more treasures before you seek another promotion.")
                return _return_value
            end
            -- switch on cloakstage
            local cloak
            local gem
            local place
            local hint
            if cloakstage == 1 then
                cloak = 58801
                gem = 55585
                place = "A Storage Room"
                hint = "in the house on the hill."
            elseif cloakstage == 2 then
                cloak = 17307
                gem = 55593
                place = "A Small Alcove"
                hint = "in the holy library."
            elseif cloakstage == 3 then
                cloak = 10308
                gem = 55619
                place = "either Treasure Room"
                hint = "in the paladin fortress."
            elseif cloakstage == 4 then
                cloak = 12325
                gem = 55659
                place = "The Treasure Room"
                hint = "beyond the Tower in the Wastes."
            elseif cloakstage == 5 then
                cloak = 43022
                gem = 55663
                place = "Treasury"
                hint = "in the ghostly fortress."
            elseif cloakstage == 6 then
                cloak = 23810
                gem = 55674
                place = "either Treasure Room with a chest"
                hint = "lost in the sands."
            elseif cloakstage == 7 then
                cloak = 51013
                gem = 55714
                place = "Mesmeriz's Secret Treasure Room"
                hint = "hidden deep underground."
            elseif cloakstage == 8 then
                cloak = 58410
                gem = 55740
                place = "Treasure Room"
                hint = "sunk in the swamp."
            elseif cloakstage == 9 then
                cloak = 52009
                gem = 55741
                place = "Treasure Room"
                hint = "buried with an ancient king."
            end
            local attack = cloakstage * 100
            if job1 or job2 or job3 or job4 then
                actor:send("You've done the following:")
                if job1 then
                    actor:send("- attacked " .. tostring(attack) .. " times")
                end
                if job2 then
                    actor:send("- found " .. "%get.obj_shortdesc[%cloak%]%")
                end
                if job3 then
                    actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
                end
                if job4 then
                    actor:send("- searched in " .. tostring(place))
                end
            end
            actor:send("</>")
            actor:send("You need to:")
            if job1 and job2 and job3 and job4 then
                actor:send("Give Honus your old cloak.")
                return _return_value
            end
            if not job1 then
                local remaining = attack - actor:get_quest_var("rogue_cloak:attack_counter")
                actor:send("- attack <b:yellow>" .. tostring(remaining) .. "</> more times while wearing your cloak.")
            end
            if not job2 then
                actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%cloak%]%</>")
            end
            if not job3 then
                actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</>")
            end
            if not job4 then
                actor:send("- <b:yellow>search</> in a place called \"<b:yellow>" .. tostring(place) .. "</>\".")
                actor:send("</>   It's <b:yellow>" .. tostring(hint) .. "</>")
            end
        end
    end
end
return _return_value