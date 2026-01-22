-- Trigger: Sacred Haven progress journal
-- Zone: 4, ID: 21
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 12 if statements
--
-- Original DG Script: #421

-- Converted from DG Script #421: Sacred Haven progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "infiltrate") the sacred haven or string.find(arg, "sacred_haven") or string.find(arg, "infiltrate_the_sacred_haven") or string.find(arg, "sacred") haven or string.find(arg, "haven") then
    if actor.level >= 25 then
        _return_value = false
        local stage = actor:get_quest_stage("sacred_haven")
        actor:send("<b:green>&uInfiltrate the Sacred Haven</>")
        actor:send("This quest is only available to neutral and evil-aligned characters.")
        actor:send("This quest is infinitely repeatable.")
        actor:send("Recommended Level: 35")
        if stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage then
            actor:send("Quest Master: " .. tostring(mobiles.template(590, 29).name))
            actor:send("</>")
            local light = actor:get_quest_var("sacred_haven:given_light")
            local key = actor:get_quest_var("sacred_haven:find_key")
            local blood = actor:get_quest_var("sacred_haven:given_blood")
            local trinket = actor:get_quest_var("sacred_haven:given_trinket")
            local earring = actor:get_quest_var("sacred_haven:given_earring")
            if stage == 1 and light == 0 then
                actor:send("Prove yourself.  Bring " .. tostring(objects.template(590, 26).name) .. " from a priest on the second floor of the Haven.")
            elseif stage == 1 and light == 1 then
                actor:send("Ask the figure about their artifacts.")
            elseif stage == 2 and key == 0 then
                actor:send("Break the figure's ally out of jail.")
            elseif stage == 2 and key == 1 then
                actor:send("Find the key the prisoner stashed in the Haven courtyard.")
            elseif stage == 2 and key == 2 then
                actor:send("Bring " .. tostring(mobiles.template(590, 29).name) .. " their artifacts.")
                if blood or trinket or earring then
                    actor:send("</>")
                    actor:send("You have brought:")
                    if blood == 1 then
                        actor:send("- " .. tostring(objects.template(590, 28).name))
                    end
                    if trinket == 1 then
                        actor:send("- " .. tostring(objects.template(590, 29).name))
                    end
                    if earring == 1 then
                        actor:send("- " .. tostring(objects.template(590, 30).name))
                    end
                end
                actor:send("</>")
                actor:send("You still need to find:")
                if blood == 0 then
                    actor:send("- " .. tostring(objects.template(590, 28).name))
                end
                if trinket == 0 then
                    actor:send("- " .. tostring(objects.template(590, 29).name))
                end
                if earring == 0 then
                    actor:send("- " .. tostring(objects.template(590, 30).name))
                end
            end
        end
    end
end
return _return_value