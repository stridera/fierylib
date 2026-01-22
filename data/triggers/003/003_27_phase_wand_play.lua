-- Trigger: phase wand play
-- Zone: 3, ID: 27
-- Type: OBJECT, Flags: USE
-- Status: CLEAN
--
-- Original DG Script: #327

-- Converted from DG Script #327: phase wand play
-- Original: OBJECT trigger, flags: USE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on self.id
if self.id == 59040 then
    local type = "air"
    local wandnum = 304
    local reward = 305
    local wandname = "wand-sky"
elseif self.id == 16107 then
    local type = "acid"
    local wandnum = 334
    local reward = 335
    local wandname = "wand-tomb"
elseif self.id == 32412 then
    local type = "fire"
    local wandnum = 314
    local reward = 315
    local wandname = "wand-blazes"
elseif self.id == 17309 then
    local type = "ice"
    local wandnum = 324
    local reward = 325
    local wandname = "wand-snow"
end
if actor.quest_stage[type_wand] == 6 and actor.quest_variable[type_wand:wandtask5] and (actor.wearing[wandnum] or actor.inventory[wandnum]) then
    _return_value = false
    actor:advance_quest("%type%_wand")
    self.room:send("%get.obj_shortdesc[%wandnum%]% begins to resonate in harmony with %self.shortdesc%!")
    wait(4)
    self.room:send("%get.obj_shortdesc[%wandnum%]% vibrates right out of your hands!")
    if actor.wearing[wandnum] then
        actor:command("remove " .. tostring(wandname))
    end
    actor:command("drop " .. tostring(wandname))
    world.destroy(wandname)
    self.room:send("In a brilliant <b:white>FLASH</> " .. "%get.obj_shortdesc[%wandnum%]% transforms into %get.obj_shortdesc[%reward%]%!")
    self.room:spawn_object(vnum_to_zone(reward), vnum_to_local(reward))
    actor:command("get wand")
    local expmod = 9240
    -- Adjust exp award by class so all classes receive the same proportionate amount
    -- switch on person.class
    if person.class == "Warrior" or person.class == "Berserker" then
        -- 110% of standard
        local expmod = (expmod + (expmod / 10))
    elseif person.class == "Paladin" or person.class == "Anti-Paladin" or person.class == "Ranger" then
        -- 115% of standard
        local expmod = (expmod + ((expmod * 2) / 15))
    elseif person.class == "Sorcerer" or person.class == "Pyromancer" or person.class == "Cryomancer" or person.class == "Illusionist" or person.class == "Bard" then
        -- 120% of standard
        local expmod = (expmod + (expmod / 5))
    elseif person.class == "Necromancer" or person.class == "Monk" then
        -- 130% of standard
        local expmod = (expmod + (expmod * 2) / 5)
    else
        local expmod = expmod
    end
    actor:send("<b:yellow>You gain experience!</>")
    local setexp = (expmod * 10)
    local loop = 0
    while loop < 5 do
        actor:award_exp(setexp)
        local loop = loop + 1
    end
    actor:set_quest_var("%type%_wand", "greet", 0)
    actor:set_quest_var("%type%_wand", "attack_counter", 0)
    local number = 1
    while number <= 5 do
        actor:set_quest_var("%type%_wand", "wandtask%number%", 0)
        local number = number + 1
    end
end
return _return_value