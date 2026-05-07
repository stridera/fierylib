-- Trigger: rock_demon_walk_in
-- Zone: 520, ID: 26
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #52026
-- Fires when anyone arrives in the rock demon's chamber: warns the
-- newcomer that the basement ceiling has collapsed sealing them in. The
-- actual exit-state change is owned by 520:25 / 520:27 (rock-well death).
-- TODO(parity): legacy DG version may have also called the seal sub-trigger
-- here so late-arriving players are properly walled in; verify against the
-- original DG dump and add `run_room_trigger(520, 25)` if so.

if actor and actor.is_player then
    actor:send("The basement ceiling collapses in on itself sealing you in!")
end