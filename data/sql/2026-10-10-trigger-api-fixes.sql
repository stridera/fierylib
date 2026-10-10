-- Trigger API fixes: bindings now exist for zone.echo, timestamp (game hours), trigger_log, find_player, get_obj_noadesc, get_people/get_objects/get_mexists/get_oexists and set_skill. Scripts that called them with legacy vnum strings or seconds, read legacy .vnum keys, or ran the staff mskillset command now use the typed API.
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/004/004_22_combat_in_eldoria_progress_journal.lua
  (4, 22, $trig$-- Converted from DG Script #422: Combat in Eldoria progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "combat in eldoria") or string.find(arg, "combat_in_eldoria") or string.find(arg, "third eldorian guard") or string.find(arg, "third black legion") or string.find(arg, "black_legion") or string.find(arg, "eldorian_guard") or string.find(arg, "third_black_legion") or string.find(arg, "third_eldorian_guard") or string.find(arg, "combat") or string.find(arg, "eldoria") then
    _return_value = true
    actor:send("<b:green>&uCombat in Eldoria</>")
    actor:send("The Third Black Legion and the Eldorian Guard, along with their allies in Split Skull and the Abbey, are locked in eternal warfare.")
    actor:send("Characters may align themselves with the forces of good or the forces of evil.")
    actor:send("But beware, once made that decision cannot be changed!")
    actor:send("Minimum Level: 10")
    if actor:get_quest_stage("black_legion") then
        actor:send("<cyan>Status: Continuous</>_")
        local id_trophy1
        local id_trophy2
        local id_trophy3
        local id_trophy4
        local id_trophy5
        local id_trophy6
        local id_trophy7
        local id_gem_cap
        local id_gem_neck
        local id_gem_arm
        local id_gem_wrist
        local id_gem_gloves
        local id_gem_jerkin
        local id_gem_robe
        local id_gem_belt
        local id_gem_legs
        local id_gem_boots
        local id_gem_mask
        local id_gem_symbol
        local id_gem_staff
        local id_gem_ssword
        local id_gem_whammer
        local id_gem_flail
        local id_gem_shiv
        local id_gem_lsword
        local id_gem_smace
        local id_gem_light
        local id_gem_food
        local id_gem_drink
        local id_cap
        local id_neck
        local team_a_idrm
        local id_wrist
        local id_gloves
        local id_jerkin
        local team_b_idelt
        local id_legs
        local team_b_idoots
        local id_mask
        local id_robe
        local id_symbol
        local id_staff
        local id_ssword
        local id_whammer
        local id_flail
        local id_shiv
        local id_lsword
        local id_smace
        local id_light
        local id_food
        local id_drink
        local legion
        local master
        local status
        if actor:get_quest_var("Black_Legion:bl_ally") then
            id_trophy1 = 5504
            id_trophy2 = 5506
            id_trophy3 = 5508
            id_trophy4 = 5510
            id_trophy5 = 5512
            id_trophy6 = 5514
            id_trophy7 = 5516
            id_gem_cap = 55570
            id_gem_neck = 55571
            id_gem_arm = 55572
            id_gem_wrist = 55573
            id_gem_gloves = 55574
            id_gem_jerkin = 55575
            id_gem_robe = 55589
            id_gem_belt = 55576
            id_gem_legs = 55577
            id_gem_boots = 55578
            id_gem_mask = 55579
            id_gem_symbol = 55580
            id_gem_staff = 55581
            id_gem_ssword = 55582
            id_gem_whammer = 55583
            id_gem_flail = 55584
            id_gem_shiv = 55585
            id_gem_lsword = 55586
            id_gem_smace = 55587
            id_gem_light = 55588
            id_gem_food = 55566
            id_gem_drink = 55567
            id_cap = 5517
            id_neck = 5519
            team_a_idrm = 5521
            id_wrist = 5523
            id_gloves = 5525
            id_jerkin = 5527
            team_b_idelt = 5529
            id_legs = 5531
            team_b_idoots = 5533
            id_mask = 5535
            id_robe = 5537
            id_symbol = 5515
            id_staff = 5539
            id_ssword = 5540
            id_whammer = 5541
            id_flail = 5542
            id_shiv = 5543
            id_lsword = 5544
            id_smace = 5545
            id_light = 5553
            id_food = 5555
            id_drink = 5557
            legion = "Black Legion"
            master = mobiles.template(41, 27).name .. " and " .. mobiles.template(55, 12).name
            status = actor:get_quest_var("black_legion:bl_faction")
        elseif actor:get_quest_var("Black_Legion:eg_ally") then
            id_trophy1 = 5503
            id_trophy2 = 5505
            id_trophy3 = 5507
            id_trophy4 = 5509
            id_trophy5 = 5511
            id_trophy6 = 5513
            id_trophy7 = 5515
            id_gem_cap = 55570
            id_gem_neck = 55571
            id_gem_arm = 55572
            id_gem_wrist = 55573
            id_gem_gloves = 55574
            id_gem_jerkin = 55575
            id_gem_robe = 55589
            id_gem_belt = 55576
            id_gem_legs = 55577
            id_gem_boots = 55578
            id_gem_mask = 55579
            id_gem_symbol = 55580
            id_gem_staff = 55581
            id_gem_ssword = 55582
            id_gem_whammer = 55583
            id_gem_flail = 55584
            id_gem_shiv = 55585
            id_gem_lsword = 55586
            id_gem_smace = 55587
            id_gem_light = 55588
            id_gem_food = 55566
            id_gem_drink = 55567
            id_cap = 5518
            id_neck = 5520
            team_a_idrm = 5522
            id_wrist = 5524
            id_gloves = 5526
            id_jerkin = 5528
            team_b_idelt = 5530
            id_legs = 5532
            team_b_idoots = 5534
            id_mask = 5536
            id_robe = 5538
            id_symbol = 5516
            id_staff = 5546
            id_ssword = 5547
            id_whammer = 5548
            id_flail = 5549
            id_shiv = 5550
            id_lsword = 5551
            id_smace = 5552
            id_light = 5554
            id_food = 5556
            id_drink = 5558
            legion = "Eldorian Guard"
            master = mobiles.template(186, 99).name .. " and " .. mobiles.template(55, 24).name
            status = actor:get_quest_var("black_legion:eg_faction")
        end
        actor:send("You are pledged to the " .. tostring(legion) .. ".")
        actor:send("Quest Master: " .. tostring(master))
        -- osend %actor% &0
        -- osend %actor% The %legion% is interested in:
        -- osend %actor% - %get.obj_shortdesc[%id_trophy1%]%
        -- osend %actor% - %get.obj_shortdesc[%id_trophy2%]%
        -- osend %actor% - %get.obj_shortdesc[%id_trophy3%]%
        -- osend %actor% - %get.obj_shortdesc[%id_trophy4%]%
        -- osend %actor% - %get.obj_shortdesc[%id_trophy5%]%
        -- osend %actor% - %get.obj_shortdesc[%id_trophy6%]%
        -- osend %actor% - %get.obj_shortdesc[%id_trophy7%]%
        actor:send("</>")
        actor:send("You have turned in:")
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy1) .. "_trophies")) .. " %get.obj_pldesc[%id_trophy1%]%")
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy2) .. "_trophies")) .. " %get.obj_pldesc[%id_trophy2%]%")
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy3) .. "_trophies")) .. " %get.obj_pldesc[%id_trophy3%]%")
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy4) .. "_trophies")) .. " %get.obj_pldesc[%id_trophy4%]%")
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy5) .. "_trophies")) .. " %get.obj_pldesc[%id_trophy5%]%")
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy6) .. "_trophies")) .. " %get.obj_pldesc[%id_trophy6%]%")
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy7) .. "_trophies")) .. " %get.obj_pldesc[%id_trophy7%]%")
        actor:send("</>")
        actor:send("Your current " .. tostring(legion) .. " faction status is " .. tostring(status) .. ".")
        if status >= 200 then
            actor:send("You have reached the maximum faction status.")
        end
        actor:send("</>")
        if status >= 20 then
            actor:send("You have access to:")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_food%]%</> for <magenta>%get.obj_shortdesc[%id_gem_food%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_food) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_drink%]%</> for <magenta>%get.obj_shortdesc[%id_gem_drink%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_drink) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_cap%]%</> for <magenta>%get.obj_shortdesc[%id_gem_cap%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_cap) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_ssword%]%</> for <magenta>%get.obj_shortdesc[%id_gem_ssword%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_ssword) .. "_reward")) .. ")_")
        end
        if status >= 40 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_neck%]%</> for <magenta>%get.obj_shortdesc[%id_gem_neck%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_neck) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_staff%]%</> for <magenta>%get.obj_shortdesc[%id_gem_staff%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_staff) .. "_reward")) .. ")_")
        end
        if status >= 55 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%team_a_idrm%]%</> for <magenta>%get.obj_shortdesc[%id_gem_arm%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(team_a_idrm) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_whammer%]%</> for <magenta>%get.obj_shortdesc[%id_gem_whammer%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_whammer) .. "_reward")) .. ")_")
        end
        if status >= 70 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_wrist%]%</> for <magenta>%get.obj_shortdesc[%id_gem_wrist%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_wrist) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_flail%]%</> for <magenta>%get.obj_shortdesc[%id_gem_flail%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_flail) .. "_reward")) .. ")_")
        end
        if status >= 85 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_gloves%]%</> for <magenta>%get.obj_shortdesc[%id_gem_gloves%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_gloves) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_symbol%]%</> for <magenta>%get.obj_shortdesc[%id_gem_symbol%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_symbol) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_light%]%</> for <magenta>%get.obj_shortdesc[%id_gem_light%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_light) .. "_reward")) .. ")_")
        end
        if status >= 100 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%team_b_idelt%]%</> for <magenta>%get.obj_shortdesc[%id_gem_belt%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(team_b_idelt) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_shiv%]%</> for <magenta>%get.obj_shortdesc[%id_gem_shiv%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_shiv) .. "_reward")) .. ")_")
        end
        if status >= 115 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%team_b_idoots%]%</> for <magenta>%get.obj_shortdesc[%id_gem_boots%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(team_b_idoots) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_lsword%]%</> for <magenta>%get.obj_shortdesc[%id_gem_lsword%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_lsword) .. "_reward")) .. ")_")
        end
        if status >= 130 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_legs%]%</> for <magenta>%get.obj_shortdesc[%id_gem_legs%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_legs) .. "_reward")) .. ")_")
        end
        if status >= 145 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_robe%]%</> for <magenta>%get.obj_shortdesc[%id_gem_robe%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_robe) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_jerkin%]%</> for <magenta>%get.obj_shortdesc[%id_gem_jerkin%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_jerkin) .. "_reward")) .. ")_")
        end
        if status >= 160 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_mask%]%</> for <magenta>%get.obj_shortdesc[%id_gem_mask%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_mask) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_smace%]%</> for <magenta>%get.obj_shortdesc[%id_gem_smace%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_smace) .. "_reward")) .. ")_")
        end
        if statu < 160 then
            actor:send("As your standing with the " .. tostring(legion) .. " improves you will have access to more rewards.")
        end
    else
        actor:send("<cyan>Status: Not Started</>")
    end
