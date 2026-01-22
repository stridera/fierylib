-- Trigger: severan fight
-- Zone: 489, ID: 32
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48932

-- Converted from DG Script #48932: severan fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if self.room ~= 48960 then
    self:emote("emits a loud wail, and returns to the site where he is bound.")
    self:teleport(get_room(489, 60))
end
if (actor.id >= 48900) and (actor.id <= 48999) then
    -- Stop combat if fighting another doom mobile
    wait(1)
    get_room(11, 0):at(function()
        self.room:find_actor("severan"):heal(1000)
    end)
end
wait(1)
local action = random(1, 10)
if action > 9 then
    -- 10% chance
    wait(1)
    self:attack_all()
elseif action > 6 then
    -- 20% chance for Shockwave area attack, 150-300 damage
    run_room_trigger(48933)
end
-- 70% chance to do nothing!