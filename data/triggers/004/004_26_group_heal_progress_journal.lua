-- Trigger: Group Heal progress journal
-- Zone: 4, ID: 26
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 24 if statements
--   Large script: 6800 chars
--
-- Original DG Script: #426

-- Converted from DG Script #426: Group Heal progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "group") heal or string.find(arg, "heal") or string.find(arg, "group_heal") then
    if actor.level >= 50 then
        if string.find(actor.class, "Priest") or string.find(actor.class, "Cleric") or string.find(actor.class, "Diabolist") then
            _return_value = false
            local stage = actor:get_quest_stage("group_heal")
            actor:send("<b:green>&uGroup Heal</>")
            actor:send("Minimum Level: 57")
            if actor:get_has_completed("group_heal") then
                local status = "Completed!"
            elseif stage then
                local status = "In Progress"
            else
                local status = "Not Started"
            end
            actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            if stage > 0 and not actor:get_has_completed("group_heal") then
                actor:send("Quest Master: " .. tostring(mobiles.template(185, 21).name))
                actor:send("</>")
                -- switch on stage
                if stage == 1 then
                    actor:send("Track down the bandit raider in the Gothra desert and recover the stolen medical supplies.")
                elseif stage == 2 then
                    actor:send("Return the medical supplies stolen by the bandit raider.")
                elseif stage == 3 or stage == 4 then
                    actor:send("Locate the records of a group healing ritual in a lost kitchen in the Great Northern Swamp.")
                elseif stage == 5 then
                    actor:send("Visit every <b:white>chef</> and <b:white>cook</> to get their notes on the healing ritual.")
                    actor:send("</>")
                    local recipe1 = actor:get_quest_var("group_heal:18515")
                    local recipe2 = actor:get_quest_var("group_heal:18516")
                    local recipe3 = actor:get_quest_var("group_heal:18517")
                    local recipe4 = actor:get_quest_var("group_heal:18518")
                    local recipe5 = actor:get_quest_var("group_heal:18519")
                    local recipe6 = actor:get_quest_var("group_heal:18520")
                    if recipe1 or recipe2 or recipe3 or recipe4 or recipe5 or recipe6 then
                        actor:send("You have already brought notes from:")
                        if recipe1 then
                            actor:send("- " .. tostring(mobiles.template(83, 7).name))
                        end
                        if recipe2 then
                            actor:send("- " .. tostring(mobiles.template(510, 7).name))
                        end
                        if recipe3 then
                            actor:send("- " .. tostring(mobiles.template(185, 12).name))
                        end
                        if recipe4 then
                            actor:send("- " .. tostring(mobiles.template(300, 3).name))
                        end
                        if recipe5 then
                            actor:send("- " .. tostring(mobiles.template(502, 3).name))
                        end
                        if recipe6 then
                            actor:send("- " .. tostring(mobiles.template(103, 8).name))
                        end
                        actor:send("</>")
                    end
                    local total = 6 - actor:get_quest_var("group_heal:total")
                    if total == 1 then
                        actor:send("Bring notes from " .. tostring(total) .. " more chef.")
                    else
                        actor:send("Bring notes from " .. tostring(total) .. " more chefs.")
                    end
                    actor:send("</>")
                    actor :send("If you need a new copy of the Rite, go to the doctor and say: <b:yellow>\"I lost the Rite\"</>.")
                    if actor:get_quest_var("group_heal:total") == 6 then
                    elseif stage == 6 then
                        actor:send("Give " .. tostring(objects.template(185, 14).name) .. " to the doctor.")
                        return _return_value
                    end
                    actor:send("You are delivering the medical packages to <b:white>injured</>, <b:white>wounded</>, <b:white>sick</>, or <b:white>hobbling</> creatures.")
                    local total = (5 - actor:get_quest_var("group_heal:total"))
                    local person1 = actor:get_quest_var("group_heal:18506")
                    local person2 = actor:get_quest_var("group_heal:46414")
                    local person3 = actor:get_quest_var("group_heal:43020")
                    local person4 = actor:get_quest_var("group_heal:12513")
                    local person5 = actor:get_quest_var("group_heal:36103")
                    local person6 = actor:get_quest_var("group_heal:58803")
                    local person7 = actor:get_quest_var("group_heal:30054")
                    actor:send("</>")
                    if person1 or person2 or person3 or person4 or person5 or person6 or person7 then
                        actor:send("You have aided:")
                        if person1 then
                            actor:send("- " .. tostring(mobiles.template(185, 6).name))
                        end
                        if person2 then
                            actor:send("- " .. tostring(mobiles.template(464, 14).name))
                        end
                        if person3 then
                            actor:send("- " .. tostring(mobiles.template(430, 20).name))
                        end
                        if person4 then
                            actor:send("- " .. tostring(mobiles.template(125, 13).name))
                        end
                        if person5 then
                            actor:send("- " .. tostring(mobiles.template(361, 3).name))
                        end
                        if person6 then
                            actor:send("- " .. tostring(mobiles.template(588, 3).name))
                        end
                        if person7 then
                            actor:send("- " .. tostring(mobiles.template(300, 54).name))
                        end
                        actor:send("</>")
                    end
                    if total == 1 then
                        actor:send("You need to deliver " .. tostring(total) .. " more packet.")
                    else
                        actor:send("You need to deliver " .. tostring(total) .. " more packets.")
                    end
                end
            end
        end
    end
end
return _return_value