end
return _return_value$trig$),
  -- data/triggers/022/022_44_belial_combat_ai_script.lua
  (22, 44, $trig$-- Converted from DG Script #2244: belial_combat_ai_script
-- Original: MOB trigger, flags: SPEECH, FIGHT, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end

-- Speech keywords: test
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "test")) then
    return true  -- No matching keywords
end
-- random combat events
local timer = random(1, 4)
if belial_ai > 0 then
    -- switch on action
    if action == 1 then
        -- Deadly Spell
        -- line 10
        run_room_trigger(22, 46)
    elseif action == 2 then
        -- Severe Spell
        run_room_trigger(22, 47)
    elseif action == 3 then
        -- Severe Spell
        run_room_trigger(22, 48)
        -- line 20
    elseif action == 4 then
        self.room:send("Belial says in common, 'Fear my wrath, puny mortal!'")
    elseif action == 5 then
        -- Kick / Switch Opponents
        local victim = room.actors[random(1, #room.actors)]
        local which = random(1, 2)
        -- switch on which
        -- line 30
        if which == 1 then
            combat.engage(self, victim.name)
        elseif which == 2 then
            skills.execute(self, "kick", self.fighting)
        end
        -- line 40
        -- Show random caster Fun Lovin's!
        if self:get_mexists(1000, 15) < 1 then
            run_room_trigger(22, 49)
        end
        -- Kick / Switch Opponents
        local victim = room.actors[random(1, #room.actors)]
        local which = random(1, 2)
        -- switch on which
        if which == 1 then
            -- line 50
            combat.engage(self, victim.name)
        elseif which == 2 then
            skills.execute(self, "kick", self.fighting)
        end
        -- Random Banter
        -- line 60
        -- Severe Spell
        run_room_trigger(22, 48)
        -- Severe Spell
        run_room_trigger(22, 47)
        -- line 70
        -- Deadly Spell
        run_room_trigger(22, 46)
        self:say("Your soul belongs to the Nines!")
        skills.execute(self, "kick", self.fighting)
        -- line 80
    end
    if belial_ai >= 1 then
        belial_ai = belial_ai - 1
    else
        local belial_ai = timer
    end
    globals.belial_ai = globals.belial_ai or true
end  -- auto-close block$trig$),
  -- data/triggers/030/030_26_test-random.lua
  (30, 26, $trig$-- Converted from DG Script #3026: test-random
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: random
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "random")) then
    return true  -- No matching keywords
end
-- This is a test to generate a random number to be used
-- in many ways
self:say("My trigger commandlist is not complete!")
local random_number = random(1, 100)
if random_number >=51 then
    self:say("We're loading object.")
else
    self:say("We're not loading object.")
end
self:say(tostring(random_number))
local mob = self:get_mexists(30, 55)
local obj = self:get_oexists(11, 27)
actor:send("There are " .. tostring(mob) .. " Druidic guards of 3055 in the game.")
actor:send("There are " .. tostring(obj) .. " iron-banded girth's in the game.")$trig$),
  -- data/triggers/043/043_63_load_lashes.lua
  (43, 63, $trig$-- Converted from DG Script #4363: Load lashes
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- Room-scoped existence check: self:get_objects(zone, id) returns the item or nil.
if not self:get_objects(43, 51) then
    self.room:spawn_object(43, 51)
end
if not self:get_objects(43, 11) then
    self.room:spawn_object(43, 11)
end$trig$),
  -- data/triggers/053/053_55_hell_trident_receive.lua
  (53, 55, $trig$-- Converted from DG Script #5355: Hell Trident receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local hellstage = actor:get_quest_stage("hell_trident")
-- switch on self.id
-- Black Priestess p2
if self.id == 6032 then
    local reward = 39
    local phase = 1
    local level = 65
    local spell1 = actor:get_has_completed("banish")
    local spell2 = actor:get_has_completed("hellfire_brimstone")
    if not actor:get_quest_var("hell_trident:helltask6") then
        if actor:get_quest_stage("vilekka_stew") > 3 then
            actor:set_quest_var("hell_trident", "helltask6", 1)
        end
    end
    if object.id == 55662 then
        local go = "gem"
    elseif object.id == 2334 then
        local go = "trident"
    end
elseif self.id == 12526 then
    local reward = 40
    local phase = 2
    local level = 90
    local spell1 = actor:get_has_completed("resurrection_quest")
    local spell2 = actor:get_has_completed("hell_gate")
    if object.id == 55739 then
        local go = "gem"
    elseif object.id == 2339 then
        local go = "trident"
    end
end
-- adding in case it's not caught somewhere else
if hellstage == "phase" then
    if not actor:get_quest_var("hell_trident:helltask5") then
        if spell1 then
            actor:set_quest_var("hell_trident", "helltask5", 1)
        end
    end
    if not actor:get_quest_var("hell_trident:helltask4") then
        if spell2 then
            actor:set_quest_var("hell_trident", "helltask4", 1)
        end
    end
end
if actor:get_has_completed("hell_trident") then
    go = nil
    local refuse = 1
    local reason = "You already command the greatest power imaginable!"
elseif actor.level < level then
    go = nil
    local refuse = 1
    local reason = "You are not yet strong enough to handle more power."
elseif hellstage < phase then
    go = nil
    local refuse = 1
    local reason = "Your trident is not ready to upgrade yet."
elseif hellstage > phase then
    go = nil
    local refuse = 1
    local reason = "I've already done everything I can to help."
end
if go == "gem" then
    local gem_id = object.id
    local gem_count = actor:get_quest_var("hell_trident:gems")
    if gem_count < 6 then
        wait(2)
        world.destroy(object.name)
        gem_count = gem_count + 1
        actor:set_quest_var("hell_trident", "gems", gem_count)
        actor:send(tostring(self.name) .. " says, 'Yes, this is perfect.'")
        wait(2)
        if gem_count == 1 then
            actor:send(tostring(self.name) .. " says, 'You have given me 1 of 6 " .. "%get.obj_pldesc[%gem_id%]%.'")
        else
            actor:send(tostring(self.name) .. " says, 'You have given me " .. tostring(gem_count) .. " of 6 " .. "%get.obj_pldesc[%gem_id%]%.'")
        end
        wait(2)
        if gem_count >= 6 then
            actor:set_quest_var("hell_trident", "helltask3", 1)
            local job1 = actor:get_quest_var("hell_trident:helltask1")
            local job2 = actor:get_quest_var("hell_trident:helltask2")
            local job3 = actor:get_quest_var("hell_trident:helltask3")
            local job4 = actor:get_quest_var("hell_trident:helltask4")
            local job5 = actor:get_quest_var("hell_trident:helltask5")
            local job6 = actor:get_quest_var("hell_trident:helltask6")
            if job1 and job2 and job3 and job4 and job5 and job6 then
                actor:send(tostring(self.name) .. " says, 'Now present the trident.'")
            else
                actor:send(tostring(self.name) .. " says, 'Complete your other sacrifices then return to me.'")
            end
        end
    else
        _return_value = true
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You have already given me 6 " .. "%get.obj_pldesc[%gem_id%]%.'")
    end
elseif go == "trident" then
    local job1 = actor:get_quest_var("hell_trident:helltask1")
    local job2 = actor:get_quest_var("hell_trident:helltask2")
    local job3 = actor:get_quest_var("hell_trident:helltask3")
    local job4 = actor:get_quest_var("hell_trident:helltask4")
    local job5 = actor:get_quest_var("hell_trident:helltask5")
    local job6 = actor:get_quest_var("hell_trident:helltask6")
    if job1 and job2 and job3 and job4 and job5 and job6 then
        wait(2)
        world.destroy(object)
        if self.id == 12526 then
            actor:send(tostring(self.name) .. " says, 'We are pleased.'")
            self:command("grin")
            wait(1)
            self.room:send(tostring(self.name) .. " turns and faces out into the endless void of his vast realm.")
            wait(1)
            self.room:send(tostring(self.name) .. " growls, 'Ir ya roza aem ya iz ednuyt...'")
            wait(2)
            self.room:send("The inner <b:blue>ire</> of the " .. get_obj_noadesc(23, 39) .. " ignites and <red>b<blue>urn</><red>s</>!")
            wait(2)
            self.room:send(tostring(self.name) .. " roars, 'Liy ya gaoh yaezk'aqa, ir ya aehg mol'tiaer I kiwa yiz laodaer zes mina...'")
            wait(2)
            self.room:send(tostring(self.name) .. " erupts in glorious <red>f<blue>l<yellow>a<red>m</><red>e</>!")
            wait(2)
            self.room:send("The <red>f<b:yellow>i<red>r</><red>es<blue>t<yellow>o<red>r</><red>m</> forms a vortex about the " .. get_obj_noadesc(23, 39) .. ", like an explosion in reverse.")
            wait(1)
            self.room:send("The trident <b:magenta>t</><magenta>w&9<blue>i</><magenta>s<blue>ts</> and contorts in the wild <red>f<b:yellow>i<red>r</><red>e</>!")
            wait(3)
            self.room:send("The fire subsides, leaving a &9<blue>midnight-black</> weapon pulsing with dark radiance.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Our bond is forged.'")
        else
            actor:send(tostring(self.name) .. " says, 'The infernal ones are pleased.'")
            wait(1)
            self.room:send(tostring(self.name) .. "'s neck goes limp as her eyes roll back into her head.")
            wait(2)
            self.room:send(tostring(self.name) .. " begins to murmur... 'Hin tel'quiet nehel -nal rillis fis...'")
            wait(3)
            self.room:send("Brilliant <blue>b&9<blue>lac</><blue>k fire seeps out of " .. get_obj_noadesc(23, 34) .. " and spreads across its surface.")
            wait(2)
            self.room:send(tostring(self.name) .. " babbles in an alien voice, 'Aul adoe shunti mor ik mor...'")
            wait(2)
            self.room:send("<red>Scarlet</> <blue>fl<blue>ames</> ignite in " .. tostring(self.name) .. "'s hands, pulsing in rhythm with her speech.")
            wait(2)
            self.room:send(tostring(self.name) .. " utters, 'Slidc ya qnoes oynaezz ya khozz qaed...' as she holds her hand over the " .. get_obj_noadesc(23, 34) .. ".")
            wait(2)
            self.room:send("The flames burn away the trident, leaving only a blazing tendril.")
            wait(2)
            self.room:send(tostring(self.name) .. " grabs the burning spire and commands, 'Le yaezzoth esaeu qae qota maenz!'")
            self.room:send("The wild flames contort as they cool into a new three-pointed form.")
            wait(2)
            if actor.level >= 90 then
                actor:send(tostring(self.name) .. " says, 'The Demon Lord Krisenna is known to traffic with mortals from time to time.  Impress him and perhaps he will grant you a boon.'")
            else
                actor:send(tostring(self.name) .. " says, 'Continue to prove your value to Hell and perhaps a Demon Lord might be willing to grant your their patronage.'")
                actor:send("<red>You must be level " .. tostring(level) .. " or greater to continue this quest.</>")
            end
        end
        self.room:spawn_object(23, reward)
        self:command("give trident " .. tostring(actor))
        local expcap = level
        if expcap < 17 then
            local expmod = 440 + ((expcap - 8) * 125)
        elseif expcap < 25 then
            local expmod = 1440 + ((expcap - 16) * 175)
        elseif expcap < 34 then
            local expmod = 2840 + ((expcap - 24) * 225)
        elseif expcap < 49 then
            local expmod = 4640 + ((expcap - 32) * 250)
        elseif expcap < 90 then
            local expmod = 8640 + ((expcap - 48) * 300)
        else
            local expmod = 20940 + ((expcap - 89) * 600)
        end
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 10 do
            actor:award_exp(setexp)
            loop = loop + 1
        end
        local number = 1
        while number < 7 do
            actor:set_quest_var("hell_trident", "helltask%number%", 0)
            number = number + 1
        end
        actor:set_quest_var("hell_trident", "gems", 0)
        actor:set_quest_var("hell_trident", "greet", 0)
        if actor:get_quest_stage("hell_trident") == 1 then
            actor:advance_quest("hell_trident")
        else
            actor:complete_quest("hell_trident")
        end
    else
        local refuse = 1
        local reason = "You have to complete all your other offerings before you give me your trident."
    end
end
if refuse then
    _return_value = true
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(reason) .. "'")
end
return _return_value$trig$),
  -- data/triggers/055/055_21_degeneration_cat_receive.lua
  (55, 21, $trig$-- Converted from DG Script #5521: degeneration_cat_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("degeneration")
if stage == 0 then
    _return_value = true
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:command("hiss actor")
    wait(2)
    self:say("Who are you?  Why are you giving me this?")
elseif stage == 1 and object.id == 58008 then
    actor:advance_quest("degeneration")
    wait(1)
    self:destroy_item("book")
    self:emote("studies the book closely.")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Hmmm, that's an unusual configuration...  The cage must have")
    self.room:send("</>been part of the secret.'")
    wait(2)
    self:emote("closes the book.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Yajiro was on to something, though his understanding was")
    self.room:send("</>quite rudimentary.  I need to dig a little deeper.'")
    wait(4)
    self:say("Literally and figuratively!")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'A troll sorcerer by the name of Mesmeriz has set up an")
    self.room:send("</>illusory lair in the Minithawkin Mines.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Word among the dark practitioners is, he's trying to perform")
    self.room:send("</>the Ritual of Night and become a lich.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Bring back the necklace he carries so I can see how much")
    self.room:send("</>progress he's made.'")
elseif stage == 2 and object.id == 37015 then
    actor:advance_quest("degeneration")
    wait(1)
    self:destroy_item("necklace")
    self.room:send(tostring(self.name) .. " utters the words, '<b:yellow>oculoinfra kariq</>'.")
    self.room:send(tostring(self.name) .. "'s eyes flash bright yellow!")
    wait(1)
    self:emote("examines " .. tostring(objects.template(370, 15).name))
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Mesmeriz was remarkably close to his goal.  The principles")
    self.room:send("</>of energy transfer he was using were quite unique.'")
    wait(4)
    self:say("It seems all he was missing was a suitable phylactery.")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'There's another wizard who has been working in body")
    self.room:send("</>modification, but on a massive scale.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'He's enchanted the entire town of Nordus and is")
    self.room:send("</>experimenting on the villagers.  Rumor is he's trying to grow bodies as fodder")
    self.room:send("</>for mass animation.'")
    wait(5)
    self:say("I must admit, I'm impressed.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'He has a mask made from the face of one of his many victims")
    self.room:send("</>which he uses as his focus.  It's a bit vulgar, but it should serve my")
    self.room:send("</>purposes.  Secure it and bring it back.'")
elseif stage == 3 and object.id == 51075 then
    actor:advance_quest("degeneration")
    wait(1)
    self:destroy_item("mask")
    wait(1)
    self:emote("greedily devours the " .. get_obj_noadesc(510, 75) .. "!")
    wait(3)
    self:command("lick")
    self:say("Nothing makes you more familiar with magic than the taste!")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Some impressive potency to use transmutation at that scale.")
    self.room:send("</>Plus some powerful evocation.'")
    wait(4)
    self:command("burp")
    self:say("Spicy!")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'But Luchiaans wasn't a very skilled necromancer it seems.")
    self.room:send("</>Still, it gives me some ideas.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'I need something of a more demonic nature to compare notes")
    self.room:send("</>to.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Cyprianum, the ruler of Demise Keep, has a particularly")
    self.room:send("</>prized servant, Voliangloch the Evil.  As a devotee of the demonic Cyprianum,")
    self.room:send("</>Voliangloch may have struck that special balance between arcane and divine.'")
    wait(7)
    self.room:send(tostring(self.name) .. " says, 'Bring me his magical focus, " .. tostring(objects.template(430, 20).name) .. ".")
    self.room:send("</>It should give me sufficient insight to Voliangloch's magic.'")
elseif stage == 4 and object.id == 43020 then
    actor:advance_quest("degeneration")
    wait(1)
    self:destroy_item("rod")
    wait(1)
    self:emote("bats " .. tostring(objects.template(430, 20).name) .. " around a bit.")
    wait(3)
    self:emote("bats " .. tostring(objects.template(430, 20).name) .. " around some more.")
    wait(5)
    self:emote("frantically swats " .. tostring(objects.template(430, 20).name) .. " around and sends it flying!")
    self:command("hiss")
    wait(3)
    self:say("Well that was most informative.")
    wait(3)
    self:say("Interesting blending technique Voliangloch employed.")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'It looks like we have to approach the big players for more")
    self.room:send("</>information now.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'The first of the true necromancers I need you to \"visit\" is")
    self.room:send("</>Kryzanthor.  He's created a vast necropolis near Anduin, the likes of which")
    self.room:send("</>most beings can only dream about!'")
    wait(6)
    self.room:send(tostring(self.name) .. " says, 'He wears a unique robe that I'd like to get my paws on.  Get")
    self.room:send("</>it and bring it back to me.'")
elseif stage == 5 and object.id == 47003 then
    actor:advance_quest("degeneration")
    wait(1)
    self:destroy_item("robe")
    self:emote("gingerly sniffs " .. tostring(objects.template(470, 3).name) .. ".")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Yes, this makes more sense.  Needing a physical conduit to")
    self.room:send("</>focus the transference of energies through while simultaneously shielding the")
    self.room:send("</>body appears to be critical here.'")
    wait(6)
    self.room:send(tostring(self.name) .. " says, 'Kryzanthor had mastered suffusing the dead with animating")
    self.room:send("</>energies, but he didn't quite have the mastery of draining life force from")
    self.room:send("</>the living.'")
    wait(6)
    self:say("There is one whom I have heard does have such a power.")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'In the Iron Hills there is an ancient barrow where several")
    self.room:send("</>kings have been laid to rest.  What's more, those of us who deal in death know")
    self.room:send("</>it's the lair of one of the two known liches in the world, King Ureal.'")
    wait(7)
    self.room:send(tostring(self.name) .. " says, 'In particular, he has a statuette I'm most interested in.")
    self.room:send("</>It supposedly can drain the energy of the living.'")
    wait(5)
    self.room:send(tostring(self.name) .. " says, 'If that's true, then it would be a huge missing piece of the")
    self.room:send("</>puzzle.'")
    wait(3)
    self:say("I'm quite excited for this one, so hurry up!")
elseif stage == 6 and object.id == 48009 then
    actor:advance_quest("degeneration")
    wait(1)
    self:destroy_item("statuette")
    self:say("Well done my little one, well done.")
    self:emote("meows in gratitude.")
    wait(2)
    self:emote("repeatedly rubs up against the statuette.")
    self.room:send("The statuette begins to glow <b:green>bright green!</>")
    wait(1)
    self:say("Fascinating...")
    wait(3)
    self:say("This is definitely helpful.")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'The last person I need information from is a curmudgeonly")
    self.room:send("</>old thing, Norisent.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'He sought to raise the dead, not just in a state of undeath,")
    self.room:send("</>but to truly restore them to life.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Unfortunately for him, his experiments failed and he turned")
    self.room:send("</>himself into a lich instead.'")
    wait(2)
    self:command("roll")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Regardless, he's been hiding out at the Cathedral of")
    self.room:send("</>Betrayal for decades now.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Find Norisent and whatever book he's keeping notes in these")
    self.room:send("</>days.  While I think I could manage this without his notes, I want to be")
    self.room:send("</>completely sure.'")
elseif stage == 8 and object.id == 8551 then
    actor:advance_quest("degeneration")
    wait(1)
    self:destroy_item("book")
    self:emote("flips through the pages of the book.")
    wait(2)
    self:command("gasp")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'It's a good thing I have these notes or my planned matrix")
    self.room:send("</>configuration would have completely backfired!  I'll make the necessary")
    self.room:send("</>adjustments to the final casting.'")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'The other thing these notes show me is I'm missing")
    self.room:send("</>something to channel the transferring energy through.'")
    wait(4)
    self:say("Hmmmmm...")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'The statuette is too strongly attuned to Ureal to be")
    self.room:send("</>suitable...'")
    wait(3)
    self:say("Let me see...")
    wait(3)
    self.room:send(tostring(self.name) .. " utters the words, <b:yellow>'hiqi avykamina'</>.")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'It seems there is a dangerous ruby hidden under some kind")
    self.room:send("</>of stairway?  That makes no sense.  Yet my divination indicates it would be an")
    self.room:send("</>acceptable conduit for this spell.'")
    wait(6)
    self:say("Seek it out!")
elseif stage == 9 and object.id == 12526 then
    wait(1)
    self:destroy_item("ruby")
    self.room:send(tostring(self.name) .. "'s eyes widen and gleam at the sight of the ruby!")
    self:say("Magnificent!  I've never seen anything quite like it.")
    wait(3)
    self:emote("scratches out a huge diagram in the earth inside the tent.")
    self.room:send(tostring(self.name) .. " carefully places " .. tostring(objects.template(125, 26).name) .. " in the center of the diagram.")
    wait(4)
    self.room:send(tostring(self.name) .. " utters the word, <b:yellow>'oculotunsofihuab'</>.")
    self.room:send("Waves of necrotic energy rush blast out from the diagram bolstering the forces of the Third Black Legion!")
    wait(4)
    self:command("cackle")
    self.room:send(tostring(self.name) .. " says, 'I've done it!  I've perfected the formula for Degeneration!!")
    self.room:send("</>Here, see how it works!!'")
    wait(4)
    actor:send("Looking at the notes, you understand what " .. tostring(self.name) .. " has done.")
    actor:send("<b:white>You have learned &9Degeneration<white>!</>")
    skills.set_level(actor, "degeneration", 100)
    actor:complete_quest("degeneration")
else
    _return_value = true
    self:command("hiss " .. tostring(actor.name))
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'This isn't what I asked for. What are you, stupid?")
    self.room:send("</>Do you need me to remind you of your <b:white>[spell progress]</>?'")
end
return _return_value$trig$),
  -- data/triggers/123/123_99_menhir_purge.lua
  (123, 99, $trig$-- Converted from DG Script #12399: menhir_purge
-- Original: WORLD trigger, flags: RANDOM, probability: 100%
if self:get_objects(123, 50) and self:get_objects(123, 51) then
    world.destroy(self.room:find_actor("awakened-menhir"))
    self.room:send(tostring(objects.template(123, 50).name) .. " gradually stops glowing and falls silent.")
end$trig$),
  -- data/triggers/185/185_23_group_heal_injured_give.lua
  (185, 23, $trig$if actor:get_quest_stage("group_heal") ~= 6 then
    return true
end

if victim.is_player then
    return true
end

local function vnum_match(zone, id)
    return victim.zone_id == zone and victim.local_id == id
end

local key = "group_heal:" .. tostring(victim.zone_id) .. "_" .. tostring(victim.local_id)
if actor:get_quest_var(key) then
    actor:send("you have already helped " .. tostring(victim.name))
    return true
end

local eligible_recipients = {
    {185,  6}, {464, 14}, {430, 20}, {125, 13},
    {361,  3}, {588,  3}, {300, 54},
}
local refused_recipients = { {625, 6}, {534, 50} }

local is_eligible = false
for _, t in ipairs(eligible_recipients) do
    if vnum_match(t[1], t[2]) then is_eligible = true; break end
end
local is_refused = false
for _, t in ipairs(refused_recipients) do
    if vnum_match(t[1], t[2]) then is_refused = true; break end
end

if is_eligible then
    actor:set_quest_var("group_heal", tostring(victim.zone_id) .. "_" .. tostring(victim.local_id), 1)
    local heal = (actor:get_quest_var("group_heal:total") or 0) + 1
    actor:set_quest_var("group_heal", "total", heal)

    actor:send("You give " .. tostring(self.shortdesc) .. " to " .. tostring(victim.name) .. " and apply the medicine to " .. tostring(victim.himher) .. ".")
    wait(1)
    self.room:send(tostring(victim.name) .. "'s wounds begin to heal as they consume the magical feast.")
    wait(2)

    -- Animal recipients (46414/36103) get a "nuzzle" rather than a thanks/bow.
    if vnum_match(464, 14) or vnum_match(361, 3) then
        victim:command("nuzzle " .. tostring(actor.name))
        wait(1)
        self.room:send(tostring(victim.name) .. " turns and departs.")
    else
        self.room:send(tostring(victim.name) .. " says, 'Thank you so much for coming to my aid!'")
        wait(1)
        self.room:send(tostring(victim.name) .. " bows and departs.")
    end

    if heal >= 5 then
        actor:set_skill("group heal", 100)
        world.destroy(victim)
        wait(1)
        actor:send("The miraculous power of St. George washes over you!")
        actor:send("The appropriate prayers to beseech the gods for group heal well up in your soul.")
        actor:complete_quest("group_heal")
        actor:send("<b:white>You have learned Group Heal</>!")
    else
        world.destroy(victim)
    end
    world.destroy(self)
elseif is_refused then
    wait(1)
    actor:send("It is not possible to help " .. tostring(victim.name) .. ".")
else
    wait(1)
    actor:send(tostring(victim.name) .. " does not appear to be hurt.")
end

return true$trig$),
  -- data/triggers/185/185_99_group_heal_status_check.lua
  (185, 99, $trig$local s = string.lower(speech)
if not (string.find(s, "status") or string.find(s, "progress")) then
    return true
end

local stage = actor:get_quest_stage("group_heal")
wait(2)

if stage == 1 then
    self.room:send(tostring(self.name) .. " says, 'Please track down the bandit raider somewhere in the")
    self.room:send("</>Gothra desert and recover our stolen medical supplies.'")
    if world.count_mobiles(185, 22) == 0 then
        get_room(11, 0):at(function() self.room:spawn_mobile(185, 22) end)
        get_room(11, 0):at(function() self.room:spawn_object(161, 6) end)
        get_room(11, 0):at(function() self.room:spawn_object(161, 6) end)
        get_room(11, 0):at(function() self:command("give scimitar bandit") end)
        get_room(11, 0):at(function() self:command("give scimitar bandit") end)
        get_room(11, 0):at(function() self.room:find_actor("bandit"):command("wear all") end)
        get_room(11, 0):at(function() self.room:find_actor("bandit"):teleport(get_room(161, 86)) end)
    end
elseif stage == 2 then
    self:say("Please find the medical supplies stolen by the bandit raider.")
elseif stage == 3 or stage == 4 then
    self.room:send(tostring(self.name) .. " says, 'You are currently trying to locate the records of a group")
    self.room:send("</>healing ritual in a lost kitchen in the Great Northern Swamp.'")
elseif stage == 5 then
    self.room:send(tostring(self.name) .. " says, 'You are visiting every <b:white>chef</> and <b:white>cook</> to get their notes on")
    self.room:send("</>the healing ritual.'")
    -- Keys match the writers (185_22 / 185_23): "group_heal:<zone>_<id>".
    local recipes = {
        { key = "group_heal:83_7",   tpl = {83, 7}    },
        { key = "group_heal:510_7",  tpl = {510, 7}   },
        { key = "group_heal:185_12", tpl = {185, 12}  },
        { key = "group_heal:300_3",  tpl = {300, 3}   },
        { key = "group_heal:502_3",  tpl = {502, 3}   },
        { key = "group_heal:103_8",  tpl = {103, 8}   },
    }
    local any = false
    for _, r in ipairs(recipes) do
        if actor:get_quest_var(r.key) then
            any = true
            break
        end
    end
    if any then
        self.room:send("</>You have already brought me notes from:")
        for _, r in ipairs(recipes) do
            if actor:get_quest_var(r.key) then
                self.room:send("- " .. tostring(mobiles.template(r.tpl[1], r.tpl[2]).name))
            end
        end
        local total = 6 - (actor:get_quest_var("group_heal:total") or 0)
        self.room:send("</>Bring me notes from " .. tostring(total) .. " more chefs.")
        self.room:send(tostring(self.name) .. " says, 'And if you need a new copy of the Rite, just say:")
        self.room:send("</><b:yellow>\"I lost the Rite\"</> and I will give you a new one.'")
    end
elseif stage == 6 then
    self.room:send(tostring(self.name) .. " says, 'You are delivering the medical packages to <b:white>injured</>, <b:white>wounded,")
    self.room:send("</><b:white>sick</>, or <b:white>hobbling</> creatures.'")
    local total = 5 - (actor:get_quest_var("group_heal:total") or 0)
    local people = {
        { key = "group_heal:185_6",  tpl = {185, 6}   },
        { key = "group_heal:464_14", tpl = {464, 14}  },
        { key = "group_heal:430_20", tpl = {430, 20}  },
        { key = "group_heal:125_13", tpl = {125, 13}  },
        { key = "group_heal:361_3",  tpl = {361, 3}   },
        { key = "group_heal:588_3",  tpl = {588, 3}   },
        { key = "group_heal:300_54", tpl = {300, 54}  },
    }
    local any = false
    for _, p in ipairs(people) do
        if actor:get_quest_var(p.key) then
            any = true
            break
        end
    end
    if any then
        self.room:send("You have aided:")
        for _, p in ipairs(people) do
            if actor:get_quest_var(p.key) then
                self.room:send("- " .. tostring(mobiles.template(p.tpl[1], p.tpl[2]).name))
            end
        end
    end
    if total == 1 then
        self.room:send("You need to deliver " .. tostring(total) .. " more packet.")
    else
        self.room:send("You need to deliver " .. tostring(total) .. " more packets.")
    end
else
    if actor:get_has_completed("group_heal") then
        self:say("You finished the quest to learn Group Heal already.")
    else
        self:say("You aren't working on a quest with me.")
    end
end$trig$),
  -- data/triggers/188/188_70_smart_combat.lua
  (188, 70, $trig$local now = timestamp()
local level = self.level
local class = self.class
local flags = self.flags
local is_sor = class == "Sorcerer"
local is_cry = class == "Cryomancer"
local is_pyr = class == "Pyromancer"
local is_nec = class == "Necromancer"
local is_arc = is_sor  or  is_cry  or  is_pyr  or  is_nec
local is_war = class == "Warrior"
local is_ran = class == "Ranger"
local is_pal = class == "Paladin"
local is_ant = class ~= nil and string.find(tostring(class), "Anti") ~= nil
local is_mon = class == "Monk"
local is_com = is_ran  or  is_pal  or  is_ant
local is_fig = is_war  or  is_mon  or  is_com
local is_rog = class == "Rogue"
local is_thi = class == "Thief"
local is_ass = class == "Assassin"
local is_mer = class == "Mercenary"
local is_bac = is_rog  or  is_thi  or  is_ass  or  is_mer
local is_cle = class == "Cleric"
local is_pri = class == "Priest"
local is_dia = class == "Diabolist"
local is_dru = class == "Druid"
local is_div = is_cle  or  is_pri  or  is_dia  or  is_dru
local is_mag = is_arc  or  is_div  or  is_com
local cir_2 = level >= 9
local cir_3 = level >= 17
local cir_4 = level >= 25
local cir_5 = level >= 33
local cir_6 = level >= 41
local cir_7 = level >= 49
local cir_8 = level >= 57
local cir_9 = level >= 65
local cir_10 = level >= 73
local cir_11 = level >= 81
local cir_12 = level >= 89
local cir_13 = level >= 97
wait(1)
local mode = random(1, 10)
-- Do fighter/rogue type stuff
if is_fig or is_bac then
    if (mode < 4) and ((is_ran and (level > 34)) or (is_war and (level > 14)) or ((is_ant or is_pal) and (level > 9))) then
        local max_tries = 5
        local attempted
        while max_tries > 0 do
            local victim = room.actors[random(1, #room.actors)]
            if victim and (victim.is_npc) and (victim.class ~= "Warrior") and (victim.class ~= "Ranger") and (not (string.find(victim.class, "Anti"))) and (victim.class ~= "Paladin") and (victim.class ~= "Monk") then
                combat.rescue(self, victim.name)
                attempted = 1
            end
            max_tries = max_tries - 1
        end
        if attempted then
            return true
        end
    end
    if (is_war or is_ran or is_pal or is_ant or is_mer) and (level - actor.level >= 0) and (self:get_worn("11") ~= -1) then
        skills.execute(self, "bash", self.fighting)
    elseif (is_ass or is_thi or (is_rog and (level > 9)) or (is_mer and (level > 10))) and (self:get_worn("16") ~= -1) then
        skills.execute(self, "backstab", self.fighting)
    elseif (is_war and (level > 49)) or ((is_pal or is_ant) and (level > 79)) then
        self:attack_all()
    elseif ((is_war or is_ran or is_pal or is_ant or is_mon or is_mer) and (level >= 1)) or (is_ass and (level >= 36)) then
        skills.execute(self, "kick", self.fighting)
    end
    return true
end
-- Initialize chance to do support spells (per-mob persistent)
if not globals.defensive then
    globals.defensive = 5
end
local defensive = globals.defensive
-- Per-mob spell cooldown timestamps (default to far past so first cast fires)
local barkskin = globals.barkskin or -9999
local armor = globals.armor or -9999
local demonskin = globals.demonskin or -9999
local demonic = globals.demonic or -9999
local mirage = globals.mirage or -9999
-- Attempt to cast support spells
if mode <= defensive then
    -- TODO(parity): the `not (flags ~= "HASTE")` guards below mean "the mob is
    -- already affected by HASTE" (i.e. don't recast). Re-derive once the
    -- runtime exposes a real affect-bitvector check.
    if ((is_nec and cir_7) or (is_arc and (not is_nec) and cir_6)) and (not (flags ~= "HASTE")) then
        spells.cast(self, "haste")
    elseif ((is_nec and cir_12) or (is_arc and (not is_nec) and cir_6)) and (not (flags ~= "STONE")) then
        spells.cast(self, "stone skin")
    elseif ((is_ran and cir_3) or is_dru) and (barkskin + 6 + (level / 10) < now) then
        spells.cast(self, "barkskin")
        globals.barkskin = now
    elseif (is_cle or (is_pal and cir_2) or is_pri) and (armor + 10 < now) then
        spells.cast(self, "armor")
        globals.armor = now
    elseif (is_dia or (is_ant and cir_2)) and (demonskin + 10 + (level / 40) < now) then
        spells.cast(self, "demonskin")
        globals.demonskin = now
    elseif is_dia and cir_4 and (demonic + 11 < now) then
        spells.cast(self, "demonic aspect")
        globals.demonic = now
    elseif is_pyr and cir_4 and (mirage + 10 < now) then
        spells.cast(self, "mirage")
        globals.mirage = now
    else
        mode = 6  -- fall through to offensive branch
    end
end
if mode > 5 then
    if (is_sor or is_cry) and cir_8 then
        spells.cast(self, "chain lightning")
    elseif is_pyr and cir_6 then
        spells.cast(self, "firestorm")
    elseif (is_sor or is_cry) and cir_6 then
        spells.cast(self, "ice storm")
    elseif (self.alignment > 350) and ((is_cle and cir_6) or (is_pri and cir_9) or (is_pal and cir_10)) then
        spells.cast(self, "holy word")
    elseif (self.alignment < -350) and ((is_cle and cir_6) or (is_dia and cir_9) or (is_ant and cir_11)) then
        spells.cast(self, "unholy word")
    elseif is_sor and cir_9 and mode <= 2 then
        spells.cast(self, "disintegrate")
        -- elseif is_cry% && %cir_9%
        -- cast 'iceball'
        -- elseif is_pyr% && %cir_9%
        -- cast 'immolate'
    elseif is_dru and cir_9 and ((not (string.find(actor.flags, "BLIND"))) or not outside) then
        spells.cast(self, "sunray")
    elseif is_sor and cir_7 then
        spells.cast(self, "bigbys clenched fist")
    elseif outside and is_dru and cir_7 then
        spells.cast(self, "call lightning")
    elseif (is_cle and cir_7) or ((is_pri or is_dia) and cir_10) then
        spells.cast(self, "full harm")
    elseif is_arc and (not is_nec) and cir_4 and (not (string.find(actor.flags, "ENFEEB"))) then
        spells.cast(self, "ray of enfeeblement")
    elseif outdoors and ((is_dru and cir_4) or (is_div and (not is_dru) and cir_5)) then
        spells.cast(self, "earthquake")
    elseif is_pyr and cir_7 and mode <= 2 then
        spells.cast(self, "melt")
    elseif is_dia and cir_7 and (not (string.find(actor.flags, "INSANITY"))) then
        spells.cast(self, "insanity")
    elseif is_pri and cir_6 and (actor.alignment < 350) then
        spells.cast(self, "divine ray")
    elseif is_dia and cir_6 then
        spells.cast(self, "stygian eruption")
    elseif is_nec and cir_5 then
        spells.cast(self, "energy drain")
    elseif (is_sor or is_cry) and cir_5 then
        spells.cast(self, "cone of cold")
    elseif (is_cle or is_dru) and cir_5 then
        spells.cast(self, "harm")
    elseif is_pyr and cir_5 then
        spells.cast(self, "heatwave")
    elseif (is_cle or is_pri) and cir_4 and (actor.alignment <= 350) then
        spells.cast(self, "dispel evil")
    elseif (is_cle or is_dia) and cir_4 and (actor.alignment >= 350) then
        spells.cast(self, "dispel good")
    elseif ((is_div and (not is_dru) and cir_4) or (is_ant and cir_6)) and (not (string.find(actor.flags, "BLIND"))) then
        spells.cast(self, "blindness")
    elseif (is_sor and cir_6) or (is_pyr and cir_4) then
        spells.cast(self, "fireball")
    elseif is_cle and cir_4 and (self.alignment >= 350) then
        spells.cast(self, "flamestrike")
    elseif (is_arc and (not is_pyr) and cir_4) or (is_dru and cir_6) then
        spells.cast(self, "lightning bolt")
    elseif is_pri and cir_3 and (self.alignment >= 350) and (actor.alignment < 350) then
        spells.cast(self, "divine bolt")
    elseif is_dia and cir_3 and (actor.alignment > 350) then
        spells.cast(self, "hell bolt")
    elseif is_div and (not is_dru) and cir_3 then
        spells.cast(self, "cause critical")
    elseif is_arc and (not is_pyr) and cir_3 then
        spells.cast(self, "shocking grasp")
    elseif is_pyr and cir_3 and (not (string.find(actor.flags, "BLIND"))) then
        spells.cast(self, "smoke")
    elseif is_dru and cir_3 then
        spells.cast(self, "writhing weeds")
    elseif is_div and (not is_dru) and cir_2 then
        spells.cast(self, "cause serious")
    elseif is_arc and (not is_pyr) and cir_2 then
        spells.cast(self, "chill touch")
    elseif is_pyr and cir_2 then
        spells.cast(self, "fire darts")
    elseif is_pyr then
        spells.cast(self, "burning hands")
    elseif is_cry then
        spells.cast(self, "ice darts")
    elseif is_arc then
        spells.cast(self, "magic missile")
    elseif is_div and not is_dru then
        spells.cast(self, "cause light")
    end
end
globals.action = now$trig$),
  -- data/triggers/188/188_91_summon_dragon.lua
  (188, 91, $trig$-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: summon
if not (cmd == "summon") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" or cmd == "su" then
    _return_value = true
    return _return_value
end
local last_summon = actor:get_quest_var("quest_items:dragonhelm_time")
-- timestamp() counts game hours (legacy time.stamp); 168 game hours == one MUD week.
local now = timestamp()
local can_summon = false
if last_summon then
    if now - last_summon >= 168 then
        can_summon = true
    else
        actor:send("You may only summon one mount per week!")
    end
else
    can_summon = true
end
if can_summon then
    local summoned
    -- The knight doesn't have a mount yet, allow them to get one
    if actor.class == "Paladin" then
        -- Knight is a paladin, give him/her a golden dragon
        self.room:spawn_mobile(188, 90)
        self.room:send_except(actor, "A brilliant golden dragon flies in from nowhere, and nuzzles " .. tostring(actor.name) .. "'s side.")
        actor:send("You begin calling for a mount..")
        actor:send("A brilliant golden dragon answers your summons.")
        summoned = "yes"
    elseif string.find(actor.class, "Anti") then
        -- Knight is an anti-paladin, give him/her a black dragon
        self.room:spawn_mobile(188, 91)
        self.room:send_except(actor, "A dusky black dragon flies in, seemingly from nowhere, and sits by " .. tostring(actor.name) .. "'s side.")
        actor:send("You begin calling for a mount..")
        actor:send("A dusky black dragon answers your summons.")
        summoned = "yes"
    else
        actor:send("You begin calling for a mount...but nothing happens.")
        self.room:send_except(actor, tostring(actor.name) .. " whistles loudly.")
    end
    -- Saddle up the dragon mount
    if summoned then
        local mount = self.room:find_actor("dragon-mount")
        if mount then mount:follow(actor.name) end
        self.room:spawn_mobile(188, 92)
        local squire = self.room:find_actor("dragonsquire")
        if squire then
            squire:spawn_object(188, 92)
            squire:command("give dragonsaddle dragon-mount")
            world.destroy(squire)
        end
        if mount then mount:command("wear dragonsaddle") end
        -- Timestamp the per-week cooldown
        actor:set_quest_var("quest_items", "dragonhelm_time", now)
    end
end
return _return_value$trig$),
  -- data/triggers/534/534_103_frost_elf_remove_blade.lua
  (534, 103, $trig$-- Converted from DG Script #53503: Frost elf remove blade
-- Original: MOB trigger, flags: RANDOM, probability: 100%
-- Sheathe the blade roughly a game hour after trigger 53502 drew it.
if globals.wielded then
    local now = timestamp()
    -- timestamp() counts game hours, as legacy `time.stamp` did.
    if now - 1 > globals.wielded then
        self:command("scan")
        wait(1)
        self:command("rem blade")
        self:command("wear blade belt")
        self:emote("returns to a more relaxed posture, watching the vicinity carefully.")
        globals.wielded = nil
    end
end$trig$),
  -- data/triggers/534/534_57_major_globe_elemental_greet.lua
  (534, 57, $trig$-- Converted from DG Script #53457: major_globe_elemental_greet
-- Original: MOB trigger, flags: GLOBAL, GREET_ALL, probability: 100%
--
-- When a questor with major_globe_spell stage 8 (or the relevant elemental
-- wand quest) approaches an elemental of the matching type, there's a 1-in-4
-- chance to spawn an elemental ward. After a non-load roll, lock out further
-- rolls for 2 minutes via globals.last_enter.

-- TODO(parity): mob ids below were legacy 5-digit vnums in the original DG
-- (e.g. 2328 = vnum 2328 plant elemental). Confirm they map to the same
-- composite (zone_id, local_id) values once mob proto migration finishes;
-- self.id alone may be ambiguous across zones.
local load_ward
local wand
if self.id == 2328 then
    -- plant elemental
    load_ward = 53
    wand = actor:get_quest_stage("acid_wand")
elseif self.id == 2806 or self.id == 2807 then
    -- mist elemental
    load_ward = 54
    wand = actor:get_quest_stage("air_wand")
elseif self.id == 2808 or self.id == 2809 or self.id == 48631 then
    -- water elemental
    load_ward = 55
elseif self.id == 5212 or self.id == 12523 or self.id == 48500 or self.id == 48511 or self.id == 48512 then
    -- flame elemental
    load_ward = 56
    wand = actor:get_quest_stage("fire_wand")
elseif self.id == 53312 or self.id == 53313 or self.id == 48630 or self.id == 48632 then
    -- ice elemental
    load_ward = 57
    wand = actor:get_quest_stage("ice_wand")
end
if actor:get_quest_stage("major_globe_spell") == 8 or wand == 8 then
    local now = timestamp()
    -- Roll only if first encounter or 2+ game hours since last non-load roll.
    local do_load = 0
    if globals.last_enter then
        if now - globals.last_enter >= 2 then
            do_load = random(1, 4)
        end
    else
        do_load = random(1, 4)
    end
    if do_load == 1 then
        if load_ward then
            self.room:spawn_object(534, load_ward)
            if actor:get_quest_stage("major_globe_spell") == 8 then
                actor:set_quest_var("major_globe_spell", "ward_" .. tostring(load_ward), 1)
            end
            wait(1)
            actor:send("<blue>" .. tostring(self.name) .. " flares briefly as you approach.</>")
            self.room:send_except(actor, "<blue>" .. tostring(self.name) .. " flares briefly as " .. tostring(actor.name) .. " approaches.</>")
        end
    else
        -- Save time stamp so questor must wait 2 minutes for next roll.
        globals.last_enter = now
    end
end$trig$),
  -- data/triggers/580/580_07_charm_person_instruments_command.lua
  (580, 7, $trig$local _return_value = true  -- Default: allow action
if actor:get_quest_stage("charm_person") == 4 then
    _return_value = true
    local room = actor.room
    -- switch on self.id
    if room:get_people(30, 10) then
        if self.id == 48925 then
            wait(2)
            self.room:send(tostring(mobiles.template(30, 10).name) .. " hums along dreamily.")
            actor:set_quest_var("charm_person", "charm1", 1)
            actor:send("<b:magenta>" .. tostring(mobiles.template(30, 10).name) .. " is charmed by your playing!</>")
        end
        if room:get_people(580, 17) then
        elseif self.id == 37012 then
            wait(2)
            self.room:send(tostring(mobiles.template(580, 17).name) .. " blushes furiously.")
            actor:set_quest_var("charm_person", "charm2", 1)
            actor:send("<b:magenta>" .. tostring(mobiles.template(580, 17).name) .. " is charmed by your playing!</>")
        end
        if room:get_people(584, 6) then
        elseif self.id == 41119 then
            wait(2)
            self.room:send(tostring(mobiles.template(584, 6).name) .. " sighs sweetly.")
            actor:set_quest_var("charm_person", "charm5", 1)
            actor:send("<b:magenta>" .. tostring(mobiles.template(584, 6).name) .. " is charmed by your playing!</>")
        end
        if room:get_people(43, 53) then
        elseif self.id == 16312 then
            wait(2)
            self.room:send(tostring(mobiles.template(43, 53).name) .. " closes her eyes and smiles.")
            actor:set_quest_var("charm_person", "charm3", 1)
            actor:send("<b:magenta>" .. tostring(mobiles.template(43, 53).name) .. " is charmed by your playing!</>")
        end
        if room:get_people(237, 21) then
        elseif self.id == 58017 then
            wait(2)
            self.room:send(tostring(mobiles.template(237, 21).name) .. " burbles with contentment.")
            actor:set_quest_var("charm_person", "charm4", 1)
            actor:send("<b:magenta>" .. tostring(mobiles.template(237, 21).name) .. " is charmed by your playing!</>")
        end
    end
    if actor:get_quest_var("charm_person:charm1") and actor:get_quest_var("charm_person:charm2") and actor:get_quest_var("charm_person:charm3") and actor:get_quest_var("charm_person:charm4") and actor:get_quest_var("charm_person:charm5") then
        wait(4)
        actor:send("Your skill in charming has greatly improved!")
        actor:send("Hinazuru's training has paid off!")
        actor:complete_quest("charm_person")
        actor:send("<b:magenta>You have learned Charm Person!</>")
        skills.set_level(actor.name, "charm person", 100)
    end
end
return _return_value$trig$)
) AS v(zone_id, id, commands)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
