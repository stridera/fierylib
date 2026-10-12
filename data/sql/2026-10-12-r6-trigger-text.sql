-- Playtest r6 #25: Random_Illness_Trigger (22:15) typos (being/beings), pronouns instead of repeated name and hard-coded his
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).
-- Guarded: a row is only touched while it still holds the previous committed
-- body (md5), so rows edited in Muditor since then are left alone.

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/022/022_15_random_illness_trigger.lua
  (22, 15, $trig$-- Converted from DG Script #2215: Random_Illness_Trigger
-- Original: WORLD trigger, flags: RANDOM, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
local occupants = self.room.actors
if #occupants > 0 then
    local victim = occupants[random(1, #occupants)]
    if victim.is_player then
        local message = random(1, 3)
        -- switch on message
        if message == 1 then
            self.room:send_except(victim, "A tiny, vicious bug buzzes around " .. tostring(victim.name) .. ", landing on " .. tostring(victim.possessive) .. " arm and biting " .. tostring(victim.object) .. ".")
            victim:send("A tiny, vicious bug buzzes around you before landing on your arm and biting you!")
            wait(15)
            self.room:send_except(victim, tostring(victim.name) .. " begins to look pale and starts shivering. (<blue>50</>)")
            victim:send("You turn pale and shiver as nausea begins to set in. (<b:red>50</>)")
            victim:damage(50)  -- type: physical
            wait(15)
            self.room:send_except(victim, tostring(victim.name) .. " falls over in pain as " .. tostring(victim.subjective) .. " begins to purge " .. tostring(victim.possessive) .. " stomach. (<blue>100</>)")
            victim:send("You fall over in pain as you begin to vomit all over the floor. (<b:red>100</>)")
            victim:damage(100)  -- type: physical
        elseif message == 2 then
            self.room:send_except(victim, tostring(victim.name) .. " trips on a rock and cuts " .. tostring(victim.object) .. "self on a rusted blade. (<blue>50</>)")
            victim:send("You trip on a rock, cutting yourself on a rusted blade. (<b:red>50</>)")
            wait(15)
            victim:damage(50)  -- type: physical
            self.room:send_except(victim, tostring(victim.name) .. " begins to twitch uncontrollably. (<blue>100</>)")
            victim:send("You begin to twitch uncomfortably as a cold shiver runs through your body. (<b:red>100</>)")
            victim:damage(100)  -- type: physical
            wait(15)
            self.room:send_except(victim, tostring(victim.name) .. " arches " .. tostring(victim.possessive) .. " back painfully and loses all control. (<blue>150</>)")
            victim:send("Uncontrollably you arch your back, causing extreme pain! (<b:red>150</>)")
            victim:damage(150)  -- type: physical
        else
            self.room:send_except(victim, tostring(victim.name) .. " begins to cough endlessly. (<blue>50</>)")
            victim:send("Something seems caught in your throat as you cough harshly. (<b:red>50</>)")
            victim:damage(50)  -- type: physical
            wait(15)
            self.room:send_except(victim, tostring(victim.name) .. " gasps for air as " .. tostring(victim.subjective) .. " continues to cough. (<blue>100</>)")
            victim:send("You gasp wildly for air as you continue to cough. (<b:red>100</>)")
            victim:damage(100)  -- type: physical
            wait(15)
            self.room:send_except(victim, tostring(victim.name) .. " chokes wildly in an attempt to get air. Nearly passing out! (<blue>150</>)")
            victim:send("Lack of air causes you to nearly pass out as you choke in an attempt to obtain oxygen. (<b:red>150</>)")
            victim:damage(150)  -- type: physical
        end
    end
end$trig$, 'ebdd33fbfba0054458d68b285e6d129b')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
