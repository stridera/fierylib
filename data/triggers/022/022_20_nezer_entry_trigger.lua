-- Trigger: Nezer_Entry_Trigger
-- Zone: 22, ID: 20
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #2220

-- Converted from DG Script #2220: Nezer_Entry_Trigger
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
-- Nezer entry messages
if alreadydone ~= 1 then
    local alreadydone = 1
    globals.alreadydone = globals.alreadydone or true
    wait(10)
    self.room:send("A large flapping noice can be heard coming from above.")
    wait(8)
    self.room:send("The blood red sky is suddenly blocked out by a flying silhouette.")
    wait(8)
    self.room:send("You're forced to duck suddenly, as a massive figure swoops low, nearly taking your head off.")
    wait(10)
    self.room:send("With a giant thump Nezer of Raymif hits the ground sending a shockwave across the ground!")
    -- start of damage loop
    local victim = self.people
    while victim do
        local next = victim.next_in_room
        if (victim.id == -1) &(victim.level < 100) then
            local damage = 350 + random(1, 50)
            local damage_dealt = victim:damage(damage)  -- type: crush
            if damage_dealt == 0 then
                victim:send("Nezer's shockwave passes through you like a shot, momentarily disorienting you.")
            elseif victim:has_effect(Effect.Flying) then
                local damage = damage / 2
                victim:send("Nezer's shockwave sends you flying into the arena wall! (<b:red>" .. tostring(damage_dealt) .. "</>)")
                self.room:send_except(victim, tostring(victim.name) .. " is thrown violently into the arena's wall! (<blue>" .. tostring(damage_dealt) .. "</>)")
            else
                victim:send("You are slammed violently into the ground after being thrown into the air by Nezer's shockwave! (<b:red>" .. tostring(damage_dealt) .. "</>)")
                self.room:send_except(victim, tostring(victim.name) .. " is slammed into the ground after being thrown into the air by Nezer's shockwave! (<blue>" .. tostring(damage_dealt) .. "</>)")
            end
        end
        local victim = next
    end
    self.room:spawn_mobile(12, 0)
end