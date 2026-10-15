-- Trigger: phase wand play
-- Zone: 2, ID: 127
-- Type: OBJECT, Flags: USE
--
-- Used at wandstep 6 by the four "harmonic" instruments that 002_108 hands out when it primes the
-- player's stage-6 wand (59040 = 590:40 for air, 16107 = 161:7 acid, 32412 = 324:12 fire,
-- 17309 = 173:9 ice). Once the player is at stage 6 with the wand primed (wandtask5) and carries
-- the stage-6 wand (304/314/324/334 = 2:104/114/124/134), the wand is consumed and replaced by the
-- stage-7 wand (305/315/325/335 = 2:105/115/125/135), the quest advances, and experience is paid.
local dg = require("dg")

local quest_type, wand_key, wand_name, reward
if (self.zone_id == 590 and self.id == 40) then
    quest_type, wand_key, wand_name, reward = "air", 104, "wand-sky", 105
elseif (self.zone_id == 161 and self.id == 7) then
    quest_type, wand_key, wand_name, reward = "acid", 134, "wand-tomb", 135
elseif (self.zone_id == 324 and self.id == 12) then
    quest_type, wand_key, wand_name, reward = "fire", 114, "wand-blazes", 115
elseif (self.zone_id == 173 and self.id == 9) then
    quest_type, wand_key, wand_name, reward = "ice", 124, "wand-snow", 125
end
if not quest_type then
    return true
end

local quest = quest_type .. "_wand"
if actor:get_quest_stage(quest) ~= 6 then return true end
if not dg.flag(actor:get_quest_var(quest .. ":wandtask5")) then return true end
if not (actor:has_equipped(2, wand_key) or actor:has_item(2, wand_key)) then
    return true
end

actor:advance_quest(quest)
local old_name = objects.template(2, wand_key).name
local new_name = objects.template(2, reward).name
self.room:send(old_name .. " begins to resonate in harmony with " .. tostring(self.shortdesc) .. "!")
wait(4)
self.room:send(old_name .. " vibrates right out of your hands!")
actor:destroy_item(wand_name)
self.room:send("In a brilliant <b:white>FLASH</> " .. old_name .. " transforms into " .. new_name .. "!")
actor:spawn_object(2, reward)

local expmod = 9240
if actor.class == "warrior" or actor.class == "berserker" then
    expmod = expmod + math.floor(expmod / 10)
elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
    expmod = expmod + math.floor((expmod * 2) / 15)
elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
    expmod = expmod + math.floor(expmod / 5)
elseif actor.class == "necromancer" or actor.class == "monk" then
    expmod = expmod + math.floor((expmod * 2) / 5)
end
actor:send("<b:yellow>You gain experience!</>")
local setexp = expmod * 10
for _ = 1, 5 do
    actor:award_exp(setexp)
end
actor:set_quest_var(quest, "greet", 0)
actor:set_quest_var(quest, "attack_counter", 0)
for n = 1, 5 do
    actor:set_quest_var(quest, "wandtask" .. tostring(n), 0)
end
return true
