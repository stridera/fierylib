-- Trigger: phase wand play
-- Zone: 2, ID: 127
-- Type: OBJECT, Flags: USE
--
-- Used at wandstep 6 by the four "harmonic" instruments to transform the
-- player's primed stage-6 wand into the corresponding stage-7 reward.
--
-- TODO(parity): A few converter artifacts could not be safely resolved
-- without engine support:
--   * `actor.wearing[wandnum]` / `actor.inventory[wandnum]` are DG-style
--     indexes; should be `actor:get_worn(slot)` and `actor:has_item(z,id)`
--     once the right call signature is decided.
--   * `world.destroy(wandname)` is being passed a name string rather than
--     the object handle returned by an inventory lookup.
--   * The exp-multiplier block referenced `person.class`; rewritten to
--     read `actor.class` since this is the character using the item.
local _return_value = true

local quest_type, wandnum, reward
if (self.zone_id == 590 and self.id == 40) then
    quest_type, wandnum, reward = "air", 304, 105
elseif (self.zone_id == 161 and self.id == 7) then
    quest_type, wandnum, reward = "acid", 334, 135
elseif (self.zone_id == 324 and self.id == 12) then
    quest_type, wandnum, reward = "fire", 314, 115
elseif (self.zone_id == 173 and self.id == 9) then
    quest_type, wandnum, reward = "ice", 324, 125
end
if not quest_type then
    return _return_value
end

local quest = quest_type .. "_wand"
if actor:get_quest_stage(quest) ~= 6 then return _return_value end
if not actor:get_quest_var(quest .. ":wandtask5") then return _return_value end
if not (actor:has_item(2, wandnum % 100) or actor:has_item(2, wandnum)) then
    return _return_value
end

actor:advance_quest(quest)
self.room:send(tostring(objects.template(2, wandnum % 100).name) .. " begins to resonate in harmony with " .. tostring(self.shortdesc) .. "!")
wait(4)
self.room:send(tostring(objects.template(2, wandnum % 100).name) .. " vibrates right out of your hands!")
self.room:send("In a brilliant <b:white>FLASH</> " .. tostring(objects.template(2, wandnum % 100).name) .. " transforms into " .. tostring(objects.template(2, reward).name) .. "!")
self.room:spawn_object(2, reward)
actor:command("get wand")

local expmod = 9240
if actor.class == "warrior" or actor.class == "berserker" then
    expmod = expmod + (expmod / 10)
elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
    expmod = expmod + ((expmod * 2) / 15)
elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
    expmod = expmod + (expmod / 5)
elseif actor.class == "necromancer" or actor.class == "monk" then
    expmod = expmod + ((expmod * 2) / 5)
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
return _return_value
