-- Trigger: Emmath Flameball progress journal
-- Zone: 4, ID: 17
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 12 if statements
--
-- Original DG Script: #417

-- Converted from DG Script #417: Emmath Flameball progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "power") or string.find(arg, "flame") or string.find(arg, "flameball") or string.find(arg, "emmath_flameball") or string.find(arg, "emmath") then
    if actor.level >= 75 then
        _return_value = false
        local stage = actor:get_quest_stage("emmath_flameball")
        actor:send("<b:green>&uPower of Flame</>")
        actor:send("Recommended Level: 85")
        actor:send("- This quest can be started at any level but requires level 85 to finish.")
        if actor:get_has_completed("emmath_flameball") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("emmath_flameball") then
            actor:send("Quest Master: " .. tostring(mobiles.template(52, 30).name))
            actor:send("</>")
            -- switch on stage
            if stage == 1 then
                actor:send("Return to Emmath and ask to prove your <b:red>worth</>.")
            elseif stage == 2 then
                actor:send("Prove your mastery over fire.")
                actor:send("Bring the three parts of flame: <b:white>White</>, <blue>Gray</>, and &9<blue>Black</>.")
                local black = actor:get_quest_var("emmath_flameball:17308")
                local white = actor:get_quest_var("emmath_flameball:5211")
                local gray = actor:get_quest_var("emmath_flameball:5212")
                if black or white or gray then
                    actor:send("</>")
                    actor:send("You have delivered:")
                    if white then
                        actor:send("- <b:white>" .. tostring(objects.template(52, 11).name) .. "</>")
                    end
                    if gray then
                        actor:send("- <blue>" .. tostring(objects.template(52, 12).name) .. "</>")
                    end
                    if black then
                        actor:send("- &9<blue>" .. tostring(objects.template(173, 8).name) .. "</>")
                    end
                end
                actor:send("</>")
                actor:send("You still need:")
                if not white then
                    actor:send("- <b:white>" .. tostring(objects.template(52, 11).name) .. "</>")
                end
                if not gray then
                    actor:send("- <blue>" .. tostring(objects.template(52, 12).name) .. "</>")
                end
                if not black then
                    actor:send("- &9<blue>" .. tostring(objects.template(173, 8).name) .. "</>")
                end
            elseif stage == 3 then
                actor:send("Bring the renegade <b:blue>blue flame</>.")
            end
        end
    end
end
return _return_value