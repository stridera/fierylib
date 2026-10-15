-- Trigger: Assassin mask command hide
-- Zone: 60, ID: 58
-- Type: OBJECT, Flags: COMMAND
--
-- TODO(parity): the converter mangled the room/maskstage gating into nested
-- elseif chains that never match. The outer `if (actor.room >= 5436 ...) and
-- maskstage == 1` only matches stage 1; the stage 2-9 `elseif` arms are
-- nested INSIDE that block and so are unreachable. Needs a full rewrite as
-- a flat switch on maskstage with the proper room-range check per stage.
--
-- Original DG Script: #6058

-- Converted from DG Script #6058: Assassin mask command hide
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: hide
if not (cmd == "hide") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "h" or _sw1 == "hi" then
        _return_value = true
        return _return_value
    end
end
local maskstage = actor:get_quest_stage("assassin_mask")
-- switch on self.id
local continue
do
    if (self.zone_id == 2 and self.id == 150) then
        if (actor.room >= 5436 and actor.room <= 5440) and maskstage == 1 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 151) then
        if (actor.room >= 16165 and actor.room <= 16173) and maskstage == 2 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 152) then
        if (actor.room >= 23711 and actor.room <= 23715) and maskstage == 3 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 153) then
        if actor.room == 16087 and maskstage == 4 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 154) then
        if actor.room == 51023 and maskstage == 5 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 155) then
        if ((actor.room >= 48191 and actor.room <= 48196) or (actor.room >= 48225 and actor.room <= 48232)) and maskstage == 6 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 156) then
        if actor.room == 4064 and maskstage == 7 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 157) then
        if actor.room == 48045 and maskstage == 8 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 158) then
        if actor.room == 52046 and maskstage == 9 then
            continue = "yes"
        end
    end
end
if continue == "yes" then
    actor:command("hide")
    wait(0.2)
    actor:send("<b:black>" .. tostring(self.shortdesc) .. " seems to absorb the shadowy darkness around you!")
    actor:set_quest_var("assassin_mask", "masktask4", 1)
else
    _return_value = true
end
return _return_value