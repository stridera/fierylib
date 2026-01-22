-- Trigger: Ice Wand progress journal
-- Zone: 4, ID: 51
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 36 if statements
--   Large script: 12725 chars
--
-- Original DG Script: #451

-- Converted from DG Script #451: Ice Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if ((string.find(arg, "ice") or string.find(arg, "water") or string.find(arg, "cold") or string.find(arg, "frost")) and (string.find(arg, "wand") or string.find(arg, "wands") or string.find(arg, "staff") or string.find(arg, "staves"))) or string.find(arg, "ice_wand") or string.find(arg, "ice_wands") or string.find(arg, "ice_staff") or string.find(arg, "water_wand") or string.find(arg, "water_wands") or string.find(arg, "water_staff") then
    local sorcererclasses = "Sorcerer Illusionist Cryomancer Pyromancer Necromancer"
    if string.find(sorcererclasses, "actor.class") then
        _return_value = false
        local stage = actor:get_quest_stage("ice_wand")
        local minlevel = (stage - 1) * 10
        if minlevel < 1 then
            local minlevel = 1
        end
        actor:send("<b:green>&uIce Wand</>")
        actor:send("Masters of ice and water will help you create and upgrade a new mystic weapon.")
        if not actor:get_has_completed("ice_wand") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        if actor:get_has_completed("ice_wand") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("ice_wand") then
            local job1 = actor:get_quest_var("ice_wand:wandtask1")
            local job2 = actor:get_quest_var("ice_wand:wandtask2")
            local job3 = actor:get_quest_var("ice_wand:wandtask3")
            local job4 = actor:get_quest_var("ice_wand:wandtask4")
            local job5 = actor:get_quest_var("ice_wand:wandtask5")
            local attack = (stage - 1) * 50
            if stage < 8 then
                local weapon = "wand"
            else
                local weapon = "staff"
            end
            local remaining = ((attack) - actor:get_quest_var("ice_wand:attack_counter"))
            -- switch on stage
            if stage == 2 then
                local master = mobiles.template(30, 13).name
                local wandgem = 55574
            elseif stage == 3 then
                local master = mobiles.template(178, 6).name
                local hint = "The shaman near Three-Falls River has developed a powerful affinity for water from his life in the canyons.  Seek his advice."
                local wandgem = 55592
                local wandtask3 = 23753
            elseif stage == 4 then
                local master = mobiles.template(23, 37).name
                local hint = "Many of the best craftspeople aren't even mortal.  There is a water sprite of some renown deep in Anlun Vale."
                local wandgem = 55607
                local wandtask3 = 2333
                local wandtask4 = 37006
            elseif stage == 5 then
                local master = mobiles.template(550, 13).name
                local hint = "A master of spirits in the far north will be able to help next."
                local wandgem = 55640
                local wandtask3 = 58018
                local wandtask4 = "&6&bthe Arabel Ocean&0"
            elseif stage == 6 then
                local master = mobiles.template(238, 2).name
                local hint = "Your next crafter is a distant relative of the Sunfire clan.  He's been squatting in a flying fortress for many months, trying to unlock its secrets."
                local wandgem = 55666
                local wandtask3 = 49011
                local wandtask4 = 17309
            elseif stage == 7 then
                local master = mobiles.template(533, 16).name
                local hint = "You'll need the advice of a master ice sculptor.  One works regularly up in Mt. Frostbite."
                local wandgem = 55684
                local wandtask3 = 55016
                local wandtask4 = 23815
            elseif stage == 8 then
                local master = mobiles.template(103, 0).name
                local hint = "There's another distant relative of the Sunfire clan who runs the hot springs near Ickle.  He's book smart and knows a thing or two about jewel crafting."
                local wandgem = 55717
                local wandtask3 = 23847
                local wandtask4 = 53457
                local place = 55105
            elseif stage == 9 then
                local master = mobiles.template(100, 12).name
                local hint = "The guild guard for the Sorcerer Guild in Ickle has learned plenty of secrets from the inner sanctum.  Talk to him."
                local wandgem = 55743
                local wandtask3 = 48018
                local wandtask4 = 53300
            elseif stage == 10 then
                local master = mobiles.template(550, 20).name
                local hint = "You must know Suralla Iceeye by now.  She's the master artisan of cold and ice.  She'll know how to make the final improvements to your staff."
                local wandgem = 53314
                local wandtask3 = 52005
                local wandtask4 = 47708
            end
            if stage == 1 then
                actor:send("Find " .. tostring(mobiles.template(30, 13).name) .. " and show him your wand.")
                return _return_value
            else
                if actor.level >= minlevel then
                    if actor:get_quest_var("ice_wand:greet") == 0 and stage ~= 2 then
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
                                        actor:send("</>    Search near the crystalline pool in Anlun Vale.")
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