-- Trigger: maid-rogue fight
-- Zone: 489, ID: 8
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48908

-- Converted from DG Script #48908: maid-rogue fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if self.room ~= 48980 then
    self:teleport(get_room(489, 80))
end
if (not world.count_mobiles("48901")) and not (self:has_effect(Effect.Blur)) then
    self:emote("keens for her lost master, lashing out in an uncontrolled frenzy!")
    spells.cast(self, "blur", self, 100)
end
if not (self:get_worn("wield")) then
    self:command("wield wrist-dagger")
end
local chance = random(1, 10)
if chance < 7 then
    skills.execute(self, "backstab", self.fighting)
end