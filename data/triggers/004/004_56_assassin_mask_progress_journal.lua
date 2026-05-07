-- Trigger: Assassin Mask progress journal
-- Zone: 4, ID: 56
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
-- TODO(parity): contains literal DG remnants like %get.obj_shortdesc[...]% or %actor.quest_variable[...]% that the converter left as raw text inside actor:send(...) calls. These need to be rewritten as proper Lua splices using objects.template(zone, id).name and actor:get_quest_var(...) before players see correct output.
--
-- Original DG Script: #456

-- Converted from DG Script #456: Assassin Mask progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "deadly") or string.find(arg, "promotion") or string.find(arg, "deadly_promotion or arg ~=assassin_mask") then
    if string.find(actor.class, "Assassin") then
        _return_value = true
        local bountystage = actor:get_quest_stage("bounty_hunt")
        local maskstage = actor:get_quest_stage("assassin_mask")
        local master = mobiles.template(60, 51).name
        local job1 = actor:get_quest_var("assassin_mask:masktask1")
        local job2 = actor:get_quest_var("assassin_mask:masktask2")
        local job3 = actor:get_quest_var("assassin_mask:masktask3")
        local job4 = actor:get_quest_var("assassin_mask:masktask4")
        actor:send("<b:green>&uDeadly Promotion</>")
        local level
        if not stage then
            level = 10
        else
            level = maskstage * 10
        end
        if not actor:get_has_completed("assassin_mask") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        local status
        if actor:get_has_completed("assassin_mask") then
            status = "Completed!"
        elseif maskstage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level then
            if maskstage == 0 then
                actor:send("You have to do a <b:cyan>[job]</> for " .. tostring(master) .. " first though.")
                return _return_value
            elseif (maskstage >= bountystage) and not actor:get_has_completed("bounty_hunt") then
                actor:send("You need to complete some more Contract Killer jobs before you can receive another promotion.")
                return _return_value
            end
            -- switch on maskstage
            local mask
            local gem
            local place
            local hint
            if maskstage == 1 then
                mask = 4500
                gem = 55592
                place = "The Shadowy Lair"
                hint = "in the Misty Caverns."
            elseif maskstage == 2 then
                mask = 17809
                gem = 55594
                place = "The Dark Chamber"
                hint = "behind a desert door."
            elseif maskstage == 3 then
                mask = 59023
                gem = 55620
                place = "A Dark Tunnel"
                hint = "on the way to a dark, hidden city."
            elseif maskstage == 4 then
                mask = 10304
                gem = 55638
                place = "Dark Chamber"
                hint = "hidden below a ghostly fortress."
            elseif maskstage == 5 then
                mask = 16200
                gem = 55666
                place = "Darkness......"
                hint = "inside an enchanted closet."
            elseif maskstage == 6 then
                mask = 43017
                gem = 55675
                place = "Surrounded by Darkness"
                hint = "in a volcanic shaft."
            elseif maskstage == 7 then
                mask = 51075
                gem = 55693
                place = "Dark Indecision"
                hint = "before an altar in a fallen maze."
            elseif maskstage == 8 then
                mask = 49062
                gem = 55719
                place = "Heart of Darkness"
                hint = "buried deep in an ancient tomb."
            elseif maskstage == 9 then
                mask = 48427
                gem = 55743
                place = "A Dark Room"
                hint = "under the ruins of a shop in an ancient city."
            end
            local attack = maskstage * 100
            actor:send("Quest Master: " .. tostring(master))
            if job1 or job2 or job3 or job4 then
                actor:send("</>")
                actor:send("You've done the following:")
                if job1 then
                    actor:send("- attacked " .. tostring(attack) .. " times")
                end
                if job2 then
                    actor:send("- found " .. "%get.obj_shortdesc[%mask%]%")
                end
                if job3 then
                    actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
                end
                if job4 then
                    actor:send("- hidden in " .. tostring(place))
                end
            end
            actor:send("</>")
            actor:send("You need to:")
            if job1 and job2 and job3 and job4 then
                actor:send("Give " .. tostring(master) .. " your old mask.")
                return _return_value
            end
            if not job1 then
                local remaining = attack - actor:get_quest_var("assassin_mask:attack_counter")
                actor:send("- attack &9<blue>" .. tostring(remaining) .. "</> more times while wearing your mask.")
            end
            if not job2 then
                actor:send("- find &9<blue>" .. "%get.obj_shortdesc[%mask%]%</>")
            end
            if not job3 then
                actor:send("- find &9<blue>" .. "%get.obj_shortdesc[%gem%]%</>")
            end
            if not job4 then
                actor:send("- &9<blue>hide in a place called \"&9<blue>" .. tostring(place) .. "</>\".")
                actor:send("</>   It's &9<blue>" .. tostring(hint) .. "</>")
            end
        end
    end
end
return _return_value