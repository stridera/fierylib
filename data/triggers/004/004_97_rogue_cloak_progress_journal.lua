-- Trigger: Rogue Cloak progress journal
-- Zone: 4, ID: 97
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 18 if statements
--   Large script: 5587 chars
--
-- Original DG Script: #497

-- Converted from DG Script #497: Rogue Cloak progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "cloak") or string.find(arg, "dagger") or string.find(arg, "cloak") and dagger or string.find(arg, "rogue_cloak") then
    if string.find(actor.class, "Rogue") or string.find(actor.class, "Bard") or actor.class ~= "Thief" then
        _return_value = false
        local huntstage = actor:get_quest_stage("treasure_hunter")
        local cloakstage = actor:get_quest_stage("rogue_cloak")
        local job1 = actor:get_quest_var("rogue_cloak:cloaktask1")
        local job2 = actor:get_quest_var("rogue_cloak:cloaktask2")
        local job3 = actor:get_quest_var("rogue_cloak:cloaktask3")
        local job4 = actor:get_quest_var("rogue_cloak:cloaktask4")
        actor:send("<b:green>&uCloak and Dagger</>")
        if not cloakstage then
            local level = 10
        else
            local level = cloakstage * 10
        end
        if not actor:get_has_completed("rogue_cloak") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        if actor:get_has_completed("rogue_cloak") then
            local status = "Completed!"
        elseif cloakstage then
            local status = "In Progress"
        else
            local status = "Not Started"
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
            if cloakstage == 1 then
                local cloak = 58801
                local gem = 55585
                local place = "A Storage Room"
                local hint = "in the house on the hill."
            elseif cloakstage == 2 then
                local cloak = 17307
                local gem = 55593
                local place = "A Small Alcove"
                local hint = "in the holy library."
            elseif cloakstage == 3 then
                local cloak = 10308
                local gem = 55619
                local place = "either Treasure Room"
                local hint = "in the paladin fortress."
            elseif cloakstage == 4 then
                local cloak = 12325
                local gem = 55659
                local place = "The Treasure Room"
                local hint = "beyond the Tower in the Wastes."
            elseif cloakstage == 5 then
                local cloak = 43022
                local gem = 55663
                local place = "Treasury"
                local hint = "in the ghostly fortress."
            elseif cloakstage == 6 then
                local cloak = 23810
                local gem = 55674
                local place = "either Treasure Room with a chest"
                local hint = "lost in the sands."
            elseif cloakstage == 7 then
                local cloak = 51013
                local gem = 55714
                local place = "Mesmeriz's Secret Treasure Room"
                local hint = "hidden deep underground."
            elseif cloakstage == 8 then
                local cloak = 58410
                local gem = 55740
                local place = "Treasure Room"
                local hint = "sunk in the swamp."
            elseif cloakstage == 9 then
                local cloak = 52009
                local gem = 55741
                local place = "Treasure Room"
                local hint = "buried with an ancient king."
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