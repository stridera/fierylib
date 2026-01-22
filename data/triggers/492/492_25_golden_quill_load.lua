-- Trigger: Golden_quill_load
-- Zone: 492, ID: 25
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #49225

-- Converted from DG Script #49225: Golden_quill_load
-- Original: WORLD trigger, flags: GLOBAL, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
get_room(585, 22):at(function()
    self.room:spawn_object(492, 51)
end)