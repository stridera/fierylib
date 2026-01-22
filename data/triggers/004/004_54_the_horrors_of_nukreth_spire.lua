-- Trigger: The Horrors of Nukreth Spire
-- Zone: 4, ID: 54
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--
-- Original DG Script: #454

-- Converted from DG Script #454: The Horrors of Nukreth Spire
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "horrors") or string.find(arg, "nukreth") or string.find(arg, "spire") or string.find(arg, "nukreth_spire") then
    if actor.level >= 10 then
        _return_value = false
        actor:send("<b:green>&uThe Horrors of Nukreth Spire</>")
        actor:send("This quest is infinitely repeatable.")
        actor:send("Recommended Level: 20")
        if actor:get_quest_stage("nukreth_spire") then
            local status = "Repeatable"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor:get_quest_stage("nukreth_spire") then
            actor:send("This quest has multiple paths and outcomes.")
            local path1 = actor:get_quest_var("nukreth_spire:path1")
            local path2 = actor:get_quest_var("nukreth_spire:path2")
            local path3 = actor:get_quest_var("nukreth_spire:path3")
            local path4 = actor:get_quest_var("nukreth_spire:path4")
            if path1 or path2 or path3 or path4 then
                actor:send("</>")
                actor:send("You have assisted the following people:")
                if path1 then
                    actor:send("- the human rebel")
                end
                if path2 then
                    actor:send("- the kobold rebel")
                end
                if path3 then
                    actor:send("- the orc rebel")
                end
                if path4 then
                    actor:send("- the goblin rebel")
                end
            end
        end
    end
end
return _return_value