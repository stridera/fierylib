-- Trigger: Tower in the Wastes progress journal
-- Zone: 4, ID: 16
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #416

-- Converted from DG Script #416: Tower in the Wastes progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "tower") or string.find(arg, "wastes") or string.find(arg, "tower_in_the_wastes") or string.find(arg, "krisenna_quest") or string.find(arg, "krisenna") quest then
    if actor.level >= 30 then
        _return_value = false
        local stage = actor:get_quest_stage("krisenna_quest")
        actor:send("<b:green>&uTower in the Wastes</>")
        actor:send("Recommended Level: 40")
        if actor:get_has_completed("krisenna_quest") then
            local status = "Completed!"
        elseif actor:get_quest_stage("krisenna_quest") then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("krisenna_quest") then
            actor:send("Quest Master: " .. tostring(mobiles.template(125, 13).name))
            actor:send("</>")
            actor:send("The injured halfling said:")
            -- switch on stage
            if stage == 1 then
                local phrase = "Have you found my brother yet?  He must be in the tower somewhere!"
            elseif stage == 2 then
                local phrase = "He carried our grandfather's warhammer.  The warhammer is very precious to my family.  Would you please find it?  I will reward you as best I can!"
            elseif stage == 3 or stage == 4 then
                local phrase = "A... demon has the warhammer, you say?  I must have the warhammer!  Losing my brother is bad enough!"
            end
            actor:send("The halfling said, '" .. tostring(phrase) .. "'")
        end
    end
end
return _return_value