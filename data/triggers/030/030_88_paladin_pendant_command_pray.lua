-- Trigger: Paladin pendant command pray
-- Zone: 30, ID: 88
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REWRITE
--
-- TODO(parity): converter mangled the legacy switch-on-room-and-stage check
-- into an outer `if actor.room == 5479 and pendantstage == 1` block that
-- accidentally wraps every other room/stage pair. Each later branch uses
-- `if room == X and pendantstage == N then\nelseif self.id == M then` which
-- is structurally wrong (the elseif is unreachable when the room check
-- passes; otherwise the empty `then` falls through). Also `local continue`
-- is declared inside branches so it's nil at the outer `if continue == "yes"`
-- check. Restructure to a single per-stage switch that sets `continue` and
-- hoist the `local continue`.
--
-- Original DG Script: #3088

-- Converted from DG Script #3088: Paladin pendant command pray
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: pray
if not (cmd == "pray") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "p" then
        _return_value = true
        return _return_value
    end
end
local anti = "Anti-Paladin"
local pendantstage = actor:get_quest_stage("paladin_pendant")
-- switch on self.id
local continue
do
    if (self.zone_id == 2 and self.id == 160) then
        if (actor.room.zone_id == 54 and actor.room.local_id == 79) and pendantstage == 1 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 161) then
        if ((actor.room.zone_id == 173 and actor.room.local_id == 45) or (actor.room.zone_id == 173 and actor.room.local_id == 46) or (actor.room.zone_id == 173 and actor.room.local_id == 51) or (actor.room.zone_id == 173 and actor.room.local_id == 52)) and pendantstage == 2 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 162) then
        if (actor.room.zone_id == 495 and actor.room.local_id == 16) and pendantstage == 3 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 163) then
        if (actor.room.zone_id == 23 and actor.room.local_id == 108) and pendantstage == 4 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 164) then
        if (actor.room.zone_id == 551 and actor.room.local_id == 5) and pendantstage == 5 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 165) then
        if (actor.room.zone_id == 530 and actor.room.local_id == 159) and pendantstage == 6 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 166) then
        if (actor.room.zone_id == 584 and actor.room.local_id == 24) and pendantstage == 7 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 167) then
        if (actor.room.zone_id == 480 and actor.room.local_id == 32) and pendantstage == 8 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 168) then
        if (actor.room.zone_id == 488 and actor.room.local_id == 80) and pendantstage == 9 then
            continue = "yes"
        end
    end
end
if continue == "yes" then
    actor:command("pray")
    wait(0.2)
    if actor.class == "paladin" then
        actor:send("<b:yellow>You have gained new insights on your righteous cause!</>")
    elseif actor.class == "anti-paladin" then
        actor:send("<b:red>You have gained new insights on your ruinouse cause!</>")
    end
    actor:set_quest_var("paladin_pendant", "necklacetask4", 1)
else
    _return_value = true
end
return _return_value