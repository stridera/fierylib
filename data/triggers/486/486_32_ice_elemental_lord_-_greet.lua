-- Trigger: ice elemental lord - greet
-- Zone: 486, ID: 32
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #48632

-- Converted from DG Script #48632: ice elemental lord - greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
if self:has_effect(Effect.Blind) then
    return _return_value
end
if self:has_effect(Effect.Coldshield) then
    self.room:spawn_object(11, 60)
    get_room(11, 0):at(function()
        -- Fragment (possible truncation): quaff coldshield
    end)
end
local coldproof = not self:has_effect(Effect.Cold)
if coldproof then
    self.room:spawn_object(11, 71)
    get_room(11, 0):at(function()
        -- Fragment (possible truncation): quaff negate-cold
    end)
end
if self:has_effect(Effect.Waterform) then
    self.room:spawn_object(11, 78)
    get_room(11, 0):at(function()
        -- Fragment (possible truncation): quaff waterform
    end)
end