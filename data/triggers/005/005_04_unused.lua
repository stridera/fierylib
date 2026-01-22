-- Trigger: **UNUSED**
-- Zone: 5, ID: 4
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #504

-- Converted from DG Script #504: **UNUSED**
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "blizzards") or string.find(arg, "blizzards") of saint augustine or string.find(arg, "blizzards_of_saint_augustine") then
    if string.find(actor.class, "Monk") then
        _return_value = false
        local chantstage = actor:get_quest_stage("monk_chants")
        local visionstage = actor:get_quest_stage("monk_vision")
        local master = mobiles.template(53, 8).name
        local level = 50
        actor:send("<b:green>&uBlizzards of Saint Augustine</>")
        actor:send("Minimum Level: " .. tostring(level))
        if chantstage > 3 then
            local status = "Completed!"
        elseif chantstage == 3 then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level and chantstage == 3 then
            if chantstage >= (visionstage - 1) then
                actor:send("You must walk further along the Way in service of Balance first.")
                return _return_value
            end
            actor:send("You are looking for a book held by a master who in turn is a servant of a beast of winter.")
            actor:send("Take it and <b:cyan>[meditate]" .. "%</> in a temple shrouded in mists.")
        end
    end
end
return _return_value