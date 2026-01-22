-- Trigger: Creeping Doom progress journal
-- Zone: 4, ID: 35
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 12 if statements
--
-- Original DG Script: #435

-- Converted from DG Script #435: Creeping Doom progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "creeping") or string.find(arg, "creeping") doom or string.find(arg, "creeping_doom") then
    if actor.level >= 75 and string.find(actor.class, "Druid") then
        _return_value = false
        local stage = actor:get_quest_stage("creeping_doom")
        actor:send("<b:green>&uCreeping Doom</>")
        actor:send("Minimum Level: 81")
        if actor:get_has_completed("creeping_doom") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("creeping_doom") then
            actor:send("Quest Master: " .. tostring(mobiles.template(615, 27).name))
            actor:send("</>")
            -- switch on stage
            if stage == 1 then
                local item1 = 11812
                local place1 = "an assassin vine on Mist Mountain"
                local item2 = 16213
                local place2 = "the great pyramid"
                local item3 = 48029
                local place3 = "Rhalean's evil sister in the northern barrow"
                local step = "gathering Nature's Rage"
            elseif stage == 2 then
                local essence = actor:get_quest_var("creeping_doom:spiders")
                local total = 11 - actor:get_quest_var("creeping_doom:spiders")
                actor:send("You are collecting essences of swarms from flies, insects, spiders, bugs, scorpions, giant ant people, etc.")
                actor:send("</>")
                actor:send("You have found " .. tostring(essence) .. " essences.")
                actor:send("You need to find " .. tostring(total) .. " more.")
                actor:send("</>")
                actor:send("Remember, the tougher the bug, the better your chances of finding essences.")
                return _return_value
            elseif stage == 3 then
                local step = "locate three sources of Nature's Vengeance."
                local item1 = 48416
                local place1 = "the elder tremaen in the elemental Plane of Fire"
                local item2 = 52034
                local place2 = "the burning tree in Templace"
                local item3 = 62503
                local place3 = "the Treant in the eldest Rhell's forest"
            elseif stage == 4 then
                actor:send("Take the Essence of Nature's Vengeance and drop it at the entrance to the logging camp, then return to the angry pixie.")
                return _return_value
            elseif stage == 5 then
                actor:send("return to the very angry pixie.")
                return _return_value
            end
            local job1 = actor.quest_variable[creeping_doom:item1]
            local job2 = actor.quest_variable[creeping_doom:item2]
            local job3 = actor.quest_variable[creeping_doom:item3]
            actor:send("You are trying to " .. tostring(step) .. ".")
            actor:send("</>")
            if job1 or job2 or job3 then
                actor:send("You have brought me:")
                if job1 then
                    actor:send("- " .. "%get.obj_shortdesc[%item1%]%")
                end
                if job2 then
                    actor:send("- " .. "%get.obj_shortdesc[%item2%]%")
                end
                if job3 then
                    actor:send("- " .. "%get.obj_shortdesc[%item3%]%")
                end
            end
            actor:send("</>")
            actor:send("You still need:")
            if not job1 then
                actor:send("- " .. "%get.obj_shortdesc[%item1%]% from %place1%.")
            end
            if not job2 then
                actor:send("- " .. "%get.obj_shortdesc[%item2%]% from %place2%.")
            end
            if not job3 then
                actor:send("- " .. "%get.obj_shortdesc[%item3%]% from %place3%.")
            end
        end
    end
end
return _return_value