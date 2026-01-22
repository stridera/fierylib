-- Trigger: chalice_dropped
-- Zone: 185, ID: 14
-- Type: OBJECT, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #18514

-- Converted from DG Script #18514: chalice_dropped
-- Original: OBJECT trigger, flags: DROP, probability: 100%
-- if the chalice is dropped it could be some1 trying to get round
-- the GET trigger...this should prevent that
self.room:send("the DROP trigger for " .. tostring(self.name) .. " is RUNNING")