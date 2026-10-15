-- Trigger: Moonwell progress journal
-- Zone: 4, ID: 15
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #415

-- Converted from DG Script #415: Moonwell progress journal
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
local _return_value = true  -- Default: allow action
if string.find(arg, "moonwell") or string.find(arg, "moonwell_spell_quest") then
    if string.find(actor.class, "druid") and actor.level >= 65 then
        _return_value = true
        local stage = actor:get_quest_stage("moonwell_spell_quest")
        local master = mobiles.template(163, 16).name
        actor:send("<b:u:green>Moonwell</>")
        actor:send("Minimum Level: 73")
        local status
        if actor:get_has_completed("moonwell_spell_quest") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("moonwell_spell_quest") then
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            -- switch on stage
            local item
            local place
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 or tonumber(_sw1) == 2 then
                    -- Vine of Mielikki
                    item = 16350
                    place = "an island of lava and fire"
                elseif tonumber(_sw1) == 3 then
                    -- The Heartstone
                    item = 48024
                    place = "an ancient burial site far to the north"
                elseif tonumber(_sw1) == 4 then
                    -- Flask of Eleweiss
                    item = 16356
                    place = "the cult of the ice dragon"
                elseif tonumber(_sw1) == 5 then
                    -- Flask of Eleweiss
                    item = 16356
                    place = "the cult of the ice dragon"
                elseif tonumber(_sw1) == 6 then
                    -- Glittering ruby ring
                    item = 5201
                    place = "a temple dedicated to fire"
                elseif tonumber(_sw1) == 7 then
                    -- Orb of Winds
                    item = 16006
                    place = "a dark fortress to the east"
                elseif tonumber(_sw1) == 8 then
                    -- Jade ring
                    item = 49011
                    place = "a wood nymph on an island of our brothers beset by beasts"
                elseif tonumber(_sw1) == 10 then
                    -- Chaos Orb
                    item = 4003
                    place = "a great dragon hidden in a hellish labyrinth"
                elseif tonumber(_sw1) == 11 then
                    -- Granite Ring
                    item = 55020
                    place = "a large temple hidden in a mountain"
                end
            end
            if stage < 6 or (stage >= 6 and (actor:get_quest_var("moonwell_spell_quest:map") or 0) == 0) then
                actor:send("Bring " .. proto_short(item) .. " from " .. tostring(place) .. ".")
            else
                actor:send("Bring " .. tostring(master) .. " your bark map.")
            end
            if stage > 6 then
                actor:send("</>")
                actor:send("If you need a new map, return to " .. tostring(master) .. " and say \"<b:green>I lost my map</>\".")
            end
        end
    end
end
return _return_value