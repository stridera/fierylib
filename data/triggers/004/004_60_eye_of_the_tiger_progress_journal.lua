-- Trigger: Eye of the Tiger progress journal
-- Zone: 4, ID: 60
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
-- TODO(parity): contains literal DG remnants like %get.obj_shortdesc[...]% or %actor.quest_variable[...]% that the converter left as raw text inside actor:send(...) calls. These need to be rewritten as proper Lua splices using objects.template(zone, id).name and actor:get_quest_var(...) before players see correct output.
--
-- Original DG Script: #460

-- Converted from DG Script #460: Eye of the Tiger progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "eye of the tiger") or string.find(arg, "tiger") then
    local hunterclasses = "Warrior Ranger Berserker Mercenary"
    if string.find(hunterclasses, actor.class) then
        _return_value = true
        local huntstage = actor:get_quest_stage("beast_master")
        local trophystage = actor:get_quest_stage("ranger_trophy")
        local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
        local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
        local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
        local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
        actor:send("<b:green>&uEye of the Tiger</>")
        local level
        if not trophystage then
            level = 10
        else
            level = trophystage * 10
        end
        if not actor:get_has_completed("ranger_trophy") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        local status
        if actor:get_has_completed("ranger_trophy") then
            status = "Completed!"
        elseif trophystage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level then
            if trophystage == 0 then
                actor:send("You must <b:cyan>[hunt]</> a great beast to demonstrate your skills first.")
                return _return_value
            elseif (trophystage >= huntstage) and not actor:get_has_completed("beast_master") then
                actor:send("Prove your dominion over some more great beasts before you can demonstrate your skills.")
                return _return_value
            end
            -- switch on trophystage
            local trophy
            local gem
            local place
            local hint
            if trophystage == 1 then
                trophy = 1607
                gem = 55579
                place = "A Coyote's Den"
                hint = "near the Kingdom of the Meer Cats."
            elseif trophystage == 2 then
                trophy = 17806
                gem = 55591
                place = "In the Lions' Den"
                hint = "in the western reaches of Gothra."
            elseif trophystage == 3 then
                trophy = 1805
                gem = 55628
                place = "either of the two Gigantic Roc Nests"
                hint = "in the Wailing Mountains."
            elseif trophystage == 4 then
                trophy = 62513
                gem = 55652
                place = "Chieftain's Lair"
                hint = "in Nukreth Spire in South Caelia."
            elseif trophystage == 5 then
                trophy = 23803
                gem = 55664
                place = "The Heart of the Den"
                hint = "where the oldest unicorn in South Caelia makes its home."
            elseif trophystage == 6 then
                trophy = 43009
                gem = 55685
                place = "Giant Lynx's Lair"
                hint = "far to the north beyond Mt. Frostbite."
            elseif trophystage == 7 then
                trophy = 47008
                gem = 55705
                place = "Giant Griffin's Nest"
                hint = "tucked away in a secluded and well guarded corner of Griffin Island."
            elseif trophystage == 8 then
                trophy = 53323
                gem = 55729
                place = "Witch's Den"
                hint = "entombed with an ancient evil king."
            elseif trophystage == 9 then
                trophy = 52014
                gem = 55741
                place = "Dargentan's Lair"
                hint = "at the pinnacle of his flying fortress."
            end
            local attack = trophystage * 100
            if job1 or job2 or job3 or job4 then
                actor:send("You've done the following:")
                if job1 then
                    actor:send("- attacked " .. tostring(attack) .. " times")
                end
                if job2 then
                    actor:send("- found " .. "%get.obj_shortdesc[%trophy%]%")
                end
                if job3 then
                    actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
                end
                if job4 then
                    actor:send("- foraged in " .. tostring(place))
                end
            end
            actor:send("</>")
            actor:send("You need to:")
            if job1 and job2 and job3 and job4 then
                actor:send("Give " .. tostring(master) .. " your old trophy.")
                return _return_value
            end
            if not job1 then
                local remaining = attack - actor:get_quest_var("ranger_trophy:attack_counter")
                actor:send("- attack <b:green>" .. tostring(remaining) .. "</> more times while wearing your trophy.")
            end
            if not job2 then
                actor:send("- find <b:green>" .. "%get.obj_shortdesc[%trophy%]%</>")
            end
            if not job3 then
                actor:send("- find <b:green>" .. "%get.obj_shortdesc[%gem%]%</>")
            end
            if not job4 then
                actor:send("- <b:green>forage</> in a place called \"<b:green>" .. tostring(place) .. "</>\".")
                actor:send("</>   It's <b:green>" .. tostring(hint) .. "</>")
            end
        end
    end
end
return _return_value