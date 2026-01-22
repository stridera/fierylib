-- Trigger: **UNUSED**
-- Zone: 5, ID: 2
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #502

-- Converted from DG Script #502: **UNUSED**
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "tremors") or string.find(arg, "tremors of saint augustine") or string.find(arg, "tremors_of_saint_augustine") then
    if string.find(actor.class, "Monk") then
        _return_value = false
        local chantstage = actor:get_quest_stage("monk_chants")
        local visionstage = actor:get_quest_stage("monk_vision")
        local master = mobiles.template(53, 8).name
        local level = 30
        actor:send("<b:green>&uTremors of Saint Augustine</>")
        actor:send("Minimum Level: " .. tostring(level))
        if chantstage > 1 then
            local status = "Completed!"
        elseif chantstage == 1 then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level and chantstage == 1 then
            if chantstage >= (visionstage - 1) then
                actor:send("You must walk further along the Way in service of Balance first.")
                return _return_value
            end
            actor:send("You are looking for a book surrounded by trees and shadows.")
            actor:send("Take it and <b:cyan>[meditate]" .. "%</> in a place that is both natural and urban, serenely peaceful and profoundly sorrowful.")
        elseif actor.level >= level and not chantstage then
            actor:send("Ask " .. tostring(master) .. " about <b:cyan>[chants]" .. "%0 to get started.")
        end
    end
end
return _return_value