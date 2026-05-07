-- Trigger: new trigger
-- Zone: 14, ID: 3
-- Type: MOB, Flags: GREET
-- Status: STUB (original DG #1403 has no body — appears to be an unfinished/template trigger)
--
-- Original DG Script: #1403
--
-- Intent: Unknown. Original was a 3% MOB GREET trigger that branched on
-- the greeted actor's name containing "truth" / "eye" / "eyes" but the
-- branch body was never written. Left as a no-op to preserve a record
-- of the original placeholder.

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end
wait(1)
if arg and (string.find(arg, "truth") or string.find(arg, "eye") or string.find(arg, "eyes")) then
    -- TODO: original DG script had no body here; intent unknown.
end
