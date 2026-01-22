-- Trigger: Eye of the Tiger progress journal
-- Zone: 4, ID: 60
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 18 if statements
--   Large script: 5795 chars
--
-- Original DG Script: #460

-- Converted from DG Script #460: Eye of the Tiger progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "eye") of the tiger or string.find(arg, "tiger") then
    local hunterclasses = "Warrior Ranger Berserker Mercenary"
    if string.find(hunterclasses, "actor.class") then
        _return_value = false
        local huntstage = actor:get_quest_stage("beast_master")
        local trophystage = actor:get_quest_stage("ranger_trophy")
        local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
        local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
        local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
        local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
        actor:send("<b:green>&uEye of the Tiger</>")
        if not trophystage then
            local level = 10
        else
            local level = trophystage * 10
        end
        if not actor:get_has_completed("ranger_trophy") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        if actor:get_has_completed("ranger_trophy") then
            local status = "Completed!"
        elseif trophystage then
            local status = "In Progress"
        else
            local status = "Not Started"
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
            if trophystage == 1 then
                local trophy = 1607
                local gem = 55579
                local place = "A Coyote's Den"
                local hint = "near the Kingdom of the Meer Cats."
            elseif trophystage == 2 then
                local trophy = 17806
                local gem = 55591
                local place = "In the Lions' Den"
                local hint = "in the western reaches of Gothra."
            elseif trophystage == 3 then
                local trophy = 1805
                local gem = 55628
                local place = "either of the two Gigantic Roc Nests"
                local hint = "in the Wailing Mountains."
            elseif trophystage == 4 then
                local trophy = 62513
                local gem = 55652
                local place = "Chieftain's Lair"
                local hint = "in Nukreth Spire in South Caelia."
            elseif trophystage == 5 then
                local trophy = 23803
                local gem = 55664
                local place = "The Heart of the Den"
                local hint = "where the oldest unicorn in South Caelia makes its home."
            elseif trophystage == 6 then
                local trophy = 43009
                local gem = 55685
                local place = "Giant Lynx's Lair"
                local hint = "far to the north beyond Mt. Frostbite."
            elseif trophystage == 7 then
                local trophy = 47008
                local gem = 55705
                local place = "Giant Griffin's Nest"
                local hint = "tucked away in a secluded and well guarded corner of Griffin Island."
            elseif trophystage == 8 then
                local trophy = 53323
                local gem = 55729
                local place = "Witch's Den"
                local hint = "entombed with an ancient evil king."
            elseif trophystage == 9 then
                local trophy = 52014
                local gem = 55741
                local place = "Dargentan's Lair"
                local hint = "at the pinnacle of his flying fortress."
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