-- Trigger: Group Armor progress journal
-- Zone: 4, ID: 27
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 18 if statements
--
-- Original DG Script: #427

-- Converted from DG Script #427: Group Armor progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "group_armor") or string.find(arg, "group_armor") then
    if (actor.level >= 50 and string.find(actor.class, "Priest")) or (actor.level >= 65 and string.find(actor.class, "Cleric")) then
        _return_value = false
        local stage = actor:get_quest_stage("group_armor")
        actor:send("<b:green>&uGroup Armor</>")
        if string.find(actor.class, "Priest") then
            actor:send("Minimum Level: 57")
        elseif string.find(actor.class, "Cleric") then
            actor:send("Minimum Level: 65")
        end
        if actor:get_has_completed("group_armor") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("group_armor") then
            actor:send("Quest Master: " .. tostring(mobiles.template(590, 99).name))
            actor:send("</>")
            -- switch on stage
            if stage == 1 then
                local item1 = actor:get_quest_var("group_armor:6118")
                local item2 = actor:get_quest_var("group_armor:11704")
                local item3 = actor:get_quest_var("group_armor:11707")
                local item4 = actor:get_quest_var("group_armor:16906")
                local obj1 = objects.template(61, 18).name
                local obj2 = objects.template(117, 4).name
                local obj3 = objects.template(117, 7).name
                local obj4 = objects.template(169, 6).name
                local step = "locate items that cast the spell &7&barmor&0"
            elseif stage == 2 then
                local step = "find a new &7&bforging hammer&0"
            elseif stage == 3 or stage == 4 then
                local step = "take the forging hammer where light reaches deep underground and &7&b[commune]&0"
            elseif stage == 5 then
                local step = "find a suitable amulet to be the focus of this spell"
                local item1 = actor:get_quest_var("group_armor:12500")
                local obj1 = objects.template(125, 0).name
            elseif stage == 6 then
                local step = "locate ethereal items to provide protective energy to the amulet"
                local item1 = actor:get_quest_var("group_armor:47004")
                local item2 = actor:get_quest_var("group_armor:47018")
                local item3 = actor:get_quest_var("group_armor:53003")
                local obj1 = objects.template(470, 4).name
                local obj2 = objects.template(470, 18).name
                local obj3 = objects.template(530, 3).name
            end
            actor:send("You are trying to " .. tostring(step) .. ".")
            if stage == 1 or stage == 5 or stage == 6 then
                if item1 or item2 or item3 or item4 then
                    actor:send("</>")
                    actor:send("You have already brought:")
                    if item1 then
                        actor:send("- " .. tostring(obj1))
                    end
                    if item2 then
                        actor:send("- " .. tostring(obj2))
                    end
                    if item3 then
                        actor:send("- " .. tostring(obj3))
                    end
                    if item4 then
                        actor:send("- " .. tostring(obj4))
                    end
                end
                actor:send("</>")
                actor:send("You still need to locate:")
                if not item1 then
                    actor:send("- <b:yellow>" .. tostring(obj1) .. "</>")
                end
                if stage == 1 or stage == 6 then
                    if not item2 then
                        actor:send("- <b:yellow>" .. tostring(obj2) .. "</>")
                    end
                    if not item3 then
                        actor:send("- <b:yellow>" .. tostring(obj3) .. "</>")
                    end
                    if stage == 1 then
                        if not item4 then
                            actor:send("- <b:yellow>" .. tostring(obj4) .. "</>")
                        end
                    end
                end
            end
        end
    end
end
return _return_value