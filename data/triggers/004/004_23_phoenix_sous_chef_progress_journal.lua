-- Trigger: Phoenix Sous Chef progress journal
-- Zone: 4, ID: 23
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 20 if statements
--   Large script: 5051 chars
--
-- Original DG Script: #423

-- Converted from DG Script #423: Phoenix Sous Chef progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "phoenix") or string.find(arg, "sous") or string.find(arg, "chef") or string.find(arg, "resort_cooking") or string.find(arg, "resort") or string.find(arg, "cooking") or string.find(arg, "phoenix_sous_chef") then
    if actor.level >= 50 then
        _return_value = false
        local stage = actor:get_quest_stage("resort_cooking")
        actor:send("<b:green>&uPhoenix Sous Chef</>")
        actor:send("Recommended Level: 90")
        actor:send("- This quest can be started at any level but requires level 90+ to finish.")
        if actor:get_has_completed("resort_cooking") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>")
        if stage > 0 and not actor:get_has_completed("resort_cooking") then
            actor:send("</>")
            actor:send("Quest Master: " .. tostring(mobiles.template(103, 8).name))
            actor:send("</>")
            -- switch on stage
            if stage == 1 then
                local recipe = "Peach Cobbler"
                local item1 = 61501
                local item2 = 23754
                local item3 = 3114
                local item4 = 35001
            elseif stage == 2 then
                local recipe = "Seafood Salad"
                local item1 = 49024
                local item2 = 23750
                local item3 = 23722
                local item4 = 8003
                local item5 = 12515
                local item6 = 1606
            elseif stage == 3 then
                local recipe = "Fish Stew"
                local item1 = 55213
                local item2 = 30002
                local item3 = 10030
                local item4 = 12552
                local item5 = 23757
                local item6 = 18509
                local item7 = 10311
            elseif stage == 4 then
                local recipe = "Honey-Glazed Ham"
                local item1 = 41011
                local item2 = 8350
                local item3 = 2001
                local item4 = 50207
                local item5 = 6106
            elseif stage == 5 then
                local recipe = "Saffroned Jasmine Rice"
                local item1 = 58019
                local item2 = 37013
                local item3 = 23760
            end
            actor:send("You are trying to make:")
            actor:send("</>==========<b:white>" .. tostring(recipe) .. "</>==========")
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