-- Trigger: maid-sorcerer fight
-- Zone: 489, ID: 9
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48909

-- Converted from DG Script #48909: maid-sorcerer fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if self.room ~= 48980 then
    self:teleport(get_room(489, 80))
end
if (not world.count_mobiles("48901")) and not (self:has_effect(Effect.Blur)) then
    self:emote("keens for her lost master, lashing out in an uncontrolled frenzy!")
    spells.cast(self, "blur", self, 100)
end
if stone then
    spells.cast(self, "stone skin", self.room:find_actor("lokari"))
    stone = nil
else
    local chance = random(1, 10)
    if chance > 7 then
        spells.cast(self, "chain lightning")
    end
end