-- Trigger: Charm Person progress journal
-- Zone: 4, ID: 44
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 28 if statements
--   Large script: 6957 chars
--
-- Original DG Script: #444

-- Converted from DG Script #444: Charm Person progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "charm") or string.find(arg, "person") or string.find(arg, "charm_person") then
    if actor.level >= 85 then
        if string.find(actor.class, "Sorcerer") or string.find(actor.class, "Bard") or string.find(actor.class, "Illusionist") then
            _return_value = false
            local master = mobiles.template(580, 38).name
            local stage = actor:get_quest_stage("charm_person")
            actor:send("<b:green>&uCharm Person</>")
            actor:send("Minimum Level: 89")
            if actor:get_has_completed("charm_person") then
                local status = "Completed!"
            elseif stage then
                local status = "In Progress"
            else
                local status = "Not Started"
            end
            actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            if stage > 0 and not actor:get_has_completed("charm_person") then
                actor:send("Quest Master: " .. tostring(master))
                actor:send("</>")
                -- switch on stage
                if stage == 1 then
                    actor:send("You must find the rod that casts Charm Person in the crypt in the Iron Hills.")
                elseif stage == 2 then
                    actor:send("Help the theatre company in Anduin perform their grand finale and bring back the unique fire ring they give out afterward.")
                    actor:send("</>")
                    actor:send("They have a number of problems which you will need to work out before you can seek out their replacement \"Pippin\" and lure him to his fiery grave.")
                elseif stage == 3 then
                    local item1 = actor:get_quest_var("charm_person:58017")
                    local item2 = actor:get_quest_var("charm_person:16312")
                    local item3 = actor:get_quest_var("charm_person:48925")
                    local item4 = actor:get_quest_var("charm_person:37012")
                    local item5 = actor:get_quest_var("charm_person:41119")
                    actor:send("Locate five musical instruments and bring them to " .. tostring(master) .. ".")
                    if item1 or item2 or item3 or item4 or item5 then
                        actor:send("</>")
                        actor:send("You have already brought:")
                        if item1 then
                            actor:send("- <magenta>" .. tostring(objects.template(580, 17).name) .. "</>")
                        end
                        if item2 then
                            actor:send("- <magenta>" .. tostring(objects.template(163, 12).name) .. "</>")
                        end
                        if item3 then
                            actor:send("- <magenta>" .. tostring(objects.template(489, 25).name) .. "</>")
                        end
                        if item4 then
                            actor:send("- <magenta>" .. tostring(objects.template(370, 12).name) .. "</>")
                        end
                        if item5 then
                            actor:send("- <magenta>" .. tostring(objects.template(411, 19).name) .. "</>")
                        end
                    end
                    actor:send("</>")
                    actor:send("You still need to find:")
                    if not item1 then
                        actor:send("- <b:magenta>" .. tostring(objects.template(580, 17).name) .. "</>")
                    end
                    if not item2 then
                        actor:send("- <b:magenta>" .. tostring(objects.template(163, 12).name) .. "</>")
                    end
                    if not item3 then
                        actor:send("- <b:magenta>" .. tostring(objects.template(489, 25).name) .. "</>")
                    end
                    if not item4 then
                        actor:send("- <b:magenta>" .. tostring(objects.template(370, 12).name) .. "</>")
                    end
                    if not item5 then
                        actor:send("- <b:magenta>" .. tostring(objects.template(411, 19).name) .. "</>")
                    end
                elseif stage == 4 then
                    local charm1 = actor:get_quest_var("charm_person:charm1")
                    local charm2 = actor:get_quest_var("charm_person:charm2")
                    local charm3 = actor:get_quest_var("charm_person:charm3")
                    local charm4 = actor:get_quest_var("charm_person:charm4")
                    local charm5 = actor:get_quest_var("charm_person:charm5")
                    actor:send("You must charm the five master charmers.  Ask them <b:white>[Let me serenade you]</>.")
                    if charm1 or charm2 or charm3 or charm4 or charm5 then
                        actor:send("</>")
                        actor:send("You have already charmed:")
                        if charm1 then
                            actor:send("- <magenta>" .. tostring(mobiles.template(30, 10).name) .. "</>")
                        end
                        if charm2 then
                            actor:send("- <magenta>" .. tostring(mobiles.template(580, 17).name) .. "</>")
                        end
                        if charm3 then
                            actor:send("- <magenta>" .. tostring(mobiles.template(43, 53).name) .. "</>")
                        end
                        if charm4 then
                            actor:send("- <magenta>" .. tostring(mobiles.template(237, 21).name) .. "</>")
                        end
                        if charm5 then
                            actor:send("- <magenta>" .. tostring(mobiles.template(584, 6).name) .. "</>")
                        end
                    end
                    actor:send("</>")
                    actor:send("You still need to find:")
                    if not charm1 then
                        actor:send("- <b:magenta>" .. tostring(mobiles.template(30, 10).name) .. "</>")
                    end
                    if not charm2 then
                        actor:send("- <b:magenta>" .. tostring(mobiles.template(580, 17).name) .. "</>")
                    end
                    if not charm3 then
                        actor:send("- <b:magenta>" .. tostring(mobiles.template(43, 53).name) .. "</>")
                    end
                    if not charm4 then
                        actor:send("- <b:magenta>" .. tostring(mobiles.template(237, 21).name) .. "</>")
                    end
                    if not charm5 then
                        actor:send("- <b:magenta>" .. tostring(mobiles.template(584, 6).name) .. "</>")
                    end
                end
            end
        end
    end
end
return _return_value