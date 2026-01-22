-- Trigger: Flood progress journal
-- Zone: 4, ID: 37
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 27 if statements
--   Large script: 6697 chars
--
-- Original DG Script: #437

-- Converted from DG Script #437: Flood progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "flood") then
    if string.find(actor.class, "Cryomancer") and actor.level >= 75 then
        _return_value = false
        local stage = actor:get_quest_stage("flood")
        actor:send("<b:green>&uFlood</>")
        actor:send("Minimum Level: 81")
        if actor:get_has_completed("flood") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("flood") then
            actor:send("Quest Master: " .. tostring(mobiles.template(390, 12).name))
            actor:send("</>")
            if stage == 1 then
                local fog = "The Blue-Fog"
                local phoenix = "Phoenix Feather Hot Springs"
                local falls = "Three-Falls River"
                local green = "The Greengreen Sea"
                local witch = "Sea's Lullaby"
                local frost = "Frost Lake"
                local black = "The Black Lake"
                local kod = "The Dreaming River"
                local water1 = actor:get_quest_var("flood:water1")
                local water2 = actor:get_quest_var("flood:water2")
                local water3 = actor:get_quest_var("flood:water3")
                local water4 = actor:get_quest_var("flood:water4")
                local water5 = actor:get_quest_var("flood:water5")
                local water6 = actor:get_quest_var("flood:water6")
                local water7 = actor:get_quest_var("flood:water7")
                local water8 = actor:get_quest_var("flood:water8")
                local item2 = actor:get_quest_var("flood:item2")
                local item3 = actor:get_quest_var("flood:item3")
                local item4 = actor:get_quest_var("flood:item4")
                local item6 = actor:get_quest_var("flood:item6")
                local item7 = actor:get_quest_var("flood:item7")
                actor:send("Rally the Great Waters of Ethilien for " .. tostring(mobiles.template(390, 12).name) .. ".")
                actor:send("</>")
                if water1 or water2 or water3 or water4 or water5 or water6 or water7 or water8 then
                    actor:send("You have rallied:")
                    if water1 then
                        actor:send("- <blue>" .. tostring(fog) .. "</>")
                    end
                    if water2 then
                        actor:send("- <blue>" .. tostring(phoenix) .. "</>")
                    end
                    if water3 then
                        actor:send("- <blue>" .. tostring(falls) .. "</>")
                    end
                    if water4 then
                        actor:send("- <blue>" .. tostring(green) .. "</>")
                    end
                    if water5 then
                        actor:send("- <blue>" .. tostring(witch) .. "</>")
                    end
                    if water6 then
                        actor:send("- <blue>" .. tostring(frost) .. "</>")
                    end
                    if water7 then
                        actor:send("- <blue>" .. tostring(black) .. "</>")
                    end
                    if water8 then
                        actor:send("- <blue>" .. tostring(kod) .. "</>")
                    end
                    actor:send("</>")
                end
                -- list items to be returned
                actor:send("You must still convince:")
                if not water1 then
                    actor:send("- <b:blue>" .. tostring(fog) .. "</>")
                    actor:send("</>")
                end
                if not water2 then
                    actor:send("- <b:blue>" .. tostring(phoenix) .. "</>")
                    if item2 == 1 then
                        actor:send("</>    Bring it " .. tostring(objects.template(584, 1).name) .. " to heat its springs.")
                        actor:send("</>    Say <b:blue>Spirit I have returned</> when you return.")
                    end
                    actor:send("</>")
                end
                if not water3 then
                    actor:send("- <b:blue>" .. tostring(falls) .. "</>")
                    if item3 == 1 then
                        actor:send("</>    Find a bell and dance for them.")
                        actor:send("</>    Say <b:blue>Spirit I have returned</> when you return.")
                    end
                    actor:send("</>")
                end
                if not water4 then
                    actor:send("- <b:blue>" .. tostring(green) .. "</>")
                    if item4 == 1 then
                        actor:send("</>    Feed her as many different foods as you can until she is full.")
                        actor:send("</>    Say <b:blue>Spirit I have returned</> when you return.")
                    end
                    actor:send("</>")
                end
                if not water5 then
                    actor:send("- <b:blue>" .. tostring(witch) .. "</>")
                    actor:send("</>")
                end
                if not water6 then
                    actor:send("- <b:blue>" .. tostring(frost) .. "</>")
                    if item6 == 1 then
                        actor:send("</>    Force her to join the cause.")
                    end
                    actor:send("</>")
                end
                if not water7 then
                    actor:send("- <b:blue>" .. tostring(black) .. "</>")
                    if item7 == 1 then
                        actor:send("</>    Bring it an eternal light to swallow into its blackness.")
                        actor:send("</>    Say <b:blue>Spirit I have returned</> when you return.")
                    end
                    actor:send("</>")
                end
                if not water8 then
                    actor:send("- <b:blue>" .. tostring(kod) .. "</>")
                    actor:send("</>")
                end
                actor:send("Tell them: <b:blue>the Arabel Ocean calls for aid</> and longs for <b:blue>revenge</>.")
            elseif stage ==2 then
                actor:send("Return the Heart of the Ocean to " .. tostring(mobiles.template(390, 12).name) .. "!")
            end
            actor:send("</>")
            actor:send("If you lost the Heart, say <b:blue>I lost the heart</>.")
        end
    end
end
return _return_value