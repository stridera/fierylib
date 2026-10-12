-- Trigger: Nezer_head_rip_1
-- Zone: 22, ID: 22
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #2222

-- Converted from DG Script #2222: Nezer_head_rip_1
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(5)
-- Let's see how many casters we have in the room.
local casters = 0
for _, victim in ipairs(self:get_people()) do
    if (victim.is_player) and (victim.level < 100) then
        if string.find(victim.class, "cleric") or string.find(victim.class, "priest") or string.find(victim.class, "druid") or string.find(victim.class, "diabolist") or string.find(victim.class, "sorcerer") or string.find(victim.class, "cryomancer") or string.find(victim.class, "pyromancer") or string.find(victim.class, "necromancer") then
            casters = casters + 1
        end
    end
end
-- So if we have casters, pick one, we don't want the same
-- one or to have a set order, so lets pick a random caster.
if casters > 0 then
    local gotyou = 0
    local target = nil
    while gotyou == 0 do
        target = self.room.actors[random(1, #self.room.actors)]
        if string.find(target.class, "cleric") or string.find(target.class, "priest") or string.find(target.class, "druid") or string.find(target.class, "diabolist") or string.find(target.class, "sorcerer") or string.find(target.class, "cryomancer") or string.find(target.class, "pyromancer") or string.find(target.class, "necromancer") then
            gotyou = gotyou + 1
        end
    end
    victim = target
    -- Hello target, now you must die!
    local message = 1
    local keepgoing = 1
    while keepgoing == 1 do
        -- TODO(parity): legacy check `victim.room == 2216` (vnum) — verify victim is in arena room (22, 16)
        if victim.room and victim.room.zone_id == 22 and victim.room.local_id == 16 then
            -- switch on message
            if message == 1 then
                self.room:send_except(victim, tostring(victim.name) .. "'s magic catches the attention of one of Nezer's heads.")
                victim:send("One of Nezer's heads suddenly takes notice of you.'")
            elseif message == 2 then
                self.room:send_except(victim, "Nezer's head darts at " .. tostring(victim.name) .. ", who only barely side steps the attack.")
                victim:send("You just barely side step a bite by Nezer's head. Lucky you.")
            elseif message == 3 then
                local damage = random(1, 20)
                damage = damage + 105
                self.room:send_except(victim, "Nezer's head darts at " .. tostring(victim.name) .. " again, this time grabbing " .. tostring(victim.possessive) .. " in his razor sharp teeth! (<blue>" .. tostring(damage) .. "</>)")
                victim:send("Nezer's head darts at you again, this time grabbing at you with it's shapr teeth, OUCH! (<b:red>" .. tostring(damage) .. "</>)")
                local damage_dealt = victim:damage(damage)  -- type: physical
            elseif message == 4 then
                local damage = random(1, 20)
                damage = damage + 150
                self.room:send_except(victim, "Nezer's second head notices the first chewing on something. (<blue>" .. tostring(damage) .. "</>)")
                victim:send("Nezer's second head notices you as the first chomps down on you hard, OUCH! (<b:red>" .. tostring(damage) .. "</>)")
                local damage_dealt = victim:damage(damage)  -- type: physical
            elseif message == 5 then
                self.room:send_except(victim, "Nezer's second head bites onto the half of " .. tostring(victim.name) .. " that was sticking out before RIPPING " .. tostring(victim.possessive) .. " in half! (<blue>DEAD</>)")
                victim:send("Nezer's second head bites onto the half of you that wasn't already being consumed before RIPPING you in half! You are DEAD! (<b:red>DEAD</>)")
                victim:damage(10000)  -- type: physical
                keepgoing = keepgoing + 1
            else
            end
        else
            self.room:send("Nezer looks around for something that is no longer there.")
            keepgoing = keepgoing + 1
        end
        wait(8)
        message = message + 1
    end
end