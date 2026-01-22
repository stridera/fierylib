-- Trigger: Meteorswarm progress journal
-- Zone: 4, ID: 29
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 12 if statements
--
-- Original DG Script: #429

-- Converted from DG Script #429: Meteorswarm progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "meteor") or string.find(arg, "meteorswarm") then
    if (string.find(actor.class, "Sorcerer") and actor.level >= 65) or (string.find(actor.class, "Pyromancer") and actor.level >= 75) then
        _return_value = false
        local stage = actor:get_quest_stage("meteorswarm")
        actor:send("<b:green>&uMeteorswarm</>")
        if string.find(actor.class, "Sorcerer") then
            actor:send("Minimum Level: 73")
        elseif string.find(actor.class, "Pyromancer") then
            actor:send("Minimum Level: 81")
        end
        if actor:get_has_completed("meteorswarm") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("meteorswarm") then
            actor:send("Quest Master: " .. tostring(mobiles.template(482, 50).name))
            actor:send("</>")
            if actor:get_quest_var("meteorswarm:new") /= yes then
                actor:send("Go find a new meteorite.")
                return _return_value
            elseif actor:get_quest_var("meteorswarm:new") /= no then
                actor:send("Bring the new meteorite to McCabe.")
                return _return_value
            end
            -- switch on stage
            if stage == 1 then
                local task = "Find Jemnon and ask about the rock demon.  McCabe said, \"He's in some tavern, no doubt, waiting for some new blunder to embark on.\""
            elseif stage == 2 then
                local task = "Find a suitable meteor focus from the rock demon in Templace."
                if actor:get_quest_var("meteorswarm:earth") == 0 then
                elseif stage == 3 then
                    local task = "Show him the meteorite."
                else
                    if actor:get_quest_var("meteorswarm:fire") == 0 then
                        local task = "Find and kill the high fire priest in the Lava Tunnels.  Then enter the lava bubble below his secret chambers."
                    else
                        local task = "Find the lava bubble in the high fire priest's secret chambers."
                    end
                end
                if actor:get_quest_var("meteorswarm:fire") == 1 then
                elseif stage == 4 then
                    local task = "Return to McCabe."
                elseif actor:get_quest_var("meteorswarm:fire") == 2 then
                    local task = "Convince the ancient dragon Dargentan to teach you the ways of air magic."
                end
                if actor:get_quest_var("meteorswarm:air") == 0 then
                elseif stage == 5 then
                    local task = "Show him the meteorite now that you have mastered earth, fire, and air."
                else
                    local task = "Take your finished focus and unleash its potential!"
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