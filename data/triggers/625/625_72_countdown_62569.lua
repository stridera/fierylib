-- Trigger: countdown 62569
-- Zone: 625, ID: 72
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #62572
--
-- TODO(parity): The legacy script keeps `charges`, `maxcharge`, `delay`,
-- and `ready` in object-scoped DG globals shared with trigger 73 (count
-- up) and 74 (seagulls). The converter wrote `globals.X = globals.X or
-- true` no-ops and then read bare `charges` (an undeclared global) as if
-- DG had hoisted it. The runtime now exposes per-object globals via
-- `globals` but the bookkeeping needs to be ported as a unit (72/73/74)
-- so the charge counter is actually shared. Left as a no-op until that
-- port is done.

-- Converted from DG Script #62572: countdown 62569
-- Original: OBJECT trigger, flags: WEAR, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end
return true