-- Trigger: Air Wand progress journal
-- Zone: 4, ID: 49
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #449

-- Converted from DG Script #449: Air Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local function proto_key(vnum)
    vnum = tonumber(vnum)
    if not vnum then return nil end
    local zone = math.floor(vnum / 100)
    if zone == 0 then zone = 1000 end
    return zone, vnum % 100
end
local function proto_short(vnum)
    local zone, id = proto_key(vnum)
    local name = zone and objects.template(zone, id).name
    if not name or name == "" then return "[no description for object " .. tostring(vnum) .. "]" end
    return name
end
local function mob_short(vnum)
    local zone, id = proto_key(vnum)
    local name = zone and mobiles.template(zone, id).name
    if not name or name == "" then return "[no description for mobile " .. tostring(vnum) .. "]" end
    return name
end
local function room_by_vnum(vnum)
    local zone, id = proto_key(vnum)
    if not zone then return nil end
    return get_room(zone, id)
end
local function room_name(vnum)
    local room = room_by_vnum(vnum)
    return room and room.name or ""
end
local _return_value = true  -- Default: allow action
if (string.find(arg, "air") and (string.find(arg, "wand") or string.find(arg, "wands") or string.find(arg, "staff") or string.find(arg, "staves"))) or string.find(arg, "air_wand") or string.find(arg, "air_wands") or string.find(arg, "air_staff") then
    local sorcererclasses = "Sorcerer Illusionist Cryomancer Pyromancer Necromancer"
    if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
        _return_value = true
        local stage = actor:get_quest_stage("air_wand")
        local minlevel = (stage - 1) * 10
        if minlevel < 1 then
            minlevel = 1
        end
        actor:send("<b:u:green>Air Wand</>")
        actor:send("Masters of air will help you create and upgrade a new mystic weapon.")
        if not actor:get_has_completed("air_wand") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        local status
        if actor:get_has_completed("air_wand") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("air_wand") then
            local job1 = actor:get_quest_var("air_wand:wandtask1")
            local job2 = actor:get_quest_var("air_wand:wandtask2")
            local job3 = actor:get_quest_var("air_wand:wandtask3")
            local job4 = actor:get_quest_var("air_wand:wandtask4")
            local job5 = actor:get_quest_var("air_wand:wandtask5")
            local attack = (stage - 1) * 50
            local weapon
            if stage < 8 then
                weapon = "wand"
            else
                weapon = "staff"
            end
            local remaining = ((attack) - (actor:get_quest_var("air_wand:attack_counter") or 0))
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
                    wandgem = 55577
                elseif tonumber(_sw1) == 3 then
                    master = mobiles.template(185, 0).name
                    hint = "Speak with the old Abbot in the Abbey of St. George."
                    wandgem = 55591
                    wandtask3 = 23750
                elseif tonumber(_sw1) == 4 then
                    master = mobiles.template(586, 1).name
                    hint = "The keeper of a southern coastal tower will have advice for you."
                    wandgem = 55605
                    wandtask3 = 2330
                    wandtask4 = 37006
                elseif tonumber(_sw1) == 5 then
                    master = mobiles.template(123, 5).name
                    hint = "A master of air near the megalith in South Caelia will be able to help next."
                    wandgem = 55644
                    wandtask3 = 12509
                    wandtask4 = "<b:white>the icy ledge outside Technitzitlan</>"
                elseif tonumber(_sw1) == 6 then
                    master = mobiles.template(123, 2).name
                    wandgem = 55665
                    hint = "Seek out the warrior-witch at the center of the southern megalith."
                    wandtask3 = 23800
                    wandtask4 = 59040
                elseif tonumber(_sw1) == 7 then
                    master = mobiles.template(490, 3).name
                    wandgem = 55682
                    hint = "She's hard to deal with, but the Seer of Griffin Isle should have some additional guidance for you."
                    wandtask3 = 51014
                    wandtask4 = 23710
                elseif tonumber(_sw1) == 8 then
                    master = mobiles.template(85, 15).name
                    hint = "In the diabolist's church is a seer who cannot see.  He's a good resource for this kind of work."
                    wandgem = 55721
                    wandtask3 = 11799
                    wandtask4 = 53454
                elseif tonumber(_sw1) == 9 then
                    master = mobiles.template(62, 16).name
                    hint = "The guardian ranger of the Druid Guild in the Red City has some helpful crafting tips."
                    wandgem = 55742
                    wandtask3 = 49019
                    wandtask4 = 23803
                elseif tonumber(_sw1) == 10 then
                    master = mobiles.template(185, 81).name
                    hint = "Silania will help you craft the finest of air weapons."
                    wandgem = 11811
                    wandtask3 = 52001
                    wandtask4 = 48862
                end
            end
            if stage == 1 then
                actor:send("Find " .. tostring(mobiles.template(30, 13).name) .. " and show him your wand.")
                return _return_value
            else
                if actor.level >= minlevel then
                    if (actor:get_quest_var("air_wand:greet") or 0) == 0 and stage ~= 2 then
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
                                        actor:send("</>    Search the far eastern edge of the continent.")
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
                                    actor:send("- <b:yellow>imbue your " .. tostring(weapon) .. " on " .. tostring(wandtask4) .. "</>")
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