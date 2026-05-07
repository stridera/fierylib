-- Trigger: Druid is prevented from going up
-- Zone: 120, ID: 5
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #12005
--
-- TODO(parity): Original DG script returns 1 ("allow") when actor vnum is
-- 12018 (the hooded druid mob). The trigger name says "prevented from going
-- up", which suggests the legacy semantic was that PREENTRY returning 1 in
-- that branch *blocks* movement. Verify Rust runtime PREENTRY return-value
-- convention before flipping this. Behaviour preserved verbatim for now.
if actor.zone_id == 120 and actor.local_id == 18 then
    return true
end
return true