-- Trigger: Resurrection progress journal
-- Zone: 4, ID: 25
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #425

-- Converted from DG Script #425: Resurrection progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local function proto_key(vnum)
    vnum = tonumber(vnum)
    if not vnum then return nil end
    local zone = math.floor(vnum / 100)
    if zone == 0 then zone = 1000 end
    return zone, vnum % 100
end
local function mob_short(vnum)
    local zone, id = proto_key(vnum)
    local name = zone and mobiles.template(zone, id).name
    if not name or name == "" then return "[no description for mobile " .. tostring(vnum) .. "]" end
    return name
end
local _return_value = true  -- Default: allow action
local mob1, mob2, mob3
if string.find(arg, "resurrection") or string.find(arg, "resurrect") or string.find(arg, "resurrection_quest") or string.find(arg, "res") then
    if string.find(actor.class, "cleric") or string.find(actor.class, "priest") or string.find(actor.class, "diabolist") and actor.level >= 75 then
        _return_value = true
        local stage = actor:get_quest_stage("resurrection_quest")
        actor:send("<b:u:green>Resurrection</>")
        actor:send("Minimum Level: 81")
        local status
        if actor:get_has_completed("resurrection_quest") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        local hunt, item
        if stage > 0 and not actor:get_has_completed("resurrection_quest") then
            actor:send("Quest Master: " .. tostring(mobiles.template(85, 50).name))
            actor:send("</>")
            -- switch on stage
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    actor:send("Ask Norisent about payment.")
                    return _return_value
                elseif tonumber(_sw1) == 2 then
                    actor:send("Norisent told you:")
                    actor:send("Do something to interfere with Ziijhan.  I hear he has a bishop locked up in the Cathedral dungeon.")
                    return _return_value
                elseif tonumber(_sw1) == 3 then
                    actor:send("Return to Norisent.")
                    return _return_value
                elseif tonumber(_sw1) == 4 then
                    hunt = tostring(mobiles.template(40, 4).name) .. ", " .. tostring(mobiles.template(40, 3).name) .. ", and " .. tostring(mobiles.template(40, 16).name)
                    mob1 = 4004
                    mob2 = 4003
                    mob3 = 4016
                    item = objects.template(40, 8).name
                elseif tonumber(_sw1) == 5 then
                    item = objects.template(40, 8).name
                elseif tonumber(_sw1) == 6 then
                    hunt = "2 Xeg-Yi and " .. tostring(mobiles.template(533, 8).name)
                    mob2 = 53411
                    mob1 = 53308
                    item = objects.template(533, 7).name
                elseif tonumber(_sw1) == 7 then
                    item = objects.template(533, 7).name
                elseif tonumber(_sw1) == 8 or tonumber(_sw1) == 9 then
                    hunt = tostring(mobiles.template(510, 5).name) .. ", " .. tostring(mobiles.template(530, 1).name) .. ", and " .. tostring(mobiles.template(510, 14).name)
                    mob1 = 51005
                    mob2 = 53001
                    mob3 = 51014
                    if string.find(actor.class, "cleric") or string.find(actor.class, "priest") then
                        item = "a large book on healing from Nordus"
                    elseif string.find(actor.class, "diabolist") then
                        item = objects.template(510, 28).name
                    end
                elseif tonumber(_sw1) == 10 then
                    hunt = tostring(mobiles.template(520, 3).name) .. " and " .. tostring(mobiles.template(520, 15).name)
                    mob1 = 52003
                    mob2 = 52015
                    item = objects.template(520, 1).name
                elseif tonumber(_sw1) == 11 then
                    item = objects.template(520, 1).name
                elseif tonumber(_sw1) == 12 then
                    actor:send("Destroy Norisent!")
                    return _return_value
                end
            end
        end
        if stage == 4 or stage == 6 or stage == 8 or stage == 10 then
            local target1 = actor:get_quest_var("resurrection_quest:mob1")
            local target2 = actor:get_quest_var("resurrection_quest:mob2")
            local target3
            if stage ~= 6 and stage ~= 10 then
                target3 = actor:get_quest_var("resurrection_quest:mob3")
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
                if target1 and ((target2 or 0) == 2) then
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
                    actor:send("- " .. mob_short(mob1))
                end
                if stage == 6 then
                    actor:send("- " .. tostring(target2) .. " " .. mob_short(mob2))
                else
                    if target2 then
                        actor:send("- " .. mob_short(mob2))
                    end
                end
                if stage == 4 or stage == 8 then
                    if target3 then
                        actor:send("- " .. mob_short(mob3))
                    end
                end
            end
            if (stage ~= 6 and (not target1 or not target2 or not target3)) or (stage == 6 and (not target1 or (target2 or 0) < 2)) then
                actor:send("</>")
                actor:send("You still need to dispatch:")
                if not target1 then
                    actor:send("- " .. mob_short(mob1))
                end
                if stage == 6 then
                    if (target2 or 0) < 2 then
                        local xeg = (2 - (target2 or 0))
                        actor:send("- " .. tostring(xeg) .. " " .. mob_short(mob2))
                    end
                else
                    if not target2 then
                        actor:send("- " .. mob_short(mob2))
                    end
                end
                if stage ~= 6 and stage ~= 10 then
                    if not target3 then
                        actor:send("- " .. mob_short(mob3))
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
            actor:send("If you need a new talisman, return to Norisent and say <b:black>\"I need a new talisman\"</>.")
        end
    end
end
return _return_value