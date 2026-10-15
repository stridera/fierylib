-- Trigger: Ranger Trophy command forage
-- Zone: 53, ID: 18
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
-- TODO(parity): the converter mangled the room/stage dispatch — every
-- branch is structured as `if (room cond) and (trophystage == N) then ...
-- elseif self.id == X then`, which only enters the inner self.id arm
-- when the outer room cond fails. Effectively only stage 1 ever fires.
-- `local continue = "yes"` is branch-scoped; reference at line 66 reads
-- a nil global. Legacy 5-digit room ids need split. Full rewrite from
-- DG #5318.
--
-- Original DG Script: #5318

-- Converted from DG Script #5318: Ranger Trophy command forage
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: forage
if not (cmd == "forage") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "f" or _sw1 == "fo" or _sw1 == "for" then
        _return_value = true
        return _return_value
    end
end
local trophystage = actor:get_quest_stage("ranger_trophy")
-- switch on self.id
local continue
do
    if (self.zone_id == 2 and self.id == 170) then
        if actor.room == 8614 and trophystage == 1 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 171) then
        if (actor.room >= 20352 and actor.room <= 20354) and trophystage == 2 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 172) then
        if (actor.room == 2392 or actor.room == 2410) and trophystage == 3 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 173) then
        if actor.room == 46244 and trophystage == 4 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 174) then
        if actor.room == 12429 and trophystage == 5 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 175) then
        if actor.room == 53568 and trophystage == 6 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 176) then
        if actor.room == 49094 and trophystage == 7 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 177) then
        if actor.room == 48080 and trophystage == 8 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 178) then
        if actor.room == 23892 and trophystage == 9 then
            continue = "yes"
        end
    end
end
if continue == "yes" then
    actor:send("You forage through the lair.")
    wait(0.2)
    actor:send("<b:green>Your connection to " .. tostring(self.shortdesc) .. " takes on new meaning!</>")
    actor:set_quest_var("ranger_trophy", "trophytask4", 1)
else
    _return_value = true
end
return _return_value