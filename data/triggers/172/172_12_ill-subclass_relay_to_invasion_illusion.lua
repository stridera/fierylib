-- Trigger: Ill-subclass: Relay to invasion illusion
-- Zone: 172, ID: 12
-- Type: WORLD, Flags: POSTENTRY
-- Status: NEEDS_REVIEW
--   Cross-trigger invocation (legacy DG `w_run_room_trig 17213`) has no
--   direct runtime equivalent yet; see TODO below.
--
-- When a quester (stage 2 or 3) walks into Gannigan's office (363:36),
-- this trigger fires the invasion-illusion sequence on that room. In DG
-- Script the relay was a `w_run_room_trig 17213`; the invasion script
-- itself lives in 172_13 (zone 172, id 13) marked GLOBAL so it never
-- self-fires.
--
-- Original DG Script: #17212

if actor:get_quest_stage("illusionist_subclass") == 2 or actor:get_quest_stage("illusionist_subclass") == 3 then
    -- TODO(parity): invoke trigger 172:13 in the context of room 363:36.
    -- Needs a runtime helper (e.g. world.run_trigger(zone, id, room) or
    -- room:fire_trigger(zone, id)). Until then, the invasion illusion
    -- never plays and the quest stalls at stage 2/3.
end