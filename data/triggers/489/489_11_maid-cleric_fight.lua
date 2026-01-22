-- Trigger: maid-cleric fight
-- Zone: 489, ID: 11
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48911

-- Converted from DG Script #48911: maid-cleric fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if self.room ~= 48980 then
    self:teleport(get_room(489, 80))
end
if (not world.count_mobiles("48901")) and not (self:has_effect(Effect.Blur)) then
    self:emote("keens for her lost master, lashing out in an uncontrolled frenzy!")
    spells.cast(self, "blur", self, 100)
end
local chance = random(1, 10)
if chance > 7 then
    run_room_trigger(48912)
end