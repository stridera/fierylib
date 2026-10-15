-- Trigger: Banish progress journal
-- Zone: 4, ID: 30
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #430

-- Converted from DG Script #430: Banish progress journal
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
local mob
local place
if string.find(arg, "banish") then
    if actor.level >= 50 and (string.find(actor.class, "priest") or string.find(actor.class, "diabolist")) then
        _return_value = true
        local stage = actor:get_quest_stage("banish")
        local master = mobiles.template(302, 16).name
        actor:send("<b:u:green>Banish</>")
        actor:send("Minimum Level: 65")
        local status
        if actor:get_has_completed("banish") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("banish") then
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            -- switch on stage
            local known
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    mob = 41119
                    place = "her chamber under the ocean waves"
                    known = "Nothing."
                elseif tonumber(_sw1) == 2 then
                    mob = 53313
                    place = "the frozen tunnels of the north"
                    known = "v"
                elseif tonumber(_sw1) == 3 then
                    mob = 37000
                    place = "a deep and ancient mine"
                    known = "vi"
                elseif tonumber(_sw1) == 4 then
                    mob = 48005
                    place = "a room filled with art in an ancient barrow"
                    known = "vib"
                elseif tonumber(_sw1) == 5 then
                    mob = 53417
                    place = "the cold valley of the far north"
                    known = "vibu"
                elseif tonumber(_sw1) == 6 then
                    mob = 23811
                    place = "a nearby fortress of clouds and crystals"
                    known = "vibug"
                elseif tonumber(_sw1) == 7 then
                    actor:send("Return to " .. tostring(mobiles.template(302, 16).name) .. " and speak the prayer aloud: <b:magenta>vibugp</>")
                    return _return_value
                end
            end
            if (actor:get_quest_var("banish:greet") or 0) == 1 then
                actor:send("To learn Banish you must next kill " .. mob_short(mob) .. " in " .. tostring(place) .. ".")
            else
                actor:send("Return to " .. tostring(master) .. " for further instruction.")
            end
            actor:send("</>")
            actor:send("</>Your knowledge of the prayer so far: <b:cyan>" .. tostring(known) .. "</>")
        end
    end
end
return _return_value