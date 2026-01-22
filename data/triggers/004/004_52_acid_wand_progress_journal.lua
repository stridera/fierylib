-- Trigger: Acid Wand progress journal
-- Zone: 4, ID: 52
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 36 if statements
--   Large script: 12720 chars
--
-- Original DG Script: #452

-- Converted from DG Script #452: Acid Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if ((string.find(arg, "acid") or string.find(arg, "earth")) and (string.find(arg, "wand") or string.find(arg, "wands") or string.find(arg, "staff") or string.find(arg, "staves"))) or string.find(arg, "acid_wand") or string.find(arg, "acid_wands") or string.find(arg, "acid_staff") or string.find(arg, "earth_wand") or string.find(arg, "earth_wands") or string.find(arg, "earth_staff") then
    local sorcererclasses = "Sorcerer Illusionist Cryomancer Pyromancer Necromancer"
    if string.find(sorcererclasses, "actor.class") then
        _return_value = false
        local stage = actor:get_quest_stage("acid_wand")
        local minlevel = (stage - 1) * 10
        if minlevel < 1 then
            local minlevel = 1
        end
        actor:send("<b:green>&uAcid Wand</>")
        actor:send("Masters of earth will help you create and upgrade a new mystic weapon.")
        if not actor:get_has_completed("acid_wand") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        if actor:get_has_completed("acid_wand") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("acid_wand") then
            local job1 = actor:get_quest_var("acid_wand:wandtask1")
            local job2 = actor:get_quest_var("acid_wand:wandtask2")
            local job3 = actor:get_quest_var("acid_wand:wandtask3")
            local job4 = actor:get_quest_var("acid_wand:wandtask4")
            local job5 = actor:get_quest_var("acid_wand:wandtask5")
            local attack = (stage - 1) * 50
            if stage < 8 then
                local weapon = "wand"
            else
                local weapon = "staff"
            end
            local remaining = ((attack) - actor:get_quest_var("acid_wand:attack_counter"))
            -- switch on stage
            if stage == 2 then
                local master = mobiles.template(30, 13).name
                local wandgem = 55576
            elseif stage == 3 then
                local master = mobiles.template(100, 56).name .. " in Ickle"
                local hint = "First, seek the one who guards the eastern gates of Ickle."
                local wandgem = 55593
                local wandtask3 = 23751
            elseif stage == 4 then
                local master = mobiles.template(625, 4).name .. " in the Rhell Forest"
                local hint = "The next two artisans dwell in the Rhell Forest south-east of Mielikki."
                local wandgem = 55606
                local wandtask3 = 2332
                local wandtask4 = 37006
            elseif stage == 5 then
                local master = mobiles.template(625, 3).name
                local hint = "Your next crafter isn't exactly part of the ranger network...  It's not actually a person at all.  Find the treant in the Rhell forest and ask it for guidance."
                local wandgem = 55647
                local wandtask3 = 16303
                local wandtask4 = "&9&bthe Northern Swamps&0"
            elseif stage == 6 then
                local master = mobiles.template(470, 75).name .. " in the Graveyard"
                local hint = "The ranger who guards the massive necropolis near Anduin has wonderful insights on crafting with decay."
                local wandgem = 55663
                local wandtask3 = 55020
                local wandtask4 = 16107
            elseif stage == 7 then
                local master = mobiles.template(40, 17).name .. " in the Black-Ice Desert"
                local hint = "Your next guide may be hard to locate...  I believe they guard the entrance to a long-lost kingdom beyond a frozen desert."
                local wandgem = 55683
                local wandtask3 = 16305
                local wandtask4 = 37082
            elseif stage == 8 then
                local master = mobiles.template(480, 29).name .. " in the Barrow"
                local hint = "Next, consult with another ranger who guards a place crawling with the dead.  The dwarf ranger in the iron hills will know how to help you."
                local wandgem = 55724
                local wandtask3 = 58414
                local wandtask4 = 53453
                local place = 16355
            elseif stage == 9 then
                local master = mobiles.template(35, 49).name .. " at the Ranger Guild"
                local hint = "The guard of the only known Ranger Guild in the world is also an excellent craftswoman.  Consult with her."
                local wandgem = 55740
                local wandtask3 = 47006
                local wandtask4 = 52018
            elseif stage == 10 then
                local master = mobiles.template(163, 15).name
                local hint = "Your last guide is the head of the ranger network himself, Eleweiss.  He can help make the final improvements to your staff."
                local wandgem = 52031
                local wandtask3 = 52007
                local wandtask4 = 47672
            end
            if stage == 1 then
                actor:send("Find " .. tostring(mobiles.template(30, 13).name) .. " and show him your wand.")
                return _return_value
            else
                if actor.level >= minlevel then
                    if actor:get_quest_var("acid_wand:greet") == 0 and stage ~= 2 then
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
                                        actor:send("</>    Search in the heart of the heart of the thorns.")
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