-- Trigger: firecaster
-- Zone: 0, ID: 6
-- Type: OBJECT, Flags: GET, WEAR
-- Status: CLEAN
--
-- Original DG Script: #6
-- Flame effect on get/wear. Original returned false to block the action.
-- TODO(parity): blocking get/wear seems unusual for a flavor flame effect;
--               verify whether the legacy intent was to allow (return true).

self.room:send("A <red>Flame</> snakes up down the blade of " .. tostring(self.shortdesc))
return false
