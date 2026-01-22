-- Trigger: Wall of Ice progress journal
-- Zone: 4, ID: 36
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #436

-- Converted from DG Script #436: Wall of Ice progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if (string.find(arg, "wall") and string.find(arg, "ice")) or string.find(arg, "wall") of ice or string.find(arg, "wall_ice") or string.find(arg, "wall_of_ice") then
    if string.find(actor.class, "Cryomancer") and actor.level >= 50 then
        _return_value = false
        actor:send("<b:green>&uWall of Ice</>")
        actor:send("Minimum Level: 57")
        if actor:get_has_completed("wall_ice") then
            local status = "Completed!"
        elseif actor:get_quest_stage("wall_ice") then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor:get_quest_stage("wall_ice") == 1 then
            actor:send("Quest Master: " .. tostring(mobiles.template(533, 16).name))
            actor:send("</>")
            actor:send("Collect 20 blocks of living ice from ice creatures.")
            actor:send("Say \"Crystalize\" in their presence to cast the spell of living ice.")
            local have = actor:get_quest_var("wall_ice:blocks")
            local need = (20 - have)
            actor:send("</>")
            actor:send("You have brought <b:cyan>" .. tostring(have) .. " blocks of living ice.</>")
            actor:send("</>")
            actor:send("You still need <b:cyan>" .. tostring(need) .. "</> more.")
            actor:send("</>")
            actor:send("If you need a new copy of the spell of living ice, return to the sculptor and say, \"<b:cyan>please replace the spell</>\".")
        end
    end
end
return _return_value