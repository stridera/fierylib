-- Trigger: Phoenix Sous Chef progress journal
-- Zone: 4, ID: 23
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
-- TODO(parity): contains literal DG remnants like %get.obj_shortdesc[...]% or %actor.quest_variable[...]% that the converter left as raw text inside actor:send(...) calls. These need to be rewritten as proper Lua splices using objects.template(zone, id).name and actor:get_quest_var(...) before players see correct output.
--
-- Original DG Script: #423

-- Converted from DG Script #423: Phoenix Sous Chef progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "phoenix") or string.find(arg, "sous") or string.find(arg, "chef") or string.find(arg, "resort_cooking") or string.find(arg, "resort") or string.find(arg, "cooking") or string.find(arg, "phoenix_sous_chef") then
    if actor.level >= 50 then
        _return_value = true
        local stage = actor:get_quest_stage("resort_cooking")
        actor:send("<b:green>&uPhoenix Sous Chef</>")
        actor:send("Recommended Level: 90")
        actor:send("- This quest can be started at any level but requires level 90+ to finish.")
        local status
        if actor:get_has_completed("resort_cooking") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>")
        if stage > 0 and not actor:get_has_completed("resort_cooking") then
            actor:send("</>")
            actor:send("Quest Master: " .. tostring(mobiles.template(103, 8).name))
            actor:send("</>")
            -- switch on stage
            local recipe
            local item1
            local item2
            local item3
            local item4
            local item5
            local item6
            local item7
            if stage == 1 then
                recipe = "Peach Cobbler"
                item1 = 61501
                item2 = 23754
                item3 = 3114
                item4 = 35001
            elseif stage == 2 then
                recipe = "Seafood Salad"
                item1 = 49024
                item2 = 23750
                item3 = 23722
                item4 = 8003
                item5 = 12515
                item6 = 1606
            elseif stage == 3 then
                recipe = "Fish Stew"
                item1 = 55213
                item2 = 30002
                item3 = 10030
                item4 = 12552
                item5 = 23757
                item6 = 18509
                item7 = 10311
            elseif stage == 4 then
                recipe = "Honey-Glazed Ham"
                item1 = 41011
                item2 = 8350
                item3 = 2001
                item4 = 50207
                item5 = 6106
            elseif stage == 5 then
                recipe = "Saffroned Jasmine Rice"
                item1 = 58019
                item2 = 37013
                item3 = 23760
            end
            actor:send("You are trying to make:")
            actor:send("</>========<==b:white>" .. tostring(recipe) .. "</>==========")
            if item1 then
                actor:send("</>  " .. "%get.obj_shortdesc[%item1%]%")
            end
            if item2 then
                actor:send("</>  " .. "%get.obj_shortdesc[%item2%]%")
            end
            if item3 then
                actor:send("</>  " .. "%get.obj_shortdesc[%item3%]%")
            end
            if item4 then
                actor:send("</>  " .. "%get.obj_shortdesc[%item4%]%")
            end
            if item5 then
                actor:send("</>  " .. "%get.obj_shortdesc[%item5%]%")
            end
            if item6 then
                actor:send("</>  " .. "%get.obj_shortdesc[%item6%]%")
            end
            if item7 then
                actor:send("</>  " .. "%get.obj_shortdesc[%item7%]%")
            end
            actor:send("</>")
            actor:send("You have retrieved:")
            local nothing = 1
            if actor:get_quest_var("resort_cooking:item1") then
                actor:send("</>  " .. "%get.obj_shortdesc[%item1%]%")
                local nothing = 0
            end
            if actor:get_quest_var("resort_cooking:item2") then
                actor:send("</>  " .. "%get.obj_shortdesc[%item2%]%")
                local nothing = 0
            end
            if actor:get_quest_var("resort_cooking:item3") then
                actor:send("</>  " .. "%get.obj_shortdesc[%item3%]%")
                local nothing = 0
            end
            if actor:get_quest_var("resort_cooking:item4") then
                actor:send("</>  " .. "%get.obj_shortdesc[%item4%]%")
                local nothing = 0
            end
            if actor:get_quest_var("resort_cooking:item5") then
                actor:send("</>  " .. "%get.obj_shortdesc[%item5%]%")
                local nothing = 0
            end
            if actor:get_quest_var("resort_cooking:item6") then
                actor:send("</>  " .. "%get.obj_shortdesc[%item6%]%")
                local nothing = 0
            end
            if actor:get_quest_var("resort_cooking:item7") then
                actor:send("</>  " .. "%get.obj_shortdesc[%item7%]%")
                local nothing = 0
            end
            if nothing then
                actor:send("</>  Nothing.")
            end
        end
    end
end
return _return_value