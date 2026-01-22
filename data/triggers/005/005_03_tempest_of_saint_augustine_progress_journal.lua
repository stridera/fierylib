-- Trigger: Tempest of Saint Augustine progress journal
-- Zone: 5, ID: 3
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #503

-- Converted from DG Script #503: Tempest of Saint Augustine progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "tempest") or string.find(arg, "tempest of saint augustine") or string.find(arg, "tempest_of_saint_augustine") then
    if string.find(actor.class, "Monk") then
        _return_value = false
        local chantstage = actor:get_quest_stage("monk_chants")
        local visionstage = actor:get_quest_stage("monk_vision")
        local master = mobiles.template(53, 8).name
        local level = 40
        actor:send("<b:green>&uTempest of Saint Augustine</>")
        actor:send("Minimum Level: " .. tostring(level))
        if chantstage > 2 then
            local status = "Completed!"
        elseif chantstage == 2 then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level and chantstage == 2 then
            if chantstage >= (visionstage - 1) then
                actor:send("You must walk further along the Way in service of Balance first.")
                return _return_value
            end
            actor:send("You are looking for a scroll, dedicated to this particular chant, guarded by a creature of the same elemental affinity.")
            actor:send("Take it and <b:cyan>[meditate]" .. "%</> on the peak of Urchet Pass.")
        end
    end
end
return _return_value