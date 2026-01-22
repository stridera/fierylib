-- Trigger: Wizard Eye progress journal
-- Zone: 4, ID: 42
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 16 if statements
--
-- Original DG Script: #442

-- Converted from DG Script #442: Wizard Eye progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "wizard") eye or string.find(arg, "wizard") or string.find(arg, "wizard_eye") then
    if string.find(actor.class, "Sorcerer") and actor.level >= 75 then
        _return_value = false
        local stage = actor:get_quest_stage("wizard_eye")
        local item1 = actor:get_quest_var("wizard_eye:item1")
        local item2 = actor:get_quest_var("wizard_eye:item2")
        local item3 = actor:get_quest_var("wizard_eye:item3")
        local item4 = actor:get_quest_var("wizard_eye:item4")
        actor:send("<b:green>&uWizard Eye</>")
        actor:send("Minimum Level: 81")
        if actor:get_has_completed("wizard_eye") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("wizard_eye") then
            local master = mobiles.template(550, 13).name
            -- switch on stage
            if stage == 1 then
                local master = mobiles.template(324, 10).name
                local task = You are trying to find master in South Caelia Highlands to ask her about Wizard Eye.
            elseif stage == 2 then
                local task = Find marigold poultice from a healer on the beachhead and give it to master.
            elseif stage == 3 then
                local master = mobiles.template(490, 3).name
                local task = Go visit master of Griffin Isle to ask her about Wizard Eye and see what you need to do next.
            elseif stage == 4 then
                local master = mobiles.template(490, 3).name
                local task = Have master make you an herbal sachet.
                local thing1 = objects.template(23, 29).name
                local thing2 = objects.template(237, 53).name
                local thing3 = objects.template(480, 5).name
            elseif stage == 5 then
                local task = Give master the sachet.
            elseif stage == 6 then
                local task = "You are looking for the apothecary in Anduin."
            elseif stage == 7 then
                local master = mobiles.template(60, 22).name
                local task = "Get The Green Woman to make you incense."
                local thing1 = objects.template(237, 54).name
                local thing2 = objects.template(32, 98).name
                local thing3 = objects.template(238, 47).name
                local thing4 = objects.template(180, 1).name
            elseif stage == 8 then
                local task = Give master the incense.
            elseif stage == 9 or stage == 10 then
                local master = mobiles.template(484, 10).name
                local thing1 = objects.template(32, 18).name
                local thing2 = objects.template(534, 24).name
                local thing3 = objects.template(430, 21).name
                local thing4 = objects.template(40, 3).name
                local task = "See the Oracle of Justice."
            elseif stage == 11 then
                local task = Give master the crystal ball.
            elseif stage == 12 then
                local task = Return to master and lay back and go to sleep.
            end
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            actor:send(tostring(task))
            if stage == 4 or stage == 7 or stage == 10 then
                if item1 or item2 or item3 or item4 then
                    actor:send("</>")
                    actor:send("You have already brought:")
                    if item1 then
                        actor:send("- " .. tostring(thing1))
                    end
                    if item2 then
                        actor:send("- " .. tostring(thing2))
                    end
                    if item3 then
                        actor:send("- " .. tostring(thing3))
                    end
                    if item4 then
                        actor:send("- " .. tostring(thing4))
                    end
                end
                actor:send("</>")
                actor:send("You still need to bring:")
                if not item1 then
                    actor:send("- " .. tostring(thing1))
                end
                if not item2 then
                    actor:send("- " .. tostring(thing2))
                end
                if not item3 then
                    actor:send("- " .. tostring(thing3))
                end
                if stage ~= 4 then
                    if not item4 then
                        actor:send("- " .. tostring(thing4))
                    end
                end
            end
        end
    end
end
return _return_value