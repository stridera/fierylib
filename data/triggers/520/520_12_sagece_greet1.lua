-- Trigger: sagece_greet1
-- Zone: 520, ID: 12
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #52012

-- Converted from DG Script #52012: sagece_greet1
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor and (actor.level < 100) then
    self:emote("screams, 'I have been waiting for you!!'")
    combat.engage(self, actor.name)
    if actor.id ~= -1 then
        self:breath_attack("fire", nil)
    end
end