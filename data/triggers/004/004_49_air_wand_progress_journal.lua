-- Trigger: Air Wand progress journal
-- Zone: 4, ID: 49
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 36 if statements
--   Large script: 12148 chars
--
-- Original DG Script: #449

-- Converted from DG Script #449: Air Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if (string.find(arg, "air") and (string.find(arg, "wand") or string.find(arg, "wands") or string.find(arg, "staff") or string.find(arg, "staves"))) or string.find(arg, "air_wand") or string.find(arg, "air_wands") or string.find(arg, "air_staff") then
    local sorcererclasses = "Sorcerer Illusionist Cryomancer Pyromancer Necromancer"
    if string.find(sorcererclasses, "actor.class") then
        _return_value = false
        local stage = actor:get_quest_stage("air_wand")
        local minlevel = (stage - 1) * 10
        if minlevel < 1 then
            local minlevel = 1
        end
        actor:send("<b:green>&uAir Wand</>")
        actor:send("Masters of air will help you create and upgrade a new mystic weapon.")
        if not actor:get_has_completed("air_wand") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        if actor:get_has_completed("air_wand") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("air_wand") then
            local job1 = actor:get_quest_var("air_wand:wandtask1")
            local job2 = actor:get_quest_var("air_wand:wandtask2")
            local job3 = actor:get_quest_var("air_wand:wandtask3")
            local job4 = actor:get_quest_var("air_wand:wandtask4")
            local job5 = actor:get_quest_var("air_wand:wandtask5")
            local attack = (stage - 1) * 50
            if stage < 8 then
                local weapon = "wand"
            else
                local weapon = "staff"
            end
            local remaining = ((attack) - actor:get_quest_var("air_wand:attack_counter"))
            -- switch on stage
            if stage == 2 then
                local master = mobiles.template(30, 13).name
                local wandgem = 55577
            elseif stage == 3 then
                local master = mobiles.template(185, 0).name
                local hint = "Speak with the old Abbot in the Abbey of St. George."
                local wandgem = 55591
                local wandtask3 = 23750
            elseif stage == 4 then
                local master = mobiles.template(586, 1).name
                local hint = "The keeper of a southern coastal tower will have advice for you."
                local wandgem = 55605
                local wandtask3 = 2330
                local wandtask4 = 37006
            elseif stage == 5 then
                local master = mobiles.template(123, 5).name
                local hint = "A master of air near the megalith in South Caelia will be able to help next."
                local wandgem = 55644
                local wandtask3 = 12509
                local wandtask4 = "&7&bthe icy ledge outside Technitzitlan&0"
            elseif stage == 6 then
                local master = mobiles.template(123, 2).name
                local wandgem = 55665
                local hint = "Seek out the warrior-witch at the center of the southern megalith."
                local wandtask3 = 23800
                local wandtask4 = 59040
            elseif stage == 7 then
                local master = mobiles.template(490, 3).name
                local wandgem = 55682
                local hint = "She's hard to deal with, but the Seer of Griffin Isle should have some additional guidance for you."
                local wandtask3 = 51014
                local wandtask4 = 23710
            elseif stage == 8 then
                local master = mobiles.template(85, 15).name
                local hint = "In the diabolist's church is a seer who cannot see.  He's a good resource for this kind of work."
                local wandgem = 55721
                local wandtask3 = 11799
                local wandtask4 = 53454
            elseif stage == 9 then
                local master = mobiles.template(62, 16).name
                local hint = "The guardian ranger of the Druid Guild in the Red City has some helpful crafting tips."
                local wandgem = 55742
                local wandtask3 = 49019
                local wandtask4 = 23803
            elseif stage == 10 then
                local master = mobiles.template(185, 81).name
                local hint = "Silania will help you craft the finest of air weapons."
                local wandgem = 11811
                local wandtask3 = 52001
                local wandtask4 = 48862
            end
            if stage == 1 then
                actor:send("Find " .. tostring(mobiles.template(30, 13).name) .. " and show him your wand.")
                return _return_value
            else
                if actor.level >= minlevel then
                    if actor:get_quest_var("air_wand:greet") == 0 and stage ~= 2 then
                        actor:send("Find the next master crafter and tell them why you have come.")
                        actor:send(tostring(hint))
                        return _return_value
                    else
                        actor:send("Quest Master: " .. tostring(master))
                        actor:send("</>")
                        if job1 or job2 or job3 or job4 then
                            actor:send("You've done the following:")
                            if job1 then
                                actor:send("- used your " .. tostring(weapon) .. " " .. tostring(attack) .. " times")
                            end
                            if job2 then
                                actor:send("- found " .. "%get.obj_shortdesc[%wandgem%]%")
                            end
                            if job3 then
                                if stage ~= 10 then
                                    actor:send("- found " .. "%get.obj_shortdesc[%wandtask3%]%")
                                else
                                    actor:send("- slayed " .. "%get.mob_shortdesc[%wandtask3%]%")
                                end
                            end
                            if job4 then
                                if stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- found " .. "%get.obj_shortdesc[%wandtask4%]%")
                                elseif stage == 5 then
                                    actor:send("- communed in " .. tostring(wandtask4))
                                elseif stage == 9 then
                                    actor:send("- slayed " .. "%get.mob_shortdesc[%wandtask4%]%")
                                end
                            end
                            actor:send("</>")
                        end
                        actor:send("You need to:")
                        if job1 and job2 then
                            if stage == 2 then
                                actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                            else
                                if job3 then
                                    if stage == 3 then
                                        actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    else
                                        if job4 then
                                            if stage ~= 6 and stage ~= 8 and stage ~= 10 then
                                                actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                            elseif stage == 6 then
                                                if not job5 then
                                                    actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    actor:send("- <b:cyan>play</> " .. "%get.obj_shortdesc[%wandtask4%]%")
                                                end
                                            elseif stage == 8 then
                                                if not job5 then
                                                    actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    local room = get.room[place]
                                                    actor:send("- imbue your " .. tostring(weapon) .. " at " .. tostring(room.name) .. ".")
                                                end
                                            elseif stage == 10 then
                                                local room = get.room[wandtask4]
                                                actor:send("- imbue your " .. tostring(weapon) .. " at " .. tostring(room.name) .. ".")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if not job1 then
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your " .. tostring(weapon) .. "</>")
                            end
                        end
                        if not job2 then
                            actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandgem%]%</>")
                        end
                        if stage > 2 then
                            if not job3 then
                                if stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandtask3%]%</>")
                                    if stage == 4 then
                                        actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                                        actor:send("</>    Search the far eastern edge of the continent.")
                                        actor:send("</>    The phrase to call the blessing is:")
                                        actor:send("</>    <b:white>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                                    end
                                else
                                    actor:send("- <b:yellow>slay " .. "%get.mob_shortdesc[%wandtask3%]%</>")
                                end
                            end
                            if not job4 then
                                if stage ~= 3 and stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandtask4%]%</>")
                                elseif stage == 5 then
                                    actor:send("- <b:yellow>imbue your " .. tostring(weapon) .. " on " .. tostring(wandtask4) .. "</>")
                                elseif stage == 9 then
                                    actor:send("- <b:yellow>slay " .. "%get.mob_shortdesc[%wandtask4%]%</>")
                                elseif stage == 10 then
                                    if job1 and job2 and job3 then
                                        actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
return _return_value