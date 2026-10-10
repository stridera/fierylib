-- Trigger: play command normalizer
-- Zone: 580, ID: 9
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--
-- Stub. Original DG presumably normalised "p" -> "play" so abbreviations
-- still hit the master-charmer instrument triggers; the body never made
-- it through the converter. As written it just returns true.
--
-- TODO: implement actual rewrite (e.g. force_command(actor, "play "..arg)
-- and return false to suppress the original "p" command), or delete the
-- trigger entirely if the runtime command parser already handles "p" as
-- a play prefix.

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: p
if not (cmd == "p") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true
return _return_value