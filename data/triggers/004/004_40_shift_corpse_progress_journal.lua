-- Trigger: Shift Corpse progress journal
-- Zone: 4, ID: 40
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #440

-- Converted from DG Script #440: Shift Corpse progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "shift") or string.find(arg, "corpse") or string.find(arg, "shift_corpse") then
    if string.find(actor.class, "Necromancer") and actor.level >= 90 then
        _return_value = false
        local stage = actor:get_quest_stage("shift_corpse")
        actor:send("<b:green>&uShift Corpse</>")
        actor:send("Minimum Level: 97")
        if actor:get_has_completed("shift_corpse") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("shift_corpse") then
            actor:send("Quest Master: the necromancer guild masters")
            actor:send("</>")
            if stage == 1 then
                actor:send("Steal the divine spark of Lokari, God of the Moonless Night.")
                actor:send("</>")
                actor:send("Give him " .. tostring(objects.template(62, 28).name) .. ", then destroy him.")
                actor:send("</>")
                actor:send("If you need a new crystal, say &9<blue>\"I need a new crystal\"</>.")
            elseif stage == 2 then
                actor:send("Destroy Lokari!")
            end
        end
    end
end
return _return_value