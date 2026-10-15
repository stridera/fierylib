-- Trigger: Word of Command progress journal
-- Zone: 4, ID: 32
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #432

-- Converted from DG Script #432: Word of Command progress journal
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
if string.find(arg, "word") or string.find(arg, "command") or string.find(arg, "word of command") or string.find(arg, "word_command") then
    if actor.level >= 65 then
        local stage
        if string.find(actor.class, "diabolist") or string.find(actor.class, "priest") then
            _return_value = true
            stage = actor:get_quest_stage("word_command")
            actor:send("<b:u:green>Word of Command</>")
            local status
            if actor:get_has_completed("word_command") then
                status = "Completed!"
            elseif (stage or 0) > 0 then
                status = "In Progress"
            else
                status = "Not Started"
            end
            actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        end
        if stage > 0 and not actor:get_has_completed("word_command") then
            actor:send("Quest Master: " .. tostring(mobiles.template(430, 21).name))
            actor:send("</>")
            actor:send("Help " .. tostring(mobiles.template(430, 21).name) .. " escape from Demise Keep!")
            actor:send(mob_short(43017) .. " and its minions will stop at nothing to keep " .. mob_short(43021) .. " trapped in its clutches!")
        end
    end
end
return _return_value