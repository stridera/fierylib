-- Trigger: Load lashes
-- Zone: 43, ID: 63
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #4363

-- Converted from DG Script #4363: Load lashes
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
if not self:get_objects("4351") then
    self.room:spawn_object(43, 51)
end
if not self:get_objects("4311") then
    self.room:spawn_object(43, 11)
end