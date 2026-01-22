-- Trigger: Hellfire and Brimstone progress journal
-- Zone: 4, ID: 46
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 20 if statements
--   Large script: 5430 chars
--
-- Original DG Script: #446

-- Converted from DG Script #446: Hellfire and Brimstone progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "hellfire") or string.find(arg, "brimstone") or string.find(arg, "hellfire_and_brimstone") or string.find(arg, "hellfire_brimstone") then
    if string.find(actor.class, "Diabolist") and actor.level >= 50 then
        _return_value = false
        local master = mobiles.template(23, 11).name
        local stage = actor:get_quest_stage("hellfire_brimstone")
        actor:send("<b:green>&uHellfire and Brimstone</>")
        actor:send("Minimum Level: 57")
        if actor:get_has_completed("hellfire_brimstone") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("hellfire_brimstone") then
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            -- switch on stage
            if stage == 1 then
                local meat = actor:get_quest_var("hellfire_brimstone:meat")
                actor:send(tostring(master) .. " needs <b:red>meat</> for the fire.")
                local total = (6 - meat)
                if total == 1 then
                    actor:send("Drop <b:red>" .. tostring(total) .. "</> more pound of flesh from the paladins at the Sacred Haven into the bonfire.")
                else
                    actor:send("Drop <b:red>" .. tostring(total) .. "</> pounds of flesh from the paladins at the Sacred Haven into the bonfire.")
                end
            elseif stage == 2 then
                local brimstone = actor:get_quest_var("hellfire_brimstone:brimstone")
                actor:send(tostring(master) .. " needs <b:yellow>brimstone</> to trace out the sigils.")
                -- (empty send to actor)
                local total = (6 - brimstone)
                if total == 1 then
                    actor:send("Bring <b:yellow>" .. tostring(total) .. "</> more quantity of brimstone from fiery spirits on the volcanic island to the north and drop them into the bonfire.")
                else
                    actor:send("Bring <b:yellow>" .. tostring(total) .. "</> quantities of brimstone from fiery spirits on the volcanic island to the north and drop it into the bonfire.")
                end
            elseif stage == 3 then
                local item1 = actor:get_quest_var("hellfire_brimstone:4318")
                local item2 = actor:get_quest_var("hellfire_brimstone:5211")
                local item3 = actor:get_quest_var("hellfire_brimstone:5212")
                local item4 = actor:get_quest_var("hellfire_brimstone:17308")
                local item5 = actor:get_quest_var("hellfire_brimstone:48110")
                local item6 = actor:get_quest_var("hellfire_brimstone:53000")
                actor:send("You are to bring " .. tostring(master) .. " fiery tributes to the Dark One.")
                actor:send("</>")
                if item1 or item2 or item3 or item4 or item5 or item6 then
                    actor:send("You have already given him:")
                    if item1 then
                        actor:send("- " .. tostring(objects.template(43, 18).name))
                    end
                    if item2 then
                        actor:send("- " .. tostring(objects.template(52, 11).name))
                    end
                    if item3 then
                        actor:send("- " .. tostring(objects.template(52, 12).name))
                    end
                    if item4 then
                        actor:send("- " .. tostring(objects.template(173, 8).name))
                    end
                    if item5 then
                        actor:send("- " .. tostring(objects.template(481, 10).name))
                    end
                    if item6 then
                        actor:send("- " .. tostring(objects.template(530, 0).name))
                    end
                end
                actor:send("</>")
                actor:send("Now bring him:")
                if not item1 then
                    actor:send("- " .. tostring(objects.template(43, 18).name) .. "</> from an actress in Anduin.</>")
                end
                if not item2 then
                    actor:send("- <b:white>" .. tostring(objects.template(52, 11).name) .. "</> from a beam of starlight deep in mine.</>")
                end
                if not item3 then
                    actor:send("- <blue>" .. tostring(objects.template(52, 12).name) .. "</> from a devotee of neutrality on a hill.</>")
                end
                if not item4 then
                    actor:send("- &9<blue>" .. tostring(objects.template(173, 8).name) .. " from Chaos incarnate.</>")
                end
                if not item5 then
                    actor:send("- <b:red>" .. tostring(objects.template(481, 10).name) .. "</> from the volcano goddess.</>")
                end
                if not item6 then
                    actor:send("- " .. tostring(objects.template(530, 0).name) .. "</> from a king in a throne room crypt.</>")
                end
            end
        end
    end
end
return _return_value