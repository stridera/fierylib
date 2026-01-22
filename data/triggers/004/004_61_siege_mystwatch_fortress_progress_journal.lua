-- Trigger: Siege Mystwatch Fortress progress journal
-- Zone: 4, ID: 61
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #461

-- Converted from DG Script #461: Siege Mystwatch Fortress progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "siege") or string.find(arg, "mystwatch") or string.find(arg, "fortress") or string.find(arg, "mystwatch_quest") or string.find(arg, "siege_mystwatch_fortress") then
    if actor.level >= 35 then
        _return_value = false
        local stage = actor:get_quest_stage("mystwatch_quest")
        actor:send("<b:green>&uSiege Mystwatch Fortress</>")
        actor:send("Recommended Level: 45")
        if stage then
            local status = "Repeatable"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage then
            actor:send("Quest Master: " .. tostring(mobiles.template(30, 25).name))
            -- switch on actor:get_quest_var("mystwatch_quest:step")
            if actor:get_quest_var("mystwatch_quest:step") == "totem" then
                local task = Give objects.template(30, 26).name to mobiles.template(160, 7).name.
            elseif actor:get_quest_var("mystwatch_quest:step") == "general" then
                local task = Kill mobiles.template(160, 7).name.
            elseif actor:get_quest_var("mystwatch_quest:step") == "skeleton" then
                local task = Kill mobiles.template(160, 15).name.
            elseif actor:get_quest_var("mystwatch_quest:step") == "warrior" then
                local task = Kill mobiles.template(160, 16).name.
            elseif actor:get_quest_var("mystwatch_quest:step") == "sentry" then
                local task = Kill mobiles.template(160, 17).name.
            elseif actor:get_quest_var("mystwatch_quest:step") == "warlord" then
                local task = Kill mobiles.template(160, 18).name.
            elseif actor:get_quest_var("mystwatch_quest:step") == "blacksmith" then
                local task = Kill mobiles.template(160, 19).name.
            elseif actor:get_quest_var("mystwatch_quest:step") == "shadow" then
                local task = Kill mobiles.template(160, 10).name.
            elseif actor:get_quest_var("mystwatch_quest:step") == "storm" then
                local task = Kill mobiles.template(160, 8).name.
            elseif actor:get_quest_var("mystwatch_quest:step") == "lord" then
                local task = Kill mobiles.template(160, 11).name.
            elseif actor:get_quest_var("mystwatch_quest:step") == "shard" then
                local task = Give objects.template(160, 23).name to mobiles.template(30, 25).name.
            else
                local task = Visit mobiles.template(30, 25).name to restart this quest.
            end
            actor:send("</>")
            actor:send("Your next step: " .. tostring(task))
        end
    end
end
return _return_value