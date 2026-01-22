-- Trigger: Nezer_head_rip_1
-- Zone: 22, ID: 22
-- Type: WORLD, Flags: GLOBAL
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #2222

-- Converted from DG Script #2222: Nezer_head_rip_1
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(5)
-- Let's see how many casters we have in the room.
local casters = 0
local victim = self.people
while victim do
    if (victim.id == -1) and (victim.level < 100) then
        if string.find(victim.class, "Cleric") or string.find(victim.class, "Priest") or string.find(victim.class, "Druid") or string.find(victim.class, "Diabolist") or string.find(victim.class, "Sorcerer") or string.find(victim.class, "Cryomancer") or string.find(victim.class, "Pyromancer") or string.find(victim.class, "Necromancer") then
            local casters = casters + 1
        end
    end
    local victim = victim.next_in_room
end
-- So if we have casters, pick one, we don't want the same
-- one or to have a set order, so lets pick a random caster.
if casters > 0 then
    local gotyou = 0
    while gotyou == 0 do
        local victim = room.actors[random(1, #room.actors)]
        if string.find(victim.class, "Cleric") or string.find(victim.class, "Priest") or string.find(victim.class, "Druid") or string.find(victim.class, "Diabolist") or string.find(victim.class, "Sorcerer") or string.find(victim.class, "Cryomancer") or string.find(victim.class, "Pyromancer") or string.find(victim.class, "Necromancer") then
            local gotyou = gotyou + 1
        end
    end
    -- Hello target, now you must die!
    local message = 1
    local keepgoing = 1
    while keepgoing == 1 do
        if victim.room == 2216 then
            -- switch on message
            if message == 1 then
                self.room:send_except(victim, tostring(victim.name) .. "'s magic catches the attention of one of Nezer's heads.")
                victim:send("One of Nezer's heads suddenly takes notice of you.'")
            elseif message == 2 then
                self.room:send_except(victim, "Nezer's head darts at " .. tostring(victim.name) .. ", who only barely side steps the attack.")
                victim:send("You just barely side step a bite by Nezer's head. Lucky you.")
            elseif message == 3 then
                local damage = random(1, 20)
                local damage = damage + 105
                self.room:send_except(victim, "Nezer's head darts at " .. tostring(victim.name) .. " again, this time grabbing " .. tostring(victim.possessive) .. " in his razor sharp teeth! (<blue>" .. tostring(damage) .. "</>)")
                victim:send("Nezer's head darts at you again, this time grabbing at you with it's shapr teeth, OUCH! (<b:red>" .. tostring(damage) .. "</>)")
                local damage_dealt = victim:damage(damage)  -- type: physical
            elseif message == 4 then
                local damage = random(1, 20)
                local damage = damage + 150
                self.room:send_except(victim, "Nezer's second head notices the first chewing on something. (<blue>" .. tostring(damage) .. "</>)")
                victim:send("Nezer's second head notices you as the first chomps down on you hard, OUCH! (<b:red>" .. tostring(damage) .. "</>)")
                local damage_dealt = victim:damage(damage)  -- type: physical
            elseif message == 5 then
                self.room:send_except(victim, "Nezer's second head bites onto the half of " .. tostring(victim.name) .. " that was sticking out before RIPPING " .. tostring(victim.possessive) .. " in half! (<blue>DEAD</>)")
                victim:send("Nezer's second head bites onto the half of you that wasn't already being consumed before RIPPING you in half! You are DEAD! (<b:red>DEAD</>)")
                victim:damage(10000)  -- type: physical
                local keepgoing = keepgoing + 1
            else
            end
        else
            self.room:send("Nezer looks around for something that is no longer there.")
            local keepgoing = keepgoing + 1
        end
        wait(8)
        local message = message + 1
    end
end