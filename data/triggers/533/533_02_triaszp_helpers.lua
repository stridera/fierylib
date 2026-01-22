-- Trigger: triaszp_helpers
-- Zone: 533, ID: 2
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
-- Fixed: Corrected broken control flow, converted %victim.name% and %actor.name%
--
-- Original DG Script: #53302

-- Converted from DG Script #53302: triaszp_helpers
-- Original: MOB trigger, flags: FIGHT, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
wait(1)
local value = random(1, 10)
-- switch on value
if value == 1 then
    self:breath_attack("frost", nil)
elseif value == 2 or value == 3 then
    self:command("sweep")
elseif value == 4 or value == 5 then
    self:command("roar")
    if world.count_mobiles("53301") < 6 then
        self.room:spawn_mobile(533, 1)
        self.room:find_actor("baby-dragon"):emote("scampers in and attacks!")
        self.room:find_actor("baby-dragon"):command("kill " .. tostring(actor.name))
    end
elseif value == 8 or value == 9 then
    local victim = self.room.actors[random(1, #self.room.actors)]
    self:emote("hisses in anger, calling to her children.")
    wait(1)
    self.room:spawn_mobile(533, 1)
    self.room:find_actor("baby-dragon"):emote("scampers in and attacks!")
    if victim.id == -1 then
        self.room:find_actor("baby-dragon"):command("kill " .. tostring(victim.name))
    else
        self.room:find_actor("baby-dragon"):command("kill " .. tostring(actor.name))
    end
else
    self:command("growl")
end