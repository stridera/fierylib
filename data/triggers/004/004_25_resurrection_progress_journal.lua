-- Trigger: Resurrection progress journal
-- Zone: 4, ID: 25
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 26 if statements
--   Large script: 7168 chars
--
-- Original DG Script: #425

-- Converted from DG Script #425: Resurrection progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "resurrection") or string.find(arg, "resurrect") or string.find(arg, "resurrection_quest") or string.find(arg, "res") then
    if string.find(actor.class, "Cleric") or string.find(actor.class, "Priest") or string.find(actor.class, "Diabolist") and actor.level >= 75 then
        _return_value = false
        local stage = actor:get_quest_stage("resurrection_quest")
        actor:send("<b:green>&uResurrection</>")
        actor:send("Minimum Level: 81")
        if actor:get_has_completed("resurrection_quest") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("resurrection_quest") then
            actor:send("Quest Master: " .. tostring(mobiles.template(85, 50).name))
            actor:send("</>")
            -- switch on stage
            if stage == 1 then
                actor:send("Ask Norisent about payment.")
                return _return_value
            elseif stage == 2 then
                actor:send("Norisent told you:")
                actor:send("Do something to interfere with Ziijhan.  I hear he has a bishop locked up in the Cathedral dungeon.")
                return _return_value
            elseif stage == 3 then
                actor:send("Return to Norisent.")
                return _return_value
            elseif stage == 4 then
                local hunt = mobiles.template(40, 4).name, mobiles.template(40, 3).name, and mobiles.template(40, 16).name
                local mob1 = 4004
                local mob2 = 4003
                local mob3 = 4016
                local item = objects.template(40, 8).name
            elseif stage == 5 then
                local item = objects.template(40, 8).name
            elseif stage == 6 then
                local hunt = 2 Xeg-Yi and mobiles.template(533, 8).name
                local mob2 = 53411
                local mob1 = 53308
                local item = objects.template(533, 7).name
            elseif stage == 7 then
                local item = objects.template(533, 7).name
            elseif stage == 8 or stage == 9 then
                local hunt = mobiles.template(510, 5).name, mobiles.template(530, 1).name, and mobiles.template(510, 14).name
                local mob1 = 51005
                local mob2 = 53001
                local mob3 = 51014
                if string.find(actor.class, "Cleric") or string.find(actor.class, "Priest") then
                    local item = "a large book on healing from Nordus"
                elseif string.find(actor.class, "Diabolist") then
                    local item = objects.template(510, 28).name
                end
            elseif stage == 10 then
                local hunt = mobiles.template(520, 3).name and mobiles.template(520, 15).name
                local mob1 = 52003
                local mob2 = 52015
                local item = objects.template(520, 1).name
            elseif stage == 11 then
                local item = objects.template(520, 1).name
            elseif stage == 12 then
                actor:send("Destroy Norisent!")
                return _return_value
            end
        end
        if stage == 4 or stage == 6 or stage == 8 or stage == 10 then
            local target1 = actor.quest_variable[resurrection_quest:mob1]
            local target2 = actor.quest_variable[resurrection_quest:mob2]
            if stage ~= 6 and stage ~= 10 then
                local target3 = actor.quest_variable[resurrection_quest:mob3]
            end
            actor:send("You must eliminate:")
            actor:send(tostring(hunt))
            if stage == 4 or stage == 8 then
                if target1 and target2 and target3 then
                    actor:send("</>")
                    actor:send("Show Norisent the death talisman.")
                    return _return_value
                end
            elseif stage == 6 then
                if target1 and (target2 == 2) then
                    actor:send("</>")
                    actor:send("Show Norisent the death talisman.")
                    return _return_value
                end
            else
                if target1 and target2 then
                    actor:send("</>")
                    actor:send("Show Norisent the death talisman.")
                    return _return_value
                end
            end
            if target1 or target2 or target3 then
                actor:send("</>")
                actor:send("You have destroyed:")
                if target1 then
                    actor:send("- " .. "%get.mob_shortdesc[%mob1%]%")
                end
                if stage == 6 then
                    actor:send("- " .. tostring(target2) .. " " .. "%get.mob_shortdesc[%mob2%]%")
                else
                    if target2 then
                        actor:send("- " .. "%get.mob_shortdesc[%mob2%]%")
                    end
                end
                if stage == 4 or stage == 8 then
                    if target3 then
                        actor:send("- " .. "%get.mob_shortdesc[%mob3%]%")
                    end
                end
            end
            if (stage ~= 6 and (not target1 or not target2 or not target3)) or (stage == 6 and (not target1 or target2 < 2)) then
                actor:send("</>")
                actor:send("You still need to dispatch:")
                if not target1 then
                    actor:send("- " .. "%get.mob_shortdesc[%mob1%]%")
                end
                if stage == 6 then
                    if target2 < 2 then
                        local xeg = (2 - target2)
                        actor:send("- " .. tostring(xeg) .. " " .. "%get.mob_shortdesc[%mob2%]%")
                    end
                else
                    if not target2 then
                        actor:send("- " .. "%get.mob_shortdesc[%mob2%]%")
                    end
                end
                if stage ~= 6 and stage ~= 10 then
                    if not target3 then
                        actor:send("- " .. "%get.mob_shortdesc[%mob3%]%")
                    end
                end
                actor:send("</>")
                actor:send("Return " .. tostring(item) .. " as proof.")
            end
            actor:send("</>")
            actor:send("Don't forget the banishment phrase: <b:blue>Dhewsost Konre</>")
        elseif stage == 5 or stage == 7 or stage == 9 or stage == 11 then
            actor:send("Bring Norisent back " .. tostring(item) .. ".")
        end
        if stage >= 4 and not actor:get_has_completed("resurrection_quest") then
            actor:send("</>")
            actor:send("If you need a new talisman, return to Norisent and say &9<blue>\"I need a new talisman\"</>.")
        end
    end
end
return _return_value