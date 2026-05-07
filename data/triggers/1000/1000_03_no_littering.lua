-- Trigger: no littering
-- Zone: 0, ID: 3
-- Type: WORLD, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #3
-- Sends a "no littering" message when a player drops something here.
-- TODO(parity): name suggests this should BLOCK littering, but original DG returns
--               1 (allow). Preserved original semantics; verify intent.

actor:send("You cannot litter here!")
return true
