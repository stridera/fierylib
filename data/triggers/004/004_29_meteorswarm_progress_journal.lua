-- Trigger: Meteorswarm progress journal
-- Zone: 4, ID: 29
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
-- TODO(parity): the stage-2 branch (lines ~43-69) is tangled by the converter:
-- nested empty `if stage == X then` blocks, multiple shadowed `local task`
-- declarations scoped to inner branches, and `task` is referenced outside the
-- outer if. The body parses but the per-stage messaging is logically broken
-- and needs a structural rewrite against the original DG #429.
--
-- Original DG Script: #429

-- Converted from DG Script #429: Meteorswarm progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "meteor") or string.find(arg, "meteorswarm") then
    if (string.find(actor.class, "sorcerer") and actor.level >= 65) or (string.find(actor.class, "pyromancer") and actor.level >= 75) then
        _return_value = true
        local stage = actor:get_quest_stage("meteorswarm")
        actor:send("<b:u:green>Meteorswarm</>")
        if string.find(actor.class, "sorcerer") then
            actor:send("Minimum Level: 73")
        elseif string.find(actor.class, "pyromancer") then
            actor:send("Minimum Level: 81")
        end
        local status
        if actor:get_has_completed("meteorswarm") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("meteorswarm") then
            actor:send("Quest Master: " .. tostring(mobiles.template(481, 150).name))
            actor:send("</>")
            if actor:get_quest_var("meteorswarm:new") == "yes" then
                actor:send("Go find a new meteorite.")
                return _return_value
            elseif actor:get_quest_var("meteorswarm:new") == "no" then
                actor:send("Bring the new meteorite to McCabe.")
                return _return_value
            end
            -- switch on stage
            local task
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    task = "Find Jemnon and ask about the rock demon.  McCabe said, \"He's in some tavern, no doubt, waiting for some new blunder to embark on.\""
                elseif tonumber(_sw1) == 2 then
                    task = "Find a suitable meteor focus from the rock demon in Templace."
                elseif tonumber(_sw1) == 3 then
                    if (actor:get_quest_var("meteorswarm:earth") or 0) == 0 then
                        task = "Show him the meteorite."
                    else
                        if (actor:get_quest_var("meteorswarm:fire") or 0) == 0 then
                            task = "Find and kill the high fire priest in the Lava Tunnels.  Then enter the lava bubble below his secret chambers."
                        else
                            task = "Find the lava bubble in the high fire priest's secret chambers."
                        end
                    end
                elseif tonumber(_sw1) == 4 then
                    if (actor:get_quest_var("meteorswarm:fire") or 0) == 1 then
                        task = "Return to McCabe."
                    elseif (actor:get_quest_var("meteorswarm:fire") or 0) == 2 then
                        task = "Convince the ancient dragon Dargentan to teach you the ways of air magic."
                    end
                elseif tonumber(_sw1) == 5 then
                    if (actor:get_quest_var("meteorswarm:air") or 0) == 0 then
                        task = "Show him the meteorite now that you have mastered earth, fire, and air."
                    else
                        task = "Take your finished focus and unleash its potential!"
                    end
                end
            end
            actor:send("McCabe wants you to:")
            actor:send(tostring(task))
            if actor:get_quest_var("meteorswarm:earth") then
                actor:send("</>")
                actor:send("If you somehow lost the meteorite, return to McCabe and say <b:red>\"I lost <b:red>the meteorite\"</>.")
            end
        end
    end
end
return _return_value