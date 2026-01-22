-- Trigger: Fire Wand progress journal
-- Zone: 4, ID: 50
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 36 if statements
--   Large script: 12356 chars
--
-- Original DG Script: #450

-- Converted from DG Script #450: Fire Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if (string.find(arg, "fire") and (string.find(arg, "wand") or string.find(arg, "wands") or string.find(arg, "staff") or string.find(arg, "staves"))) or string.find(arg, "fire_wand") or string.find(arg, "fire_wands") or string.find(arg, "fire_staff") then
    local sorcererclasses = "Sorcerer Illusionist Cryomancer Pyromancer Necromancer"
    if string.find(sorcererclasses, "actor.class") then
        _return_value = false
        local stage = actor:get_quest_stage("fire_wand")
        local minlevel = (stage - 1) * 10
        if minlevel < 1 then
            local minlevel = 1
        end
        actor:send("<b:green>&uFire Wand</>")
        actor:send("Masters of fire will help you create and upgrade a new mystic weapon.")
        if not actor:get_has_completed("fire_wand") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        if actor:get_has_completed("fire_wand") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("fire_wand") then
            local job1 = actor:get_quest_var("fire_wand:wandtask1")
            local job2 = actor:get_quest_var("fire_wand:wandtask2")
            local job3 = actor:get_quest_var("fire_wand:wandtask3")
            local job4 = actor:get_quest_var("fire_wand:wandtask4")
            local job5 = actor:get_quest_var("fire_wand:wandtask5")
            local attack = (stage - 1) * 50
            if stage < 8 then
                local weapon = "wand"
            else
                local weapon = "staff"
            end
            local remaining = ((attack) - actor:get_quest_var("fire_wand:attack_counter"))
            -- switch on stage
            if stage == 2 then
                local master = mobiles.template(30, 13).name
                local wandgem = 55575
            elseif stage == 3 then
                local master = mobiles.template(41, 26).name
                local hint = "A minion of the dark flame out east will know what to do."
                local wandgem = 55590
                local wandtask3 = 23752
                local wandvnum = 311
            elseif stage == 4 then
                local master = mobiles.template(103, 6).name
                local hint = "There's a fire master in the frozen north who likes to spend his time at the hot springs."
                local wandgem = 55612
                local wandtask3 = 2331
                local wandtask4 = 37006
            elseif stage == 5 then
                local master = mobiles.template(123, 4).name
                local hint = "A master of fire near the megalith in South Caelia will be able to help next."
                local wandgem = 55639
                local wandtask3 = 12526
                local wandtask4 = "&1&bthe Lava Tunnels&0"
            elseif stage == 6 then
                local master = mobiles.template(238, 11).name
                local hint = "A seraph crafts with the power of the sun and sky.  It can be found in the floating fortress in South Caelia."
                local wandgem = 55662
                local wandtask3 = 5201
                local wandtask4 = 32412
            elseif stage == 7 then
                local master = mobiles.template(481, 5).name
                local hint = "I hate to admit it, but Vulcera is your next crafter.  Good luck appeasing her though..."
                local wandgem = 55689
                local wandtask3 = 43018
                local wandtask4 = 11705
            elseif stage == 8 then
                local master = mobiles.template(482, 50).name
                local hint = "You're headed back to Fiery Island.  Crazy old McCabe can help you improve your staff further."
                local wandgem = 55716
                local wandtask3 = 53000
                local wandtask4 = 53456
                local place = 5272
            elseif stage == 9 then
                local master = mobiles.template(484, 12).name
                local hint = "Seek out the one who speaks for the Sun near Anduin.  He can upgrade your wand."
                local wandgem = 55739
                local wandtask3 = 48126
                local wandtask4 = 4013
            elseif stage == 10 then
                local master = mobiles.template(52, 30).name
                local hint = "Surely you've heard of Emmath Firehand.  He's the supreme artisan of fiery goods.  He can help you make the final improvements to your staff."
                local wandgem = 23822
                local wandtask3 = 52002
                local wandtask4 = 47800
            end
            if stage == 1 then
                actor:send("Find " .. tostring(mobiles.template(30, 13).name) .. " and show him your wand.")
                return _return_value
            else
                if actor.level >= minlevel then
                    if actor:get_quest_var("fire_wand:greet") == 0 and stage ~= 2 then
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
                                        actor:send("</>    Search the south point beyond Anlun Vale.")
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
                                    actor:send("- <b:yellow>imbue your " .. tostring(weapon) .. " in " .. tostring(wandtask4) .. "</>")
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