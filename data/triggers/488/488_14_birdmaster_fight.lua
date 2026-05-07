-- Trigger: birdmaster fight
-- Zone: 488, ID: 14
-- Type: MOB, Flags: FIGHT
-- Status: REVIEWED
--
-- Original DG Script: #48814
--
-- Behavior: 20% chance per fight tick. If fewer than 6 cavern-hawks
-- (488/15) exist worldwide, blow a whistle to spawn a fresh hawk in the room
-- and order it to attack the current actor.

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
if world.count_mobiles(488, 15) < 6 then
    wait(1)
    self:emote("holds a bird whistle to his lips and lets out a loud whistle!")
    wait(1)
    self.room:spawn_mobile(488, 15)
    local hawk = self.room:find_actor("cavern-hawk")
    if hawk and actor then
        hawk:emote("swoops in to the aid of " .. tostring(self.name) .. "!")
        hawk:command("hit " .. tostring(actor.name))
    end
end