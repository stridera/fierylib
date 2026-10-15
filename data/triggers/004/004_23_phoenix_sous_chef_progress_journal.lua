-- Trigger: Phoenix Sous Chef progress journal
-- Zone: 4, ID: 23
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #423

-- Converted from DG Script #423: Phoenix Sous Chef progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local function proto_key(vnum)
    vnum = tonumber(vnum)
    if not vnum then return nil end
    local zone = math.floor(vnum / 100)
    if zone == 0 then zone = 1000 end
    return zone, vnum % 100
end
local function proto_short(vnum)
    local zone, id = proto_key(vnum)
    local name = zone and objects.template(zone, id).name
    if not name or name == "" then return "[no description for object " .. tostring(vnum) .. "]" end
    return name
end
local _return_value = true  -- Default: allow action
if string.find(arg, "phoenix") or string.find(arg, "sous") or string.find(arg, "chef") or string.find(arg, "resort_cooking") or string.find(arg, "resort") or string.find(arg, "cooking") or string.find(arg, "phoenix_sous_chef") then
    if actor.level >= 50 then
        _return_value = true
        local stage = actor:get_quest_stage("resort_cooking")
        actor:send("<b:u:green>Phoenix Sous Chef</>")
        actor:send("Recommended Level: 90")
        actor:send("- This quest can be started at any level but requires level 90+ to finish.")
        local status
        if actor:get_has_completed("resort_cooking") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
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
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    recipe = "Peach Cobbler"
                    item1 = 61501
                    item2 = 23754
                    item3 = 3114
                    item4 = 35001
                elseif tonumber(_sw1) == 2 then
                    recipe = "Seafood Salad"
                    item1 = 49024
                    item2 = 23750
                    item3 = 23722
                    item4 = 8003
                    item5 = 12515
                    item6 = 1606
                elseif tonumber(_sw1) == 3 then
                    recipe = "Fish Stew"
                    item1 = 55213
                    item2 = 30002
                    item3 = 10030
                    item4 = 12552
                    item5 = 23757
                    item6 = 18509
                    item7 = 10311
                elseif tonumber(_sw1) == 4 then
                    recipe = "Honey-Glazed Ham"
                    item1 = 41011
                    item2 = 8350
                    item3 = 2001
                    item4 = 50207
                    item5 = 6106
                elseif tonumber(_sw1) == 5 then
                    recipe = "Saffroned Jasmine Rice"
                    item1 = 58019
                    item2 = 37013
                    item3 = 23760
                end
            end
            actor:send("You are trying to make:")
            actor:send("</>========<==b:white>" .. tostring(recipe) .. "</>==========")
            if item1 then
                actor:send("</>  " .. proto_short(item1))
            end
            if item2 then
                actor:send("</>  " .. proto_short(item2))
            end
            if item3 then
                actor:send("</>  " .. proto_short(item3))
            end
            if item4 then
                actor:send("</>  " .. proto_short(item4))
            end
            if item5 then
                actor:send("</>  " .. proto_short(item5))
            end
            if item6 then
                actor:send("</>  " .. proto_short(item6))
            end
            if item7 then
                actor:send("</>  " .. proto_short(item7))
            end
            actor:send("</>")
            actor:send("You have retrieved:")
            local nothing = 1
            if actor:get_quest_var("resort_cooking:item1") then
                actor:send("</>  " .. proto_short(item1))
                nothing = 0
            end
            if actor:get_quest_var("resort_cooking:item2") then
                actor:send("</>  " .. proto_short(item2))
                nothing = 0
            end
            if actor:get_quest_var("resort_cooking:item3") then
                actor:send("</>  " .. proto_short(item3))
                nothing = 0
            end
            if actor:get_quest_var("resort_cooking:item4") then
                actor:send("</>  " .. proto_short(item4))
                nothing = 0
            end
            if actor:get_quest_var("resort_cooking:item5") then
                actor:send("</>  " .. proto_short(item5))
                nothing = 0
            end
            if actor:get_quest_var("resort_cooking:item6") then
                actor:send("</>  " .. proto_short(item6))
                nothing = 0
            end
            if actor:get_quest_var("resort_cooking:item7") then
                actor:send("</>  " .. proto_short(item7))
                nothing = 0
            end
            if nothing then
                actor:send("</>  Nothing.")
            end
        end
    end
end
return _return_value