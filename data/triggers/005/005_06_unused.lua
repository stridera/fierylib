-- Trigger: **UNUSED**
-- Zone: 5, ID: 6
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #506

-- Converted from DG Script #506: **UNUSED**
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "fires") or string.find(arg, "fires") of saint augustine or string.find(arg, "fires_of_saint_augustine") then
    if string.find(actor.class, "Monk") then
        _return_value = false
        local chantstage = actor:get_quest_stage("monk_chants")
        local visionstage = actor:get_quest_stage("monk_vision")
        local master = mobiles.template(53, 8).name
        local level = 80
        actor:send("<b:green>&uFires of Saint Augustine</>")
        actor:send("Minimum Level: " .. tostring(level))
        if chantstage > 6 then
            local status = "Completed!"
        elseif chantstage == 6 then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level and chantstage == 6 then
            if chantstage >= (visionstage - 1) then
                actor:send("You must walk further along the Way in service of Balance first.")
                return _return_value
            end
            actor:send("You are looking for a scroll of curses, carried by children of air in a floating fortress.")
            actor:send("Take it and <b:cyan>[meditate]" .. "%</> at an altar dedicated to fire's destructive forces.")
        end
    end
end
return _return_value