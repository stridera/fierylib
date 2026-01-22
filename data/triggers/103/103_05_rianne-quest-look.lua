-- Trigger: rianne-quest-look
-- Zone: 103, ID: 5
-- Type: WORLD, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 19 if statements
--
-- Original DG Script: #10305

-- Converted from DG Script #10305: rianne-quest-look
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: look
if not (cmd == "look") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("resort_cooking") < 1 or actor:get_quest_stage("resort_cooking") > 5 then
    _return_value = false
    return _return_value
end
-- switch on actor:get_quest_stage("resort_cooking")
if actor:get_quest_stage("resort_cooking") == 1 then
    local recipe = "Peach Cobbler"
    local item1 = 61501
    local item2 = 23754
    local item3 = 3114
    local item4 = 35001
elseif actor:get_quest_stage("resort_cooking") == 2 then
    local recipe = "Seafood Salad"
    local item1 = 49024
    local item2 = 23750
    local item3 = 23722
    local item4 = 8003
    local item5 = 12515
    local item6 = 1606
elseif actor:get_quest_stage("resort_cooking") == 3 then
    local recipe = "Fish Stew"
    local item1 = 55213
    local item2 = 30002
    local item3 = 10030
    local item4 = 12552
    local item5 = 23757
    local item6 = 18509
    local item7 = 10311
elseif actor:get_quest_stage("resort_cooking") == 4 then
    local recipe = "Honey-Glazed Ham"
    local item1 = 41011
    local item2 = 8350
    local item3 = 2001
    local item4 = 50207
    local item5 = 6106
elseif actor:get_quest_stage("resort_cooking") == 5 then
    local recipe = "Saffroned Jasmine Rice"
    local item1 = 58019
    local item2 = 37013
    local item3 = 23760
else
    _return_value = false
    return _return_value
end
if string.find(arg, "recipe") or string.find(arg, "wall") or string.find(arg, "paper") or string.find(arg, "slip") then
    actor:send("The wall is covered in slips of paper, each with a different recipe.  One")
    actor:send("</>especially stands out among the mess.")
    actor:send("</>")
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
elseif string.find(arg, "icebox") then
    actor:send("Looking inside the icebox, you see:")
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
else
    _return_value = false
end
return _return_value