-- Trigger: TD AB Normalizer
-- Zone: 49, ID: 3
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #4903
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%
--
-- Catches the partial command "ca" on the armband. Returning true allows the
-- normal command lookup to continue (it should expand to "capture" via DG's
-- abbreviation matching, then 049_04 fires). The 1% probability is a token
-- weight against other ca-prefixed commands; the body is intentionally a
-- pass-through.

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

if cmd ~= "ca" then
    return true
end

return true
