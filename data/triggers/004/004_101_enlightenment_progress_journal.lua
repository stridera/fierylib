-- Trigger: Enlightenment progress journal
-- Zone: 4, ID: 101
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
-- TODO(parity): contains literal DG remnants like %get.obj_shortdesc[...]% or %actor.quest_variable[...]% that the converter left as raw text inside actor:send(...) calls. These need to be rewritten as proper Lua splices using objects.template(zone, id).name and actor:get_quest_var(...) before players see correct output.
--
-- Original DG Script: #501

-- Converted from DG Script #501: Enlightenment progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "enlightenment") or string.find(arg, "monk vision") or string.find(arg, "monk_vision") then
    if string.find(actor.class, "Monk") then
        _return_value = true
        local missionstage = actor:get_quest_stage("elemental_chaos")
        local visionstage = actor:get_quest_stage("monk_vision")
        local master = mobiles.template(53, 8).name
        local job1 = actor:get_quest_var("monk_vision:visiontask1")
        local job2 = actor:get_quest_var("monk_vision:visiontask2")
        local job3 = actor:get_quest_var("monk_vision:visiontask3")
        local job4 = actor:get_quest_var("monk_vision:visiontask4")
        actor:send("<b:green>&uEnlightenment</>")
        local level
        if not visionstage then
            level = 10
        else
            level = visionstage * 10
        end
        if not actor:get_has_completed("monk_vision") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        local status
        if actor:get_has_completed("monk_vision") then
            status = "Completed!"
        elseif visionstage then
            status = "In Progress"
        else
            status = "Not Started"
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
            local book
            local gem
            local room
            local place
            local hint
            if visionstage == 1 then
                book = 59006
                gem = 55582
                room = get_room("4328")
                place = room.name
                hint = "in a place to perform."
            elseif visionstage == 2 then
                book = 18505
                gem = 55591
                room = get_room("58707")
                place = room.name
                hint = "near a sandy beach."
            elseif visionstage == 3 then
                book = 8501
                gem = 55623
                room = get_room("18597")
                place = room.name
                hint = "in a cloistered library."
            elseif visionstage == 4 then
                book = 12532
                gem = 55655
                room = get_room("58102")
                place = room.name
                hint = "on Hakujo's home island."
            elseif visionstage == 5 then
                book = 16209
                gem = 55665
                room = get_room("16057")
                place = room.name
                hint = "in the ghostly fortress."
            elseif visionstage == 6 then
                book = 43013
                gem = 55678
                room = get_room("59054")
                place = room.name
                hint = "in the fortress of the zealous."
            elseif visionstage == 7 then
                book = 53009
                gem = 55710
                room = get_room("49079")
                place = room.name
                hint = "off-shore of the island of great beasts."
            elseif visionstage == 8 then
                book = 58415
                gem = 55722
                room = get_room("11820")
                place = room.name
                hint = "beyond the Blue-Fog Trail."
            elseif visionstage == 9 then
                book = 58412
                gem = 55741
                room = get_room("52075")
                place = room.name
                hint = "in the shattered citadel of Templace."
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