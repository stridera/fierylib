-- Trigger: Rogue cloak search
-- Zone: 53, ID: 29
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
-- TODO(parity): same elseif/and structure bug as 053_18 — outer `if
-- (room) and (cloakstage == 1)` then nested `elseif self.id == ...`
-- means only stage 1 ever fires. `local continue = "yes"` is
-- branch-scoped (read at 66). Legacy 5-digit room ids. Full rewrite
-- from DG #5329.
--
-- Original DG Script: #5329

-- Converted from DG Script #5329: Rogue cloak search
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: search
if not (cmd == "search") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" or _sw1 == "se" then
        _return_value = true
        return _return_value
    end
end
local cloakstage = actor:get_quest_stage("rogue_cloak")
-- switch on self.id
local continue
do
    if (self.zone_id == 2 and self.id == 180) then
        if (actor.room.zone_id == 136 and actor.room.local_id == 60) and cloakstage == 1 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 181) then
        if (actor.room.zone_id == 185 and actor.room.local_id == 49) and cloakstage == 2 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 182) then
        if ((actor.room.zone_id == 590 and actor.room.local_id == 80) or (actor.room.zone_id == 590 and actor.room.local_id == 81)) and cloakstage == 3 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 183) then
        if (actor.room.zone_id == 126 and actor.room.local_id == 26) and cloakstage == 4 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 184) then
        if (actor.room.zone_id == 160 and actor.room.local_id == 68) and cloakstage == 5 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 185) then
        if ((actor.room.zone_id == 162 and actor.room.local_id == 15) or (actor.room.zone_id == 162 and actor.room.local_id == 20)) and cloakstage == 6 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 186) then
        if (actor.room.zone_id == 370 and actor.room.local_id == 62) and cloakstage == 7 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 187) then
        if (actor.room.zone_id == 530 and actor.room.local_id == 103) and cloakstage == 8 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 188) then
        if (actor.room.zone_id == 480 and actor.room.local_id == 83) and cloakstage == 9 then
            continue = "yes"
        end
    end
end
if continue == "yes" then
    actor:command("search")
    actor:send("<b:yellow>You have found your target!</>")
    actor:set_quest_var("rogue_cloak", "cloaktask4", 1)
else
    _return_value = true
end
return _return_value