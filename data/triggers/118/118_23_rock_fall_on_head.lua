-- Trigger: rock_fall_on_head
-- Zone: 118, ID: 23
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #11823

-- Converted from DG Script #11823: rock_fall_on_head
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
wait(2)
if actor.level < 100 then
    local die1 = random(1, 60)
    local die2 = random(1, 60)
    local damage = die1 + die2
    local victim = room.actors[random(1, #room.actors)]
    local damage_dealt = victim:damage(damage)  -- type: crush
    if damage_dealt == 0 then
        self.room:send_except(victim, "A large stone slipped off of the entrance to a cave, but " .. tostring(victim.name) .. " is unharmed.")
        victim:send("A large rock from the cave entrace to the west just missed you!")
    else
        self.room:send_except(victim, "A large stone slipped off of the entrance to a cave to the west and hit " .. tostring(victim.name) .. ". (<blue>" .. tostring(damage_dealt) .. "</>)")
        victim:send("A large rock from the cave entrace to the west hits you in the head! (<red>" .. tostring(damage_dealt) .. "</>)")
    end
    wait(3)
end