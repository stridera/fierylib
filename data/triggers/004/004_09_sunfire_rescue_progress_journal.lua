-- Trigger: Sunfire Rescue progress journal
-- Zone: 4, ID: 9
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 11 if statements
--
-- Original DG Script: #409

-- Converted from DG Script #409: Sunfire Rescue progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "sunfire") or string.find(arg, "serin") or string.find(arg, "rescue") or string.find(arg, "sunfire_rescue") or string.find(arg, "sunfire_crest") or string.find(arg, "serin_sunfire_rescue") or string.find(arg, "sunfire_crest") then
    local stage = actor:get_quest_stage("sunfire_rescue")
    if actor.level >= 80 or stage then
        _return_value = false
        actor:send("<b:green>&uSunfire Rescue</>")
        actor:send("This quest is only available to good-aligned characters.")
        actor:send("Minimum Level: 85")
        actor:send("- This quest can be started at any level but requires level 85 to finish.")
        if actor:get_has_completed("sunfire_rescue") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage == 1 then
            actor:send("Quest Master: " .. tostring(mobiles.template(237, 19).name))
            actor:send("</>")
            actor:send("You must bring the elven cloak, ring, and boots from Templace to Serin Sunfire to help him escape!")
            actor:send("</>")
            local boots = actor:get_quest_var("sunfire_rescue:boots")
            local cloak = actor:get_quest_var("sunfire_rescue:cloak")
            local ring = actor:get_quest_var("sunfire_rescue:ring")
            local total = boots + cloak + ring
            if total > 0 then
                actor:send("You have retrieved the following treasures:")
                if boots then
                    actor:send(tostring(objects.template(520, 8).name) .. ".")
                end
                if cloak then
                    actor:send(tostring(objects.template(520, 9).name) .. ".")
                end
                if ring then
                    actor:send(tostring(objects.template(520, 1).name) .. ".")
                end
                actor:send("</>")
            end
            actor:send("You still need to find:")
            if boots == 0 then
                actor:send(tostring(objects.template(520, 8).name) .. ".")
            end
            if cloak == 0 then
                actor:send(tostring(objects.template(520, 9).name) .. ".")
            end
            if ring == 0 then
                actor:send(tostring(objects.template(520, 1).name) .. ".")
            end
        end
    end
end
return _return_value