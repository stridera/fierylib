-- Trigger: balor-fight
-- Zone: 22, ID: 28
-- Type: MOB, Flags: GREET_ALL, FIGHT
-- Status: CLEAN
--
-- Original DG Script: #2228

-- Converted from DG Script #2228: balor-fight
-- Original: MOB trigger, flags: GREET_ALL, FIGHT, probability: 100%
if not (self:has_effect(Effect.Fireshield)) then
    self.room:spawn_object(520, 53)
    get_room(11, 0):at(function()
        -- Fragment (possible truncation): quaff sagece-fireshield
    end)
    self:destroy_item("sagece-fireshield")
end