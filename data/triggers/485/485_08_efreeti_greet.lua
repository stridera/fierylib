-- Trigger: efreeti_greet
-- Zone: 485, ID: 8
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #48508

-- Converted from DG Script #48508: efreeti_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
if not (self:has_effect(Effect.Fireshield)) and not (self:has_effect(Effect.Blind)) then
    self.room:spawn_object(11, 65)
    self.room:spawn_object(11, 72)
    get_room(11, 0):at(function()
        -- Fragment (possible truncation): quaff fireshield
    end)
    get_room(11, 0):at(function()
        -- Fragment (possible truncation): quaff negate-heat
    end)
end