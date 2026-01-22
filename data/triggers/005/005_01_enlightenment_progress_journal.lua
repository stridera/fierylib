-- Trigger: Enlightenment progress journal
-- Zone: 5, ID: 1
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 18 if statements
--   Large script: 6150 chars
--
-- Original DG Script: #501

-- Converted from DG Script #501: Enlightenment progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "enlightenment") or string.find(arg, "monk") vision or string.find(arg, "monk_vision") then
    if string.find(actor.class, "Monk") then
        _return_value = false
        local missionstage = actor:get_quest_stage("elemental_chaos")
        local visionstage = actor:get_quest_stage("monk_vision")
        local master = mobiles.template(53, 8).name
        local job1 = actor:get_quest_var("monk_vision:visiontask1")
        local job2 = actor:get_quest_var("monk_vision:visiontask2")
        local job3 = actor:get_quest_var("monk_vision:visiontask3")
        local job4 = actor:get_quest_var("monk_vision:visiontask4")
        actor:send("<b:green>&uEnlightenment</>")
        if not visionstage then
            local level = 10
        else
            local level = visionstage * 10
        end
        if not actor:get_has_completed("monk_vision") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        if actor:get_has_completed("monk_vision") then
            local status = "Completed!"
        elseif visionstage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level then
            if visionstage == 0 then
                actor:send("You must undertake a <b:cyan>[mission]</> in service of Balance first.")
                return _return_value
            elseif (visionstage >= missionstage) and not actor:get_has_completed("elemental_chaos") then
                actor:send("You must walk further along the Way in service of Balance first.")
                return _return_value
            end
            -- switch on visionstage
            if visionstage == 1 then
                local book = 59006
                local gem = 55582
                local room = get_room("4328")
                local place = room.name
                local hint = "in a place to perform."
            elseif visionstage == 2 then
                local book = 18505
                local gem = 55591
                local room = get_room("58707")
                local place = room.name
                local hint = "near a sandy beach."
            elseif visionstage == 3 then
                local book = 8501
                local gem = 55623
                local room = get_room("18597")
                local place = room.name
                local hint = "in a cloistered library."
            elseif visionstage == 4 then
                local book = 12532
                local gem = 55655
                local room = get_room("58102")
                local place = room.name
                local hint = "on Hakujo's home island."
            elseif visionstage == 5 then
                local book = 16209
                local gem = 55665
                local room = get_room("16057")
                local place = room.name
                local hint = "in the ghostly fortress."
            elseif visionstage == 6 then
                local book = 43013
                local gem = 55678
                local room = get_room("59054")
                local place = room.name
                local hint = "in the fortress of the zealous."
            elseif visionstage == 7 then
                local book = 53009
                local gem = 55710
                local room = get_room("49079")
                local place = room.name
                local hint = "off-shore of the island of great beasts."
            elseif visionstage == 8 then
                local book = 58415
                local gem = 55722
                local room = get_room("11820")
                local place = room.name
                local hint = "beyond the Blue-Fog Trail."
            elseif visionstage == 9 then
                local book = 58412
                local gem = 55741
                local room = get_room("52075")
                local place = room.name
                local hint = "in the shattered citadel of Templace."
            end
            local attack = visionstage * 100
            if job1 or job2 or job3 or job4 then
                actor:send("You've done the following:")
                if job1 then
                    actor:send("- attacked " .. tostring(attack) .. " times")
                end
                if job2 then
                    actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
                end
                if job3 then
                    actor:send("- found " .. "%get.obj_shortdesc[%book%]%")
                end
                if job4 then
                    actor:send("- read in " .. tostring(place))
                end
            end
            actor:send("</>")
            actor:send("You need to:")
            if job1 and job2 and job3 and job4 then
                actor:send("Give " .. tostring(master) .. " your current vision mark.")
                return _return_value
            end
            if not job1 then
                local remaining = attack - actor:get_quest_var("monk_vision:attack_counter")
                actor:send("- attack &9<blue>" .. tostring(remaining) .. "</> more times while wearing your vision mark.")
            end
            if not job4 then
                actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</> and <b:yellow>%get.obj_shortdesc[%book%]%</> and <b:yellow>read</> in a place called \"<b:yellow>%place%</>\".")
                actor:send("</>   It's <b:green>" .. tostring(hint) .. "</>")
            else
                if not job2 then
                    actor:send("- bring " .. tostring(master) .. " <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</>")
                end
                if not job3 then
                    actor:send("- bring " .. tostring(master) .. " <b:yellow>" .. "%get.obj_shortdesc[%book%]%</>")
                end
            end
        end
    end
end
return _return_value