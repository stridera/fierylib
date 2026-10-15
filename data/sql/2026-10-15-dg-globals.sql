-- DG globals parity: cross-trigger variables read/written through the entity globals table (needs fierymud-rs 1f4bbd8 or later; wand/mace greeters, 484 paralysis, 510, 590 levers, 580, 557_06, 188 xcast, 060 subclass, bells). Guards are the bodies at fierylib b0a8021.
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
  -- data/triggers/004/004_99_eldoria_variable_load.lua
  (4, 99, $trig$-- Converted from DG Script #499: Eldoria variable load
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local id_gem_3bl_cap = 55570
local id_gem_3bl_neck = 55571
local id_gem_3bl_arm = 55572
local id_gem_3bl_wrist = 55573
local id_gem_3bl_gloves = 55574
local id_gem_3bl_jerkin = 55575
local id_gem_3bl_robe = 55589
local id_gem_3bl_belt = 55576
local id_gem_3bl_legs = 55577
local id_gem_3bl_boots = 55578
local id_gem_3bl_mask = 55579
local id_gem_3bl_symbol = 55580
local id_gem_3bl_staff = 55581
local id_gem_3bl_ssword = 55582
local id_gem_3bl_whammer = 55583
local id_gem_3bl_flail = 55584
local id_gem_3bl_shiv = 55585
local id_gem_3bl_lsword = 55586
local id_gem_3bl_smace = 55587
local id_gem_3bl_light = 55588
local id_gem_3bl_food = 55566
local id_gem_3bl_drink = 55567
local id_3bl_cap = 5517
local id_3bl_neck = 5519
local id_3bl_arm = 5521
local id_3bl_wrist = 5523
local id_3bl_gloves = 5525
local id_3bl_jerkin = 5527
globals.id_gem_3bl_cap = id_gem_3bl_cap; globals.id_gem_3bl_neck = id_gem_3bl_neck; globals.id_gem_3bl_arm = id_gem_3bl_arm; globals.id_gem_3bl_wrist = id_gem_3bl_wrist; globals.id_gem_3bl_gloves = id_gem_3bl_gloves; globals.id_gem_3bl_jerkin = id_gem_3bl_jerkin; globals.id_gem_3bl_robe = id_gem_3bl_robe; globals.id_gem_3bl_belt = id_gem_3bl_belt; globals.id_gem_3bl_legs = id_gem_3bl_legs; globals.id_gem_3bl_boots = id_gem_3bl_boots; globals.id_gem_3bl_mask = id_gem_3bl_mask; globals.id_gem_3bl_symbol = id_gem_3bl_symbol; globals.id_gem_3bl_staff = id_gem_3bl_staff; globals.id_gem_3bl_ssword = id_gem_3bl_ssword; globals.id_gem_3bl_whammer = id_gem_3bl_whammer; globals.id_gem_3bl_flail = id_gem_3bl_flail; globals.id_gem_3bl_shiv = id_gem_3bl_shiv; globals.id_gem_3bl_lsword = id_gem_3bl_lsword; globals.id_gem_3bl_smace = id_gem_3bl_smace; globals.id_gem_3bl_light = id_gem_3bl_light; globals.id_gem_3bl_food = id_gem_3bl_food; globals.id_gem_3bl_drink = id_gem_3bl_drink; globals.id_3bl_cap = id_3bl_cap; globals.id_3bl_neck = id_3bl_neck; globals.id_3bl_arm = id_3bl_arm; globals.id_3bl_wrist = id_3bl_wrist; globals.id_3bl_gloves = id_3bl_gloves; globals.id_3bl_jerkin = id_3bl_jerkin
-- Fragment (possible truncation): m_3bl_belt id_3bl_legs id_3bl_boots id_3bl_mask id_3bl_robe id_3bl_symbol id_3bl_staff id_3bl_ssword id_3bl_whammer id_3bl_flail id_3bl_shiv id_3bl_lsword id_3bl_smace id_3bl_light id_3bl_food id_3bl_drink
local id_gem_3eg_cap = 55570
local id_gem_3eg_neck = 55571
local id_gem_3eg_arm = 55572
local id_gem_3eg_wrist = 55573
local id_gem_3eg_gloves = 55574
local id_gem_3eg_jerkin = 55575
local id_gem_3eg_robe = 55589
local id_gem_3eg_belt = 55576
local id_gem_3eg_legs = 55577
local id_gem_3eg_boots = 55578
local id_gem_3eg_mask = 55579
local id_gem_3eg_symbol = 55580
local id_gem_3eg_staff = 55581
local id_gem_3eg_ssword = 55582
local id_gem_3eg_whammer = 55583
local id_gem_3eg_flail = 55584
local id_gem_3eg_shiv = 55585
local id_gem_3eg_lsword = 55586
local id_gem_3eg_smace = 55587
local id_gem_3eg_light = 55588
local id_gem_3eg_food = 55566
local id_gem_3eg_drink = 55567
local id_3eg_cap = 5518
local id_3eg_neck = 5520
local id_3eg_arm = 5522
local id_3eg_wrist = 5524
local id_3eg_gloves = 5526
local id_3eg_jerkin = 5528
globals.id_gem_3eg_cap = id_gem_3eg_cap; globals.id_gem_3eg_neck = id_gem_3eg_neck; globals.id_gem_3eg_arm = id_gem_3eg_arm; globals.id_gem_3eg_wrist = id_gem_3eg_wrist; globals.id_gem_3eg_gloves = id_gem_3eg_gloves; globals.id_gem_3eg_jerkin = id_gem_3eg_jerkin; globals.id_gem_3eg_robe = id_gem_3eg_robe; globals.id_gem_3eg_belt = id_gem_3eg_belt; globals.id_gem_3eg_legs = id_gem_3eg_legs; globals.id_gem_3eg_boots = id_gem_3eg_boots; globals.id_gem_3eg_mask = id_gem_3eg_mask; globals.id_gem_3eg_symbol = id_gem_3eg_symbol; globals.id_gem_3eg_staff = id_gem_3eg_staff; globals.id_gem_3eg_ssword = id_gem_3eg_ssword; globals.id_gem_3eg_whammer = id_gem_3eg_whammer; globals.id_gem_3eg_flail = id_gem_3eg_flail; globals.id_gem_3eg_shiv = id_gem_3eg_shiv; globals.id_gem_3eg_lsword = id_gem_3eg_lsword; globals.id_gem_3eg_smace = id_gem_3eg_smace; globals.id_gem_3eg_light = id_gem_3eg_light; globals.id_gem_3eg_food = id_gem_3eg_food; globals.id_gem_3eg_drink = id_gem_3eg_drink; globals.id_3eg_cap = id_3eg_cap; globals.id_3eg_neck = id_3eg_neck; globals.id_3eg_arm = id_3eg_arm; globals.id_3eg_wrist = id_3eg_wrist; globals.id_3eg_gloves = id_3eg_gloves; globals.id_3eg_jerkin = id_3eg_jerkin
-- Fragment (possible truncation): m_3eg_belt id_3eg_legs id_3eg_boots id_3eg_mask id_3eg_robe id_3eg_symbol id_3eg_staff id_3eg_ssword id_3eg_whammer id_3eg_flail id_3eg_shiv id_3eg_lsword id_3eg_smace id_3eg_light id_3eg_food id_3eg_drink$trig$, '6a069c449e0dfdfc3e2c4df09d958542'),
  -- data/triggers/030/030_133_random_bells.lua
  (30, 133, $trig$-- Converted from DG Script #3133: Random Bells
-- Original: OBJECT trigger, flags: RANDOM, GET, WEAR, REMOVE, probability: 100%
-- RANDOM binds `actor` to the item itself, so tell the events apart by name.
if event ~= "RANDOM" then
    -- this is a wear/get/remove trigger
    local myowner = actor
    globals.myowner = myowner
    self.room:send_except(myowner, "Bells ring on " .. tostring(myowner.name) .. "'s hat as " .. tostring(myowner.name) .. " moves.")
    myowner:send("The bells on your hat ring as you shift your position.")
else
    -- this is a random trigger
    local myowner = globals.myowner  -- DG global: set by the wear branch, shared by the item's triggers
    if myowner then
        if myowner:has_equipped(30, 306) then
            -- the global variable was set (by the wear trigger)
            self.room:send_except(myowner, "Bells ring on " .. tostring(myowner.name) .. "'s hat as " .. tostring(myowner.name) .. " moves.")
            myowner:send("The bells on your hat ring as you shift your position.")
        else
            -- hat not worn, so assume it was removed
            globals.myowner = nil
        end
    end
end$trig$, 'a10f409e885b9f43253d67e2f0ca616b'),
  -- data/triggers/055/055_24_eldoria_quartermasters_load.lua
  (55, 24, $trig$-- Converted from DG Script #5524: Eldoria Quartermasters load
-- Original: MOB trigger, flags: LOAD, probability: 100%
if (self.zone_id == 55 and self.id == 12) then
    local id_trophy1 = 5504
    local id_trophy2 = 5506
    local id_trophy3 = 5508
    local id_trophy4 = 5510
    local id_trophy5 = 5512
    local id_trophy6 = 5514
    local id_trophy7 = 5516
    local id_gem_3bl_cap = 55570
    local id_gem_3bl_neck = 55571
    local id_gem_3bl_arm = 55572
    local id_gem_3bl_wrist = 55573
    local id_gem_3bl_gloves = 55574
    local id_gem_3bl_jerkin = 55575
    local id_gem_3bl_robe = 55589
    local id_gem_3bl_belt = 55576
    local id_gem_3bl_legs = 55577
    local id_gem_3bl_boots = 55578
    local id_gem_3bl_mask = 55579
    local id_gem_3bl_symbol = 55580
    local id_gem_3bl_staff = 55581
    local id_gem_3bl_ssword = 55582
    local id_gem_3bl_whammer = 55583
    local id_gem_3bl_flail = 55584
    local id_gem_3bl_shiv = 55585
    local id_gem_3bl_lsword = 55586
    local id_gem_3bl_smace = 55587
    local id_gem_3bl_light = 55588
    local id_gem_3bl_food = 55566
    local id_gem_3bl_drink = 55567
    local id_3bl_cap = 5517
    local id_3bl_neck = 5519
    local id_3bl_arm = 5521
    local id_3bl_wrist = 5523
    local id_3bl_gloves = 5525
    local id_3bl_jerkin = 5527
    globals.id_gem_3bl_cap = id_gem_3bl_cap; globals.id_gem_3bl_neck = id_gem_3bl_neck; globals.id_gem_3bl_arm = id_gem_3bl_arm; globals.id_gem_3bl_wrist = id_gem_3bl_wrist; globals.id_gem_3bl_gloves = id_gem_3bl_gloves; globals.id_gem_3bl_jerkin = id_gem_3bl_jerkin; globals.id_gem_3bl_robe = id_gem_3bl_robe; globals.id_gem_3bl_belt = id_gem_3bl_belt; globals.id_gem_3bl_legs = id_gem_3bl_legs; globals.id_gem_3bl_boots = id_gem_3bl_boots; globals.id_gem_3bl_mask = id_gem_3bl_mask; globals.id_gem_3bl_symbol = id_gem_3bl_symbol; globals.id_gem_3bl_staff = id_gem_3bl_staff; globals.id_gem_3bl_ssword = id_gem_3bl_ssword; globals.id_gem_3bl_whammer = id_gem_3bl_whammer; globals.id_gem_3bl_flail = id_gem_3bl_flail; globals.id_gem_3bl_shiv = id_gem_3bl_shiv; globals.id_gem_3bl_lsword = id_gem_3bl_lsword; globals.id_gem_3bl_smace = id_gem_3bl_smace; globals.id_gem_3bl_light = id_gem_3bl_light; globals.id_gem_3bl_food = id_gem_3bl_food; globals.id_gem_3bl_drink = id_gem_3bl_drink; globals.id_3bl_cap = id_3bl_cap; globals.id_3bl_neck = id_3bl_neck; globals.id_3bl_arm = id_3bl_arm; globals.id_3bl_wrist = id_3bl_wrist; globals.id_3bl_gloves = id_3bl_gloves; globals.id_3bl_jerkin = id_3bl_jerkin
    -- Fragment (possible truncation): num_3bl_belt id_3bl_legs id_3bl_boots id_3bl_mask id_3bl_robe id_3bl_symbol id_3bl_staff id_3bl_ssword id_3bl_whammer id_3bl_flail id_3bl_shiv id_3bl_lsword id_3bl_smace id_3bl_light id_3bl_food id_3bl_drink
elseif (self.zone_id == 55 and self.id == 24) then
    local id_trophy1 = 5503
    local id_trophy2 = 5505
    local id_trophy3 = 5507
    local id_trophy4 = 5509
    local id_trophy5 = 5511
    local id_trophy6 = 5513
    local id_trophy7 = 5515
    local id_gem_3eg_cap = 55570
    local id_gem_3eg_neck = 55571
    local id_gem_3eg_arm = 55572
    local id_gem_3eg_wrist = 55573
    local id_gem_3eg_gloves = 55574
    local id_gem_3eg_jerkin = 55575
    local id_gem_3eg_robe = 55589
    local id_gem_3eg_belt = 55576
    local id_gem_3eg_legs = 55577
    local id_gem_3eg_boots = 55578
    local id_gem_3eg_mask = 55579
    local id_gem_3eg_symbol = 55580
    local id_gem_3eg_staff = 55581
    local id_gem_3eg_ssword = 55582
    local id_gem_3eg_whammer = 55583
    local id_gem_3eg_flail = 55584
    local id_gem_3eg_shiv = 55585
    local id_gem_3eg_lsword = 55586
    local id_gem_3eg_smace = 55587
    local id_gem_3eg_light = 55588
    local id_gem_3eg_food = 55566
    local id_gem_3eg_drink = 55567
    local id_3eg_cap = 5518
    local id_3eg_neck = 5520
    local id_3eg_arm = 5522
    local id_3eg_wrist = 5524
    local id_3eg_gloves = 5526
    local id_3eg_jerkin = 5528
    globals.id_gem_3eg_cap = id_gem_3eg_cap; globals.id_gem_3eg_neck = id_gem_3eg_neck; globals.id_gem_3eg_arm = id_gem_3eg_arm; globals.id_gem_3eg_wrist = id_gem_3eg_wrist; globals.id_gem_3eg_gloves = id_gem_3eg_gloves; globals.id_gem_3eg_jerkin = id_gem_3eg_jerkin; globals.id_gem_3eg_robe = id_gem_3eg_robe; globals.id_gem_3eg_belt = id_gem_3eg_belt; globals.id_gem_3eg_legs = id_gem_3eg_legs; globals.id_gem_3eg_boots = id_gem_3eg_boots; globals.id_gem_3eg_mask = id_gem_3eg_mask; globals.id_gem_3eg_symbol = id_gem_3eg_symbol; globals.id_gem_3eg_staff = id_gem_3eg_staff; globals.id_gem_3eg_ssword = id_gem_3eg_ssword; globals.id_gem_3eg_whammer = id_gem_3eg_whammer; globals.id_gem_3eg_flail = id_gem_3eg_flail; globals.id_gem_3eg_shiv = id_gem_3eg_shiv; globals.id_gem_3eg_lsword = id_gem_3eg_lsword; globals.id_gem_3eg_smace = id_gem_3eg_smace; globals.id_gem_3eg_light = id_gem_3eg_light; globals.id_gem_3eg_food = id_gem_3eg_food; globals.id_gem_3eg_drink = id_gem_3eg_drink; globals.id_3eg_cap = id_3eg_cap; globals.id_3eg_neck = id_3eg_neck; globals.id_3eg_arm = id_3eg_arm; globals.id_3eg_wrist = id_3eg_wrist; globals.id_3eg_gloves = id_3eg_gloves; globals.id_3eg_jerkin = id_3eg_jerkin
    -- Fragment (possible truncation): num_3eg_belt id_3eg_legs id_3eg_boots id_3eg_mask id_3eg_robe id_3eg_symbol id_3eg_staff id_3eg_ssword id_3eg_whammer id_3eg_flail id_3eg_shiv id_3eg_lsword id_3eg_smace id_3eg_light id_3eg_food id_3eg_drink
end
-- (the id_trophy1..7 locals are scoped to the branches above; no consumer reads them from globals)$trig$, '4051d6e6bfd15e51b2d701aa4b53b210'),
  -- data/triggers/060/060_06_quest_timulos_training.lua
  (60, 6, $trig$-- Converted from DG Script #6006: quest_timulos_training
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"training"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if string.find(actor.class, "rogue") then
    if actor.level >= 10 and actor.level <= 25 then
        if not globals.use_subclass then
            self:command("nod " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'Well which would you like to train as: <yellow>mercenary</>, <red>assassin</>, or <b:red>thief</>?'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Say one of them.'")
        else
            actor:send(tostring(self.name) .. " says, 'One moment, I'm getting someone else set up.'")
            actor:send(tostring(self.name) .. " ushers you into the corner.")
            self.room:send_except(actor, tostring(self.name) .. " ushers " .. tostring(actor.name) .. " into the corner.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Wait there.'")
        end
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'I like your zeal, but it's a little too soon for you to subclass, kid.'")
    else
        actor:send(tostring(self.name) .. " says, 'It's waaaaaaay too late to train you.  That ship has sailed!'")
    end
else
    actor:send(tostring(self.name) .. " says, 'Go find someone else to train with.'")
    wait(0.2)
    -- this may need to be changed in the future if new classes are invented that aren't just <name>s for pluralizing.
    actor:send(tostring(self.name) .. " says, 'I don't work with " .. tostring(actor.class) .. "s.'")
end$trig$, 'a2c2a4aff3586734d05cc75314faef58'),
  -- data/triggers/060/060_07_quest_timulos_merc.lua
  (60, 7, $trig$-- Converted from DG Script #6007: quest_timulos_merc
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"mercenary"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(actor.class, "rogue") then
    -- switch on actor.race
    -- case ADD NEW RESTRICTED RACES HERE
    -- if actor.level% >= 10 && %actor.level% <= 25
    -- msend %actor% &1Your race may not subclass to mercenary.&0
    -- halt
    -- endif
    wait(0.2)
    if actor.level >= 10 and actor.level <= 25 then
        if globals.use_subclass then
            actor:send(tostring(self.name) .. " says, 'One moment, I'm getting someone else set up.'")
            actor:send(tostring(self.name) .. " ushers you into the corner.")
            self.room:send_except(actor, tostring(self.name) .. " ushers " .. tostring(actor.name) .. " into the corner.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Wait there.'")
        else
            actor:send(tostring(self.name) .. " says, 'So, you wish to become a mercenary do you?'")
            globals.use_subclass = "Mer"
        end
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'I like your zeal, but it's a little too soon for you to subclass kid.'")
    else
        actor:send(tostring(self.name) .. " says, 'It's waaaaaaay too late to train you.  That ship has sailed!'")
    end
else
    actor:send(tostring(self.name) .. " says, 'I do not know how to train you to be one, sorry, go away.'")
end$trig$, 'f45ee736bb51d781b2f161d297808b49'),
  -- data/triggers/060/060_08_quest_timulos_assassin.lua
  (60, 8, $trig$-- Converted from DG Script #6008: quest_timulos_assassin
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"assassin"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(actor.class, "rogue") then
    -- switch on actor.race
    -- case ADD NEW RESTRICTED RACES HERE
    -- if actor.level% <= 25
    -- msend %actor% &1Your race may not subclass to assassin.&0
    -- halt
    -- endif
    wait(0.2)
    if actor.level >= 10 and actor.level <= 25 then
        if actor.alignment <= -350 then
            if globals.use_subclass then
                actor:send(tostring(self.name) .. " says, 'One moment, I'm getting someone else set up.'")
                actor:send(tostring(self.name) .. " ushers you into the corner.")
                self.room:send_except(actor, tostring(self.name) .. " ushers " .. tostring(actor.name) .. " into the corner.")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'Wait there.'")
            else
                actor:send(tostring(self.name) .. " says, 'So, you wish to become an assassin do you?'")
                globals.use_subclass = "Ass"
            end
        else
            actor:send(tostring(self.name) .. " says, 'You aren't nearly evil enough yet.'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Go kill some more people.'")
            wait(3)
            actor:send(tostring(self.name) .. " says, 'Really good, really innocent people.'")
        end
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'I like your zeal, but it's a little too soon for you to subclass kid.'")
    else
        actor:send(tostring(self.name) .. " says, 'It's waaaaaaay too late to train you.  That ship has sailed!'")
    end
else
    actor:send(tostring(self.name) .. " says, 'I do not know how to train you to be one, sorry, go away.'")
end$trig$, '2d63db4bce388bcc05c297fc40db814c'),
  -- data/triggers/060/060_09_quest_timulos_thief.lua
  (60, 9, $trig$-- Converted from DG Script #6009: quest_timulos_thief
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"thief"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(actor.class, "rogue") then
    -- switch on actor.race
    -- case ADD NEW RESTRICTED RACES HERE
    -- if actor.level% <= 25
    -- msend %actor% &1Your race may not subclass to thief.&0
    -- halt
    -- endif
    wait(0.2)
    if actor.level >= 10 and actor.level <= 25 then
        if globals.use_subclass then
            actor:send(tostring(self.name) .. " says, 'One moment, I'm getting someone else set up.'")
            actor:send(tostring(self.name) .. " ushers you into the corner.")
            self.room:send_except(actor, tostring(self.name) .. " ushers " .. tostring(actor.name) .. " into the corner.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Wait there.'")
        else
            actor:send(tostring(self.name) .. " says, 'So, you wish to become a thief do you?'")
            globals.use_subclass = "Thi"
        end
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'I like your zeal, but it's a little too soon for you too subclass kid.'")
    else
        actor:send(tostring(self.name) .. " says, 'It's waaaaaaay too late to train you.  That ship has sailed!'")
    end
else
    actor:send(tostring(self.name) .. " says, 'I do not know how to train you to be one, sorry, go away.'")
end$trig$, 'a61004d171599bfc053f4bac8c31fac5'),
  -- data/triggers/060/060_10_quest_timulous_yesno.lua
  (60, 10, $trig$-- Converted from DG Script #6010: quest_timulous_yesno
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "no"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if string.find(actor.class, "rogue") and (actor.level >= 10 and actor.level <= 25) then
    if string.find(speech, "yes") then
        if actor:get_has_failed("merc_ass_thi_subclass") then
            actor:restart_quest("merc_ass_thi_subclass")
            actor:advance_quest("merc_ass_thi_subclass")
            actor:advance_quest("merc_ass_thi_subclass")
            self:command("nod")
            actor:send(tostring(self.name) .. " says, 'Then try again.'")
            wait(0.2)
            if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "thief" then
                actor:send(tostring(self.name) .. " says, 'Be careful this time!  Stay hidden getting in and out.'")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'And no murdering anyone!'")
            elseif actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "assassin" then
                actor:send(tostring(self.name) .. " says, 'And be quick about it!'")
            end
            return _return_value
        end
        if globals.use_subclass then
            actor:start_quest("merc_ass_thi_subclass", globals.use_subclass)
            self:command("nod")
            actor:send(tostring(self.name) .. " says, 'So, you truly wish to continue.'")
            wait(0.1)
            if string.find(globals.use_subclass, "Mer") then
                actor:send(tostring(self.name) .. " says, 'Yes, a mercenary would serve well for that...'")
                self:emote("thinks back for a moment.")
                wait(1)
                actor:send(tostring(self.name) .. " says, 'He would pay well.  Yes, that <b:cyan>Lord</> would pay well indeed.'")
            elseif string.find(globals.use_subclass, "Ass") then
                actor:send(tostring(self.name) .. " says, 'An assassin would be perfect, but to show your true desire...'")
                self:emote("grins deeply, curling his lip up.")
                wait(1)
                actor:send(tostring(self.name) .. " says, 'Yes, that would bring a good <b:cyan>price</>.'")
            elseif string.find(globals.use_subclass, "Thi") then
                actor:send(tostring(self.name) .. " says, 'Hmmm, a true thief would have to get something I think.'")
                self:emote("smiles cruelly.")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'There is a <b:cyan>package</> that someone could get back.'")
            end
            wait(2)
            actor:send(tostring(self.name) .. " says, 'You can check your <b:cyan>[subclass progress]</> if you need.'")
        else
            actor:send(tostring(self.name) .. " says, 'You have to pick one first!'")
            wait(2)
            self:command("tap")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Well which would you like to train as: <yellow>mercenary</>, <red>assassin</>, or <b:red>thief</>?'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Say one of them.'")
        end
    elseif string.find(speech, "no") then
        actor:send(tostring(self.name) .. " says, 'Well then go away.'")
        self:emote("points north.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'I said go.'")
        self:emote("pushes " .. tostring(actor.name) .. " away.")
        self:command("open fence")
        actor:move("north")
        self:command("close fence")
    end
end
globals.use_subclass = nil$trig$, 'fa24f2f3f29f6b99260b3393ce991833'),
  -- data/triggers/060/060_31_assassin_subclass_mayor_calls_for_help.lua
  (60, 31, $trig$-- Converted from DG Script #6031: assassin_subclass_mayor_calls_for_help
-- Original: MOB trigger, flags: FIGHT, probability: 100%
wait(0.2)
-- DG global `round`: fight rounds seen by this mob so far (unset reads as 0)
local round = globals.round or 0
-- switch on round
do
    local _sw1 = string.lower(tostring(round or ""))
    if tonumber(_sw1) == 1 then
        self.room:send(tostring(self.name) .. " cries out in surprise!")
        self.room:send(tostring(self.name) .. " shouts, 'Help!  Help!!  Someone is trying to kill me!!'")
    elseif tonumber(_sw1) == 3 then
        self.room:send("A commotion echoes from downstairs!")
        self.room:send("The guards are coming to the Mayor's rescue!")
        wait(0.2)
        self.room:send("Quick footsteps begin to approach the room!")
    elseif tonumber(_sw1) == 5 then
        self.room:send("Someone shouts, 'Quickly, rescue the Mayor!!'")
        wait(0.2)
        self.room:send("The footsteps speed up!")
    elseif tonumber(_sw1) == 8 then
        self.room:send(tostring(self.name) .. " gurgles, 'Someone help!!!'")
        wait(0.2)
        self.room:send("The sound of footsteps gets louder!")
    elseif tonumber(_sw1) == 10 then
        self.room:send(tostring(self.name) .. " gurgles, 'Hurry!  I'm dying!!!'")
        wait(0.2)
        self.room:send("Someone shouts, 'I'm coming Mr. Mayor!'")
        self.room:send("The footsteps are almost here!")
    elseif tonumber(_sw1) == 13 then
        self.room:send("The footsteps are right outside the door!")
    elseif tonumber(_sw1) == 15 then
        self.room:send("One of the City Hall guards bursts into the room!")
        self.room:send("The City Hall guard cries, 'I'll save you Mr. Mayor!!'")
        self.room:send_except(actor, "The City Hall guard leaps on " .. tostring(actor.name) .. " and drags " .. tostring(actor.himher) .. " from the building!")
        actor:send("The City Hall guard throws himself on you and breaks up the fight.")
        actor:send("You are dragged out of the building and thrown out of town!")
        -- teleport the player anywhere in the farmlands other than the fields*
        actor:teleport(get_room(80, random(1, 225)))
        wait(0.2)
        -- actor looks around
        wait(0.2)
        actor:send("The City Hall guard tells you, 'And don't you come back!'")
        globals.round = nil
        actor:fail_quest("merc_ass_thi_subclass")
        actor:send("<b:yellow>You have failed your quest!</>")
        actor:send("You'll have to go back to " .. tostring(mobiles.template(60, 50).name) .. " and start over!")
        return _return_value
    end
end
round = round + 1
globals.round = round$trig$, 'd684a4a0a9b17d41a4106f2d92ae30cf'),
  -- data/triggers/060/060_61_connectfour_start.lua
  (60, 61, $trig$-- Converted from DG Script #6061: connectfour start
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- Command location mask 4: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: start
if not (cmd == "start") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" or _sw1 == "st" or _sw1 == "sta" or _sw1 == "star" then
        _return_value = true
        return _return_value
    end
end
if player1 then
    if player2 then
        actor:send(tostring(player1.name) .. " and " .. tostring(player2.name) .. " are already playing ConnectFour!")
    else
        self.room:send_except(actor, tostring(actor.name) .. " joins the ConnectFour game as player 2.")
        actor:send("You are now joining the ConnectFour game!")
        if p2col == "<b:red>" then
            actor:send("You are the <b:red>red</> pieces!")
            self.room:send_except(actor, tostring(actor.name) .. " gets the <b:red>red</> pieces.")
            player1:send("You get to go first!")  -- fixed: space in var name
            local status = 1
            globals.status = status
            local turn = 1
            globals.turn = turn
        elseif p2col == "<b:black>" then
            actor:send("You are the <b:black>black</> pieces!")
            self.room:send_except(actor, tostring(actor.name) .. " gets the <b:black>black</> pieces.")
            player1:send("You get to go first!")
            local status = 1
            globals.status = status
            local turn = 1
            globals.turn = turn
        end
        local player2 = actor
        globals.player2 = player2
    end
else
    self.room:send_except(actor, tostring(actor.name) .. " starts a new ConnectFour game as player 1.")
    actor:send("Alright!  Starting new ConnectFour game.  You are player 1.")
    actor:send("Do you want to be red or black?  Use the select command to choose.")
    local player1 = actor
    globals.player1 = player1
end
return _return_value$trig$, 'adc482c8d2d4550d0cc3386efa5ed0bc'),
  -- data/triggers/060/060_63_connectfour_select_color.lua
  (60, 63, $trig$-- Converted from DG Script #6063: connectfour select color
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- Command location mask 4: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: select
if not (cmd == "select") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" or _sw1 == "se" or _sw1 == "sel" then
        _return_value = true
        return _return_value
    end
end
if (status == 0) and player1 and (actor.name == player1.name) then
    if arg == "red" then
        actor:send("You are the <b:red>red</> pieces!")
        self.room:send_except(actor, tostring(actor.name) .. " chooses to play with the <b:red>red</> pieces!")
        if player2 then
            player2:send("You are the <b:black>black</> pieces!")
            self.room:send_except(player2, tostring(player2.name) .. " gets the <b:black>black</> pieces.")
            actor:send("You get to go first!")
            local status = 1
            globals.status = status
            local turn = 1
            globals.turn = turn
        end
        local p1col = "<b:red>"
        globals.p1col = p1col
        local p2col = "<b:black>"
        globals.p2col = p2col
        local p1desc = "<b:red>red</>"
        globals.p1desc = p1desc
        local p2desc = "<b:black>black</>"
        globals.p2desc = p2desc
    elseif arg == "black" then
        actor:send("You are the <b:black>black</> pieces!")
        self.room:send_except(actor, tostring(actor.name) .. " chooses to play with the <b:black>black</> pieces!")
        if player2 then
            player2:send("You are the <b:red>red</> pieces!")
            self.room:send_except(player2, tostring(player2.name) .. " gets the <b:red>red</> pieces.")
            actor:send("You get to go first!")
            local status = 1
            globals.status = status
            local turn = 1
            globals.turn = turn
        end
        local p1col = "<b:black>"
        globals.p1col = p1col
        local p2col = "<b:red>"
        globals.p2col = p2col
        local p1desc = "<b:black>black</>"
        globals.p1desc = p1desc
        local p2desc = "<b:red>red</>"
        globals.p2desc = p2desc
    else
        actor:send("You may only select 'red' or 'black'.")
    end
    local a1 = "O"
    local a2 = "O"
    local a3 = "O"
    local a4 = "O"
    local a5 = "O"
    local a6 = "O"
    local a7 = "O"
    local b1 = "O"
    local b2 = "O"
    local b3 = "O"
    local b4 = "O"
    local b5 = "O"
    local b6 = "O"
    local b7 = "O"
    local c1 = "O"
    local c2 = "O"
    local c3 = "O"
    local c4 = "O"
    local c5 = "O"
    local c6 = "O"
    local c7 = "O"
    local d1 = "O"
    local d2 = "O"
    local d3 = "O"
    local d4 = "O"
    local d5 = "O"
    local d6 = "O"
    local d7 = "O"
    local e1 = "O"
    local e2 = "O"
    local e3 = "O"
    local e4 = "O"
    local e5 = "O"
    local e6 = "O"
    local e7 = "O"
    local f1 = "O"
    local f2 = "O"
    local f3 = "O"
    local f4 = "O"
    local f5 = "O"
    local f6 = "O"
    local f7 = "O"
    local g1 = "O"
    local g2 = "O"
    local g3 = "O"
    local g4 = "O"
    local g5 = "O"
    local g6 = "O"
    local g7 = "O"
    globals.a1 = a1
    globals.a2 = a2
    globals.a3 = a3
    globals.a4 = a4
    globals.a5 = a5
    globals.a6 = a6
    globals.a7 = a7
    globals.b1 = b1
    globals.b2 = b2
    globals.b3 = b3
    globals.b4 = b4
    globals.b5 = b5
    globals.b6 = b6
    globals.b7 = b7
    globals.c1 = c1
    globals.c2 = c2
    globals.c3 = c3
    globals.c4 = c4
    globals.c5 = c5
    globals.c6 = c6
    globals.c7 = c7
    globals.d1 = d1
    globals.d2 = d2
    globals.d3 = d3
    globals.d4 = d4
    globals.d5 = d5
    globals.d6 = d6
    globals.d7 = d7
    globals.e1 = e1
    globals.e2 = e2
    globals.e3 = e3
    globals.e4 = e4
    globals.e5 = e5
    globals.e6 = e6
    globals.e7 = e7
    globals.f1 = f1
    globals.f2 = f2
    globals.f3 = f3
    globals.f4 = f4
    globals.f5 = f5
    globals.f6 = f6
    globals.f7 = f7
    globals.g1 = g1
    globals.g2 = g2
    globals.g3 = g3
    globals.g4 = g4
    globals.g5 = g5
    globals.g6 = g6
    globals.g7 = g7
else
    _return_value = true
end
return _return_value$trig$, '6bef2812b4580931f4afe494ce9e565b'),
  -- data/triggers/060/060_66_connectfour_drop_piece.lua
  (60, 66, $trig$-- Converted from DG Script #6066: connectfour drop piece
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- Command location mask 4: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: drop
if not (cmd == "drop") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "d" or _sw1 == "dr" then
        _return_value = true
        return _return_value
    end
end
if (actor.name == player1.name) or (actor.name == player2.name) then
    if status == 0 then
        actor:send("The game hasn't started yet!")
        return _return_value
    elseif status == 2 then
        actor:send("The game is already over!")
        return _return_value
    end
end
local piece
if actor.name == player1.name then
    if turn ~= 1 then
        actor:send("It's not your turn!")
        return _return_value
    end
    piece = p1colO&0
elseif actor.name == player2.name then
    if turn ~= 2 then
        actor:send("It's not your turn!")
        return _return_value
    end
    piece = p2colO&0
else
    _return_value = true
    return _return_value
end
local full
if arg == 1 then
    if g1 == "O" then
        local g1 = piece
        globals.g1 = g1
    elseif f1 == "O" then
        local f1 = piece
        globals.f1 = f1
    elseif e1 == "O" then
        local e1 = piece
        globals.e1 = e1
    elseif d1 == "O" then
        local d1 = piece
        globals.d1 = d1
    elseif c1 == "O" then
        local c1 = piece
        globals.c1 = c1
    elseif b1 == "O" then
        local b1 = piece
        globals.b1 = b1
    elseif a1 == "O" then
        local a1 = piece
        globals.a1 = a1
    else
        full = 1
    end
elseif arg == 2 then
    if g2 == "O" then
        local g2 = piece
        globals.g2 = g2
    elseif f2 == "O" then
        local f2 = piece
        globals.f2 = f2
    elseif e2 == "O" then
        local e2 = piece
        globals.e2 = e2
    elseif d2 == "O" then
        local d2 = piece
        globals.d2 = d2
    elseif c2 == "O" then
        local c2 = piece
        globals.c2 = c2
    elseif b2 == "O" then
        local b2 = piece
        globals.b2 = b2
    elseif a2 == "O" then
        local a2 = piece
        globals.a2 = a2
    else
        full = 1
    end
elseif arg == 3 then
    if g3 == "O" then
        local g3 = piece
        globals.g3 = g3
    elseif f3 == "O" then
        local f3 = piece
        globals.f3 = f3
    elseif e3 == "O" then
        local e3 = piece
        globals.e3 = e3
    elseif d3 == "O" then
        local d3 = piece
        globals.d3 = d3
    elseif c3 == "O" then
        local c3 = piece
        globals.c3 = c3
    elseif b3 == "O" then
        local b3 = piece
        globals.b3 = b3
    elseif a3 == "O" then
        local a3 = piece
        globals.a3 = a3
    else
        full = 1
    end
elseif arg == 4 then
    if g4 == "O" then
        local g4 = piece
        globals.g4 = g4
    elseif f4 == "O" then
        local f4 = piece
        globals.f4 = f4
    elseif e4 == "O" then
        local e4 = piece
        globals.e4 = e4
    elseif d4 == "O" then
        local d4 = piece
        globals.d4 = d4
    elseif c4 == "O" then
        local c4 = piece
        globals.c4 = c4
    elseif b4 == "O" then
        local b4 = piece
        globals.b4 = b4
    elseif a4 == "O" then
        local a4 = piece
        globals.a4 = a4
    else
        full = 1
    end
elseif arg == 5 then
    if g5 == "O" then
        local g5 = piece
        globals.g5 = g5
    elseif f5 == "O" then
        local f5 = piece
        globals.f5 = f5
    elseif e5 == "O" then
        local e5 = piece
        globals.e5 = e5
    elseif d5 == "O" then
        local d5 = piece
        globals.d5 = d5
    elseif c5 == "O" then
        local c5 = piece
        globals.c5 = c5
    elseif b5 == "O" then
        local b5 = piece
        globals.b5 = b5
    elseif a5 == "O" then
        local a5 = piece
        globals.a5 = a5
    else
        full = 1
    end
elseif arg == 6 then
    if g6 == "O" then
        local g6 = piece
        globals.g6 = g6
    elseif f6 == "O" then
        local f6 = piece
        globals.f6 = f6
    elseif e6 == "O" then
        local e6 = piece
        globals.e6 = e6
    elseif d6 == "O" then
        local d6 = piece
        globals.d6 = d6
    elseif c6 == "O" then
        local c6 = piece
        globals.c6 = c6
    elseif b6 == "O" then
        local b6 = piece
        globals.b6 = b6
    elseif a6 == "O" then
        local a6 = piece
        globals.a6 = a6
    else
        full = 1
    end
elseif arg == 7 then
    if g7 == "O" then
        local g7 = piece
        globals.g7 = g7
    elseif f7 == "O" then
        local f7 = piece
        globals.f7 = f7
    elseif e7 == "O" then
        local e7 = piece
        globals.e7 = e7
    elseif d7 == "O" then
        local d7 = piece
        globals.d7 = d7
    elseif c7 == "O" then
        local c7 = piece
        globals.c7 = c7
    elseif b7 == "O" then
        local b7 = piece
        globals.b7 = b7
    elseif a7 == "O" then
        local a7 = piece
        globals.a7 = a7
    else
        full = 1
    end
else
    actor:send("Drop a piece in where!?")
    return _return_value
end
if full then
    actor:send("Column " .. tostring(arg) .. " is full!  Try a different one.")
    return _return_value
end
actor:send("You drop a piece in column " .. tostring(arg) .. ".")
self.room:send_except(actor, tostring(actor.name) .. " drops a piece in column " .. tostring(arg) .. ".")
local row1 = a1a2a3a4a5a6a7
local row2 = b1b2b3b4b5b6b7
local row3 = c1c2c3c4c5c6c7
local row4 = d1d2d3d4d5d6d7
local row5 = e1e2e3e4e5e6e7
local row6 = f1f2f3f4f5f6f7
local row7 = g1g2g3g4g5g6g7
local col1 = a1b1c1d1e1f1g1
local col2 = a2b2c2d2e2f2g2
local col3 = a3b3c3d3e3f3g3
local col4 = a4b4c4d4e4f4g4
local col5 = a5b5c5d5e5f5g5
local col6 = a6b6c6d6e6f6g6
local col7 = a7b7c7d7e7f7g7
local dnw1 = d1e2f3g4
local dnw2 = c1d2e3f4g5
local dnw3 = b1c2d3e4f5g6
local dnw4 = a1b2c3d4e5f6g7
local dnw5 = a2b3c4d5e6f7
local dnw6 = a3b4c5d6e7
local dnw7 = a4b5c6d7
local dne1 = a4b3c2d1
local dne2 = a5b4c3d2e1
local dne3 = a6b5c4d3e2f1
local dne4 = a7b6c5d4e3f2g1
local dne5 = b7c6d5e4f3g2
local dne6 = c7d6e5f4g3
local dne7 = d7e6f5g4
local streak = piecepiecepiecepiece
local win
if (string.find(row1, "streak")) or (string.find(row2, "streak")) or (string.find(row3, "streak")) or (string.find(row4, "streak")) or (string.find(row5, "streak")) or (string.find(row6, "streak")) or (string.find(row7, "streak")) then
    win = 1
elseif (string.find(col1, "streak")) or (string.find(col2, "streak")) or (string.find(col3, "streak")) or (string.find(col4, "streak")) or (string.find(col5, "streak")) or (string.find(col6, "streak")) or (string.find(col7, "streak")) then
    win = 1
elseif (string.find(dnw1, "streak")) or (string.find(dnw2, "streak")) or (string.find(dnw3, "streak")) or (string.find(dnw4, "streak")) or (string.find(dnw5, "streak")) or (string.find(dnw6, "streak")) or (string.find(dnw7, "streak")) then
    win = 1
elseif (string.find(dne1, "streak")) or (string.find(dne2, "streak")) or (string.find(dne3, "streak")) or (string.find(dne4, "streak")) or (string.find(dne5, "streak")) or (string.find(dne6, "streak")) or (string.find(dne7, "streak")) then
    win = 1
end
if win then
    actor:send("You win!")
    self.room:send_except(actor, tostring(actor.name) .. " wins!")
    if player1.name == actor.name then
        local p1win = 1
        globals.p1win = p1win
    else
        local p2win = 1
        globals.p2win = p2win
    end
    local status = 2
    globals.status = status
end
if globals.turn == 1 then
    globals.turn = 2
else
    globals.turn = 1
end
return _return_value$trig$, '3555009a963ec44b73e1b1376b88aece'),
  -- data/triggers/060/060_68_connectfour_reset_game.lua
  (60, 68, $trig$-- Converted from DG Script #6068: connectfour reset game
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- Command location mask 4: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: reset
if not (cmd == "reset") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "r" or _sw1 == "re" or _sw1 == "res" then
        _return_value = true
        return _return_value
    end
end
if status == 2 then
    self.room:send("Resetting ConnectFour.")
    local a1 = 0
    local a2 = 0
    local a3 = 0
    local a4 = 0
    local a5 = 0
    local a6 = 0
    local a7 = 0
    local b1 = 0
    local b2 = 0
    local b3 = 0
    local b4 = 0
    local b5 = 0
    local b6 = 0
    local b7 = 0
    local c1 = 0
    local c2 = 0
    local c3 = 0
    local c4 = 0
    local c5 = 0
    local c6 = 0
    local c7 = 0
    local d1 = 0
    local d2 = 0
    local d3 = 0
    local d4 = 0
    local d5 = 0
    local d6 = 0
    local d7 = 0
    local e1 = 0
    local e2 = 0
    local e3 = 0
    local e4 = 0
    local e5 = 0
    local e6 = 0
    local e7 = 0
    local f1 = 0
    local f2 = 0
    local f3 = 0
    local f4 = 0
    local f5 = 0
    local f6 = 0
    local f7 = 0
    local g1 = 0
    local g2 = 0
    local g3 = 0
    local g4 = 0
    local g5 = 0
    local g6 = 0
    local g7 = 0
    local player1 = 0
    local player2 = 0
    local status = 0
    local p1col = 0
    local p2col = 0
    local p1desc = 0
    local p2desc = 0
    local p1win = 0
    local p2win = 0
    local p1forfeit = 0
    local p2forfeit = 0
    -- Fragment (possible truncation): set turn
    globals.a1 = a1
    globals.a2 = a2
    globals.a3 = a3
    globals.a4 = a4
    globals.a5 = a5
    globals.a6 = a6
    globals.a7 = a7
    globals.b1 = b1
    globals.b2 = b2
    globals.b3 = b3
    globals.b4 = b4
    globals.b5 = b5
    globals.b6 = b6
    globals.b7 = b7
    globals.c1 = c1
    globals.c2 = c2
    globals.c3 = c3
    globals.c4 = c4
    globals.c5 = c5
    globals.c6 = c6
    globals.c7 = c7
    globals.d1 = d1
    globals.d2 = d2
    globals.d3 = d3
    globals.d4 = d4
    globals.d5 = d5
    globals.d6 = d6
    globals.d7 = d7
    globals.e1 = e1
    globals.e2 = e2
    globals.e3 = e3
    globals.e4 = e4
    globals.e5 = e5
    globals.e6 = e6
    globals.e7 = e7
    globals.f1 = f1
    globals.f2 = f2
    globals.f3 = f3
    globals.f4 = f4
    globals.f5 = f5
    globals.f6 = f6
    globals.f7 = f7
    globals.g1 = g1
    globals.g2 = g2
    globals.g3 = g3
    globals.g4 = g4
    globals.g5 = g5
    globals.g6 = g6
    globals.g7 = g7
    globals.player1 = player1
    globals.player2 = player2
    globals.status = status
    globals.p1col = p1col
    globals.p2col = p2col
    globals.p1desc = p1desc
    globals.p2desc = p2desc
    globals.p1win = p1win
    globals.p2win = p2win
    globals.p1forfeit = p1forfeit
    globals.p2forfeit = p2forfeit
    -- (the DG `set turn ...` was truncated by the converter; the first player moves first)
    self.room:send("Board cleared.")
elseif status == 1 then
    if (actor.name == player1.name) or (actor.name == player2.name) then
        actor:send("If you want to end the game, forfeit first, then reset.")
    else
        actor:send("Wait until " .. tostring(player1.name) .. " and " .. tostring(player2.name) .. " are done playing!")
    end
elseif status == 0 then
    if player1 and (actor.name == player1.name) then
        actor:send("You can't reset the board until the game is over.")
    else
        actor:send("The board is already cleared!")
    end
end
return _return_value$trig$, '8fd78fc0d79e74128dcda259f42a388f'),
  -- data/triggers/060/060_70_connectfour_forfeit_game.lua
  (60, 70, $trig$-- Converted from DG Script #6070: connectfour forfeit game
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- Command location mask 4: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: forfeit
if not (cmd == "forfeit") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "f" or _sw1 == "fo" or _sw1 == "for" then
        _return_value = true
        return _return_value
    end
end
if (status == 0) or (not player1) or (not player2) then
    actor:send("But the game hasn't even started yet!")
elseif (player1.name == actor.name) or (player2.name == actor.name) then
    if status == 2 then
        actor:send("But the game's already over!")
        return _return_value
    end
    if arg == "yes" then
        actor:send("You forfeit the game!")
        self.room:send_except(actor, tostring(actor.name) .. " forfeits the game!")
        if player1.name == actor.name then
            local p1forfeit = 2
            globals.p1forfeit = p1forfeit
        elseif player2.name == actor.name then
            local p2forfeit = 2
            globals.p2forfeit = p2forfeit
        end
        local status = 2
        globals.status = status
    else
        actor:send("Are you absolutely sure you want to forfeit?  If so, type 'forfeit yes'.")
        if player1.name == actor.name then
            local p1forfeit = 1
            globals.p1forfeit = p1forfeit
        elseif player2.name == actor.name then
            local p2forfeit = 1
            globals.p2forfeit = p2forfeit
        end
    end
else
    actor:send("You can't forfeit a game you're not even playing!")
end
return _return_value$trig$, '6405bcaea5b310755f1ff7b82fb3e71c'),
  -- data/triggers/060/060_75_hearts_start.lua
  (60, 75, $trig$-- Converted from DG Script #6075: hearts start
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- Command location mask 4: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: start
if not (cmd == "start") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" or _sw1 == "st" or _sw1 == "sta" or _sw1 == "star" then
        _return_value = true
        return _return_value
    end
end
if status then
    actor:send("The game has already started.  You must wait for it to finish.")
end
if player1 then
    if player2 then
        if player3 then
            if player4 then
                actor:send("Sorry, four people are already playing Hearts.")
                actor:send("You'll have to wait for the next game.")
            else
                if (actor.name == player1.name) or (actor.name == player2.name) or (actor.name == player3.name) then
                    actor:send("You're already in the game!")
                else
                    self.room:send_except(actor, tostring(actor.name) .. " joins the Hearts game as player 4.")
                    actor:send("You are now joining the Hearts game as player 4.")
                    local player4 = actor
                    globals.player4 = player4
                    player1:send("The cards are now ready to be dealt.")
                    player2:send("The cards are now ready to be dealt.")
                    player3:send("The cards are now ready to be dealt.")
                    actor:send("The cards are now ready to be dealt.")
                    local status = 1
                    globals.status = status
                end
            end
        else
            if (actor.name == player1.name) or (actor.name == player2.name) then
                actor:send("You're already in the game!")
            else
                self.room:send_except(actor, tostring(actor.name) .. " joins the Hearts game as player 3.")
                actor:send("You are now joining the Hearts game as player 3.")
                local player3 = actor
                globals.player3 = player3
            end
        end
    else
        if actor.name == player1.name then
            actor:send("You're already in the game!")
        else
            self.room:send_except(actor, tostring(actor.name) .. " joins the Hearts game as player 2.")
            actor:send("You are now joining the Hearts game as player 2.")
            local player2 = actor
            globals.player2 = player2
        end
    end
else
    self.room:send_except(actor, tostring(actor.name) .. " starts a new game of Hearts as player 1.")
    actor:send("Alright!  Starting a new game of Hearts.  You are player 1.")
    local player1 = actor
    globals.player1 = player1
end
return _return_value$trig$, 'ee5378185f64960475da7761b15436c4'),
  -- data/triggers/060/060_77_hearts_deal.lua
  (60, 77, $trig$-- Converted from DG Script #6077: hearts deal
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- Command location mask 4: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: deal
if not (cmd == "deal") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
if cmd == "d" or cmd == "de" then
    _return_value = true
    return _return_value
end
if player1 and player2 and player3 and player4 then
    if (player1.name ~= actor.name) and (player2.name ~= actor.name) and (player3.name ~= actor.name) then
        -- UNCONVERTED: ( player4.name% != %actor.name%)
        _return_value = true
        return _return_value
    end
    if status > 1 then
        actor:send("Wait for this hand to end before dealing again!")
        return _return_value
    end
    actor:send("You deal the cards across the table.")
    self.room:send_except(actor, tostring(actor.name) .. " deals the cards, beginning a new round.")
    local card = 1
    while card <= 52 do
        card[card] = 0
        local rank = card - 13 * ((card - 1)/ 13)
        local suit = ((card - 1)/ 13) + 1
        if rank == 1 then
            rank = "Two"
        elseif rank == 2 then
            rank = "Three"
        elseif rank == 3 then
            rank = "Four"
        elseif rank == 4 then
            rank = "Five"
        elseif rank == 5 then
            rank = "Six"
        elseif rank == 6 then
            rank = "Seven"
        elseif rank == 7 then
            rank = "Eight"
        elseif rank == 8 then
            rank = "Nine"
        elseif rank == 9 then
            rank = "Ten"
        elseif rank == 10 then
            rank = "Jack"
        elseif rank == 11 then
            rank = "Queen"
        elseif rank == 12 then
            rank = "King"
        elseif rank == 13 then
            rank = "Ace"
        end
        if suit == 1 then
            suit = "Clubs"
        elseif suit == 2 then
            suit = "Diamonds"
        elseif suit == 3 then
            suit = "Spades"
        elseif suit == 4 then
            suit = "Hearts"
        end
        name[card] = rank% of %suit
        globals["name" .. card] = globals["name" .. card] or true
        card = card + 1
    end
    local count = 0
    local plyr = 1
    while plyr <= 4 do
        local cnt = 1
        while cnt <= 13 do
            local dlt = 0
            local dlt_cnt = 0
            while not dlt do
                dlt_cnt = dlt_cnt + 1
                local card = random(1, 52)
                local desc = XcardX
                if not (string.find(cards, "desc")) then
                    card[card] = plyr
                    globals["card" .. card] = globals["card" .. card] or true
                    local cards = cardsdesc
                    local dlt = 1
                end
            end
            while not dlt do
                dlt_cnt = dlt_cnt + 1
                local card = random(1, 52)
                local desc = XcardX
                if not (string.find(cards, "desc")) then
                    card[card] = plyr
                    globals["card" .. card] = globals["card" .. card] or true
                    local cards = cardsdesc
                    local dlt = 1
                end
            end
            cnt = cnt + 1
            if cnt < 13 then
                actor:send("Dealing of cards failed; please attempt again.")
                return _return_value
            end
            plyr = plyr + 1
            if card1 == 1 then
                globals.turn = 1
                player1:send("It's your turn first; you must play the " .. tostring(name1) .. ".")
            elseif card1 == 2 then
                globals.turn = 2
                player2:send("It's your turn first; you must play the " .. tostring(name1) .. ".")
            elseif card1 == 3 then
                globals.turn = 3
                player3:send("It's your turn first; you must play the " .. tostring(name1) .. ".")
            elseif card1 == 4 then
                globals.turn = 4
                player4:send("It's your turn first; you must play the " .. tostring(name1) .. ".")
            end
            local first_turn = 1
            globals.first_turn = first_turn
            local status = 3
            globals.status = status
        end
    end
else
    -- TODO(parity): the converter put this branch inside the
    -- inner while loop; structurally it belongs to the outer
    -- "all four players present?" if at line 29. Hoisted here.
    if (player1 and (player1.name == actor.name)) or (player2 and (player2.name == actor.name)) or (player3 and (player3.name == actor.name)) then
        actor:send("You can't deal until four people have joined!")
    else
        _return_value = true
    end
end
return _return_value$trig$, '4a83116a89bb1dd1c683db138cb919c4'),
  -- data/triggers/060/060_83_hearts_endgame.lua
  (60, 83, $trig$-- Converted from DG Script #6083: hearts endgame
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- Command location mask 4: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: endgame
if not (cmd == "endgame") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "e" or _sw1 == "en" then
        _return_value = true
        return _return_value
    end
end
if status == 4 then
    local plyr = 1
    while plyr <= 4 do
        local score
        if card37 == plyr + 4 then
            score = 13
        end
        if card40 == plyr + 4 then
            score = score + 1
        end
        if card41 == plyr + 4 then
            score = score + 1
        end
        if card42 == plyr + 4 then
            score = score + 1
        end
        if card43 == plyr + 4 then
            score = score + 1
        end
        if card44 == plyr + 4 then
            score = score + 1
        end
        if card45 == plyr + 4 then
            score = score + 1
        end
        if card46 == plyr + 4 then
            score = score + 1
        end
        if card47 == plyr + 4 then
            score = score + 1
        end
        if card48 == plyr + 4 then
            score = score + 1
        end
        if card49 == plyr + 4 then
            score = score + 1
        end
        if card50 == plyr + 4 then
            score = score + 1
        end
        if card51 == plyr + 4 then
            score = score + 1
        end
        if card52 == plyr + 4 then
            score = score + 1
        end
        if plyr == 1 then
            local score1 = score
        elseif plyr == 2 then
            local score2 = score
        elseif plyr == 3 then
            local score3 = score
        elseif plyr == 4 then
            local score4 = score
        end
    end
    local score1, score2, score3, score4
    if (score1 == 26) or (score2 == 26) or (score3 == 26) or (score4 == 26) then
        if score1 == 26 then
            player1:send("You took all the point cards!  Everyone else gets 26 points.")
            player2:send(tostring(player1.name) .. " took all the point cards, so you get 26 points.")
            player3:send(tostring(player1.name) .. " took all the point cards, so you get 26 points.")
            player4:send(tostring(player1.name) .. " took all the point cards, so you get 26 points.")
            score1 = 0
            score2 = 26
            score3 = 26
            score4 = 26
        elseif score2 == 26 then
            player1:send(tostring(player2.name) .. " took all the point cards, so you get 26 points.")
            player2:send("You took all the point cards!  Everyone else gets 26 points.")
            player3:send(tostring(player2.name) .. " took all the point cards, so you get 26 points.")
            player4:send(tostring(player2.name) .. " took all the point cards, so you get 26 points.")
            score1 = 26
            score2 = 0
            score3 = 26
            score4 = 26
        elseif score3 == 26 then
            player1:send(tostring(player3.name) .. " took all the point cards, so you get 26 points.")
            player2:send(tostring(player3.name) .. " took all the point cards, so you get 26 points.")
            player3:send("You took all the point cards!  Everyone else gets 26 points.")
            player4:send(tostring(player3.name) .. " took all the point cards, so you get 26 points.")
            score1 = 26
            score2 = 26
            score3 = 0
            score4 = 26
        elseif score4 == 26 then
            player1:send(tostring(player4.name) .. " took all the point cards, so you get 26 points.")
            player2:send(tostring(player4.name) .. " took all the point cards, so you get 26 points.")
            player3:send(tostring(player4.name) .. " took all the point cards, so you get 26 points.")
            player4:send("You took all the point cards!  Everyone else gets 26 points.")
            score1 = 26
            score2 = 26
            score3 = 26
            score4 = 0
        end
    end
    total1 = total1 + score1
    total2 = total2 + score2
    total3 = total3 + score3
    total4 = total4 + score4
    player1:send("You scored " .. tostring(score1) .. " points this round, bringing your total to " .. tostring(total1) .. ".")
    player2:send("You scored " .. tostring(score2) .. " points this round, bringing your total to " .. tostring(total2) .. ".")
    player3:send("You scored " .. tostring(score3) .. " points this round, bringing your total to " .. tostring(total3) .. ".")
    player4:send("You scored " .. tostring(score4) .. " points this round, bringing your total to " .. tostring(total4) .. ".")
    if (total1 > 99) or (total2 > 99) or (total3 > 99) or (total4 > 99) then
        self.room:send("The game is over!")
        self.room:send(tostring(player1.name) .. " scored a total of " .. tostring(total1) .. " points.")
        self.room:send(tostring(player2.name) .. " scored a total of " .. tostring(total2) .. " points.")
        self.room:send(tostring(player3.name) .. " scored a total of " .. tostring(total3) .. " points.")
        self.room:send(tostring(player4.name) .. " scored a total of " .. tostring(total4) .. " points.")
        player1 = nil
        player2 = nil
        player3 = nil
        player4 = nil
        status = nil
    else
        local status = 1
        globals.status = status
    end
else
    _return_value = true
end
return _return_value$trig$, '558f13cd63b2e54e2754180ca3018e2e'),
  -- data/triggers/103/103_09_khysan-greet.lua
  (103, 9, $trig$local ice_stage = actor:get_quest_stage("ice_shards")
-- DG %type%_wand: the wand questmaster's LOAD trigger (002_111) stores the element in globals.type
local wand_quest = (globals.type or "type") .. "_wand"
local wand_stage = actor:get_quest_stage(wand_quest)

local seen_before = false
if (ice_stage or 0) > 0 and ice_stage > 0 then
    seen_before = true
end
if globals.wandstep and (wand_stage or 0) > globals.wandstep then
    seen_before = true
end
if globals.wandstep and wand_stage == globals.wandstep and (actor:get_quest_var(wand_quest .. ":greet") or 0) == 1 then
    seen_before = true
end

wait(1)
actor:send(self.name .. " looks up at your approach.")

if seen_before then
    self:say("Welcome back my friend.")
    wait(0.2)
    if (ice_stage or 0) > 0 and ice_stage > 0 and not actor:get_has_completed("ice_shards") then
        self:say("Did you find any more clues?")
        if globals.wandstep and wand_stage == globals.wandstep then
            local minlevel = (globals.wandstep - 1) * 10
            wait(1)
            if actor.level >= minlevel then
                if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
                    self:say("Or is there something else that brings you back?")
                else
                    self:say("Or do you have what I need for a new staff?")
                end
            end
        end
    else
        if globals.wandstep and wand_stage == globals.wandstep then
            local minlevel = (globals.wandstep - 1) * 10
            if actor.level >= minlevel then
                if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
                    self:say("Is there something else that brings you back?")
                else
                    self:say("Do you have what I need for a new staff?")
                end
            end
        end
    end
else
    self.room:send(self.name .. " smiles warmly and says, 'Welcome to Phoenix Feather Resort.'")
    wait(1)
    self:say("We are currently offering free services to all adventurers.")
    wait(1)
    self:command("bow " .. actor.name)
    self:say("Please enjoy your stay.  You may enter the hot springs to the south.")
    if globals.wandstep and wand_stage == globals.wandstep then
        wait(1)
        local minlevel = (globals.wandstep - 1) * 10
        if actor.level >= minlevel and (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
            self.room:send(self.name .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        end
    end
    if not ((ice_stage or 0) > 0 and ice_stage > 0) then
        wait(0.3)
        if string.find(actor.class, "cryomancer") then
            if actor:get_has_completed("major_globe_spell")
               and actor:get_has_completed("relocate_spell_quest")
               and actor:get_has_completed("wall_ice")
               and actor:get_has_completed("waterform")
               and actor:get_has_completed("flood") then
                self:say("Oh, " .. actor.name .. " " .. tostring(actor.title) .. "!  I've heard of you!  You're quite talked about amongst our fellow cryomancers.")
                if actor.level > 88 then
                    self.room:send("</>")
                    self:say("Makes me wonder if you could have mastered the most powerful cryomantic spell ever known.")
                end
            end
        end
    end
end$trig$, 'eb61dc510f7ade4261139f4aaca2790d'),
  -- data/triggers/123/123_13_megalith_quest_keeper_greet.lua
  (123, 13, $trig$-- Converted from DG Script #12313: megalith_quest_keeper_greet
-- Original: MOB trigger, flags: GREET, probability: 100%

wait(0.2)
-- DG %type%_wand: the questmaster's LOAD trigger (002_111) stores the element in globals.type
local wand_quest = (globals.type or "type") .. "_wand"
if actor:get_quest_stage(wand_quest) == globals.wandstep and not actor:get_has_failed("megalith_quest") then
    local minlevel = (globals.wandstep - 1) * 10
    if actor.level >= minlevel then
        if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
            self.room:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        else
            self:say("Do you have what I need for the wand?")
        end
        wait(1)
    end
end
local stage = actor:get_quest_stage("megalith_quest")
-- switch on self.id
do
    if (self.zone_id == 123 and self.id == 3) then
        if actor:get_has_completed("megalith_quest") then
            self:command("cheer")
            wait(1)
            self:say("I can feel the Earth rejoicing from here to Templace!  Surely with Her blessing we can move to cleanse the ancient home of my people.")
        elseif actor:get_has_failed("megalith_quest") then
            self:emote("drops to the ground.")
            wait(1)
            self:say("All hope is lost...  Without Her blessing, the demons will rampage forever.")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item4") or 0) == 1) then
            self:command("bow " .. tostring(actor.name))
            wait(1)
            self:say("I thank you most humbly for your assistance with calling the Spirits of Earth.")
        elseif stage > 2 then
            self:say("Finally, our Mother Goddess will be able to walk our world again!")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item4") or 0) ~= 0) and ((actor:get_quest_var("megalith_quest:north") or 0) ~= 0) then
            self:command("bow " .. tostring(actor.name))
            self.room:send(tostring(self.name) .. " speaks in voice like a gentle breeze across sunlit grass, 'Are you here to help me summon the Spirits of Earth to protect our coven?'")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item4") or 0) ~= 0) and ((actor:get_quest_var("megalith_quest:north") or 0) ~= 1) then
            self:say("Do you have the granite ring?")
        end
    elseif (self.zone_id == 123 and self.id == 4) then
        if actor:get_has_completed("megalith_quest") then
            self:say("This land is again full with the pulse, the pull, the bloodpump of creation...")
            self:command("bow " .. tostring(actor.name))
            wait(1)
            self:say("Thanks to you.")
        elseif actor:get_has_failed("megalith_quest") then
            self.room:send(tostring(self.name) .. " begins to mutter to the standing stone, 'Destruction, greater than you or I can ever imagine...'")
            wait(1)
            self.room:send(tostring(self.name) .. " continues to mutter... 'A wave of protean fire curls around the planet and bares the world clean as bone...'")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item2") or 0) == 1) then
            self:command("nod " .. tostring(actor.name))
            wait(1)
            self:say("I thank you most humbly for your assistance with calling the Spirits of Fire.")
        elseif stage > 2 then
            self.room:send(tostring(self.name) .. " whispers, 'Feel that?  That tingle in your veins?'")
            wait(1)
            self:say("That is the Lady of the Stars.  She approaches...")
            self.room:send(tostring(self.name) .. " takes a deep breath and exhales a cloud of <b:red>s</><red>p</><b:yellow>a</><red>r</><yellow>k</><b:yellow>s</>!")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item2") or 0) ~= 0) and ((actor:get_quest_var("megalith_quest:south") or 0) ~= 0) then
            self:command("nod " .. tostring(actor.name))
            self:say("Hail traveler.")
            wait(0.2)
            self.room:send("In a whisper like smokey ash " .. tostring(self.name) .. " says, 'Are you here to help me summon the Spirits of Fire to protect our coven?'")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item2") or 0) ~= 0) and ((actor:get_quest_var("megalith_quest:south") or 0) ~= 1) then
            self:say("I hope you brought the flaming jewel from Vulcera.")  -- typo: sat
        end
    elseif (self.zone_id == 123 and self.id == 5) then
        if actor:get_has_completed("megalith_quest") then
            self:command("dance " .. tostring(actor.name))
            wait(0.4)
            self:say("Finally we might be able to heal my poor family in Nordus!")
            wait(3)
            self:say("Can't you feel it?  The breath, the pull...")
            self:emote("exclaims in a ringing voice, 'Glory to - !!'")
            self:command("laugh")
        elseif actor:get_has_failed("megalith_quest") then
            self:emote("stands completely still, staring off into the void.")
            wait(1)
            self:say("Huh.")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item3") or 0) == 1) then
            self:command("wave " .. tostring(actor.name))
            wait(0.4)
            self:say("Thanks so much for your help with the Air Spirits!")
        elseif stage > 2 then
            self.room:send(tostring(self.name) .. " proclaims, 'Rejoice, the Great Work continues!  Soon the Faerie Goddess will be with us!'")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item3") or 0) ~= 0) and ((actor:get_quest_var("megalith_quest:east") or 0) ~= 0) then
            self:command("wave " .. tostring(actor.name))
            wait(0.4)
            self.room:send("In a jubilant tone, " .. tostring(self.name) .. " says, 'Hi there! Are you here to help me summon the Spirits of Air to protect our coven?'")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item3") or 0) ~= 0) and ((actor:get_quest_var("megalith_quest:east") or 0) ~= 1) then
            wait(0.2)
            self:say("I hope you were able to recover that cloud bracelet!")
        end
    elseif (self.zone_id == 123 and self.id == 6) then
        if actor:get_has_completed("megalith_quest") then
            self:emote("stifles tears of joy.")
            wait(1)
            self:say("I am overjoyed to see my Mother once again!  I can hear the rivers sing across Ethilien.  Our coven may be able to bring balance where the Dreaming flooded into the mortal realm at last.")
        elseif actor:get_has_failed("megalith_quest") then
            self:say("A catastrophe...  As terrible as the night the Dream engulfed the Syric Mountains...")
            wait(2)
            self:emote("begins to slip into a fugue.")
            wait(4)
            self:say("I still remember that night...")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item4") or 0) == 1) then
            self:command("curtsy " .. tostring(actor.name))
            wait(2)
            self:say("Spirits of Water overflow from the Dreaming into this realm, thanks to you!")
        elseif stage > 2 then
            self:say("Thanks to you, soon the Great Mother will be able to come from the Deep Dreaming once more!")
            self:command("hug " .. tostring(actor.name))
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item4") or 0) ~= 0) and ((actor:get_quest_var("megalith_quest:west") or 0) ~= 0) then
            self:command("curtsy " .. tostring(actor.name))
            wait(1)
            self:say("Merry met!")
            wait(2)
            self.room:send(tostring(self.name) .. " speaks in a silver voice, like bells reverberating over water, 'Are you here to help me summon the Spirits of Water to protect our coven?'")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item4") or 0) ~= 0) and ((actor:get_quest_var("megalith_quest:west") or 0) ~= 1) then
            self:say("Have you been able to bring me some water?")
        end
    end
end$trig$, '7bccf9ad862fc0fe6dbc78e6c23245a0'),
  -- data/triggers/185/185_26_sexton_greet.lua
  (185, 26, $trig$wait(2)
if actor:get_quest_stage("phase_mace") == globals.macestep then
    local minlevel = (globals.macestep or 0) * 10
    if actor.level >= minlevel then
        if (actor:get_quest_var("phase_mace:greet") or 0) == 0 then
            actor:send(tostring(self.name) .. " says, 'I sense a ghostly presence about your weapons.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I need?'")
        end
    end
end$trig$, 'b2eb3250bc9c7eae05b7d2462492cee4'),
  -- data/triggers/185/185_28_phase_mace_sexton_speech_upgrade.lua
  (185, 28, $trig$local s = string.lower(speech)

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"upgrade", "upgrades", "upgrading", "mace", "improvement", "improvements", "improving"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
if actor.class == "cleric" or actor.class == "priest" then
    local minlevel = (globals.macestep or 0) * 10
    if actor:get_quest_stage("phase_mace") == globals.macestep then
        if actor.level >= minlevel then
            actor:set_quest_var("phase_mace", "greet", 1)
            self.room:send(tostring(self.name) .. " says, 'I can add benedictions to your mace, yes.'")
            wait(1)
            self:say("You'll need to use your mace " .. tostring(globals.maceattack) .. " times.")
            -- (empty room echo)
            self:say("I'll also need the following:")
            self.room:send("- <b:cyan>" .. "%get.obj_shortdesc[%maceitem3%]%</>, for its spiritual protection.")
            if globals.macestep ~= 2 then
                self.room:send("- <b:cyan>" .. "%get.obj_shortdesc[%maceitem2%]%</>, as a model for the new mace.")
                self.room:send("- <b:cyan>" .. "%get.obj_shortdesc[%maceitem3%]%</>, for its power in fighting the undead.")
                self.room:send("- <b:cyan>" .. "%get.obj_shortdesc[%maceitem4%]%</>, for its guiding light.")
            else
                -- (empty room echo)
                self.room:send(tostring(self.name) .. " says, 'And finally, you'll need to make a pilgrimage to four burial")
                self.room:send("</>grounds to see what lies ahead on your journey:'")
                self.room:send("- <magenta>the necropolis near Anduin</>")
                self.room:send("- <magenta>the pyramid in the Gothra desert</>")
                self.room:send("- <magenta>the ancient barrow in the Iron Hills</>")
                self.room:send("- <magenta>the cemetary outside the Cathedral of Betrayal</>")
                -- (empty room echo)
                self.room:send(tostring(self.name) .. " says, 'Be warned, these places are <red>exceedingly dangerous!</>  All you")
                self.room:send("</>have to do is <b:cyan>[dig]</> up a handful of dirt from each place and bring it")
                self.room:send("</>back to me.'")
            end
            -- (empty room echo)
            self.room:send(tostring(self.name) .. " says, 'You can check your <b:cyan>[mace progress]</> at")
            self.room:send("</>any time.'")
        else
            self.room:send(tostring(self.name) .. " says, 'You'll need to be at least level " .. tostring(minlevel) .. " before I")
            self.room:send("</>can improve your bond with your weapon.'")
        end
    elseif actor:get_has_completed("phase_mace") then
        self:say("There is no weapon greater than the mace of disruption!")
    elseif actor:get_quest_stage("phase_mace") < globals.macestep then
        self:say("Your mace isn't ready for improvement yet.")
    elseif actor:get_quest_stage("phase_mace") > globals.macestep then
        self:say("I've done all I can already.")
        wait(1)
        -- switch on actor:get_quest_stage("phase_mace")
        if actor:get_quest_stage("phase_mace") == 3 then
            self.room:send(tostring(self.name) .. " says, 'The Cleric Guild is capable of some miraculous")
            self.room:send("</>crafting.  Visit the Cleric Guild Master in the Arctic Village of Ickle")
            self.room:send("</>and talk to High Priest Zalish.  He should be able to help you.'")
        elseif actor:get_quest_stage("phase_mace") == 4 then
            self.room:send(tostring(self.name) .. " says, 'Continue with the Cleric Guild Masters.  Check in")
            self.room:send("</>with the High Priestess in the City of Anduin.'")
        elseif actor:get_quest_stage("phase_mace") == 5 then
            self.room:send(tostring(self.name) .. " says, 'Sometimes to battle the dead, we need to use their")
            self.room:send("</>own dark natures against them.  Few are as knowledgeable about the dark")
            self.room:send("</>arts as Ziijhan, the Defiler, in the Cathedral of Betrayal.'")
        elseif actor:get_quest_stage("phase_mace") == 6 then
            self.room:send(tostring(self.name) .. " says, 'Return again to the Abbey of St. George and seek out")
            self.room:send("</>Silania.  Her mastry of spiritual matters will be necessary to improve")
            self.room:send("</>this mace any further.'")
        elseif actor:get_quest_stage("phase_mace") == 7 then
            self.room:send(tostring(self.name) .. " says, 'Of the few remaining who are capable of improving your")
            self.room:send("</>mace, one is a priest of a god most foul.  Find Ruin Wormheart, that")
            self.room:send("</>most heinous of Blackmourne's servators.'")
        elseif actor:get_quest_stage("phase_mace") == 8 then
            self.room:send(tostring(self.name) .. " says, 'The most powerful force in the war against the dead")
            self.room:send("</>is the sun itself.  Consult with the sun's Oracle in the ancient pyramid")
            self.room:send("</>near Anduin.'")
        elseif actor:get_quest_stage("phase_mace") == 9 then
            self.room:send(tostring(self.name) .. " says, 'With everything prepared, return to the very")
            self.room:send("</>beginning of your journey.  The High Priestess of Mielikki, the very")
            self.room:send("</>center of the Cleric Guild, will know what to do.'")
        end
    end
end$trig$, 'dc697cc2ef1035c39c391db08da8fe09'),
  -- data/triggers/188/188_20_xcast_xcast.lua
  (188, 20, $trig$-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: xcast
if not (cmd == "xcast") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- 
-- X-cast
-- This trigger works with 18821, x-decide, to cast custom spells with various
-- effects.  It may only be used by mobiles in the 18820 to 18842 range,
-- Laoris' dragonquest mobiles.
-- 
-- Expected variables set by x-decide:
-- xid - unique integer identifier, like 1
-- xname - name of the spell, such as 'arctic blast'
-- xstars - duration to cast the spell, ie., 2
-- xmagic - magic words uttered at the end of the spell, like 'zimblo argis'
-- xeffect - actual effect of the spell, such as 'damage' or 'expel'
-- xmode - sets whether it's victim or self-only
-- xamount - only meaningful for some spell types, ie., 100
-- 
if (actor.zone_id == 188 and actor.id >= 20 and actor.id <= 42) then
    _return_value = false
    -- Must use x-decide to select a spell first
    if not globals.xname then
        actor:send("You have not chosen a spell to x-cast yet!")
        -- No x-casting damage on self, immortals, or people in other rooms
    elseif (globals.xmode == "victim") and (arg.name == actor.name) then
        actor:send("You cannot x-cast at yourself.")
    elseif (globals.xmode == "victim") and (arg.room ~= actor.room) then
        actor:send("You must be in the same room as " .. tostring(arg.name) .. "!")
    elseif (globals.xmode == "victim") and (arg.level > 99) then
        actor:send("You cannot x-cast at immortals!")
    else
        local notarg
        local spell_stop
        local damage
        if globals.xmode ~= "victim" then
            notarg = 1
        end
        -- Begin casting messages
        if globals.xmode == "victim" then
            arg:send(tostring(actor.name) .. " starts casting <b:yellow>'" .. tostring(globals.xname) .. "'</> at <b:red>You</>!!!...")
            self.room:send_except(arg, tostring(actor.name) .. " starts casting <b:yellow>'" .. tostring(globals.xname) .. "'</>...")
            actor:send("You start casting <b:yellow>'" .. tostring(globals.xname) .. "'</>...")
        elseif globals.xmode == "self" then
            self.room:send_except(actor, tostring(actor.name) .. " starts casting <b:yellow>'" .. tostring(globals.xname) .. "'</>...")
        end
        actor:send("You start chanting...")
        wait(2)
        -- Imitate casting stars
        local stars = globals.xstars
        while stars > 0 do
            if notarg or (arg.room == actor.room) then
                actor:send(tostring(stars) .. " remaining on " .. tostring(globals.xname))
                wait(2)
                stars = stars - 1
            else
                spell_stop = 1
                stars = 0
            end
        end
        -- If player is still here, make with the magic
        if spell_stop ~= 1 then
            if notarg or (arg.room == actor.room) then
                if globals.xmode == "victim" then
                    arg:send(tostring(actor.name) .. " stares at you and utters the words, '" .. tostring(globals.xmagic) .. "'.")
                    self.room:send_except(arg, tostring(actor.name) .. " closes " .. tostring(actor.possessive) .. " eyes and utters the words, '" .. tostring(globals.xmagic) .. "'.")
                elseif globals.xmode == "self" then
                    self.room:send_except(actor, tostring(actor.name) .. " closes " .. tostring(actor.possessive) .. " eyes and utters the words, '" .. tostring(globals.xmagic) .. "'.")
                end
                actor:send("You complete your spell.")
                if globals.xeffect == "damage" then
                    damage = globals.xamount + random(1, 50)
                end
                -- Show the message
                if globals.xid == 1 then
                    self.room:send_except(actor, "<yellow>" .. tostring(actor.name) .. " lets out a <red>soul-rending<yellow> screech</>!")
                    actor:send("<yellow>You let out shattering screech!</>")
                elseif globals.xid == 2 then
                    self.room:send_except(actor, "<b:white>" .. tostring(actor.name) .. " waves a taloned paw, bring down a </><cyan>bli<blue>zz</><cyan>ard<b:white> of snow!</>")
                    actor:send("<b:white>You wave a taloned paw at the room, bringing down a </><cyan>bli<blue>zz</><cyan>ard<b:white> of snow!</>")
                elseif globals.xid == 3 then
                    self.room:send_except(actor, "<b:white>" .. tostring(actor.name) .. " looks much healthier than before!</>")
                    actor:send("<b:white>You feel MUCH healthier than before!</>")
                elseif globals.xid == 4 then
                    self.room:send_except(arg, tostring(actor.name) .. " waves a hand at " .. tostring(arg.name) .. ", whisking " .. tostring(arg.object) .. " away!")
                    actor:send("You wave a hand at " .. tostring(arg.name) .. ", whisking " .. tostring(arg.object) .. " away!")
                elseif globals.xid == 5 then
                    self.room:send_except(actor, "<b:white>" .. tostring(actor.name) .. " speaks a holy word of sanctification!</>")
                    actor:send("<b:white>You speak a holy word of sanctification!</>")
                elseif globals.xid == 6 then
                    arg:send("<b:black>" .. tostring(actor.name) .. " chants an arcane word at you, locking you in an iron maiden!</>")
                    self.room:send_except(arg, "<b:black>" .. tostring(actor.name) .. " chants an arcane word at " .. tostring(arg.name) .. ", locking " .. tostring(arg.object) .. " in an iron maiden!</>")
                    actor:send("<b:black>You chant an arcane word at " .. tostring(arg.name) .. ", locking " .. tostring(arg.object) .. " in an iron maiden!</>")
                elseif globals.xid == 7 then
                    self.room:send_except(actor, "<blue>Lightning streaks out from " .. tostring(actor.name) .. "'s body, sizzling through the air.</>")
                    actor:send("<blue>Lightning streaks out from your body, crackling through the air.</>")
                elseif globals.xid == 8 then
                    arg:send(tostring(actor.name) .. " screams a commination at you, causing runes to appear on your skin!  (<b:red>" .. tostring(damage) .. "</>)")
                    self.room:send_except(arg, "Runes appear on " .. tostring(arg.name) .. " as " .. tostring(actor.name) .. " screams an obloquy at " .. tostring(arg.object) .. "!  (<blue>" .. tostring(damage) .. "</>)")
                    actor:send("You scream a curse at " .. tostring(arg.name) .. ", causing runes to appear on " .. tostring(arg.possessive) .. " skin! (<yellow>" .. tostring(damage) .. "</>)")
                elseif globals.xid == 9 then
                    arg:send(tostring(actor.name) .. " flings a ball of caustic acid at you, burning your flesh. (<b:red>" .. tostring(damage) .. "</>)")
                    self.room:send_except(arg, tostring(actor.name) .. " flings a ball of caustic acid at " .. tostring(arg.name) .. ", burning " .. tostring(actor.possessive) .. " flesh.  (<blue>" .. tostring(damage) .. "</>)")
                    actor:send("You throw a ball of caustic acid at " .. tostring(arg.name) .. ", burning " .. tostring(arg.possessive) .. " flesh. (<yellow>" .. tostring(damage) .. "</>)")
                else
                    self.room:send_except(actor, "X-cast failure.  Nothing happens.")
                    actor:send("Unrecognized xid number.")
                end
                -- Do the deed
                if globals.xeffect == "damage" then
                    local damage_dealt = arg:damage(damage)  -- type: physical
                elseif globals.xeffect == "heal" then
                    actor:heal(globals.xamount)
                end
                if globals.xeffect == "transport" then
                    if globals.xamount == -1 then
                        arg:send(tostring(actor.name) .. " waves a hand at you, whisking you away!")
                        local max_tries = 20
                        while max_tries > 0 do
                            arg:teleport(get_room(math.floor(random(1, 60000 / 100)), (random(1, 60000 % 100))))
                            if arg.room ~= actor.room then
                                max_tries = 0
                            end
                            max_tries = max_tries - 1
                        end
                        -- TODO(parity): legacy used `if not max_tries` to detect "never escaped",
                        -- but the loop now decrements past zero so the original safety net
                        -- is dead code. Decide whether to bail to (0,0) on failure.
                    else
                        arg:teleport(get_room(math.floor(globals.xamount / 100), globals.xamount % 100))
                    end
                    arg:command("look")
                elseif globals.xeffect == "area" then
                    local max_tries = 20
                    local target_list = ""
                    while max_tries > 0 do
                        local victim = self.room.actors[random(1, #self.room.actors)]
                        if victim then
                            if (victim.id ~= actor.id) and not (string.find(target_list, victim.name, 1, true)) then
                                target_list = target_list .. victim.name .. ","
                                damage = globals.xamount + random(1, 50)
                                if globals.xid == 1 then
                                    victim:send("<yellow>The screech pierces into your head, causing great pain!</> (<b:red>" .. tostring(damage) .. "</>)")
                                    self.room:send_except(victim, "<yellow>" .. tostring(victim.name) .. " grasps " .. tostring(victim.possessive) .. " head in pain.</> (<blue>" .. tostring(damage) .. "</>)")
                                    local damage_dealt = victim:damage(damage)  -- type: physical
                                elseif globals.xid == 2 then
                                    victim:send("<cyan>The sudden blizzard <b:white>chills</><cyan> you to the bone!</> (<b:red>" .. tostring(damage) .. "</>)")
                                    self.room:send_except(victim, "<cyan>" .. tostring(victim.name) .. " shivers and turns blue in the blizzard.</> (<blue>" .. tostring(damage) .. "</>)")
                                    local damage_dealt = victim:damage(damage)  -- type: physical
                                elseif (globals.xid == 5) and (victim.alignment <= -350) then
                                    victim:send("<b:white>You cry out in pain upon hearing " .. tostring(actor.name) .. "'s blessing!</> (<b:red>" .. tostring(damage) .. "</>)")
                                    self.room:send_except(victim, "<b:white>" .. tostring(victim.name) .. " grasps " .. tostring(victim.possessive) .. " head upon hearing " .. tostring(actor.name) .. "'s blessing!</> (<blue>" .. tostring(damage) .. "</>)")
                                    local damage_dealt = victim:damage(damage)  -- type: physical
                                elseif globals.xid == 7 then
                                    victim:send("<blue>The lightning strikes you in the chest, shocking your body!</> (<b:red>" .. tostring(damage) .. "</>)")
                                    self.room:send_except(victim, "<blue>" .. tostring(victim.name) .. " reels back, struck in the chest by the lightning!</> (<blue>" .. tostring(damage) .. "</>)")
                                    local damage_dealt = victim:damage(damage)  -- type: physical
                                end
                            end
                        else
                            max_tries = 0
                        end
                        max_tries = max_tries - 1
                    end
                end
            else
                spell_stop = 1
            end
        end
        -- If the player left somewhere along the way, fail spell
        if spell_stop == 1 then
            actor:send("You stop invoking abruptly!")
            self.room:send_except(actor, tostring(actor.name) .. " stops invoking abruptly!")
        end
    end
else
    -- Do nothing for non-dragonquest mobs
    _return_value = true
end
return _return_value$trig$, 'f084d504cf699bb9175f951140e22585'),
  -- data/triggers/481/481_153_mccabe_greet.lua
  (481, 153, $trig$-- Converted from DG Script #48253: mccabe greet
-- Original: MOB trigger, flags: GREET, probability: 100%
local stage = actor:get_quest_stage("meteorswarm")
wait(1)
-- No one should be here but sorcs and pyros, so let's throw the rest back out
-- DG %type%_wand: the questmaster's LOAD trigger (002_111) stores the element in globals.type
local wand_quest = (globals.type or "type") .. "_wand"
if actor.class ~= "sorcerer" and actor.class ~= "pyromancer" and actor:get_quest_stage(wand_quest) < (globals.wandstep or 999) then
    self:command("con " .. tostring(actor))
    wait(2)
    self:say("What are you doing here?! Get out!")
    wait(1)
    self.room:send_except(actor, "<b:blue>" .. tostring(self.name) .. " </><cyan> sends a blast of air at <b:black>" .. tostring(actor.name) .. "<cyan> sending them<blue> tumbling!</>")
    actor:send("<b:blue>" .. tostring(self.name) .. " </><cyan> sends a blast of air at <b:red>YOU<cyan> sending you<blue> tumbling!</>")
    actor:teleport(get_room(481, 154))
    actor:send("<b:blue>" .. tostring(self.name) .. "'s </><cyan>blast of air sends you<blue> tumbling!</>")
    actor:teleport(get_room(481, 153))
    actor:send("<b:blue>" .. tostring(self.name) .. "'s </><cyan>blast of air sends you<blue> tumbling!</>")
    actor:teleport(get_room(481, 152))
    actor:send("<b:blue>" .. tostring(self.name) .. "'s </><cyan>blast of air comes at you from a new angle, sending you<blue> tumbling!</>")
    actor:teleport(get_room(481, 151))
    local damage = (actor.level * 2) + random(1, 30)
    local damage_dealt = actor:damage(damage)  -- type: fire
    actor:send("<b:red>You sustain </><red>severe burns<blue> as you plunge head first through drizzling </><red>lava.</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
elseif (string.find(actor.class, "sorcerer") and actor.level > 72) or (string.find(actor.class, "pyromancer") and actor.level > 80) or actor:get_quest_stage(wand_quest) == globals.wandstep then
    local minlevel = ((globals.wandstep or 1) - 1) * 10
    if (string.find(actor.class, "sorcerer") and actor.level > 72) or (string.find(actor.class, "pyromancer") and actor.level > 80) then
        if actor:get_quest_var("meteorswarm:new") ~= "no" then
            actor:send(tostring(self.name) .. " tells you, 'Do you have the new meteorite?'")
        elseif (stage or 0) == 0 then
            self.room:spawn_mobile(481, 151)
            self:command("peer seagull")
            self:emote("focuses closely on the seagull flying overhead.")
            self.room:send(tostring(self.name) .. " starts casting '<b:yellow>meteorswarm</>' at an unsuspecting seagull.")
            wait(1)
            run_room_trigger(481, 157)
            self.room:find_actor("seagull"):command("panic")
            self.room:find_actor("seagull"):emote("panics and flees to the north.")
            world.destroy(self.room:find_actor("seagull"))
            wait(2)
            self:command("giggle")
            wait(5)
            actor:send(tostring(self.name) .. " tells you, 'I see you admire my conjuring.  Perhaps you've never seen anyone calling <b:cyan>meteors</>?'")
        elseif stage == 1 then
            actor:send(tostring(self.name) .. " tells you, 'Have you spoken to Jemnon?  He's in some tavern, no doubt, waiting for some new blunder to embark on.'")
        elseif stage == 2 then
            actor:send(tostring(self.name) .. " tells you, 'Well, did Jemnon tell you where the rock demon is?'")
        elseif stage == 3 then
            actor:send(tostring(self.name) .. " tells you, 'Have you found a suitable focus?'")
        elseif stage == 4 then
            actor:send(tostring(self.name) .. " tells you, 'I can see from the singe marks you accomplished your task!  Are you ready to press on?'")
        elseif stage == 5 then
            actor:send(tostring(self.name) .. " tells you, 'Were you able to glean something from Dargentan's teachings?'")
        end
        if actor:get_quest_stage(wand_quest) == globals.wandstep then
            if actor.level >= minlevel then
                if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
                    actor:send(tostring(self.name) .. " tells you, 'Or is there even MORE you want from me?  You seem to be in need of a crafting <b:cyan>[upgrade]</>.'")
                else
                    actor:send(tostring(self.name) .. " says, 'Do you have what I need for the " .. tostring(globals.weapon) .. "?'")
                end
            end
        end
    else
        if actor.level >= minlevel then
            if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
                actor:send(tostring(self.name) .. " tells you, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
            else
                actor:send(tostring(self.name) .. " tells you, 'Do you have what I need for the " .. tostring(globals.weapon) .. "?'")
            end
        end
    end
end$trig$, 'c2fdb06d9b20a626b37254f0d40dc37f'),
  -- data/triggers/481/481_24_vulcera_greet1.lua
  (481, 24, $trig$-- Converted from DG Script #48124: vulcera_greet1
-- Original: MOB trigger, flags: GREET, GREET_ALL, probability: 100%
-- DG %type%_wand: the questmaster's LOAD trigger (002_111) stores the element in globals.type
local wand_quest = (globals.type or "type") .. "_wand"
wait(0.6)
self:command("peer " .. tostring(actor.name))
self:say("So puny one, you dare to disturb me?")
local stage = 7
local person = actor
local i = person.group_size
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage(wand_quest) == globals.wandstep then
            if person.level >= 60 then
                if (person:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
                    wait(0.2)
                    self:say("What do you want pathetic mortal?")
                else
                    self:say("Do you have what I require for the " .. tostring(globals.weapon) .. "?")
                end
            end
        end
        if person:get_quest_stage("fieryisle_quest") == stage then
            person:advance_quest("fieryisle_quest")
            person:send("<b:white>You have advanced your quest!</>")
            if person:has_item(481, 16) then
                wait(0.2)
                self:emote("does a double take at " .. tostring(person.name) .. ".")
                self:say("Are you the one who has the key to the ivory chest?!")
                wait(1)
                self:command("bow " .. tostring(person.name))
                self:say("If so you could end my punishment, I would make it worth your while.")
                wait(2)
                self:emote("mutters a brief incantation and a cloak of flames appears.")
                person:send("<b:white>Group credit will not be awarded for the next step.</>")
            end
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end$trig$, '7d9269fdcb2c4728eb0a0b18bdd1eeda'),
  -- data/triggers/484/484_04_lord-realm-spawn.lua
  (484, 4, $trig$-- Converted from DG Script #48404: lord-realm-spawn
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
-- This is for room 47658: The Heart of the Realm.
-- DG global `lord_loaded`, shared with 484_06 (same room)
if not globals.lord_loaded then
    globals.lord_loaded = 1
    wait(1)
    self.room:send("Before your eyes, a nondescript boulder molds itself into the image of a man of gigantic proportions.")
    self.room:spawn_mobile(484, 6)
    wait(1)
    self.room:send("When the transformation is complete, the elemental flexes his thick stone fingers fluidly.")
    self.room:find_actor("lord-realm"):spawn_object(484, 2)
    self.room:find_actor("lord-realm"):command("mat 1100 hold staff-justice")
    self.room:find_actor("lord-realm"):shout("It has been long since I have taken this form! Beware--this time I will be the victorious one!")
end$trig$, 'b9b88429a1a565361779fdeeb04ea214'),
  -- data/triggers/484/484_06_lord-dead-unsetting-global.lua
  (484, 6, $trig$-- Converted from DG Script #48406: lord-dead-unsetting-global
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
globals.lord_loaded = 0$trig$, '48a6959df652123f249046be5de197b7'),
  -- data/triggers/484/484_08_lord-realm_fight.lua
  (484, 8, $trig$-- Converted from DG Script #48408: lord-realm fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
-- DG global `has_blur`, set by 484_09 (HIT_PERCENT) on the same mob
if globals.has_blur and globals.has_blur ~= 0 then
    if not (self:has_effect(Effect.Blur)) then
        self:emote("slows as " .. tostring(self.name) .. " returns to normal speed.")
        globals.has_blur = 0
    end
end
local victim = self.room.actors[random(1, #self.room.actors)]
if victim then
    local action = random(1, 10)
    if action > 8 then
        wait(2)
        self.room:send_except(victim, tostring(self.name) .. " swings a rocky fist at " .. tostring(victim.name) .. ", toppling " .. tostring(victim.object) .. "!")
        victim:send(tostring(self.name) .. " swings a rocky fist at you, knocking you over!")
        self:send("You swing a rocky fist at " .. tostring(victim.name) .. ", knocking " .. tostring(victim.object) .. " over!")
        victim:teleport(get_room(11, 0))
        victim:command("recline")
        victim:teleport(self.room)
    elseif action > 7 then
        if victim.is_player then
            combat.engage(self, victim.name)
        end
    end
end$trig$, 'ce00814508f6d76eadb12b8c2f17781a'),
  -- data/triggers/484/484_09_lord-realm_hitprcnt_50.lua
  (484, 9, $trig$-- Converted from DG Script #48409: lord-realm hitprcnt 50
-- Original: MOB trigger, flags: HIT_PERCENT, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
if not (self:has_effect(Effect.Blind)) and not (self:has_effect(Effect.Blur)) then
    wait(2)
    self.room:spawn_object(11, 59)
    get_room(11, 0):at(function()
        -- Fragment (possible truncation): quaff blur
    end)
    self.room:send(tostring(self.name) .. "'s rock formation cracks slightly...")
    self:emote("composes " .. tostring(self.object) .. "self and " .. tostring(self.possessive) .. " quickness seems to increase!")
    globals.has_blur = 1
end$trig$, 'c703f649621c05220189ef3ba83560ef'),
  -- data/triggers/484/484_104_mighty_druid_random_paralysis-wear-off.lua
  (484, 104, $trig$local now = timestamp()  -- game hours, as legacy %time.stamp%
for n = 1, 4 do
    local v = globals["paralysis_victim_" .. n]
    if v and (v.room ~= self.room or (globals["paralysis_expire_" .. n] or 0) <= now) then
        if v.room == self.room then
            self.room:send_except(v, "<green>The crop of roots recedes, releasing " .. tostring(v.name) .. " from its grasp.</>")
            v:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
        else
            self.room:send("<green>The crop of roots recedes, releasing " .. tostring(v.name) .. " from its grasp.</>")
        end
        globals["paralysis_victim_" .. n] = nil
    end
end$trig$, '7e1ffe633770648602b73df97a0f26a1'),
  -- data/triggers/484/484_105_mighty_druid_entanglement.lua
  (484, 105, $trig$local now = timestamp()  -- game hours, as legacy %time.stamp%
for n = 1, 4 do
    local v = globals["paralysis_victim_" .. n]
    if v and (v.room ~= self.room or (globals["paralysis_expire_" .. n] or 0) <= now) then
        -- Clear paralysis on expired victim
        if v.room == self.room then
            self.room:send_except(v, "<green>The crop of roots recedes, releasing " .. tostring(v.name) .. " from its grasp.</>")
            v:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
        else
            self.room:send("<green>The crop of roots recedes, releasing " .. tostring(v.name) .. " from its grasp.</>")
        end
        globals["paralysis_victim_" .. n] = nil
    end
end
-- 25% chance to do creeping doom proc
if random(1, 4) == 1 then
    wait(2)
    run_room_trigger(484, 103)
    return
end
-- 75% chance to attempt to entangle: use the first free slot; the more slots are taken, the
-- lower the chance (50%, 33%, 25%, 20%); quit if all four are taken.
local slot = 1
while slot <= 4 and globals["paralysis_victim_" .. slot] do
    slot = slot + 1
end
if slot > 4 then
    return
end
if random(1, 2 * slot + 2) > 3 then
    return
end

local function entangled(person)
    for n = 1, 4 do
        local v = globals["paralysis_victim_" .. n]
        if v and v.name == person.name then
            return true
        end
    end
    return false
end

-- find a victim, preferably an assassin, but settle for any player if no assassin is found
local victim, secondary_victim
local max_tries = 10
while max_tries >= 0 do
    victim = self.room.actors[random(1, #self.room.actors)]
    if victim and victim.is_player then
        if entangled(victim) then
            victim = self
        elseif victim.class == "assassin" then
            max_tries = 0
        else
            secondary_victim = victim
        end
    end
    max_tries = max_tries - 1
end
-- quit if no players
if not (victim and victim.is_player) then
    if secondary_victim then
        victim = secondary_victim
    else
        return
    end
end
wait(2)
self.room:send_except(victim, tostring(self.name) .. " snarls and waves a hand at the ground at " .. tostring(victim.name) .. "'s feet.")
victim:send(tostring(self.name) .. " snarls at you and waves a hand at the ground around your feet!")
self.room:send_except(victim, "<green>A crop of wriggling roots bursts from the ground, entangling " .. tostring(victim.name) .. "!</>")
victim:send("<green>A crop of wriggling roots bursts from the ground, entangling you!</>")
-- declare paralysis message
globals.message = "<green>The roots lock you in place, preventing movement!</>"
-- create a basher to force the player into a bashed stance
if (victim.size == "Small") or (victim.size == "Tiny") then
    -- Basher is medium
    self.room:spawn_mobile(484, 115)
elseif (victim.size == "Large") or (victim.size == "Huge") or (victim.size == "Giant") then
    -- Basher is huge
    self.room:spawn_mobile(484, 113)
else
    -- Basher is large
    self.room:spawn_mobile(484, 114)
end
self.room:find_actor("bashing-roots"):spawn_object(10, 16)
self.room:find_actor("bashing-roots"):command("mat 1100 wear shield")
victim:command("stand")
self.room:find_actor("bashing-roots"):command("bash " .. tostring(victim.name))
self.room:find_actor("bashing-roots"):destroy_item("shield")
world.destroy(self.room:find_actor("bashing-roots"))
-- reinitiate combat if victim was tanking
if actor.name == victim.name then
    wait(2)
    combat.engage(self, victim.name)
end
-- save victim variable
globals["paralysis_victim_" .. slot] = victim
globals["paralysis_expire_" .. slot] = now + 1$trig$, '55e3dc852fa63c1c82afa3aca60e9175'),
  -- data/triggers/484/484_130_paralysis_prevent_quaff.lua
  (484, 130, $trig$-- Converted from DG Script #48530: paralysis_prevent_quaff
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: quaff
if not (cmd == "quaff") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '96afb49ac0c86901f4ebaa245c6e47c4'),
  -- data/triggers/484/484_131_paralysis_prevent_remove.lua
  (484, 131, $trig$-- Converted from DG Script #48531: paralysis_prevent_remove
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: remove
if not (cmd == "remove") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '346cdcdf366294c596eb3d07b3f5cbce'),
  -- data/triggers/484/484_132_paralysis_prevent_wear.lua
  (484, 132, $trig$-- Converted from DG Script #48532: paralysis_prevent_wear
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: wear
if not (cmd == "wear") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '0fcf084a7dfa4be646d371e1b13c7b25'),
  -- data/triggers/484/484_133_paralysis_prevent_wield.lua
  (484, 133, $trig$-- Converted from DG Script #48533: paralysis_prevent_wield
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: qield
if not (cmd == "qield") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '7e7769740a1b302ecb21866fc3759849'),
  -- data/triggers/484/484_134_paralysis_prevent_order.lua
  (484, 134, $trig$-- Converted from DG Script #48534: paralysis_prevent_order
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: order
if not (cmd == "order") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, 'c6696e5212222f5984f6e0f3c20aaa66'),
  -- data/triggers/484/484_135_paralysis_prevent_memorize.lua
  (484, 135, $trig$-- Converted from DG Script #48535: paralysis_prevent_memorize
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: memorize
if not (cmd == "memorize") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '3134082f5281f0a9d13a471bbe48645f'),
  -- data/triggers/484/484_136_paralysis_prevent_pray.lua
  (484, 136, $trig$-- Converted from DG Script #48536: paralysis_prevent_pray
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: pray
if not (cmd == "pray") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '7b2239a446b5f54eefd719dee73c26cb'),
  -- data/triggers/484/484_137_paralysis_prevent_stand.lua
  (484, 137, $trig$-- Converted from DG Script #48537: paralysis_prevent_stand
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: stand
if not (cmd == "stand") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '1f57d3cb6a23dd6159154938a86922f7'),
  -- data/triggers/484/484_138_paralysis_prevent_get.lua
  (484, 138, $trig$-- Converted from DG Script #48538: paralysis_prevent_get
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: get
if not (cmd == "get") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, 'b8785e537541a10e6337834e5b6c2c4b'),
  -- data/triggers/484/484_139_paralysis_prevent_give.lua
  (484, 139, $trig$-- Converted from DG Script #48539: paralysis_prevent_give
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: give
if not (cmd == "give") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, 'cc7ccf150459d434395c26ab2be73ae3'),
  -- data/triggers/484/484_140_paralysis_prevent_put.lua
  (484, 140, $trig$-- Converted from DG Script #48540: paralysis_prevent_put
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: put
if not (cmd == "put") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, 'a2c14109b7b023c04ebdb1bdb2704124'),
  -- data/triggers/484/484_141_paralysis_prevent_recite.lua
  (484, 141, $trig$-- Converted from DG Script #48541: paralysis_prevent_recite
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: recite
if not (cmd == "recite") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '4e52ae56d97f769f2cd8827987a8a74e'),
  -- data/triggers/484/484_142_paralysis_prevent_use.lua
  (484, 142, $trig$-- Converted from DG Script #48542: paralysis_prevent_use
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: use
if not (cmd == "use") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '73a3f9397234dbaf419c6cef39846e89'),
  -- data/triggers/484/484_143_paralysis_prevent_drop.lua
  (484, 143, $trig$-- Converted from DG Script #48543: paralysis_prevent_drop
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: drop
if not (cmd == "drop") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '032690cc7886322032cf0c3d6269ddff'),
  -- data/triggers/484/484_144_unused.lua
  (484, 144, $trig$-- Converted from DG Script #48544: unused
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: west
if not (cmd == "west") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, 'b7a9710eaf7668913ed824991b8ec16b'),
  -- data/triggers/484/484_145_unused.lua
  (484, 145, $trig$-- Converted from DG Script #48545: unused
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: east
if not (cmd == "east") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '2a96192da5f8c6651a5b90c260d90914'),
  -- data/triggers/484/484_146_unused.lua
  (484, 146, $trig$-- Converted from DG Script #48546: unused
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: up
if not (cmd == "up") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, 'cd286caadd18f32d0ca81116077b8f30'),
  -- data/triggers/484/484_147_unused.lua
  (484, 147, $trig$-- Converted from DG Script #48547: unused
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: down
if not (cmd == "down") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, 'd0371ba946e109ae2ed6374f4ad72076'),
  -- data/triggers/484/484_148_unused.lua
  (484, 148, $trig$-- Converted from DG Script #48548: unused
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: order
if not (cmd == "order") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '056b5795e3ce65f56fe2384a593906da'),
  -- data/triggers/484/484_149_unused.lua
  (484, 149, $trig$-- Converted from DG Script #48549: unused
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: rescue
if not (cmd == "rescue") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '178f85b0bfb5c4af32ed3e63b597e551'),
  -- data/triggers/484/484_151_unused.lua
  (484, 151, $trig$-- Converted from DG Script #48551: unused
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: memorize
if not (cmd == "memorize") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '82a393ba5ced8dd032ef1a85b7421849'),
  -- data/triggers/484/484_152_unused.lua
  (484, 152, $trig$-- Converted from DG Script #48552: unused
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: pray
if not (cmd == "pray") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, 'de8157ae6e21db2fa3a37c0733bac024'),
  -- data/triggers/484/484_153_unused.lua
  (484, 153, $trig$-- Converted from DG Script #48553: unused
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: steal
if not (cmd == "steal") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '8a7cdf6d12ab82bd5021c9854c2a51ab'),
  -- data/triggers/484/484_154_unused.lua
  (484, 154, $trig$-- Converted from DG Script #48554: unused
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: mount
if not (cmd == "mount") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '5240c1236c2059d40818a22edc87e808'),
  -- data/triggers/484/484_155_unused.lua
  (484, 155, $trig$-- Converted from DG Script #48555: unused
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: enter
if not (cmd == "enter") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '1308ddaacfb2c110c9942aed3be34860'),
  -- data/triggers/484/484_156_unused.lua
  (484, 156, $trig$-- Converted from DG Script #48556: unused
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: summon
if not (cmd == "summon") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, 'c3ca55c38e847ebd9116b2eb0abc60a1'),
  -- data/triggers/484/484_157_unused.lua
  (484, 157, $trig$-- Converted from DG Script #48557: unused
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: disarm
if not (cmd == "disarm") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '3447bc5f682bc5613178dc7c7d962529'),
  -- data/triggers/484/484_158_unused.lua
  (484, 158, $trig$-- Converted from DG Script #48558: unused
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: guard
if not (cmd == "guard") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, 'ff1b85e5f7f6ee23dcbacfc0a09b44bc'),
  -- data/triggers/484/484_159_unused.lua
  (484, 159, $trig$-- Converted from DG Script #48559: unused
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: track
if not (cmd == "track") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '8b47dc6288b698fc79e8d9bdcc56b9a0'),
  -- data/triggers/484/484_160_unused.lua
  (484, 160, $trig$-- Converted from DG Script #48560: unused
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: leave
if not (cmd == "leave") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, 'de183ce8e69cdf38aa47702b1978191d'),
  -- data/triggers/484/484_161_unused.lua
  (484, 161, $trig$-- Converted from DG Script #48561: unused
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: hide
if not (cmd == "hide") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '50e2dfe5ff0d3248706bd6245be92b96'),
  -- data/triggers/484/484_162_unused.lua
  (484, 162, $trig$-- Converted from DG Script #48562: unused
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: throatcut
if not (cmd == "throatcut") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, 'f55f49a8b4259c447987718486886172'),
  -- data/triggers/484/484_163_unused.lua
  (484, 163, $trig$-- Converted from DG Script #48563: unused
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: stand
if not (cmd == "stand") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '8f6b1395635734ae78d88d465de6c743'),
  -- data/triggers/484/484_164_unused.lua
  (484, 164, $trig$-- Converted from DG Script #48564: unused
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: alert
if not (cmd == "alert") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local block
if globals.paralysis_victim_1 and (globals.paralysis_victim_1.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_2 and (globals.paralysis_victim_2.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_3 and (globals.paralysis_victim_3.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_4 and (globals.paralysis_victim_4.name == actor.name) then
    block = 1
elseif globals.paralysis_victim_5 and (globals.paralysis_victim_5.name == actor.name) then
    block = 1
end
if block then
    _return_value = false
    if globals.message then
        actor:send(tostring(globals.message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = true
end
return _return_value$trig$, '672a726d2ffd3001cc377fd7b3f1f777'),
  -- data/triggers/502/502_04_diplomat_quest_ranger_receiving_things.lua
  (502, 4, $trig$-- Converted from DG Script #50204: Diplomat quest: ranger receiving things
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- TODO: actor.id and object.id are now "zone:local" strings, so the
-- numeric equality checks (50218, 50201, 50209) never match. The intent
-- appears to be: when given a diplomat-token (legacy 50218 -> 502:18),
-- record which mob delivered it (legacy 50201/50209 -> 502:1 / 502:9)
-- via globals.mdiplomat, then consume the token. Rewrite using
-- `actor.zone_id`/`actor.local_id` and `object.zone_id`/`object.local_id`
-- once the intended composite IDs are confirmed; the local `mdiplomat`
-- assignments below are dead (block-scoped, never read).
local actor_id = actor.id
wait(0.1)
if (object.zone_id == 502 and object.id == 18) then
    wait(0.1)
    if (actor.zone_id == 502 and actor_id == 1) then
        local mdiplomat = 1
        globals.mdiplomat = mdiplomat
    elseif (actor.zone_id == 502 and actor_id == 9) then
        local mdiplomat = 0
        globals.mdiplomat = mdiplomat
    end
    self:destroy_item("diplomat-token")
end$trig$, '2db276b71b55838ff50be1c8bb4394c9'),
  -- data/triggers/510/510_00_pawn_shop_nordus.lua
  (510, 0, $trig$local speech_lower = string.lower(speech or "")

-- Speech phrase: floor phrase is (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech or "") .. " "
if not string.find(speech_padded, "[%s%p]floor phrase is[%s%p]") then
    return true  -- Not the phrase
end

-- Switch on the global `chosen` index (set when the player entered the
-- room — see 510_02). Each case demands a specific phrase.
local flagit = 0
if globals.chosen == 1 and speech_lower == "floor phrase is open sesame" then
    flagit = 1
elseif globals.chosen == 2 and speech_lower == "floor phrase is eingang bitte" then
    flagit = 1
elseif globals.chosen == 3 and speech_lower == "floor phrase is traverser dedans" then
    flagit = 1
elseif globals.chosen == 4 and speech_lower == "floor phrase is let me in dorkus" then
    flagit = 1
end

if flagit == 1 then
    -- TODO(parity): Lua runtime does not yet expose dynamic exit/door
    -- mutation (no `room:exit(dir):set_state{...}` / `:set_destination`).
    -- The intent is to temporarily reveal the down exit from room
    -- (510, 30) to (510, 75) for ~7 seconds, then reseal it. Restore
    -- when the door API lands.
    self.room:send("The ground begins to rumble and the dirt begins to part.")
    wait(7)
    self.room:send("The ground again begins to tremble as the passageway dissolves.")
    wait(5)
    self.room:send("The floor returns to normal without a trace of the secret it holds.")
end$trig$, '3ac3aed9718636eb62f48a6fbbb4ad52'),
  -- data/triggers/510/510_01_maze_room_one.lua
  (510, 1, $trig$-- TODO(parity): The Lua runtime does not yet expose dynamic exit/door
-- mutation (no `room:exit(dir):set_destination(room)` /
-- `:set_state{hidden = ..., description = ...}`). The original intent:
--   1. Hide all six compass exits.
--   2. Pick `exitsreq` = random(1, 6) and randomly assign that many
--      directions to a random destination in (510, 71..76), each with
--      description "The entrance wavers slightly as you look at it."
--   3. With 30% probability also set `up` to (510, 77) with description
--      "This doorway looks more solid than the others." (the maze exit).
--   4. After 1 tick, clear the `exitdone` global so the next group
--      passing through re-rolls.
-- Restore the body below when the door-mutation API lands.

if globals.exitdone == 1 then
    return true
end
globals.exitdone = 1

-- Placeholder: keep the gate so we don't busy-loop, but the maze
-- shuffle itself is a no-op until the door API exists.
wait(1)
globals.exitdone = nil$trig$, 'e275f1dd3113cabe0ba773911b34f80c'),
  -- data/triggers/510/510_02_set_encrytped_phrase.lua
  (510, 2, $trig$if globals.running == "yes" then
    return true
end
globals.running = "yes"
globals.chosen = random(1, 4)

local descr
    do
        local _sw1 = string.lower(tostring(globals.chosen or ""))
        if tonumber(_sw1) == 1 then
            descr = "PLTWK ZHWIL OIXWI ONXML KMJ"
        elseif tonumber(_sw1) == 2 then
            descr = "PLTWK ZHWIL OIXMB XGFVZ LIYBX"
        elseif tonumber(_sw1) == 3 then
            descr = "PLTWK ZHWIL OIXBK KVJZL ORIMW KNX"
        elseif tonumber(_sw1) == 4 then
            descr = "PLTWK ZHWIL OIXTX DMJQG NOWSN C"
        end
    end

-- TODO(parity): The Lua runtime does not yet expose
-- `room:exit(dir):set_state{description = ...}`. Original intent: write
-- `descr` (the ciphertext) into the `n` exit description of (510, 30)
-- so players reading the description can decode it and speak the
-- plaintext at room (510, 0). Restore when the door API lands.
local _ = descr  -- keep `descr` referenced until the door API is wired.

    wait(2)
    globals.running = nil$trig$, 'a622ce904abe7019c0b3e289cae72024'),
  -- data/triggers/510/510_03_luchiaans_greeting.lua
  (510, 3, $trig$local magequest = globals.magequest or 0
local clericquest = globals.clericquest or 0
if actor.is_player and actor.level < 100 then
    if (string.find(actor.class, "necromancer") or string.find(actor.class, "sorcerer")) and magequest < 2 then
        wait(0.5)
        self:command("ponder")
        wait(2)
        self.room:send_except(actor, "Luchiaans leans close to " .. tostring(actor.name) .. ".")
        self:whisper(actor.name, "You and I could be partners in this, if you want? I could use an extra pair of hands.")
    end
    if string.find(actor.class, "warrior") then
        wait(0.5)
        self:command("ponder")
        wait(2)
        self:command("poke " .. tostring(actor.name))
        self:say("Hmm... not bad stock for my experiments.  I may save your corpse.")
        self:emote("grins diabolically.")
        self:command("cackle")
    end
    if (string.find(actor.class, "cleric") or string.find(actor.class, "priest")) and clericquest < 2 then
        wait(0.5)
        self:command("ponder")
        wait(2)
        self.room:send_except(actor, "Luchiaans leans close to " .. tostring(actor.name) .. ".")
        self:whisper(actor.name, "Can you teach me some of your healing spells?")
        self:whisper(actor.name, "I may have a need for the theory of regeneration.")
    end
end$trig$, '34bda78c3dd06edf13aca025cf6fc599'),
  -- data/triggers/510/510_04_only_clerics_enter.lua
  (510, 4, $trig$if actor.level >= 100 then
    return true
end

if string.find(actor.class, "cleric") or string.find(actor.class, "priest") then
    actor:send("You feel a calmness come over you, as if the troubles of the world are washed away.")
    globals.entry = (globals.entry or 0) + 1
    return true
else
    actor:send("You can't seem to enter the room!  It is like stepping against a solid wall,")
    actor:send("</>but you can see in.")
    actor:send("You seem to hear a voice whisper, 'This room is not for you.'")
    return false
end$trig$, '5977f27c9495537fae13987ea118fd28'),
  -- data/triggers/510/510_05_want_to_help_luchiaans.lua
  (510, 5, $trig$-- Speech keywords: partners, teach
local speech_lower = string.lower(speech or "")
local asked_partners = string.find(speech_lower, "partners") ~= nil
local asked_teach = string.find(speech_lower, "teach") ~= nil
if not (asked_partners or asked_teach) then
    return true
end

if not actor.is_player then
    return true
end

local class
if string.find(actor.class, "cleric") or string.find(actor.class, "priest") then
    class = "C"
elseif string.find(actor.class, "necromancer") or string.find(actor.class, "sorcerer") then
    class = "S"
end

local clericquest = globals.clericquest or 0
local magequest = globals.magequest or 0

if asked_teach then
    if class ~= "C" then
        self:command("laugh " .. tostring(actor.name))
        self:say("I have nothing to learn from you, " .. tostring(actor.name) .. " you upstart!")
    elseif clericquest == 3 then
        self:say("Thanks, but I don't need any more cleric books.")
    else
        self:say("Yes, well, not exactly teach, there is a book of cleric spells in the town, but only a cleric can get it.")
        self:command("chuckle")
        self:say("If you bring it to me I will reward you.")
        if clericquest ~= 2 then
            globals.clericquest = 1
        end
    end
else
    if class ~= "S" then
        self:command("pat " .. tostring(actor.name))
        self:say("No way would I want to be partners with anyone but a sorceror.")
    elseif actor.level < 30 then
        self:say("Sorry, " .. tostring(actor.name) .. ".  I think you are a bit puny to be my partner at the moment.")
    elseif magequest == 2 then
        self:say("Sorry, I've already got everything I need in order to start building up my zombie army.")
    else
        self:command("smile")
        self:say("Great, " .. tostring(actor.name) .. ".")
        self:say("Let's get this relationship off to a flying start - bring me a phoenix heart.")
        self:say("I need it for my regeneration potions.")
        self:emote("rubs his hands together in glee.")
        self:say("I think Rana Theroxa has a pet phoenix somewhere near the council chambers.")
        globals.magequest = 1
    end
end$trig$, 'cdc7d04482b21a0440315e4469eda099'),
  -- data/triggers/510/510_07_open_display_case.lua
  (510, 7, $trig$-- Speech phrase: amehs (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech or "") .. " "
if not string.find(speech_padded, "[%s%p]amehs[%s%p]") then
    return true  -- Not the phrase
end

if globals.got_book == 1 then
    actor:send("You marvel at the resonant tones of your voice, perhaps you should be an actor.")
    return true
end

self.room:send("The display case folds and collapses to the floor.")
local case = self.room:find_object("display-case")
if case then
    world.destroy(case)
end
self.room:spawn_object(510, 22)
-- Stash a spare display case in the holding area so a future reset
-- has one to drop here.
get_room(510, 99):spawn_object(510, 21)
globals.got_book = 1$trig$, '4a9c95c5987e67f9c179e1c177c43846'),
  -- data/triggers/510/510_09_guardian_of_book.lua
  (510, 9, $trig$if globals.alreadyrun == 1 then
    return true
end
if actor.room.zone_id ~= 510 then
    return true
end

actor.room:spawn_mobile(510, 25)
local guardian = actor.room:find_actor("guardian")
if guardian then
    guardian:say("You are not worthy to handle the book of Nordus!")
    guardian:command("hit " .. tostring(actor.name))
end
globals.alreadyrun = 1$trig$, 'e12b542f340e2b9ab5b59bc907c15b3e'),
  -- data/triggers/510/510_11_give_to_luchiaans.lua
  (510, 11, $trig$local clericquest = globals.clericquest or 0
local magequest = globals.magequest or 0
local zone = object.zone_id
local id = object.id

if zone == 510 and id == 22 then
    -- Damaged book - more work to do.
    wait(0.5)
    self:say("Hmm...a damaged spellbook.")
    wait(2)
    self:say("Look, " .. tostring(actor.name) .. ", why don't you fix this then maybe we can talk.")
    globals.clericquest = 2
    return true
elseif zone == 510 and id == 23 then
    -- Completed spellbook - reward depends on whether they did it solo.
    wait(0.5)
    self:command("grin")
    self:say(tostring(actor.name) .. ", you've done me proud.")
    self:say("Although I guess you haven't really done any favours for the rest of the world!")
    self:command("cackle")
    local book = self.room:find_object("book-of-healing")
    if book then
        world.destroy(book)
    end
    if clericquest == 1 then
        self:say("And you did it all on your own initiative!  Well, here's a gift you can use.")
        self.room:spawn_object(510, 24)
        self:command("give wand " .. tostring(actor.name))
    elseif clericquest == 2 then
        self:say("Even though I had to help you, you did succeed, so here is a small reward.")
        self.room:spawn_object(510, 25)
        self:command("give wand " .. tostring(actor.name))
    else
        self:say("Best of all, I didn't even ask you to do this, so I don't owe you anything.")
        self:command("cackle")
    end
    globals.clericquest = 3
    return true
elseif zone == 510 and id == 28 then
    -- Phoenix heart.
    wait(0.5)
    self:say("Thanks, " .. tostring(actor.name) .. ".")
    self:say("Now I can generate an army of undead, unkillable zombies to help in my plans.")
    self:command("cackle")
    local heart = self.room:find_object("phoenix-heart")
    if heart then
        world.destroy(heart)
    end
    if magequest == 1 then
        self:say("Oh... about that partner thing.  You know I was joking right?")
        self:emote("looks a bit sheepish.")
        self:say("Well... here's a token of my thanks, but that's all you're getting.")
        self.room:spawn_object(510, 29)
        self:command("give green " .. tostring(actor.name))
        globals.magequest = 2
    else
        self:say("It was very generous of you to give this when I didn't ask for it!")
        self:command("grin")
    end
    return true
elseif zone == 85 and id == 50 then
    -- Generic gate item - silently accept and stop.
    return true
else
    -- Unrecognized gift - return it.
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    wait(0.8)
    self:say("What am I supposed to do with this?")
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
    return false
end$trig$, 'a563b5e4c92d0413107a6a89874ca55f'),
  -- data/triggers/510/510_14_get_heart_of_phoenix.lua
  (510, 14, $trig$local already_got = globals.already_got or 0
if already_got == 1 then
    return true
end

local allowed
if actor:has_equipped(510, 26) then
    actor:send("The corpse is extremely hot and may combust soon!")
    actor:award_exp(30000)
    globals.already_got = 1
    allowed = true
else
    actor:send("The corpse is too hot to touch without special protection!")
    allowed = false
end

wait(2)
self.room:send("The corpse suddenly crumbles to ash.")
return allowed$trig$, '47ae17a6089d8a32e4e7f9e5af88e1a8'),
  -- data/triggers/557/557_00_phase_armor_-_greet.lua
  (557, 0, $trig$-- Converted from DG Script #55700: Phase Armor - Greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
-- DG globals set on this mob by its init (LOAD) trigger, 557:10-39
local classes = self:getvar("classes")
local phase = self:getvar("phase")
if classes == nil or phase == nil then
    return true  -- the init trigger has not run for this mob
end
local _return_value = true  -- Default: allow action
wait(0.2)
local anti = "Anti-Paladin"
if not actor or not actor.can_be_seen then
    _return_value = true
else
    if actor.level <= (20 * (phase - 1)) then
        _return_value = true
    elseif not string.find(string.lower(classes), actor.class, 1, true) or (classes == anti and actor.class == "paladin") then
        _return_value = true
    elseif actor:get_quest_stage("phase_armor") == (phase - 1) then
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, 'Welcome, would you like to do some armor quests?  If so, just ask me about them.'")
    end
end
if string.find(self.class, "necromancer") then
    if actor:get_quest_stage("shift_corpse") > 0 then
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'May Death guide your hunt for Lokari.'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'If you need a new crystal, msend " .. tostring(actor) .. " " .. tostring(self.name) .. " says, <b:black>\"I need a new crystal\"</>.'")
    end
elseif string.find(self.class, "pyromancer") then
    if actor:get_quest_stage("supernova") == 2 and (actor:has_item(489, 17) or actor:has_equipped(489, 17)) then
        actor:advance_quest("supernova")
        local step3, step4, step5, step6
        local rnd1 = random(1, 3)
        do
            local _sw1 = string.lower(tostring(rnd1 or ""))
            if tonumber(_sw1) == 1 then
                step3 = 4318
            elseif tonumber(_sw1) == 2 then
                step3 = 10316
            elseif tonumber(_sw1) == 3 then
                step3 = 58062
            end
        end
        actor:set_quest_var("supernova", "step3", step3)
        local rnd2 = random(1, 3)
        do
            local _sw2 = string.lower(tostring(rnd2 or ""))
            if tonumber(_sw2) == 1 then
                step4 = 18577
            elseif tonumber(_sw2) == 2 then
                step4 = 17277
            elseif tonumber(_sw2) == 3 then
                step4 = 8561
            end
        end
        actor:set_quest_var("supernova", "step4", step4)
        local rnd3 = random(1, 3)
        do
            local _sw3 = string.lower(tostring(rnd3 or ""))
            if tonumber(_sw3) == 1 then
                step5 = 53219
            elseif tonumber(_sw3) == 2 then
                step5 = 47343
            elseif tonumber(_sw3) == 3 then
                step5 = 16278
            end
        end
        actor:set_quest_var("supernova", "step5", step5)
        local rnd4 = random(1, 3)
        do
            local _sw4 = string.lower(tostring(rnd4 or ""))
            if tonumber(_sw4) == 1 then
                step6 = 58657
            elseif tonumber(_sw4) == 2 then
                step6 = 35119
            elseif tonumber(_sw4) == 3 then
                step6 = 55422
            end
        end
        actor:set_quest_var("supernova", "step6", step6)
        local step7 = random(1, 3)
        actor:set_quest_var("supernova", "step7", step7)
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'Ah I see you found one of Phayla's lamps!'")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Phayla likes to visit the material plane to engage in her favorite leisure activities.'")
        wait(2)
        local clue = actor:get_quest_var("supernova:step3")
        -- switch on clue
        do
            local _sw5 = string.lower(tostring(clue or ""))
            if tonumber(_sw5) == 4318 then
                actor:send(tostring(self.name) .. " says, 'Recently, she was spotted in Anduin, taking in a show from the best seat in the house.'")
            elseif tonumber(_sw5) == 10316 then
                actor:send(tostring(self.name) .. " says, 'I understand she frequents the hottest spring at the popular resort up north.'")
            elseif tonumber(_sw5) == 58062 then
                actor:send(tostring(self.name) .. " says, 'She occasionally visits a small remote island theatre, where she enjoys meditating in their reflecting room.'")
            end
        end
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You may be able to find a clue to her whereabouts there.'")
    end
elseif (self.class == "cleric" or self.class == "priest" or self.class == "diabolist") and globals.macestep then
    if actor:get_quest_stage("phase_mace") == globals.macestep then
        local minlevel = globals.macestep * 10
        if actor.level >= minlevel then
            wait(0.2)
            if (actor:get_quest_var("phase_mace:greet") or 0) == 0 then
                actor:send(tostring(self.name) .. " says, 'I sense a ghostly presence about your weapons.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I need for the mace?'")
            end
        end
    end
end
-- TODO(parity): converter mashed two conditions together. Original
-- DG gated an info dump on the ursa_quest stage AND the speaker
-- being mob (60, 7). Restored that conservative reading via
-- self.zone_id / self.local_id; verify against legacy.
if actor:get_quest_stage("ursa_quest") > 0 and self.zone_id == 60 and self.local_id == 7 then
    wait(1)
    actor:send(tostring(self.name) .. " notices the concerned look on your face.")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'So, the merchant has gotten himself in quite a bit of trouble.'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'I know what he must do, but he won't like it.'")
    self:command("chuckle")
    wait(1)
    actor:send(tostring(self.name) .. " dips his quill in a well of blood and scratches out a sinister letter.")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Quickly, take this to him!  Perhaps the Darkness still finds him...  amusing.'")
    -- TODO(parity): verify (625, 10) is the intended (zone, local_id) for the
    -- ursa-quest letter; converter may have left a 5-digit legacy vnum.
    self.room:spawn_object(625, 10)
    self:command("give letter " .. tostring(actor))
end
if actor:get_quest_stage("hell_trident") == 1 and self.zone_id == 60 and self.local_id == 32 then
    if actor.level >= 65 then
        wait(0.2)
        if not actor:get_quest_var("hell_trident:helltask5") then
            if actor:get_has_completed("banish") then
                actor:set_quest_var("hell_trident", "helltask5", 1)
            end
        end
        if not actor:get_quest_var("hell_trident:helltask4") then
            if actor:get_has_completed("hellfire_brimstone") then
                actor:set_quest_var("hell_trident", "helltask4", 1)
            end
        end
        if not actor:get_quest_var("hell_trident:helltask6") then
            if actor:get_quest_stage("vilekka_stew") > 3 then
                actor:set_quest_var("hell_trident", "helltask6", 1)
            end
        end
        if (actor:get_quest_var("hell_trident:greet") or 0) == 0 then
            actor:send(tostring(self.name) .. " says, 'Hmmm, is that a demon's trident I sense on you?  Perhaps you would like some help with <b:cyan>[upgrades]</>.'")
        else
            local job1 = actor:get_quest_var("hell_trident:helltask1")
            local job2 = actor:get_quest_var("hell_trident:helltask2")
            local job3 = actor:get_quest_var("hell_trident:helltask3")
            local job4 = actor:get_quest_var("hell_trident:helltask4")
            local job5 = actor:get_quest_var("hell_trident:helltask5")
            local job6 = actor:get_quest_var("hell_trident:helltask6")
            if job1 and job2 and job3 and job4 and job5 and job6 then
                actor:send(tostring(self.name) .. " says, 'You return with victory in your eyes.  Hand me your trident.'")
            else
                actor:send(tostring(self.name) .. " says, 'Have you met Hell's demands?'")
            end
        end
    end
end
return _return_value$trig$, 'd0fa14606bb4c2907a266feaba2ad039'),
  -- data/triggers/557/557_06_guild_master_refuse.lua
  (557, 6, $trig$-- Converted from DG Script #55706: Guild Master refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Item ids in the DG globals are legacy vnums (zone * 100 + local id).
-- Mace-quest ids: DG globals set on this mob by the mace LOAD trigger (002_118), if it has one.
local vnum = object.zone_id * 100 + object.id
if vnum == globals.maceitem2 or vnum == globals.maceitem3 or vnum == globals.maceitem4 or vnum == globals.maceitem5 or vnum == globals.mace_id then
    return _return_value
end
-- TODO(parity): 55662 / 2334 are 5-digit legacy vnums. Verify intent
-- (likely (556, 62) ghost crystal and (23, 34) hell trident) and
-- switch to (zone_id, local_id) once confirmed.
if (object.zone_id == 556 and object.id == 62) or (object.zone_id == 23 and object.id == 34) then
    return _return_value
end
-- Phase-armor inputs: stored on the mob by its init (LOAD) trigger, 557:10-39.
local wanted = false
for _, key in ipairs({"hands_armor", "hands_gem", "feet_armor", "feet_gem", "wrist_armor", "wrist_gem", "head_armor", "head_gem", "arms_armor", "arms_gem", "legs_armor", "legs_gem", "body_armor", "body_gem"}) do
    if vnum == self:getvar(key) then
        wanted = true
        break
    end
end
if wanted then
    return _return_value
else
    _return_value = true
    wait(0.1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    actor:send(tostring(self.name) .. " returns your item to you.")
end
return _return_value$trig$, '7570bd87bf90b6b379715e9aefc9b620'),
  -- data/triggers/580/580_100_exit_room_58196.lua
  (580, 100, $trig$if direction == "north" then
    if not globals.running then
        globals.running = 1
        wait(1)
        local rnd = self.room.actors[random(1, #self.room.actors)]
        rnd:send("An image of a goddess appears before you for a second - she holds her hands out to you.")
        wait(1)
        rnd:send("The goddess says, 'Speak my name to leave this room, Yajiro was ever the joker...'")
        wait(1)
        rnd:send("The goddess gets enfolded into a large pearl then suddenly she disappears.")
        globals.running = nil
    end
end$trig$, '5e302e18c7b0e5e045bdf151292229ea'),
  -- data/triggers/590/590_18_three_lever_pull.lua
  (590, 18, $trig$-- Command filter: pull
if not (cmd == "pull") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local lever = ({left = 1, center = 2, right = 3})[arg]
-- check to see if levers are pulled in right order. Legacy ran set_levers (590_22) synchronously
-- here; m_run_room_trig is queued until this trigger returns, so the order is rolled inline
-- (same permutations as 590_22) and this very pull is judged against it.
if globals.first_kill ~= 2 and lever then
    local orders = {{1, 2, 3}, {1, 3, 2}, {2, 3, 1}, {2, 1, 3}, {3, 2, 1}, {3, 1, 2}}
    local o = orders[random(1, 6)]
    globals.first, globals.secnd, globals.last = o[1], o[2], o[3]
    globals.first_kill = 2
    globals.first_pin = 1
    globals.secnd_pin = 1
    globals.last_pin = 1
end
if world.count_objects(590, 35) == 1 then
    local dmg = 0
    if actor.level <= 40 then
        dmg = (2 * actor.level) + random(1, 70)
    elseif actor.level >= 41 and actor.level <= 70 then
        dmg = (3 * actor.level) + random(1, 100)
    elseif actor.level >= 71 and actor.level <= 100 then
        dmg = (4 * actor.level) + random(1, 130)
    end
    local already = function()
        actor:send("The lever seems to have already been pulled.")
        self.room:send_except(actor, tostring(actor.name) .. " tries to pull the lever that has already been pulled.")
    end
    if not lever then
        actor:send("Pull what?")
    elseif globals.last == lever and globals.first_pin == 3 and globals.secnd_pin == 3 then
        if globals.last_pin == 3 then
            already()
        else
            actor:send("You pull the lever, which puts into motion what sounds like chains behind the door.")
            self.room:send_except(actor, tostring(actor.name) .. " pulls the lever, which leads to the noise of chains moving behind the door.")
            wait(0.5)
            self.room:send("*Click*")
            wait(0.5)
            self.room:send("The large stone door slowly slides open.")
            get_room(590, 55):at(function()
                self.room:send("The large stone door slowly slides open.")
            end)
            get_room(590, 56):exit("south"):set_state({has_door = true})
            get_room(590, 55):exit("north"):set_state({has_door = true})
            world.destroy(self.room:find_actor("large-silver-levers"))
            globals.first_kill = nil
            globals.last_pin = nil
            globals.secnd_pin = nil
            globals.first_pin = nil
        end
    elseif globals.secnd == lever and globals.first_pin == 3 then
        if globals.secnd_pin == 3 then
            already()
        else
            actor:send("You pull the lever, which leads to a series of loud clicks behind the door.")
            self.room:send_except(actor, tostring(actor.name) .. " pulls the lever, which causes a series of loud clicks to reverberate from the door.")
            wait(0.5)
            self.room:send("You hear something in the doors locking mechanism drop.")
            globals.secnd_pin = 3
        end
    elseif globals.first == lever then
        if globals.first_pin == 3 then
            already()
        else
            actor:send("As you pull the lever, the faint sound of gears turning echo out from the door.")
            self.room:send_except(actor, tostring(actor.name) .. " pulls the lever and the faint sound of gears turning echo from the door.")
            wait(0.5)
            self.room:send("You hear something in the doors locking mechanism drop.")
            globals.first_pin = 3
        end
    elseif lever == 1 then
        self.room:send_except(actor, tostring(actor.name) .. " reaches over and pulls the left lever.")
        actor:send("You pull the left lever.")
        self.room:send_except(actor, tostring(actor.name) .. " bends over in agony as a searing jolt of pain grasps " .. tostring(actor.object) .. " body.  (<blue>" .. tostring(dmg) .. "</>)")
        actor:send("You bend over in extreme anguish as a jolt of pain tears through your body.  (<b:red>" .. tostring(dmg) .. "</>)")
        local damage_dealt = actor:damage(dmg)  -- type: physical
    elseif lever == 2 then
        self.room:send_except(actor, tostring(actor.name) .. " reaches out and pulls the center lever.")
        actor:send("You pull the center lever.")
        self.room:send_except(actor, "A sudden rush of a smoky grey air blasts " .. tostring(actor.name) .. ", hitting " .. tostring(actor.object) .. " squre in the chest and knocking " .. tostring(actor.object) .. " back.  (<blue>" .. tostring(dmg) .. "</>)")
        actor:send("A sudden rush of a smoky grey air comes from nowhere and plows into your chest with the force of a war hammer.  (<b:red>" .. tostring(dmg) .. "</>)")
        local damage_dealt = actor:damage(dmg)  -- type: physical
    else
        self.room:send_except(actor, tostring(actor.name) .. " reaches out and pulls the right lever.")
        actor:send("You pull the right lever.")
        self.room:send_except(actor, "Blue arcs of electricity flow out of the lever and travel up " .. tostring(actor.name) .. "'s arm, sending " .. tostring(actor.object) .. " reeling with a jolt.  (<blue>" .. tostring(dmg) .. "</>)")
        actor:send("A blue arc of electricity jumps out of the lever and travels through your body, giving you quite a jolt.  (<b:red>" .. tostring(dmg) .. "</>)")
        local damage_dealt = actor:damage(dmg)  -- type: physical
    end
else
    _return_value = true
end
return _return_value$trig$, '0f844b064912f1243a019de0c2d3cf87')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
