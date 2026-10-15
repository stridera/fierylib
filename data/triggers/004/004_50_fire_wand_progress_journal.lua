-- Trigger: Fire Wand progress journal
-- Zone: 4, ID: 50
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #450

-- Converted from DG Script #450: Fire Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
-- Item, mob and room names go through the dg library: the legacy vnums are not zone * 100 + id
-- everywhere (zone 117 holds 11811, zone 30 holds 3218, ...), and a task flag that was reset to 0
-- counts as unset (dg.flag).
local dg = require("dg")
local function proto_short(vnum) return dg.oname(vnum) end
local function mob_short(vnum) return dg.mname(vnum) end
local function room_name(vnum) return dg.rname(vnum) end
local _return_value = true  -- Default: allow action
if (string.find(arg, "fire") and (string.find(arg, "wand") or string.find(arg, "wands") or string.find(arg, "staff") or string.find(arg, "staves"))) or string.find(arg, "fire_wand") or string.find(arg, "fire_wands") or string.find(arg, "fire_staff") then
    local sorcererclasses = "Sorcerer Illusionist Cryomancer Pyromancer Necromancer"
    if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
        _return_value = true
        local stage = actor:get_quest_stage("fire_wand")
        local minlevel = (stage - 1) * 10
        if minlevel < 1 then
            minlevel = 1
        end
        actor:send("<b:u:green>Fire Wand</>")
        actor:send("Masters of fire will help you create and upgrade a new mystic weapon.")
        if not actor:get_has_completed("fire_wand") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        local status
        if actor:get_has_completed("fire_wand") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("fire_wand") then
            local job1 = dg.flag(actor:get_quest_var("fire_wand:wandtask1"))
            local job2 = dg.flag(actor:get_quest_var("fire_wand:wandtask2"))
            local job3 = dg.flag(actor:get_quest_var("fire_wand:wandtask3"))
            local job4 = dg.flag(actor:get_quest_var("fire_wand:wandtask4"))
            local job5 = dg.flag(actor:get_quest_var("fire_wand:wandtask5"))
            local attack = (stage - 1) * 50
            local weapon
            if stage < 8 then
                weapon = "wand"
            else
                weapon = "staff"
            end
            local remaining = ((attack) - (actor:get_quest_var("fire_wand:attack_counter") or 0))
            -- switch on stage
            local master
            local wandgem
            local hint
            local wandtask3
            local wandtask4
            local place
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 2 then
                    master = mobiles.template(30, 13).name
                    wandgem = 55575
                elseif tonumber(_sw1) == 3 then
                    master = mobiles.template(41, 26).name
                    hint = "A minion of the dark flame out east will know what to do."
                    wandgem = 55590
                    wandtask3 = 23752
                elseif tonumber(_sw1) == 4 then
                    master = mobiles.template(103, 6).name
                    hint = "There's a fire master in the frozen north who likes to spend his time at the hot springs."
                    wandgem = 55612
                    wandtask3 = 2331
                    wandtask4 = 37006
                elseif tonumber(_sw1) == 5 then
                    master = mobiles.template(123, 4).name
                    hint = "A master of fire near the megalith in South Caelia will be able to help next."
                    wandgem = 55639
                    wandtask3 = 12526
                    wandtask4 = "<b:red>the Lava Tunnels</>"
                elseif tonumber(_sw1) == 6 then
                    master = mobiles.template(238, 11).name
                    hint = "A seraph crafts with the power of the sun and sky.  It can be found in the floating fortress in South Caelia."
                    wandgem = 55662
                    wandtask3 = 5201
                    wandtask4 = 32412
                elseif tonumber(_sw1) == 7 then
                    master = mobiles.template(481, 5).name
                    hint = "I hate to admit it, but Vulcera is your next crafter.  Good luck appeasing her though..."
                    wandgem = 55689
                    wandtask3 = 43018
                    wandtask4 = 11705
                elseif tonumber(_sw1) == 8 then
                    master = mobiles.template(481, 150).name
                    hint = "You're headed back to Fiery Island.  Crazy old McCabe can help you improve your staff further."
                    wandgem = 55716
                    wandtask3 = 53000
                    wandtask4 = 53456
                    place = 5272
                elseif tonumber(_sw1) == 9 then
                    master = mobiles.template(484, 12).name
                    hint = "Seek out the one who speaks for the Sun near Anduin.  He can upgrade your wand."
                    wandgem = 55739
                    wandtask3 = 48126
                    wandtask4 = 4013
                elseif tonumber(_sw1) == 10 then
                    master = mobiles.template(52, 30).name
                    hint = "Surely you've heard of Emmath Firehand.  He's the supreme artisan of fiery goods.  He can help you make the final improvements to your staff."
                    wandgem = 23822
                    wandtask3 = 52002
                    wandtask4 = 47800
                end
            end
            if stage == 8 then
                place = 5272
            end
            if stage == 1 then
                actor:send("Find " .. tostring(mobiles.template(30, 13).name) .. " and show him your wand.")
                return _return_value
            else
                if actor.level >= minlevel then
                    if (actor:get_quest_var("fire_wand:greet") or 0) == 0 and stage ~= 2 then
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
                                actor:send("- found " .. proto_short(wandgem))
                            end
                            if job3 then
                                if stage ~= 10 then
                                    actor:send("- found " .. proto_short(wandtask3))
                                else
                                    actor:send("- slayed " .. mob_short(wandtask3))
                                end
                            end
                            if job4 then
                                if stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- found " .. proto_short(wandtask4))
                                elseif stage == 5 then
                                    actor:send("- communed in " .. tostring(wandtask4))
                                elseif stage == 9 then
                                    actor:send("- slayed " .. mob_short(wandtask4))
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
                                                    actor:send("- <b:cyan>play</> " .. proto_short(wandtask4))
                                                end
                                            elseif stage == 8 then
                                                if not job5 then
                                                    actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    local room_label = room_name(place)
                                                    actor:send("- imbue your " .. tostring(weapon) .. " at " .. room_label .. ".")
                                                end
                                            elseif stage == 10 then
                                                local room_label = room_name(wandtask4)
                                                actor:send("- imbue your " .. tostring(weapon) .. " at " .. room_label .. ".")
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
                            actor:send("- <b:yellow>find " .. proto_short(wandgem) .. "</>")
                        end
                        if stage > 2 then
                            if not job3 then
                                if stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. proto_short(wandtask3) .. "</>")
                                    if stage == 4 then
                                        actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                                        actor:send("</>    Search the south point beyond Anlun Vale.")
                                        actor:send("</>    The phrase to call the blessing is:")
                                        actor:send("</>    <b:white>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                                    end
                                else
                                    actor:send("- <b:yellow>slay " .. mob_short(wandtask3) .. "</>")
                                end
                            end
                            if not job4 then
                                if stage ~= 3 and stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. proto_short(wandtask4) .. "</>")
                                elseif stage == 5 then
                                    actor:send("- <b:yellow>imbue your " .. tostring(weapon) .. " in " .. tostring(wandtask4) .. "</>")
                                elseif stage == 9 then
                                    actor:send("- <b:yellow>slay " .. mob_short(wandtask4) .. "</>")
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