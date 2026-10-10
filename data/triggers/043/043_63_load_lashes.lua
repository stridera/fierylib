-- Trigger: Load lashes
-- Zone: 43, ID: 63
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #4363

-- Converted from DG Script #4363: Load lashes
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- Room-scoped existence check: self:get_objects(zone, id) returns the item or nil.
if not self:get_objects(43, 51) then
    self.room:spawn_object(43, 51)
end
if not self:get_objects(43, 11) then
    self.room:spawn_object(43, 11)
end