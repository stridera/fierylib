-- Trigger: Troll Mask progress journal
-- Zone: 4, ID: 6
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 12 if statements
--
-- Original DG Script: #406

-- Converted from DG Script #406: Troll Mask progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "tribal") or string.find(arg, "trouble") or string.find(arg, "tribal_trouble") or string.find(arg, "troll_mask") or string.find(arg, "troll") or string.find(arg, "troll") mask quest then
    if string.find(actor.race, "troll") then
        if actor.level >= 45 then
            _return_value = false
            local job1 = actor:get_quest_var("troll_quest:got_item:37080")
            local job2 = actor:get_quest_var("troll_quest:got_item:37081")
            local job3 = actor:get_quest_var("troll_quest:got_item:37082")
            actor:send("<b:green>&uTribal Trouble</>")
            actor:send("Minimum Level: 55")
            if not actor:get_quest_stage("troll_quest") then
                local status = "Not Started"
            elseif actor:get_has_completed("troll_quest") then
                local status = "Completed!"
            elseif actor:get_quest_stage("troll_quest") == 1 then
                local status = "In Progress"
            end
            actor:send("<cyan>Stats: " .. tostring(status) .. "</>_")
            if actor:get_quest_stage("troll_quest") == 1 then
                actor:send("Quest Master: " .. tostring(mobiles.template(370, 0).name))
                actor:send("</>")
                actor:send(tostring(mobiles.template(370, 0).name) .. " told you:")
                actor:send("Long ago, three powerful items of the trolls were stolen by jealous shamans from different tribes and hidden away.")
                actor:send("If you were to bring the objects back to me, I could reward you quite handsomely._")
                actor:send("- One is the bough of a sacred mangrove tree that stood in the courtyard of a great troll palace before it was destroyed by a feline god of the snows.")
                actor:send("- One is a vial of red dye made from the blood of our enemies, stolen by a tribe in a canyon who wished to unlock its power.")
                actor:send("- One is a large hunk of malachite, a stone we have always valued for its deep green color.  Our enemies the swamp lizards also liked its color, however, and guard it jealously.")
                if job1 or job2 or job3 then
                    actor:send("</>")
                    actor:send("You have found the following items:")
                    if job1 then
                        actor:send("- " .. tostring(objects.template(370, 80).name))
                    end
                    if job2 then
                        actor:send("- " .. tostring(objects.template(370, 81).name))
                    end
                    if job3 then
                        actor:send("- " .. tostring(objects.template(370, 82).name))
                    end
                end
                actor:send("</>")
                actor:send("You still need to find:")
                if not job1 then
                    actor:send("- " .. tostring(objects.template(370, 80).name))
                end
                if not job2 then
                    actor:send("- " .. tostring(objects.template(370, 81).name))
                end
                if not job3 then
                    actor:send("- " .. tostring(objects.template(370, 82).name))
                end
            end
        end
    end
end
return _return_value