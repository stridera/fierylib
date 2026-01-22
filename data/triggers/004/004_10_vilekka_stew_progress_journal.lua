-- Trigger: Vilekka Stew progress journal
-- Zone: 4, ID: 10
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 21 if statements
--   Large script: 5439 chars
--
-- Original DG Script: #410

-- Converted from DG Script #410: Vilekka Stew progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "service") or string.find(arg, "lolth") or string.find(arg, "vilekka_stew") or string.find(arg, "vilekka") or string.find(arg, "stew") or string.find(arg, "drow_boots") or string.find(arg, "in_service_of_lolth") or string.find(arg, "drow_boots") or string.find(arg, "drow") then
    if actor.level >= 25 then
        _return_value = false
        local stage = actor:get_quest_stage("vilekka_stew")
        actor:send("<b:green>&uIn Service of Lolth</>")
        actor:send("This quest is only available to neutral and evil-aligned characters.")
        actor:send("Recommended Level: 90")
        actor:send("- This quest starts at level 25 and continues through level 90.")
        if actor:get_has_completed("vilekka_stew") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("vilekka_stew") then
            actor:send("Quest Master: " .. tostring(mobiles.template(237, 28).name))
            actor:send("</>")
            -- switch on stage
            if stage == 1 then
                actor:send("Bring Vilekka the heart of the drow living in the surface city!")
            elseif stage == 2 then
                actor:send("Tell Vilekka if you wish to stop or continue.")
            elseif stage == 3 then
                actor:send("You must bring Vilekka the head of the drider king.")
            elseif stage == 4 then
                actor:send("Tell Vilekka if you wish to stop or continue.")
            elseif stage == 5 then
                local num_spices = actor:get_quest_var("vilekka_stew:num_spices")
                local spice1 = actor:get_quest_var("vilekka_stew:got_spice:12552")
                local spice2 = actor:get_quest_var("vilekka_stew:got_spice:49022")
                local spice3 = actor:get_quest_var("vilekka_stew:got_spice:23750")
                local spice4 = actor:get_quest_var("vilekka_stew:got_spice:23751")
                local spice5 = actor:get_quest_var("vilekka_stew:got_spice:23752")
                local spice6 = actor:get_quest_var("vilekka_stew:got_spice:23753")
                local spice7 = actor:get_quest_var("vilekka_stew:got_spice:23754")
                local spice8 = actor:get_quest_var("vilekka_stew:got_spice:23755")
                local spice9 = actor:get_quest_var("vilekka_stew:got_spice:23756")
                local spice10 = actor:get_quest_var("vilekka_stew:got_spice:23757")
                local spice11 = actor:get_quest_var("vilekka_stew:got_spice:23758")
                local spice12 = actor:get_quest_var("vilekka_stew:got_spice:23759")
                local spice13 = actor:get_quest_var("vilekka_stew:got_spice:23760")
                actor:send("Bring Vilekka 10 herbs and spices so that she can make a stew out of the head and heart.")
                if num_spices > 0 then
                    actor:send("</>")
                    actor:send("So far you have brought:")
                    if spice1 then
                        actor:send("- " .. tostring(objects.template(125, 52).name))
                    end
                    if spice2 then
                        actor:send("- " .. tostring(objects.template(490, 22).name))
                    end
                    if spice3 then
                        actor:send("- " .. tostring(objects.template(237, 50).name))
                    end
                    if spice4 then
                        actor:send("- " .. tostring(objects.template(237, 51).name))
                    end
                    if spice5 then
                        actor:send("- " .. tostring(objects.template(237, 52).name))
                    end
                    if spice6 then
                        actor:send("- " .. tostring(objects.template(237, 53).name))
                    end
                    if spice7 then
                        actor:send("- " .. tostring(objects.template(237, 54).name))
                    end
                    if spice8 then
                        actor:send("- " .. tostring(objects.template(237, 55).name))
                    end
                    if spice9 then
                        actor:send("- " .. tostring(objects.template(237, 56).name))
                    end
                    if spice10 then
                        actor:send("- " .. tostring(objects.template(237, 57).name))
                    end
                    if spice11 then
                        actor:send("- " .. tostring(objects.template(237, 58).name))
                    end
                    if spice12 then
                        actor:send("- " .. tostring(objects.template(237, 59).name))
                    end
                    if spice13 then
                        actor:send("- " .. tostring(objects.template(237, 60).name))
                    end
                end
                actor:send("</>")
                local total = 10 - num_spices
                actor:send("Bring " .. tostring(total) .. " more spices to prepare the stew.")
            end
        end
    end
end
return _return_value