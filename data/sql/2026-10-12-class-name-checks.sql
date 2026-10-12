-- Class name checks: actor.class is the lowercase class plain name (capitalized / 'anti' / '%anti%' comparisons never matched)
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
  -- data/triggers/002/002_102_phase_wands_bigby_research_assistant_receive.lua
  (2, 102, $trig$local _return_value = true

local quest_type, wandgem, wand, next_id
if object.id == 300 then
    quest_type, wandgem, wand, next_id = "air", 55577, true, 101
elseif object.id == 310 then
    quest_type, wandgem, wand, next_id = "fire", 55575, true, 111
elseif object.id == 320 then
    quest_type, wandgem, wand, next_id = "ice", 55574, true, 121
elseif object.id == 330 then
    quest_type, wandgem, wand, next_id = "acid", 55576, true, 131
elseif (object.zone_id == 555 and object.id == 77) then
    quest_type, wandgem = "air", true
elseif (object.zone_id == 555 and object.id == 75) then
    quest_type, wandgem = "fire", true
elseif (object.zone_id == 555 and object.id == 74) then
    quest_type, wandgem = "ice", true
elseif (object.zone_id == 555 and object.id == 76) then
    quest_type, wandgem = "acid", true
end
if not quest_type then
    return _return_value
end

local quest = quest_type .. "_wand"
local times = 50
local stage = actor:get_quest_stage(quest)

if stage == 2 then
    if wand then
        if actor:get_quest_var(quest .. ":wandtask1") and actor:get_quest_var(quest .. ":wandtask2") then
            actor:advance_quest(quest)
            actor:set_quest_var(quest, "greet", 0)
            actor:set_quest_var(quest, "attack_counter", 0)
            for n = 1, 5 do
                actor:set_quest_var(quest, "wandtask" .. tostring(n), 0)
            end
            wait(2)
            self:say("Fantastic work!  This is everything.")
            wait(1)
            self.room:send(tostring(self.name) .. " combines the materials to empower " .. tostring(object.shortdesc) .. "!")
            world.destroy(object)
            wait(2)
            actor:send(tostring(self.name) .. " presents you with a new wand!")
            self.room:spawn_object(2, next_id)
            self:command("give wand " .. tostring(actor.name))
            local expmod = 690
            if actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
                expmod = expmod + (expmod / 5)
            elseif actor.class == "necromancer" then
                expmod = expmod + ((expmod * 2) / 5)
            end
            actor:send("<b:yellow>You gain experience!</>")
            local setexp = expmod * 10
            for _ = 1, 5 do
                actor:award_exp(setexp)
            end
            wait(2)
            if actor.level < 20 then
                self:say("In time, you'll be able to take another step.  Come back when you've seen some more of the world.")
            else
                self:say("You're ready to take the next step.")
                wait(1)
                if quest_type == "air" then
                    self:say("Speak with the old Abbot in the Abbey of St. George.")
                elseif quest_type == "fire" then
                    self:say("The keeper of the temple to the dark flame out east will know what to do.")
                elseif quest_type == "ice" then
                    self:say("The shaman near Three-Falls River has developed a powerful affinity for water from his life in the canyons.  Seek his advice.")
                elseif quest_type == "acid" then
                    self:say("First, seek the one who guards the eastern gates of Ickle.")
                end
            end
        else
            self.room:send(tostring(self.name) .. " scrutinizes " .. tostring(object.shortdesc) .. " with suspicion.")
            wait(1)
            self.room:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. ".")
            self:say("You haven't finished all the tasks to prime the wand yet.")
        end
    elseif wandgem then
        actor:set_quest_var(quest, "wandtask2", 1)
        wait(2)
        world.destroy(object)
        self:say("Yes, this is exactly what I need!")
        wait(1)
        if actor:get_quest_var(quest .. ":wandtask1") then
            self:say("Give me the wand to improve.")
        else
            self:say("Keep practicing with your wand!")
            wait(2)
            self:say("Come back when you've attacked " .. tostring(times) .. " times.")
        end
    end
elseif (stage or 0) < 2 then
    if wand then
        wait(2)
        if not stage then
            actor:start_quest(quest)
            self:say("I can upgrade your " .. quest_type .. " wand!  But what I will do is just the first step in a life-long journey.")
            wait(2)
            self.room:send(tostring(self.name) .. " says, 'This step is relatively simple though.  You can check your <b:cyan>[wand progress]</> with me as well.'")
            wait(1)
        end
        actor:advance_quest(quest)
        self:command("nod")
        self:say("Yes, this is a good match for you.")
        wait(1)
        self:say("To upgrade your wand:")
        self.room:send("- attack <b:yellow>" .. tostring(times) .. "</> times with it")
        self.room:send("- bring me <b:yellow>" .. tostring(objects.template(555, wandgem - 55520).name) .. "</>")
        wait(2)
        self:say("Do that and I'll be able to improve it.")
        self:command("give wand " .. tostring(actor.name))
    elseif wandgem then
        self.room:send(tostring(self.name) .. " declines " .. tostring(object.shortdesc) .. ".")
        wait(1)
        self:say("Before you give me anything else, give me the wand you wish to improve.")
    end
else
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:say("I've already upgraded your wand as much as I know how.")
end
return _return_value$trig$, 'e89fcd676e0fd787a85bc257517bb0cc'),
  -- data/triggers/002/002_127_phase_wand_play.lua
  (2, 127, $trig$local _return_value = true

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
return _return_value$trig$, 'cc22ff238752e5261aafd89bd8216a9b'),
  -- data/triggers/004/004_12_guild_armor_phase_two_progress_journal.lua
  (4, 12, $trig$-- Converted from DG Script #412: Guild Armor Phase Two progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if ((string.find(arg, "guild") or string.find(arg, "phase") or string.find(arg, "armor")) and (string.find(arg, "two") or string.find(arg, "2"))) or string.find(arg, "guild_armor_phase_two") or string.find(arg, "guild_armor_phase_2") or string.find(arg, "phase_armor_two") or string.find(arg, "phase_armor_2") then
    _return_value = true
    actor:send("<b:green>&uGuild Armor Phase Two</>")
    actor:send("Mininum Level: 21")
    actor:send("Items for this quest drop from mobs between level 21 and 40.")
    if actor:get_quest_stage("phase_armor") > 1 then
        local sorcererclasses = "Sorcerer Cryomancer Pyromancer Illusionist"
        local clericclasses = "Cleric Priest"
        local rogueclasses = "Rogue Mercenary Assassin Thief"
        local anti = "Anti-Paladin"
        local master
        if string.find(sorcererclasses, actor.class) then
            local feet_gem = 55613
            local head_gem = 55635
            local hands_gem = 55602
            local arms_gem = 55646
            local legs_gem = 55657
            local body_gem = 55668
            local wrist_gem = 55624
            local feet_armor = 55335
            local head_armor = 55343
            local hands_armor = 55331
            local arms_armor = 55347
            local legs_armor = 55351
            local body_armor = 55355
            local wrist_armor = 55339
            local feet_reward = 55479
            local head_reward = 55475
            local hands_reward = 55481
            local arms_reward = 55476
            local legs_reward = 55478
            local body_reward = 55477
            local wrist_reward = 55480
            if string.find(actor.class, "Sorcerer") then
                master = "the Archmage of Ickle"
            elseif string.find(actor.class, "Cryomancer") then
                master = "the Archmage of Ickle, the High Cryomancer, and the master cryomancer"
            elseif string.find(actor.class, "Pyromancer") then
                master = "the Archmage of Ickle, the High Pyromancer, and the master pyromancer"
            elseif string.find(actor.class, "Illusionist") then
                master = "the Archmage of Ickle, Erasmus, and Esh"
            end
        elseif string.find(actor.class, "Necromancer") then
            local feet_gem = 55609
            local head_gem = 55631
            local hands_gem = 55598
            local arms_gem = 55642
            local legs_gem = 55653
            local body_gem = 55664
            local wrist_gem = 55620
            local feet_armor = 55335
            local head_armor = 55343
            local hands_armor = 55331
            local arms_armor = 55347
            local legs_armor = 55351
            local body_armor = 55355
            local wrist_armor = 55339
            local feet_reward = 55458
            local head_reward = 55454
            local hands_reward = 55460
            local arms_reward = 55455
            local legs_reward = 55457
            local body_reward = 55456
            local wrist_reward = 55459
            master = "Asiri'Qaxt and Schkerra"
        elseif string.find(clericclasses, actor.class) then
            local feet_gem = 55612
            local head_gem = 55634
            local hands_gem = 55601
            local arms_gem = 55645
            local legs_gem = 55656
            local body_gem = 55667
            local wrist_gem = 55623
            local feet_armor = 55332
            local head_armor = 55340
            local hands_armor = 55328
            local arms_armor = 55344
            local legs_armor = 55348
            local body_armor = 55352
            local wrist_armor = 55336
            local feet_reward = 55437
            local head_reward = 55433
            local hands_reward = 55439
            local arms_reward = 55434
            local legs_reward = 55436
            local body_reward = 55435
            local wrist_reward = 55438
            master = "the High Priestess of Anduin and Zeno the Priest"
        elseif string.find(actor.class, "Diabolist") then
            local feet_gem = 55606
            local head_gem = 55628
            local hands_gem = 55595
            local arms_gem = 55639
            local legs_gem = 55650
            local body_gem = 55661
            local wrist_gem = 55617
            local feet_armor = 55332
            local head_armor = 55340
            local hands_armor = 55328
            local arms_armor = 55344
            local legs_armor = 55348
            local body_armor = 55352
            local wrist_armor = 55336
            local feet_reward = 55472
            local head_reward = 55468
            local hands_reward = 55474
            local arms_reward = 55469
            local legs_reward = 55471
            local body_reward = 55470
            local wrist_reward = 55473
            master = "the Black Priestess"
        elseif string.find(actor.class, "Druid") then
            local feet_gem = 55607
            local head_gem = 55629
            local hands_gem = 55596
            local arms_gem = 55640
            local legs_gem = 55651
            local body_gem = 55662
            local wrist_gem = 55618
            local feet_armor = 55334
            local head_armor = 55342
            local hands_armor = 55330
            local arms_armor = 55346
            local legs_armor = 55350
            local body_armor = 55354
            local wrist_armor = 55338
            local feet_reward = 55451
            local head_reward = 55447
            local hands_reward = 55453
            local arms_reward = 55448
            local legs_reward = 55450
            local body_reward = 55449
            local wrist_reward = 55452
            master = "the Black Priestess and the diabolist"
        elseif string.find(actor.class, "Warrior") then
            local feet_gem = 55615
            local head_gem = 55637
            local hands_gem = 55604
            local arms_gem = 55648
            local legs_gem = 55659
            local body_gem = 55670
            local wrist_gem = 55626
            local feet_armor = 55332
            local head_armor = 55340
            local hands_armor = 55328
            local arms_armor = 55344
            local legs_armor = 55348
            local body_armor = 55352
            local wrist_armor = 55336
            local feet_reward = 55416
            local head_reward = 55412
            local hands_reward = 55418
            local arms_reward = 55413
            local legs_reward = 55415
            local body_reward = 55414
            local wrist_reward = 55417
            master = "the high druid and a serene druidess"
        elseif actor.class == "anti-paladin" then
            local feet_gem = 55605
            local head_gem = 55627
            local hands_gem = 55594
            local arms_gem = 55638
            local legs_gem = 55649
            local body_gem = 55660
            local wrist_gem = 55616
            local feet_armor = 55332
            local head_armor = 55340
            local hands_armor = 55328
            local arms_armor = 55344
            local legs_armor = 55348
            local body_armor = 55352
            local wrist_armor = 55336
            local feet_reward = 55430
            local head_reward = 55426
            local hands_reward = 55432
            local arms_reward = 55427
            local legs_reward = 55429
            local body_reward = 55428
            local wrist_reward = 55431
            master = "the warrior coach of Anduin"
        elseif string.find(actor.class, "Ranger") then
            local feet_gem = 55611
            local head_gem = 55633
            local hands_gem = 55600
            local arms_gem = 55644
            local legs_gem = 55655
            local body_gem = 55666
            local wrist_gem = 55622
            local feet_armor = 55333
            local head_armor = 55341
            local hands_armor = 55329
            local arms_armor = 55345
            local legs_armor = 55349
            local body_armor = 55353
            local wrist_armor = 55337
            local feet_reward = 55444
            local head_reward = 55440
            local hands_reward = 55446
            local arms_reward = 55441
            local legs_reward = 55443
            local body_reward = 55442
            local wrist_reward = 55445
            master = "Galithel Silverwing"
        elseif actor.class == "paladin" then
            local feet_gem = 55610
            local head_gem = 55632
            local hands_gem = 55599
            local arms_gem = 55643
            local legs_gem = 55654
            local body_gem = 55665
            local wrist_gem = 55621
            local feet_armor = 55332
            local head_armor = 55340
            local hands_armor = 55328
            local arms_armor = 55344
            local legs_armor = 55348
            local body_armor = 55352
            local wrist_armor = 55336
            local feet_reward = 55423
            local head_reward = 55419
            local hands_reward = 55425
            local arms_reward = 55420
            local legs_reward = 55422
            local body_reward = 55421
            local wrist_reward = 55424
            master = "the Grey Knight"
        elseif string.find(actor.class, "Monk") then
            local feet_gem = 55608
            local head_gem = 55630
            local hands_gem = 55597
            local arms_gem = 55641
            local legs_gem = 55652
            local body_gem = 55663
            local wrist_gem = 55619
            local feet_armor = 55334
            local head_armor = 55342
            local hands_armor = 55330
            local arms_armor = 55346
            local legs_armor = 55350
            local body_armor = 55354
            local wrist_armor = 55338
            local feet_reward = 55465
            local head_reward = 55461
            local hands_reward = 55467
            local arms_reward = 55462
            local legs_reward = 55464
            local body_reward = 55463
            local wrist_reward = 55466
            master = "the Head Monk"
        elseif string.find(actor.class, "Berserker") then
            local feet_gem = 55607
            local head_gem = 55631
            local hands_gem = 55595
            local arms_gem = 55638
            local legs_gem = 55655
            local body_gem = 55665
            local wrist_gem = 55619
            local feet_armor = 55334
            local head_armor = 55342
            local hands_armor = 55330
            local arms_armor = 55346
            local legs_armor = 55350
            local body_armor = 55354
            local wrist_armor = 55338
            local feet_reward = 55771
            local head_reward = 55767
            local hands_reward = 55773
            local arms_reward = 55768
            local legs_reward = 55770
            local body_reward = 55769
            local wrist_reward = 55772
            master = "Tozug, Khargol, Jora Granitearm"
        elseif string.find(rogueclasses, actor.class) then
            local feet_gem = 55614
            local head_gem = 55636
            local hands_gem = 55603
            local arms_gem = 55647
            local legs_gem = 55658
            local body_gem = 55669
            local wrist_gem = 55625
            local feet_armor = 55333
            local head_armor = 55341
            local hands_armor = 55329
            local arms_armor = 55345
            local legs_armor = 55349
            local body_armor = 55353
            local wrist_armor = 55337
            local feet_reward = 55486
            local head_reward = 55482
            local hands_reward = 55488
            local arms_reward = 55483
            local legs_reward = 55485
            local body_reward = 55484
            local wrist_reward = 55487
            master = "Princess Signess, Haren, and Blackhaven"
        elseif string.find(actor.class, "Bard") then
            local feet_gem = 55606
            local head_gem = 55630
            local hands_gem = 55600
            local arms_gem = 55640
            local legs_gem = 55649
            local body_gem = 55664
            local wrist_gem = 55621
            local feet_armor = 55334
            local head_armor = 55342
            local hands_armor = 55330
            local arms_armor = 55346
            local legs_armor = 55350
            local body_armor = 55354
            local wrist_armor = 55338
            local feet_reward = 55785
            local head_reward = 55781
            local hands_reward = 55787
            local arms_reward = 55782
            local legs_reward = 55784
            local body_reward = 55783
            local wrist_reward = 55786
            master = "the Master Herald and the Bard Union Master"
        end
        local got_hands = actor:get_quest_var("phase_armor:hands_armor_armor_acquired")
        local got_feet = actor:get_quest_var("phase_armor:feet_armor_armor_acquired")
        local got_wrist = actor:get_quest_var("phase_armor:wrist_armor_armor_acquired")
        local got_head = actor:get_quest_var("phase_armor:head_armor_armor_acquired")
        local got_arms = actor:get_quest_var("phase_armor:arms_armor_armor_acquired")
        local got_legs = actor:get_quest_var("phase_armor:legs_armor_armor_acquired")
        local got_body = actor:get_quest_var("phase_armor:body_armor_armor_acquired")
        local hands_count = actor:get_quest_var("phase_armor:hands_gem_gems_acquired")
        local feet_count = actor:get_quest_var("phase_armor:feet_gem_gems_acquired")
        local wrist_count = actor:get_quest_var("phase_armor:wrist_gem_gems_acquired")
        local head_count = actor:get_quest_var("phase_armor:head_gem_gems_acquired")
        local arms_count = actor:get_quest_var("phase_armor:arms_gem_gems_acquired")
        local legs_count = actor:get_quest_var("phase_armor:legs_gem_gems_acquired")
        local body_count = actor:get_quest_var("phase_armor:body_gem_gems_acquired")
        local done_hands = got_hands == 1  and  hands_count == 3
        local done_feet = got_feet == 1  and  feet_count == 3
        local done_wrist = got_wrist == 1  and  wrist_count == 3
        local done_head = got_head == 1  and  head_count == 3
        local done_arms = got_arms == 1  and  arms_count == 3
        local done_legs = got_legs == 1  and  legs_count == 3
        local done_body = got_body == 1  and  body_count == 3
        local given = got_hands + got_feet + got_wrist + got_head + got_arms + got_legs + got_body
        given = given + hands_count + feet_count + wrist_count + head_count + arms_count + legs_count + body_count
        local unrewarded = (got_hands + hands_count  ~=  4) + (got_feet + feet_count  ~=  4) + (got_wrist + wrist_count  ~=  4)
        unrewarded = unrewarded + (got_head + head_count  ~=  4) + (got_arms + arms_count  ~=  4)
        unrewarded = unrewarded + (got_legs + legs_count  ~=  4) + (got_body + body_count  ~=  4)
        if done_hands and done_feet and done_wrist and done_head and done_arms and done_legs and done_body then
            actor:send("<cyan>Status: Completed!</>")
            return _return_value
        end
        actor:send("<cyan>Status: In Progress</>")
        actor:send("Quest Master is: " .. tostring(master))
        actor:send("You need to retrieve:")
        actor:send("</>  " .. "%get.obj_shortdesc[%hands_armor%]% and 3 of %get.obj_shortdesc[%hands_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%feet_armor%]% and 3 of %get.obj_shortdesc[%feet_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%wrist_armor%]% and 3 of %get.obj_shortdesc[%wrist_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%head_armor%]% and 3 of %get.obj_shortdesc[%head_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%arms_armor%]% and 3 of %get.obj_shortdesc[%arms_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%legs_armor%]% and 3 of %get.obj_shortdesc[%legs_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%body_armor%]% and 3 of %get.obj_shortdesc[%body_gem%]%")
        if not given then
            actor:send("You haven't retrieved anything yet.")
            return _return_value
        elseif unrewarded then
            actor:send("You have found:")
        end
        if got_hands and not done_hands then
            actor:send("</>  " .. "%get.obj_shortdesc[%hands_armor%]%")
        end
        if hands_count and not done_hands then
            actor:send("</>  " .. tostring(hands_count) .. " of " .. "%get.obj_shortdesc[%hands_gem%]%")
        end
        if got_feet and not done_feet then
            actor:send("</>  " .. "%get.obj_shortdesc[%feet_armor%]%")
        end
        if feet_count and not done_feet then
            actor:send("</>  " .. tostring(feet_count) .. " of " .. "%get.obj_shortdesc[%feet_gem%]%")
        end
        if got_wrist and not done_wrist then
            actor:send("</>  " .. "%get.obj_shortdesc[%wrist_armor%]%")
        end
        if wrist_count and not done_wrist then
            actor:send("</>  " .. tostring(wrist_count) .. " of " .. "%get.obj_shortdesc[%wrist_gem%]%")
        end
        if got_head and not done_head then
            actor:send("</>  " .. "%get.obj_shortdesc[%head_armor%]%")
        end
        if head_count and not done_head then
            actor:send("</>  " .. tostring(head_count) .. " of " .. "%get.obj_shortdesc[%head_gem%]%")
        end
        if got_arms and not done_arms then
            actor:send("</>  " .. "%get.obj_shortdesc[%arms_armor%]%")
        end
        if arms_count and not done_arms then
            actor:send("</>  " .. tostring(arms_count) .. " of " .. "%get.obj_shortdesc[%arms_gem%]%")
        end
        if got_legs and not done_legs then
            actor:send("</>  " .. "%get.obj_shortdesc[%legs_armor%]%")
        end
        if legs_count and not done_legs then
            actor:send("</>  " .. tostring(legs_count) .. " of " .. "%get.obj_shortdesc[%legs_gem%]%")
        end
        if got_body and not done_body then
            actor:send("</>  " .. "%get.obj_shortdesc[%body_armor%]%")
        end
        if body_count and not done_body then
            actor:send("</>  " .. tostring(body_count) .. " of " .. "%get.obj_shortdesc[%body_gem%]%")
        end
        if done_hands and done_feet and done_wrist and done_head and done_arms and done_legs and done_body then
            actor:send("</>")
            actor:send("You have completed quests for:")
        end
        if done_hands then
            actor:send("</>  " .. "%get.obj_shortdesc[%hands_reward%]%")
        end
        if done_feet then
            actor:send("</>  " .. "%get.obj_shortdesc[%feet_reward%]%")
        end
        if done_wrist then
            actor:send("</>  " .. "%get.obj_shortdesc[%wrist_reward%]%")
        end
        if done_head then
            actor:send("</>  " .. "%get.obj_shortdesc[%head_reward%]%")
        end
        if done_arms then
            actor:send("</>  " .. "%get.obj_shortdesc[%arms_reward%]%")
        end
        if done_legs then
            actor:send("</>  " .. "%get.obj_shortdesc[%legs_reward%]%")
        end
        if done_body then
            actor:send("</>  " .. "%get.obj_shortdesc[%body_reward%]%")
        end
    else
        actor:send("<cyan>Status: Not Started</>")
    end
end
return _return_value$trig$, '901b8f99a34aa02bff9521ebfce6035a'),
  -- data/triggers/004/004_13_guild_armor_phase_three_progress_journal.lua
  (4, 13, $trig$-- Converted from DG Script #413: Guild Armor Phase Three progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if ((string.find(arg, "guild") or string.find(arg, "phase") or string.find(arg, "armor")) and (string.find(arg, "three") or string.find(arg, "3"))) or string.find(arg, "guild_armor_phase_three") or string.find(arg, "guild_armor_phase_3") or string.find(arg, "phase_armor_three") or string.find(arg, "phase_armor_3") then
    _return_value = true
    actor:send("<b:green>&uGuild Armor Phase Three</>")
    actor:send("Mininum Level: 41")
    actor:send("Items for this quest drop from mobs above level 41.")
    if actor:get_quest_stage("phase_armor") > 2 then
        local sorcererclasses = "Sorcerer Cryomancer Pyromancer Illusionist"
        local clericclasses = "Cleric Priest"
        local rogueclasses = "Rogue Mercenary Assassin Thief"
        local anti = "Anti-Paladin"
        local master
        if string.find(sorcererclasses, actor.class) then
            local feet_gem = 55690
            local head_gem = 55712
            local hands_gem = 55679
            local arms_gem = 55723
            local legs_gem = 55734
            local body_gem = 55745
            local wrist_gem = 55701
            local feet_armor = 55363
            local head_armor = 55371
            local hands_armor = 55359
            local arms_armor = 55375
            local legs_armor = 55379
            local body_armor = 55383
            local wrist_armor = 55367
            local feet_reward = 55556
            local head_reward = 55552
            local hands_reward = 55558
            local arms_reward = 55553
            local legs_reward = 55555
            local body_reward = 55554
            local wrist_reward = 55557
            if string.find(actor.class, "Sorcerer") then
                master = "the Archmage of Anduin"
            elseif string.find(actor.class, "Cryomancer") then
                master = "a cryomancer in Anduin"
            elseif string.find(actor.class, "Pyromancer") then
                master = "a pyromancer in Anduin"
            elseif string.find(actor.class, "Illusionist") then
                master = "Aylana in Anduin"
            end
        elseif string.find(actor.class, "Necromancer") then
            local feet_gem = 55686
            local head_gem = 55708
            local hands_gem = 55675
            local arms_gem = 55719
            local legs_gem = 55730
            local body_gem = 55741
            local wrist_gem = 55697
            local feet_armor = 55363
            local head_armor = 55371
            local hands_armor = 55359
            local arms_armor = 55375
            local legs_armor = 55379
            local body_armor = 55383
            local wrist_armor = 55367
            local feet_reward = 55535
            local head_reward = 55531
            local hands_reward = 55537
            local arms_reward = 55532
            local legs_reward = 55534
            local body_reward = 55533
            local wrist_reward = 55536
            master = "a necromancer in Anduin"
        elseif string.find(clericclasses, actor.class) then
            local feet_gem = 55689
            local head_gem = 55711
            local hands_gem = 55678
            local arms_gem = 55722
            local legs_gem = 55733
            local body_gem = 55744
            local wrist_gem = 55700
            local feet_armor = 55360
            local head_armor = 55368
            local hands_armor = 55356
            local arms_armor = 55372
            local legs_armor = 55376
            local body_armor = 55380
            local wrist_armor = 55364
            local feet_reward = 55514
            local head_reward = 55510
            local hands_reward = 55516
            local arms_reward = 55511
            local legs_reward = 55513
            local body_reward = 55512
            local wrist_reward = 55515
            master = "the High Priest Zalish"
        elseif string.find(actor.class, "Diabolist") then
            local feet_gem = 55683
            local head_gem = 55705
            local hands_gem = 55672
            local arms_gem = 55716
            local legs_gem = 55727
            local body_gem = 55738
            local wrist_gem = 55694
            local feet_armor = 55360
            local head_armor = 55368
            local hands_armor = 55356
            local arms_armor = 55372
            local legs_armor = 55376
            local body_armor = 55380
            local wrist_armor = 55364
            local feet_reward = 55549
            local head_reward = 55545
            local hands_reward = 55551
            local arms_reward = 55546
            local legs_reward = 55548
            local body_reward = 55547
            local wrist_reward = 55550
            master = "Ruin Wormheart"
        elseif string.find(actor.class, "Druid") then
            local feet_gem = 55684
            local head_gem = 55706
            local hands_gem = 55673
            local arms_gem = 55717
            local legs_gem = 55728
            local body_gem = 55739
            local wrist_gem = 55695
            local feet_armor = 55362
            local head_armor = 55370
            local hands_armor = 55358
            local arms_armor = 55374
            local legs_armor = 55378
            local body_armor = 55382
            local wrist_armor = 55366
            local feet_reward = 55528
            local head_reward = 55524
            local hands_reward = 55530
            local arms_reward = 55525
            local legs_reward = 55527
            local body_reward = 55526
            local wrist_reward = 55529
            master = "the Heirophant"
        elseif string.find(actor.class, "Warrior") then
            local feet_gem = 55692
            local head_gem = 55714
            local hands_gem = 55681
            local arms_gem = 55725
            local legs_gem = 55736
            local body_gem = 55747
            local wrist_gem = 55703
            local feet_armor = 55360
            local head_armor = 55368
            local hands_armor = 55356
            local arms_armor = 55372
            local legs_armor = 55376
            local body_armor = 55380
            local wrist_armor = 55364
            local feet_reward = 55493
            local head_reward = 55489
            local hands_reward = 55495
            local arms_reward = 55490
            local legs_reward = 55492
            local body_reward = 55491
            local wrist_reward = 55494
            master = "the Warrior Coach in Ickle"
        elseif actor.class == "anti-paladin" then
            local feet_gem = 55682
            local head_gem = 55704
            local hands_gem = 55671
            local arms_gem = 55715
            local legs_gem = 55726
            local body_gem = 55737
            local wrist_gem = 55693
            local feet_armor = 55360
            local head_armor = 55368
            local hands_armor = 55356
            local arms_armor = 55372
            local legs_armor = 55376
            local body_armor = 55380
            local wrist_armor = 55364
            local feet_reward = 55507
            local head_reward = 55503
            local hands_reward = 55509
            local arms_reward = 55504
            local legs_reward = 55506
            local body_reward = 55505
            local wrist_reward = 55508
            master = "the Avatar of Zzur"
        elseif string.find(actor.class, "Ranger") then
            local feet_gem = 55688
            local head_gem = 55710
            local hands_gem = 55677
            local arms_gem = 55721
            local legs_gem = 55732
            local body_gem = 55743
            local wrist_gem = 55699
            local feet_armor = 55361
            local head_armor = 55369
            local hands_armor = 55357
            local arms_armor = 55373
            local legs_armor = 55377
            local body_armor = 55381
            local wrist_armor = 55365
            local feet_reward = 55521
            local head_reward = 55517
            local hands_reward = 55523
            local arms_reward = 55518
            local legs_reward = 55520
            local body_reward = 55519
            local wrist_reward = 55522
            master = "the Avatar of Haddixx"
        elseif actor.class == "paladin" then
            local feet_gem = 55687
            local head_gem = 55709
            local hands_gem = 55676
            local arms_gem = 55720
            local legs_gem = 55731
            local body_gem = 55742
            local wrist_gem = 55698
            local feet_armor = 55360
            local head_armor = 55368
            local hands_armor = 55356
            local arms_armor = 55372
            local legs_armor = 55376
            local body_armor = 55380
            local wrist_armor = 55364
            local feet_reward = 55500
            local head_reward = 55496
            local hands_reward = 55502
            local arms_reward = 55497
            local legs_reward = 55499
            local body_reward = 55498
            local wrist_reward = 55501
            master = "Belward"
        elseif string.find(actor.class, "Monk") then
            local feet_gem = 55685
            local head_gem = 55707
            local hands_gem = 55674
            local arms_gem = 55718
            local legs_gem = 55729
            local body_gem = 55740
            local wrist_gem = 55696
            local feet_armor = 55362
            local head_armor = 55370
            local hands_armor = 55358
            local arms_armor = 55374
            local legs_armor = 55378
            local body_armor = 55382
            local wrist_armor = 55366
            local feet_reward = 55542
            local head_reward = 55538
            local hands_reward = 55544
            local arms_reward = 55539
            local legs_reward = 55541
            local body_reward = 55540
            local wrist_reward = 55543
            master = "the Almoner"
        elseif string.find(actor.class, "Berserker") then
            local feet_gem = 55686
            local head_gem = 55710
            local hands_gem = 55672
            local arms_gem = 55717
            local legs_gem = 55726
            local body_gem = 55742
            local wrist_gem = 55696
            local feet_armor = 55362
            local head_armor = 55370
            local hands_armor = 55358
            local arms_armor = 55374
            local legs_armor = 55378
            local body_armor = 55382
            local wrist_armor = 55366
            local feet_reward = 55778
            local head_reward = 55774
            local hands_reward = 55780
            local arms_reward = 55775
            local legs_reward = 55777
            local body_reward = 55776
            local wrist_reward = 55779
            master = "Avaldr Mountainhelm"
        elseif string.find(rogueclasses, actor.class) then
            local feet_gem = 55691
            local head_gem = 55713
            local hands_gem = 55680
            local arms_gem = 55724
            local legs_gem = 55735
            local body_gem = 55746
            local wrist_gem = 55702
            local feet_armor = 55361
            local head_armor = 55369
            local hands_armor = 55357
            local arms_armor = 55373
            local legs_armor = 55377
            local body_armor = 55381
            local wrist_armor = 55365
            local feet_reward = 55563
            local head_reward = 55559
            local hands_reward = 55565
            local arms_reward = 55560
            local legs_reward = 55562
            local body_reward = 55561
            local wrist_reward = 55564
            master = "an Elite Mercenary in Ickle"
        elseif string.find(actor.class, "Bard") then
            local feet_gem = 55685
            local head_gem = 55708
            local hands_gem = 55671
            local arms_gem = 55720
            local legs_gem = 55728
            local body_gem = 55743
            local wrist_gem = 55694
            local feet_armor = 55362
            local head_armor = 55370
            local hands_armor = 55358
            local arms_armor = 55374
            local legs_armor = 55378
            local body_armor = 55382
            local wrist_armor = 55366
            local feet_reward = 55792
            local head_reward = 55788
            local hands_reward = 55794
            local arms_reward = 55789
            local legs_reward = 55791
            local body_reward = 55790
            local wrist_reward = 55793
            master = "Grand Diva Belissica"
        end
        local got_hands = actor:get_quest_var("phase_armor:hands_armor_armor_acquired")
        local got_feet = actor:get_quest_var("phase_armor:feet_armor_armor_acquired")
        local got_wrist = actor:get_quest_var("phase_armor:wrist_armor_armor_acquired")
        local got_head = actor:get_quest_var("phase_armor:head_armor_armor_acquired")
        local got_arms = actor:get_quest_var("phase_armor:arms_armor_armor_acquired")
        local got_legs = actor:get_quest_var("phase_armor:legs_armor_armor_acquired")
        local got_body = actor:get_quest_var("phase_armor:body_armor_armor_acquired")
        local hands_count = actor:get_quest_var("phase_armor:hands_gem_gems_acquired")
        local feet_count = actor:get_quest_var("phase_armor:feet_gem_gems_acquired")
        local wrist_count = actor:get_quest_var("phase_armor:wrist_gem_gems_acquired")
        local head_count = actor:get_quest_var("phase_armor:head_gem_gems_acquired")
        local arms_count = actor:get_quest_var("phase_armor:arms_gem_gems_acquired")
        local legs_count = actor:get_quest_var("phase_armor:legs_gem_gems_acquired")
        local body_count = actor:get_quest_var("phase_armor:body_gem_gems_acquired")
        local done_hands = got_hands == 1  and  hands_count == 3
        local done_feet = got_feet == 1  and  feet_count == 3
        local done_wrist = got_wrist == 1  and  wrist_count == 3
        local done_head = got_head == 1  and  head_count == 3
        local done_arms = got_arms == 1  and  arms_count == 3
        local done_legs = got_legs == 1  and  legs_count == 3
        local done_body = got_body == 1  and  body_count == 3
        local given = got_hands + got_feet + got_wrist + got_head + got_arms + got_legs + got_body
        given = given + hands_count + feet_count + wrist_count + head_count + arms_count + legs_count + body_count
        local unrewarded = (got_hands + hands_count  ~=  4) + (got_feet + feet_count  ~=  4) + (got_wrist + wrist_count  ~=  4)
        unrewarded = unrewarded + (got_head + head_count  ~=  4) + (got_arms + arms_count  ~=  4)
        unrewarded = unrewarded + (got_legs + legs_count  ~=  4) + (got_body + body_count  ~=  4)
        if done_hands and done_feet and done_wrist and done_head and done_arms and done_legs and done_body then
            actor:send("<cyan>Status: Completed</>")
            return _return_value
        end
        actor:send("<cyan>Status: In Progress</>")
        actor:send("Quest Master is: " .. tostring(master))
        actor:send("You need to retrieve:")
        actor:send("</>  " .. "%get.obj_shortdesc[%hands_armor%]% and 3 of %get.obj_shortdesc[%hands_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%feet_armor%]% and 3 of %get.obj_shortdesc[%feet_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%wrist_armor%]% and 3 of %get.obj_shortdesc[%wrist_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%head_armor%]% and 3 of %get.obj_shortdesc[%head_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%arms_armor%]% and 3 of %get.obj_shortdesc[%arms_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%legs_armor%]% and 3 of %get.obj_shortdesc[%legs_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%body_armor%]% and 3 of %get.obj_shortdesc[%body_gem%]%")
        if not given then
            actor:send("You haven't retrieved anything yet.")
            return _return_value
        elseif unrewarded then
            actor:send("You have found:")
        end
        if got_hands and not done_hands then
            actor:send("</>  " .. "%get.obj_shortdesc[%hands_armor%]%")
        end
        if hands_count and not done_hands then
            actor:send("</>  " .. tostring(hands_count) .. " of " .. "%get.obj_shortdesc[%hands_gem%]%")
        end
        if got_feet and not done_feet then
            actor:send("</>  " .. "%get.obj_shortdesc[%feet_armor%]%")
        end
        if feet_count and not done_feet then
            actor:send("</>  " .. tostring(feet_count) .. " of " .. "%get.obj_shortdesc[%feet_gem%]%")
        end
        if got_wrist and not done_wrist then
            actor:send("</>  " .. "%get.obj_shortdesc[%wrist_armor%]%")
        end
        if wrist_count and not done_wrist then
            actor:send("</>  " .. tostring(wrist_count) .. " of " .. "%get.obj_shortdesc[%wrist_gem%]%")
        end
        if got_head and not done_head then
            actor:send("</>  " .. "%get.obj_shortdesc[%head_armor%]%")
        end
        if head_count and not done_head then
            actor:send("</>  " .. tostring(head_count) .. " of " .. "%get.obj_shortdesc[%head_gem%]%")
        end
        if got_arms and not done_arms then
            actor:send("</>  " .. "%get.obj_shortdesc[%arms_armor%]%")
        end
        if arms_count and not done_arms then
            actor:send("</>  " .. tostring(arms_count) .. " of " .. "%get.obj_shortdesc[%arms_gem%]%")
        end
        if got_legs and not done_legs then
            actor:send("</>  " .. "%get.obj_shortdesc[%legs_armor%]%")
        end
        if legs_count and not done_legs then
            actor:send("</>  " .. tostring(legs_count) .. " of " .. "%get.obj_shortdesc[%legs_gem%]%")
        end
        if got_body and not done_body then
            actor:send("</>  " .. "%get.obj_shortdesc[%body_armor%]%")
        end
        if body_count and not done_body then
            actor:send("</>  " .. tostring(body_count) .. " of " .. "%get.obj_shortdesc[%body_gem%]%")
        end
        if done_hands and done_feet and done_wrist and done_head and done_arms and done_legs and done_body then
            actor:send("</>")
            actor:send("You have completed quests for:")
        end
        if done_hands then
            actor:send("</>  " .. "%get.obj_shortdesc[%hands_reward%]%")
        end
        if done_feet then
            actor:send("</>  " .. "%get.obj_shortdesc[%feet_reward%]%")
        end
        if done_wrist then
            actor:send("</>  " .. "%get.obj_shortdesc[%wrist_reward%]%")
        end
        if done_head then
            actor:send("</>  " .. "%get.obj_shortdesc[%head_reward%]%")
        end
        if done_arms then
            actor:send("</>  " .. "%get.obj_shortdesc[%arms_reward%]%")
        end
        if done_legs then
            actor:send("</>  " .. "%get.obj_shortdesc[%legs_reward%]%")
        end
        if done_body then
            actor:send("</>  " .. "%get.obj_shortdesc[%body_reward%]%")
        end
    else
        actor:send("<cyan>Status: Not Started</>")
    end
end
return _return_value$trig$, 'cbe980a265054c0db95c565b5736e4f2'),
  -- data/triggers/004/004_97_rogue_cloak_progress_journal.lua
  (4, 97, $trig$-- Converted from DG Script #497: Rogue Cloak progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "cloak") or string.find(arg, "dagger") or string.find(arg, "cloak and dagger") or string.find(arg, "rogue_cloak") then
    if string.find(actor.class, "Rogue") or string.find(actor.class, "Bard") or actor.class ~= "thief" then
        _return_value = true
        local huntstage = actor:get_quest_stage("treasure_hunter")
        local cloakstage = actor:get_quest_stage("rogue_cloak")
        local job1 = actor:get_quest_var("rogue_cloak:cloaktask1")
        local job2 = actor:get_quest_var("rogue_cloak:cloaktask2")
        local job3 = actor:get_quest_var("rogue_cloak:cloaktask3")
        local job4 = actor:get_quest_var("rogue_cloak:cloaktask4")
        actor:send("<b:green>&uCloak and Dagger</>")
        local level
        if not cloakstage then
            level = 10
        else
            level = cloakstage * 10
        end
        if not actor:get_has_completed("rogue_cloak") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        local status
        if actor:get_has_completed("rogue_cloak") then
            status = "Completed!"
        elseif cloakstage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level then
            if cloakstage == 0 then
                actor:send("You must <b:cyan>[hunt]</> down more treasure first.")
                return _return_value
            elseif (cloakstage >= huntstage) and not actor:get_has_completed("treasure_hunter") then
                actor:send("Find some more treasures before you seek another promotion.")
                return _return_value
            end
            -- switch on cloakstage
            local cloak
            local gem
            local place
            local hint
            if cloakstage == 1 then
                cloak = 58801
                gem = 55585
                place = "A Storage Room"
                hint = "in the house on the hill."
            elseif cloakstage == 2 then
                cloak = 17307
                gem = 55593
                place = "A Small Alcove"
                hint = "in the holy library."
            elseif cloakstage == 3 then
                cloak = 10308
                gem = 55619
                place = "either Treasure Room"
                hint = "in the paladin fortress."
            elseif cloakstage == 4 then
                cloak = 12325
                gem = 55659
                place = "The Treasure Room"
                hint = "beyond the Tower in the Wastes."
            elseif cloakstage == 5 then
                cloak = 43022
                gem = 55663
                place = "Treasury"
                hint = "in the ghostly fortress."
            elseif cloakstage == 6 then
                cloak = 23810
                gem = 55674
                place = "either Treasure Room with a chest"
                hint = "lost in the sands."
            elseif cloakstage == 7 then
                cloak = 51013
                gem = 55714
                place = "Mesmeriz's Secret Treasure Room"
                hint = "hidden deep underground."
            elseif cloakstage == 8 then
                cloak = 58410
                gem = 55740
                place = "Treasure Room"
                hint = "sunk in the swamp."
            elseif cloakstage == 9 then
                cloak = 52009
                gem = 55741
                place = "Treasure Room"
                hint = "buried with an ancient king."
            end
            local attack = cloakstage * 100
            if job1 or job2 or job3 or job4 then
                actor:send("You've done the following:")
                if job1 then
                    actor:send("- attacked " .. tostring(attack) .. " times")
                end
                if job2 then
                    actor:send("- found " .. "%get.obj_shortdesc[%cloak%]%")
                end
                if job3 then
                    actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
                end
                if job4 then
                    actor:send("- searched in " .. tostring(place))
                end
            end
            actor:send("</>")
            actor:send("You need to:")
            if job1 and job2 and job3 and job4 then
                actor:send("Give Honus your old cloak.")
                return _return_value
            end
            if not job1 then
                local remaining = attack - actor:get_quest_var("rogue_cloak:attack_counter")
                actor:send("- attack <b:yellow>" .. tostring(remaining) .. "</> more times while wearing your cloak.")
            end
            if not job2 then
                actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%cloak%]%</>")
            end
            if not job3 then
                actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</>")
            end
            if not job4 then
                actor:send("- <b:yellow>search</> in a place called \"<b:yellow>" .. tostring(place) .. "</>\".")
                actor:send("</>   It's <b:yellow>" .. tostring(hint) .. "</>")
            end
        end
    end
end
return _return_value$trig$, '0baf7db12124455d636b25d61a0e108e'),
  -- data/triggers/012/012_60_summon_dragon.lua
  (12, 60, $trig$-- Converted from DG Script #1260: summon_dragon
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: summon
if not (cmd == "summon") then
    return true  -- Not our command
end
-- TODO: per-summoner one-mount-only gate (DG used a global var here);
-- the converter emitted dead `globals.has_one = globals.has_one or true`
-- which never blocked re-summons. Leaving open until the runtime exposes
-- a per-actor quest/flag suitable for tracking summoned mounts.
if actor.class == "paladin" then
    self.room:spawn_mobile(12, 60)
    self.room:send_except(actor, "A brilliant golden dragon flies in, seemingly from nowhere, and nuzzles " .. tostring(actor.name) .. "'s side.")
    actor:send("You begin calling for a mount..")
    actor:send("A brilliant golden dragon answers your summons.")
    local dragon = self.room:find_actor("golden-dragon")
    if dragon then
        dragon:follow(actor)
        dragon:spawn_object(12, 62)
        dragon:command("wear dragonsaddle")
    end
elseif string.find(actor.class, "Anti") then
    self.room:spawn_mobile(12, 63)
    self.room:send_except(actor, "A dusky black dragon flies in, seemingly from nowhere, and sits by " .. tostring(actor.name) .. "'s side.")
    actor:send("You begin calling for a mount..")
    actor:send("A dusky black dragon answers your summons.")
    local dragon = self.room:find_actor("black-dragon")
    if dragon then
        dragon:follow(actor)
        dragon:spawn_object(12, 62)
        dragon:command("wear dragonsaddle")
    end
else
    actor:send("You begin calling for a mount...but nothing happens.")
    self.room:send_except(actor, tostring(actor.name) .. " whistles loudly.")
end$trig$, '6894ff28ed87d2eed28346704a39e624'),
  -- data/triggers/018/018_00_traveller_greet_all.lua
  (18, 0, $trig$-- Converted from DG Script #1800: traveller_greet_all
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
if self.room.zone_id == 18 and self.room.local_id == 2 and actor.level < 100 then
    wait(1)
    actor:send("Thelmor hugs you warmly.")
    actor:send("Thelmor tells you, 'Thank you for freeing me.'")
    actor:send("Thelmor mutters something about Izaro.")
    wait(2)
    if world.count_mobiles(18, 8) == 0 then
        actor:send("Thelmor wails pitifully.")
        actor:send("Thelmor says, 'My revenge is fulfilled, and I am free!'")
        self:command("rem blade")
        self:command("drop blade")
        actor:send("Thelmor dissipates before your very eyes.")
        if actor.class == "ranger" and actor.level > 80 then
            actor:start_quest("blur")
            actor:send("A voice from the forest whispers, 'You have done the forest a great service.")
            actor:send("</>Meet me at the nearby spring.'")
        end
        world.destroy(self.room:find_actor("self"))
        return true
    else
        actor:send("Thelmor shouts, 'Izaro!  It is time to end this.'")
        wait(2)
        actor:send("Izaro streaks in from the forest.")
        wait(1)
        local izaro = self.room:find_actor("fallen-nymph")
        if izaro then
            izaro:teleport(self.room)
            combat.engage(izaro)
        end
    end
end$trig$, 'c7deb8dc4facdf7df95511888cc2fe2a'),
  -- data/triggers/018/018_06_evil_nymph_death.lua
  (18, 6, $trig$-- Converted from DG Script #1806: evil_nymph_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- TODO(parity): debug "running" send is a leftover from DG; remove once verified.
-- TODO(parity): legacy group iteration uses DG-specific group_member[i]/next_in_room
-- semantics that may not match the Rust runtime. Validate that actor.group_size and
-- actor.group_member[a] resolve correctly, otherwise rewrite using a proper group
-- iterator (e.g. for _, p in ipairs(actor:group()) do ...).
if self.room.zone_id == 18 and self.room.local_id == 2 and world.count_mobiles(18, 13) > 0 then
    self.room:send("As the nymph dies, the shade of Thelmor dissipates in peace.")
    world.destroy(self.room:find_actor("shade"))
end
local person = actor
local i = person.group_size
if i then
    local a = 1
    while i > a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person.class == "ranger" and person.level > 80 and not person:get_quest_stage("blur") then
                person:start_quest("blur")
                person:send("A voice from the forest whispers, 'You have done the forest a great service.  Meet me at the nearby spring.'")
            end
        elseif person then
            i = i + 1
        end
        a = a + 1
    end
elseif person.class == "ranger" and person.level > 80 and not person:get_quest_stage("blur") then
    person:start_quest("blur")
    person:send("A voice from the forest whispers, 'You have done the forest a great service.  Meet me at the nearby spring.'")
end$trig$, '42304e9fc0d6e880f8b01c1acae66018'),
  -- data/triggers/022/022_41_belial_pre_combat_banter.lua
  (22, 41, $trig$-- Converted from DG Script #2241: belial_pre_combat_banter
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- Belial's Pre Combat Banter
-- Stage marker: belial_queue == 2 (set in source, used by trigger 42 to choose return banter)
globals.belial_queue = 2
for _, victim in ipairs(self:get_people()) do
    if (victim.zone_id ~= 22 or victim.id ~= 19) then
        if victim.class == "paladin" then
            if victim.gender == "Female" then
                wait(1)
                victim:send("Belial slowly approaches, lifting your chin to meet his piercing gaze.")
                self.room:send_except(victim, "Belial slowly approaches " .. tostring(victim.name) .. ", lifting her chin to his gaze.")
                wait(5)
                self.room:send("Belial says in common, 'A rare and beautiful thing...'")
                wait(3)
                self.room:send("Belial says in common, 'Such a pity you should end here.'")
                victim:send("Belial gently presses a finger to your lips.")
                self.room:send_except(victim, "Belial gently presses a finger to the lips of " .. tostring(victim.name) .. "'.")
                wait(5)
                self.room:send("Belial says in common, 'I could offer you such pleasures beyond imagination.'")
                wait(3)
                victim:send("Belial stares deeply into your eyes.")
                self.room:send_except(victim, "Belial stares deeply into the eyes of " .. tostring(victim.name))
                self.room:send("Belial says in common, 'But that would not be enough, no.?'")
                wait(5)
                self.room:send("Belial says in common, 'No... your soul is too puerile to understand such!'")
                wait(3)
                victim:send("Belial casts your head away from his sudden, baleful sneer.")
                self.room:send_except(victim, "Belial balefully sneers at " .. tostring(victim.name) .. ", casting her head aside.")
                self.room:send("Belial says in common, 'Instead you shall all die by my hand!'")
                wait(1)
                self.room:find_actor("belial"):command("kill " .. tostring(victim.name))
                return true
            elseif victim.gender == "Male" then
                wait(1)
                victim:send("Belial slowly paces about you, sizing up your mettle.")
                self.room:send_except(victim, "slowly paces about " .. tostring(victim.name) .. ", sizing him up.")
                wait(5)
                self.room:send("Belial says in common, 'Such pious arrogance...'")
                wait(3)
                self.room:send("Belial says in common, 'Fitting that you should end here.'")
                self.room:send("Belial pauses for a moment, pressing his finger to his lips.")
                wait(5)
                self.room:send("Belial breaths in heavily, raising his hands skyward.")
                self.room:send("Belial says in common, 'Do you hear them... do you hear their screams?'")
                wait(5)
                self.room:send("Belial says in common, 'They sing to me...'")
                wait(3)
                victim:send("Belial snaps around, sneering at you with loathing and contempt.")
                self.room:send_except(victim, "Belial snaps around, sneering at " .. tostring(victim.name) .. " with loathing and contempt.")
                wait(5)
                self.room:send("Belial says in common, 'And now I shall add your screams to the concerto!'")
                wait(1)
                self.room:find_actor("belial"):command("kill " .. tostring(victim.name))
                return true
            end
        else
            wait(2)
            self.room:send("Belial says in common, 'How charming, someone come to throw themselves on my blade!'")
            wait(3)
            self.room:send("Belial says in common, 'Agents of a lesser perhaps... hmmm?'")
            self.room:send("Belial says in common, 'Come to usurp my throne, yes?'")
            wait(5)
            self.room:send("Belial paces about observingly, one hand clenched around a blood-red ranseur.")
            wait(3)
            self.room:send("Belial says in common, 'What's the matter, hellcat got your tongue?'")
            wait(3)
            self.room:send("Belial says in common, 'Don't be fooled, I see you trembling with fear...'")
            self.room:send("Belial says in common, 'I can smell it on you like a rotting, fetid wound!'")
            wait(5)
            self.room:send("Belial's eyes flair black as coal as he spins the blood-red ranseur about.")
            wait(3)
            self.room:send("Belial says in common, 'No matter, for your life ends here!'")
            self.room:send("Belial growls, 'Have at thee!'")
            wait(1)
            self.room:find_actor("belial"):command("kill " .. tostring(victim.name))
            return _return_value
        end
    end
end$trig$, '0a02ee0545f7e293996dfec81e3925ab'),
  -- data/triggers/023/023_01_patriarch_receives_truthstone.lua
  (23, 1, $trig$local _return_value = true  -- Default: allow action
-- 
-- original Smoldering Trident trigger
-- 
if (object.zone_id == 23 and object.id == 0) then
    wait(1)
    local object_shortdesc = object.shortdesc
    world.destroy(object)
    wait(3)
    self.room:send_except(actor, tostring(self.name) .. " stops tossing meat into the fire and peers at " .. tostring(actor.name) .. ".")
    actor:send(tostring(self.name) .. " stops tossing meat into the fire and looks at you.")
    wait(3)
    if actor.class == "diabolist" then
        if actor.level >= 35 then
            self:command("smile")
            self:say("Excellent...very, very excellent.")
            self:emote("pockets " .. tostring(object_shortdesc) .. ".")
            wait(2)
            self:say("He will be very happy with this.")
            self:emote("turns towards the fire and begins chanting in an arcane tongue.")
            wait(3)
            self:emote("chants, 'Olarag hroshi nofaraio...'")
            wait(2)
            self.room:send("The flames begin to <blue>fl<blue>are</>, licking the cavern roof above!")
            wait(2)
            self:emote("chants, 'Dala kenthu sarijko dennal...'")
            wait(2)
            self.room:send("The &9<blue>un</><magenta>ho<blue>ly</> <blue>fi<blue>re</> continues to grow, nearly engulfing " .. tostring(self.name) .. "!")
            wait(2)
            self:emote("chants, 'Yarak tilaru kenzo jing!'")
            self.room:send("As " .. tostring(self.name) .. " completes " .. tostring(self.possessive) .. " chant, the <blue>fla<blue>mes</> suddenly contract into a ball.")
            wait(3)
            self.room:send("A <yellow>chi<blue>ll<green>ing</> voice croaks something in a language you do not understand.")
            wait(2)
            self.room:send("The ball of <blue>fl<blue>ame</> slowly begins to change shape, elongating and pulsating.")
            self.room:send("The <blue>fl<blue>ames</> take the shape of a <red>scar<blue>let <yellow>trident</>.")
            wait(3)
            self.room:send("The trident falls to the ground by the &9<blue>smoldering <red>emb<blue>ers</>.")
            wait(1)
            self:emote("gets a smoldering trident.")
            wait(1)
            self:say("Yes, I believe you have proven yourself indeed.")
            self:command("smile")
            wait(2)
            self:say("The weapon is for you.")
            wait(1)
            if actor.gender == "Female" then
                self:say("Go forth and smite those who might stand against us, sister.")
            elseif actor.gender == "Male" then
                self:say("Go forth and smite those who might stand against us, brother.")
            else
                self:say("Go forth and smite those who might stand against us.")
            end
            self.room:spawn_object(23, 34)
            self:command("give smoldering-trident " .. tostring(actor.name))
            if not actor:get_quest_stage("hell_trident") then
                actor:start_quest("hell_trident")
            end
            wait(1)
            -- 
            -- for Hellfire Trident
            -- 
            if actor.level >= 65 then
                self:say("Hell hungers for more and will reward you greatly if you feed it.  Attack with that trident 666 times then seek out the Black Priestess, the left hand of Ruin Wormheart.  She will guide your offerings.")
            else
                self:say("Other forces of Hell will eventually take notice of you too now.  Seek out the left hand of Ruin Wormheart, the Black Priestess, after you have grown more.  She will be your emissary.")
                actor:send("<red>Reach level 65 to continue this quest.</>")
            end
            -- 
            -- for Hellfire and Brimstone
            -- 
            if (actor.level > 56) and not actor:get_quest_stage("hellfire_brimstone") then
                wait(2)
                self:say("You seem to be quite powerful already.  Powerful enough in fact to handle the Fire of the Dark One.")
                wait(2)
                self:say("Would you like to learn to rain fire and brimstone down on your enemies?")
            end
            -- 
            -- original Smoldering Trident trigger
            -- 
        else
            self:command("blink")
            self:say("Quite amazing that you were able to retrieve " .. tostring(object_shortdesc) .. ".")
            self:command("peer " .. tostring(actor.name))
            wait(2)
            self:say("Unfortunately, I don't think the Dark One would want to see such a weakling.  Return here again when you are more powerful.")
        end
    else
        self:command("snicker " .. tostring(actor.name))
        self:say("You are no diabolist!  You no more deserve this power than Mielikki herself!")
        self:emote("tosses " .. tostring(object_shortdesc) .. " in the flames.")
        wait(2)
        self:say("Run along now, there is nothing more for you here.")
    end
end
-- 
-- Hellfire and Brimstone continued
-- 
if actor:get_quest_stage("hellfire_brimstone") == 3 then
    if (object.zone_id == 43 and object.id == 18) or (object.zone_id == 52 and object.id == 11) or (object.zone_id == 52 and object.id == 12) or (object.zone_id == 173 and object.id == 8) or (object.zone_id == 481 and object.id == 10) or (object.zone_id == 530 and object.id == 0) then
        if actor:get_quest_var("hellfire_brimstone:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) then
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(2)
            self:say("I have no need for a second " .. tostring(objects.template(object.zone_id, object.local_id).name) .. "!")
        else
            wait(2)
            actor:set_quest_var("hellfire_brimstone", (tostring(object.zone_id) .. "_" .. tostring(object.local_id)), 1)
            self.room:send(tostring(self.name) .. " holds " .. tostring(object.shortdesc) .. " in his gnarled fist.")
            self:say("You have done well " .. tostring(actor.name) .. ".")
            world.destroy(object)
        end
        wait(2)
        local item1 = actor:get_quest_var("hellfire_brimstone:4318")
        local item2 = actor:get_quest_var("hellfire_brimstone:5211")
        local item3 = actor:get_quest_var("hellfire_brimstone:5212")
        local item4 = actor:get_quest_var("hellfire_brimstone:17308")
        local item5 = actor:get_quest_var("hellfire_brimstone:48110")
        local item6 = actor:get_quest_var("hellfire_brimstone:53000")
        if item1 and item2 and item3 and item4 and item5 and item6 then
            self:emote("laughs with dark pleasure!")
            self:say("A fine set of tributes to the Dark One!")
            wait(4)
            self:say("Now behold as I set this cavern alight!")
            wait(2)
            self.room:send("<b:red>" .. tostring(self.name) .. " spreads the flaming tributes throughout the cavern.</>")
            self.room:send("<b:red>The piles of brimstone burn hot and bright!</>")
            wait(3)
            self.room:send("<b:red>The fires trace out lines on the cavern floor, forming a huge burning sigil.</>")
            wait(4)
            actor:send("<b:red>Gazing into the burning sigil, you feel the words to a prayer to the Dark One forming in your soul.</>_")
            actor:send("You have learned the prayers for <b:red>H<yellow>e<red>llf<yellow>i<red>re</> <red>and <blue>Br<yellow>i<red>mst<yellow>o<red>ne</>!")
            actor:complete_quest("hellfire_brimstone")
            if not actor:get_quest_var("hell_trident:helltask4") and actor:get_quest_stage("hell_trident") == 1 then
                actor:set_quest_var("hell_trident", "helltask4", 1)
            end
            skills.set_level(actor, "hellfire and brimstone", 1000)
        else
            self:say("Bring me the rest of the fiery tributes!")
        end
    else
        _return_value = true
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        self:say("I have no need for this!")
    end
end
return _return_value$trig$, '12117c3316c7f5d3a967d6230149baf6'),
  -- data/triggers/030/030_160_skill_trainer_speach.lua
  (30, 160, $trig$-- Converted from DG Script #3160: ***skill trainer speach***
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- Speech keywords: training yes backstab bludgeoning shadow slashing sneak steal switch throatcut track conceal corner double dual eye switch retreat hide pick piercing bandage douse lure cartwheel rend
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "training") or string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "backstab") or string.find(string.lower(speech), "bludgeoning") or string.find(string.lower(speech), "shadow") or string.find(string.lower(speech), "slashing") or string.find(string.lower(speech), "sneak") or string.find(string.lower(speech), "steal") or string.find(string.lower(speech), "switch") or string.find(string.lower(speech), "throatcut") or string.find(string.lower(speech), "track") or string.find(string.lower(speech), "conceal") or string.find(string.lower(speech), "corner") or string.find(string.lower(speech), "double") or string.find(string.lower(speech), "dual") or string.find(string.lower(speech), "eye") or string.find(string.lower(speech), "switch") or string.find(string.lower(speech), "retreat") or string.find(string.lower(speech), "hide") or string.find(string.lower(speech), "pick") or string.find(string.lower(speech), "piercing") or string.find(string.lower(speech), "bandage") or string.find(string.lower(speech), "douse") or string.find(string.lower(speech), "lure") or string.find(string.lower(speech), "cartwheel") or string.find(string.lower(speech), "rend")) then
    return true  -- No matching keywords
end
wait(2)
-- make sure they have a quest record for saving variables
if actor:get_quest_stage("trainer_3160") < 1 then
    actor:start_quest("trainer_3160")
else
    actor:erase_quest("trainer_3160")
    actor:start_quest("trainer_3160")
end
-- introductions: lists the skills available
if speech == "training?" or speech == "training" or speech == "yes" then
    self.room:send(tostring(self.name) .. " says, 'Sure, I can help you improve just about any necessary stealthy")
    self.room:send("</>talent.  But remember, I can't teach you skills you don't already know.'")
    -- (empty room echo)
    self.room:send("</>Just ask me about a skill, and I'll give you a quote:")
    -- (empty room echo)
    self.room:send("</>backstab, bandage, bludgeoning weapons, cartwheel, conceal, corner")
    self.room:send("</>double attack, douse, dual wield, eye gouge, group retreat, hide, lure, pick lock,")
    self.room:send("</>piercing weapons, rend, retreat, shadow, slashing weapons, sneak, sneak attack,")
    self.room:send("</>steal, switch, throatcut, track.")
    return _return_value
else
    -- defining variables for this script
    local name = actor.name
    local cha = actor.real_cha
    local int = actor.real_int
    -- 
    -- Identify the skill to be trained
    local skill, word2
    if speech == "backstab" then
        skill = actor:has_skill("backstab")
    elseif speech == "bludgeoning weapons" then
        skill = actor:has_skill("bludgeoning weapons")
        word2 = "weapons"
    elseif speech == "cartwheel" then
        skill = actor:has_skill("cartwheel")
    elseif speech == "conceal" then
        skill = actor:has_skill("conceal")
    elseif speech == "corner" then
        skill = actor:has_skill("corner")
    elseif speech == "double attack" then
        skill = actor:has_skill("double attack")
        word2 = "attack"
    elseif speech == "dual wield" then
        skill = actor:has_skill("dual wield")
        word2 = "wield"
    elseif speech == "eye gouge" then
        word2 = "gouge"
        skill = actor:has_skill("eye gouge")
    elseif speech == "group retreat" then
        word2 = "retreat"
        skill = actor:has_skill("group retreat")
    elseif speech == "hide" then
        skill = actor:has_skill("hide")
    elseif speech == "instant kill" then
        skill = actor:has_skill("instant kill")
        word2 = "kill"
    elseif speech == "lure" then
        skill = actor:has_skill("lure")
    elseif speech == "pick lock" then
        skill = actor:has_skill("pick lock")
        word2 = "lock"
    elseif speech == "piercing weapons" then
        skill = actor:has_skill("piercing weapons")
        word2 = "weapons"
    elseif speech == "rend" then
        skill = actor:has_skill("rend")
    elseif speech == "retreat" then
        skill = actor:has_skill("retreat")
    elseif speech == "shadow" then
        skill = actor:has_skill("shadow")
    elseif speech == "slashing weapons" then
        skill = actor:has_skill("slashing weapons")
        word2 = "weapons"
    elseif speech == "sneak" then
        skill = actor:has_skill("sneak")
    elseif speech == "sneak attack" then
        skill = actor:has_skill("sneak attack")
        word2 = "attack"
    elseif speech == "steal" then
        skill = actor:has_skill("steal")
    elseif speech == "switch" then
        skill = actor:has_skill("switch")
    elseif speech == "throatcut" then
        skill = actor:has_skill("throatcut")
    elseif speech == "track" then
        skill = actor:has_skill("track")
    elseif speech == "bandage" then
        skill = actor:has_skill("bandage")
    elseif speech == "douse" then
        skill = actor:has_skill("douse")
    else
        self:say("I'm not familiar with " .. tostring(speech) .. ".")
        return _return_value
    end
    -- 
    -- Check to see if a skill should be taught at all
    -- 
    local skill = 10 * skill
    local maxskill = actor.level * 10 + 60
    -- check for capped skills
    local cap = 1000
    if speech == "track" then
        -- switch on actor.class
        if actor.class == "mercenary" then
            cap = 850
        elseif actor.class == "rogue" then
            cap = 650
        elseif actor.class == "thief" then
            cap = 600
        elseif actor.class == "assassin" then
            cap = 750
        end
    elseif speech == "dodge" or speech == "parry" then
        -- switch on actor.race
        if actor.race == "ogre" or actor.race == "troll" then
            cap = 700
        end
    elseif speech == "riposte" then
        -- switch on actor.race
        if actor.race == "ogre" then
            cap = 700
        end
    end
    if skill < 50 then
        self.room:send(tostring(self.name) .. " says, 'I wouldn't know where to start.")
        -- Fragment (possible truncation): Lets talk about improving a skill you actually know.'
        return _return_value
    elseif skill >= cap or skill >= maxskill then
        self:say("There is nothing left to teach you. You've mastered " .. tostring(speech) .. "!")
        return _return_value
    end
    if cap < maxskill then
        maxskill = cap
    end
    -- This portion is for smooth speech indicating the effects of a players cha or int
    self:command("score")
    if cha > 70 then
        self:say("I like you.")
        if int > 70 then
            -- (empty room echo)
            self.room:send(tostring(self.name) .. " says, '...and you're pretty bright.")
            self.room:send("</>I'll give you a good deal.'")
        elseif int < 50 then
            -- (empty room echo)
            self:say("..but you aren't the smartest.")
        end
    elseif cha < 50 then
        self:say("I don't like you much.")
        if int > 70 then
            -- (empty room echo)
            self:say("...but you are pretty bright.")
        elseif int < 50 then
            -- (empty room echo)
            self:say("...and you aren't the smartest.")
        else
        end
    else
        self:say("You're alright.")
        if int > 70 then
            -- (empty room echo)
            self:say("...and you're pretty bright.")
        elseif int < 50 then
            -- (empty room echo)
            self:say("...but you aren't the smartest.")
        end
    end
    -- (empty room echo)
    -- Now a price is calculated
    local change = maxskill - skill
    local opinion = 200 - (cha + int)
    local price = change * opinion * actor.level * actor.level / (skill * 20)
    -- 
    -- now the price in copper has to be divided into coinage.
    local plat = price / 1000
    local gold = price / 100 - plat * 10
    local silv = price / 10 - plat * 100 - gold * 10
    local copp = price  - plat * 1000 - gold * 100 - silv * 10
    -- now the price can be reported
    self:say("I'll teach you " .. tostring(speech) .. " for " .. tostring(plat) .. " platinum, " .. tostring(gold) .. " gold, " .. tostring(silv) .. " silver, " .. tostring(copp) .. " copper.")
    -- (empty room echo)
    self:say("Just bring me the money when you're ready to practice.")
    actor:set_quest_var("trainer_3160", "skill_name", speech)
    if word2 then
        actor:set_quest_var("trainer_3160", "word2", word2)
    end
    actor:set_quest_var("trainer_3160", "skill_level", skill)
    actor:set_quest_var("trainer_3160", "price", price)
    actor:set_quest_var("trainer_3160", "actor_level", actor.level)
end$trig$, '44e82bc95da673dd3d12735a846572bb'),
  -- data/triggers/030/030_165_calken_trainer_speech.lua
  (30, 165, $trig$-- Converted from DG Script #3165: Calken trainer speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: training yes 2H dodge parry riposte hitall barehand bash disarm first guard kick mount rescue riding safefall springleap tame tantrum maul berserk ground battle roundhouse
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "training") or string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "2h") or string.find(string.lower(speech), "dodge") or string.find(string.lower(speech), "parry") or string.find(string.lower(speech), "riposte") or string.find(string.lower(speech), "hitall") or string.find(string.lower(speech), "barehand") or string.find(string.lower(speech), "bash") or string.find(string.lower(speech), "disarm") or string.find(string.lower(speech), "first") or string.find(string.lower(speech), "guard") or string.find(string.lower(speech), "kick") or string.find(string.lower(speech), "mount") or string.find(string.lower(speech), "rescue") or string.find(string.lower(speech), "riding") or string.find(string.lower(speech), "safefall") or string.find(string.lower(speech), "springleap") or string.find(string.lower(speech), "tame") or string.find(string.lower(speech), "tantrum") or string.find(string.lower(speech), "maul") or string.find(string.lower(speech), "berserk") or string.find(string.lower(speech), "ground") or string.find(string.lower(speech), "battle") or string.find(string.lower(speech), "roundhouse")) then
    return true  -- No matching keywords
end
wait(2)
-- make sure they have a quest record for saving variables
if actor:get_quest_stage("trainer_3165") < 1 then
    actor:start_quest("trainer_3165")
else
    actor:erase_quest("trainer_3165")
    actor:start_quest("trainer_3165")
end
-- introductions: lists the skills available
if speech == "training?" or speech == "training" or speech == "yes" then
    self.room:send(tostring(self.name) .. " says, 'Sure, I can help you improve just about any necessary martial")
    self.room:send("</>talent.  But remember, I can't teach you skills you don't already know.'")
    -- (empty room echo)
    self.room:send("</>Just ask me about a skill, and I'll give you a quote:")
    -- (empty room echo)
    self.room:send("</>2H bludgeoning weapons, 2H piercing weapons, 2H slashing weapons, barehand,")
    self.room:send("</>bash, battle howl, berserk, disarm, dodge, first aid, ground shaker, guard,")
    self.room:send("</>hitall, kick, maul, mount, parry, rescue, riding, riposte, roundhouse, safefall,")
    self.room:send("</>springleap, tame, tantrum.")
    wait(2)
    self:say("Feel free to ask me about one of them and I'll give you a price.")
    return _return_value
else
    -- defining variables for this script
    speech = speech
    local name = actor.name
    local cha = actor.real_cha
    local int = actor.real_int
    -- 
    -- Identify the skill to be trained
    local skill, word2
    if speech == "bash" then
        skill = actor:has_skill("bash")
    elseif string.find(speech, "2H") then
        if string.find(speech, "bludgeoning") then
            word2 = "bludgeoning"
            skill = actor:has_skill("2H bludgeoning weapons")
        elseif string.find(speech, "piercing") then
            word2 = "piercing"
            skill = actor:has_skill("2H piercing weapons")
        elseif string.find(speech, "slashing") then
            word2 = "slashing"
            skill = actor:has_skill("2H slashing weapons")
        else
            self:say("Not sure that I've heard of that one.  What was it again?")
            return _return_value
        end
    elseif speech == "disarm" then
        skill = actor:has_skill("disarm")
    elseif speech == "dodge" then
        skill = actor:has_skill("dodge")
    elseif speech == "parry" then
        skill = actor:has_skill("parry")
    elseif speech == "riposte" then
        skill = actor:has_skill("riposte")
    elseif speech == "hitall" then
        skill = actor:has_skill("hitall")
    elseif speech == "barehand" then
        skill = actor:has_skill("barehand")
    elseif speech == "springleap" then
        skill = actor:has_skill("springleap")
    elseif speech == "safefall" then
        skill = actor:has_skill("safefall")
    elseif speech == "bash" then
        skill = actor:has_skill("bash")
    elseif speech == "guard" then
        skill = actor:has_skill("guard")
    elseif speech == "rescue" then
        skill = actor:has_skill("rescue")
    elseif speech == "kick" then
        skill = actor:has_skill("kick")
    elseif speech == "first aid" then
        word2 = "aid"
        skill = actor:has_skill("first aid")
    elseif speech == "mount" then
        skill = actor:has_skill("mount")
    elseif speech == "riding" then
        skill = actor:has_skill("riding")
    elseif speech == "tame" then
        skill = actor:has_skill("tame")
    elseif speech == "ground shaker" then
        word2 = "shaker"
        skill = actor:has_skill("ground shaker")
    elseif speech == "battle howl" then
        word2 = "howl"
        skill = actor:has_skill("battle howl")
    elseif speech == "maul" then
        skill = actor:has_skill("maul")
    elseif speech == "tantrum" then
        skill = actor:has_skill("tantrum")
    elseif speech == "berserk" then
        skill = actor:has_skill("berserk")
    elseif speech == "roundhouse" then
        skill = actor:has_skill("roundhouse")
    else
        self:say("I'm not familiar with " .. tostring(speech) .. ".")
        return _return_value
    end
    -- 
    -- Check to see if a skill should be taught at all
    -- 
    local skill = 10 * skill
    local maxskill = actor.level * 10 + 60
    -- check for capped skills
    local cap = 1000
    if speech == "track" then
        -- switch on actor.class
        if actor.class == "mercenary" then
            cap = 850
        elseif actor.class == "rogue" then
            cap = 650
        elseif actor.class == "thief" then
            cap = 600
        elseif actor.class == "assassin" then
            cap = 750
        end
    elseif speech == "dodge" or speech == "parry" then
        -- switch on actor.race
        if actor.race == "ogre" or actor.race == "troll" then
            cap = 700
        end
    elseif speech == "riposte" then
        -- switch on actor.race
        if actor.race == "ogre" then
            cap = 700
        end
    end
    if skill < 50 then
        self.room:send(tostring(self.name) .. " says, 'I wouldn't know where to start.")
        self.room:send("</>Let's talk about improving a skill you actually know.'")
        return _return_value
    elseif skill >= cap or skill >= maxskill then
        self:say("There is nothing left to teach you - you've mastered " .. tostring(speech) .. "!")
        return _return_value
    end
    if cap < maxskill then
        maxskill = cap
    end
    -- This portion is for smooth speech indicating the effects of a players cha or int
    self:command("score")
    if cha > 70 then
        self:say("I like you.")
        if int > 70 then
            -- (empty room echo)
            self.room:send(tostring(self.name) .. " says, '...and you're pretty bright.")
            self.room:send("I'll give you a good deal.'")
        elseif int < 50 then
            -- (empty room echo)
            self:say("...but you aren't the smartest.")
        end
    elseif cha < 50 then
        self:say("I don't like you much.")
        if int > 70 then
            -- (empty room echo)
            self:say("...but you are pretty bright.")
        elseif int < 50 then
            -- (empty room echo)
            self:say("...and you aren't the smartest.")
        else
        end
    else
        self:say("You're alright.")
        if int > 70 then
            -- (empty room echo)
            self:say("...and you're pretty bright.")
        elseif int < 50 then
            -- (empty room echo)
            self:say("...but you aren't the smartest.")
        end
    end
    -- (empty room echo)
    -- Now a price is calculated
    local change = maxskill - skill
    local opinion = 200 - (cha + int)
    local price = change * opinion * actor.level * actor.level / (skill * 20)
    -- 
    -- now the price in copper has to be divided into coinage.
    local plat = price / 1000
    local gold = price / 100 - plat * 10
    local silv = price / 10 - plat * 100 - gold * 10
    local copp = price  - plat * 1000 - gold * 100 - silv * 10
    -- now the price can be reported
    self:say("I'll teach you " .. tostring(speech) .. " for " .. tostring(plat) .. " platinum, " .. tostring(gold) .. " gold, " .. tostring(silv) .. " silver, " .. tostring(copp) .. " copper.")
    -- (empty room echo)
    self:say("Just get me the money, and I'll get started.")
    actor:set_quest_var("trainer_3165", "skill_name", speech)
    if word2 then
        actor:set_quest_var("trainer_3165", "word2", word2)
    end
    actor:set_quest_var("trainer_3165", "skill_level", skill)
    actor:set_quest_var("trainer_3165", "price", price)
    actor:set_quest_var("trainer_3165", "actor_level", actor.level)
end$trig$, '0413cef2f734986a6f7a42445e7364f9'),
  -- data/triggers/030/030_180_load_random_gems.lua
  (30, 180, $trig$-- Converted from DG Script #3180: load random gems
-- Original: MOB trigger, flags: GREET, probability: 100%
if self:has_effect(Effect.Invisible) then
    self:command("vis")
end
-- number of gems to load -- starting at 3, but that might be too many
local loop = 3
-- gem IDs go from  to 55566-55751
-- p1 IDs from 55566-55593
-- p2 IDs from 55594-55670
-- P3 cnums from 55671-55747 (there are gems up to 55751, but not used.
-- random # -- 1-10 to create probabilities of good gem
-- 0 = NO GEM
-- 1 = NO GEM
-- 2-6 = P1 Gem
-- 7-9 = P2 Gem
-- 10  = P3 Gem
-- -- lets see if we should run process to get gems
-- -- we do that by looking for object 18701 -- if we are wearing it
-- -- then we don't need to load gems again
-- all the important stuff encased in this loop
if not self:has_equipped(187, 1) then
    self.room:spawn_object(187, 1)
    get_room(11, 0):at(function()
        self:command("wear lock")
    end)
    local itt = 1
    while itt <= loop do
        local p = random(1, 10)
        local base = 0
        local extra = 0
        if p == 10 then
            base = 55671
            extra = random(1, 76)
        elseif (p <= 9) and (p >= 7) then
            -- p2 gem
            base = 55594
            extra = random(1, 76)
        elseif (p <= 6) and (p >= 2) then
            -- p1 gem
            base = 55566
            extra = random(1, 27)
        end
        -- p < 2 leaves base/extra at 0 (no gem)
        if base > 55560 then
            local gem = base + extra
            self.room:spawn_object(math.floor(gem / 100), gem % 100)
            self:command("sell gem elspeth")
        end
        itt = itt + 1
    end
    self:command("chuckle")
    self:say("you wouldn't believe who I had to beat down to get these")
    self:command("flex")
end
-- 
-- Adding hint to find Rogue Guild for Elspeth
-- 
if (self.zone_id == 30 and self.id == 10) then
    if actor.class == "rogue" and actor.level < 10 then
        wait(4)
        actor:send(tostring(self.name) .. " notices you skulking about her shop.")
        actor:send("<b:white>" .. tostring(self.name) .. " tells you, 'If you're looking for a certain Guild Hall, <cyan>search<white> behind</>")
        actor:send("</><b:white>the <cyan>curtain<white> on the wall.'</>")
    end
end$trig$, '66bb2ee7114f7a036bf73e0b608e6426'),
  -- data/triggers/030/030_30_myst_quest_reward.lua
  (30, 30, $trig$-- Converted from DG Script #3030: Myst_quest_reward
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
wait(1)
self:destroy_item("shard")
-- Create a random number by which to judge prize table off of.
local rnd = random(1, 100)
if rnd >= 90 then
    self.room:spawn_object(4, 1)
elseif rnd < 90 and rnd >= 70 then
    self.room:spawn_object(30, 40)
elseif rnd < 70 and rnd >= 30 then
    -- switch on random(1, 19)
    if random(1, 19) == 1 then
        -- cure crit x3
        self.room:spawn_object(83, 42)
    elseif random(1, 19) == 2 then
        -- strength
        self.room:spawn_object(30, 274)
    elseif random(1, 19) == 3 then
        -- wisdom
        self.room:spawn_object(30, 278)
    elseif random(1, 19) == 4 then
        -- monk fire
        self.room:spawn_object(30, 249)
    elseif random(1, 19) == 5 then
        -- monk acid
        self.room:spawn_object(30, 258)
    elseif random(1, 19) == 6 then
        -- bless, remove curse, cure serious
        self.room:spawn_object(117, 1)
    elseif random(1, 19) == 7 then
        -- prot evil, enhance con, remove poison
        self.room:spawn_object(117, 2)
    elseif random(1, 19) == 8 then
        -- prot evil, enhance wis
        self.room:spawn_object(178, 8)
    elseif random(1, 19) == 9 then
        -- prot cold, monk ice
        self.room:spawn_object(30, 241)
    elseif random(1, 19) == 10 then
        -- monk lightning
        self.room:spawn_object(30, 255)
    elseif random(1, 19) == 11 then
        -- monk ice
        self.room:spawn_object(30, 252)
    elseif random(1, 19) == 12 then
        -- prot cold
        self.room:spawn_object(30, 265)
    elseif random(1, 19) == 13 then
        -- prot fire
        self.room:spawn_object(30, 262)
    elseif random(1, 19) == 14 then
        -- prot air
        self.room:spawn_object(30, 268)
    elseif random(1, 19) == 15 then
        -- prot earth
        self.room:spawn_object(30, 271)
    elseif random(1, 19) == 16 then
        -- intelligence
        self.room:spawn_object(30, 282)
    elseif random(1, 19) == 17 then
        -- charisma
        self.room:spawn_object(30, 286)
    elseif random(1, 19) == 18 then
        -- constitution
        self.room:spawn_object(30, 290)
    elseif random(1, 19) == 19 then
        -- dexterity
        self.room:spawn_object(30, 294)
    else
        self:say("This quest reward has a broken potion random chance, let a god know.")
    end
elseif rnd < 30 then
    self.room:spawn_object(30, 41)
else
    self:say("The reward for this quest is broken, contact a god and let them know.")
end
self:shout("Hark all and listen, " .. tostring(actor.name) .. " has fended off a great evil for our fair town!")
wait(1)
self:say("Here, " .. tostring(actor.name) .. " you have earned this as a reward.")
wait(1)
self:command("give all " .. tostring(actor.name))
if not actor:get_has_completed("mystwatch_quest") and actor:get_quest_var("mystwatch_quest:step") == "complete" then
    actor:complete_quest("mystwatch_quest")
    local expcap
    if actor.level < 50 then
        expcap = actor.level
    else
        expcap = 50
    end
    local expmod = 0
    if expcap < 9 then
        expmod = (((expcap * expcap) + expcap) / 2) * 55
    elseif expcap < 17 then
        expmod = 440 + ((expcap - 8) * 125)
    elseif expcap < 25 then
        expmod = 1440 + ((expcap - 16) * 175)
    elseif expcap < 34 then
        expmod = 2840 + ((expcap - 24) * 225)
    elseif expcap < 49 then
        expmod = 4640 + ((expcap - 32) * 250)
    elseif expcap < 90 then
        expmod = 8640 + ((expcap - 48) * 300)
    else
        expmod = 20940 + ((expcap - 89) * 600)
    end
    -- switch on actor.class
    if actor.class == "warrior" or actor.class == "berserker" then
        expmod = (expmod + (expmod / 10))
    elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
        expmod = (expmod + ((expmod * 2) / 15))
    elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
        expmod = (expmod + (expmod / 5))
    elseif actor.class == "necromancer" or actor.class == "monk" then
        expmod = (expmod + ((expmod * 2) / 5))
    end
    actor:send("<b:yellow>You gain experience!</>")
    local setexp = (expmod * 10)
    local loop = 0
    while loop < 3 do
        actor:award_exp(setexp)
        loop = loop + 1
    end
end
if world.count_mobiles(160, 7) < 1 then
    get_room(160, 64):at(function()
        self.room:spawn_mobile(160, 7)
    end)
end$trig$, '73c969c416bfc230a1d1efddbe57265d'),
  -- data/triggers/030/030_83_dragon_slayer_isilynor_receive.lua
  (30, 83, $trig$-- Converted from DG Script #3083: Dragon Slayer Isilynor Receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- hunt notices here
local stage, victim1, go, pendantstage, item
if (object.zone_id == 30 and object.id == 80) then
    stage = 1
    victim1 = "a dragon hedge"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 81) then
    stage = 2
    victim1 = "the green wyrmling"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 82) then
    stage = 3
    victim1 = "Wug the Fiery Drakling"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 83) then
    stage = 4
    victim1 = "the young blue dragon"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 84) then
    stage = 5
    victim1 = "a faerie dragon"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 85) then
    stage = 6
    victim1 = "the wyvern"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 86) then
    stage = 7
    victim1 = "an ice lizard"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 87) then
    stage = 8
    victim1 = "the Beast of Borgan"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 88) then
    stage = 9
    victim1 = "Tri-Aszp"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 89) then
    stage = 10
    victim1 = "the Hydra"
    go = "hunt"
    -- paladin pendant items start here
elseif object.id == 360 then
    pendantstage = 1
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 120 and object.id == 3) then
    pendantstage = 1
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 555 and object.id == 82) then
    pendantstage = 1
    item = "gem"
    go = "necklace"
elseif object.id == 361 then
    pendantstage = 2
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 237 and object.id == 8) then
    pendantstage = 2
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 555 and object.id == 90) then
    pendantstage = 2
    item = "gem"
    go = "necklace"
elseif object.id == 362 then
    pendantstage = 3
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 580 and object.id == 5) then
    pendantstage = 3
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 556 and object.id == 22) then
    pendantstage = 3
    item = "gem"
    go = "necklace"
elseif object.id == 363 then
    pendantstage = 4
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 481 and object.id == 23) then
    pendantstage = 4
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 556 and object.id == 54) then
    pendantstage = 4
    item = "gem"
    go = "necklace"
elseif object.id == 364 then
    pendantstage = 5
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 123 and object.id == 36) then
    pendantstage = 5
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 556 and object.id == 62) then
    pendantstage = 5
    item = "gem"
    go = "necklace"
elseif object.id == 365 then
    pendantstage = 6
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 430 and object.id == 19) then
    pendantstage = 6
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 556 and object.id == 77) then
    pendantstage = 6
    item = "gem"
    go = "necklace"
elseif object.id == 366 then
    pendantstage = 7
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 370 and object.id == 15) then
    pendantstage = 7
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 557 and object.id == 9) then
    pendantstage = 7
    item = "gem"
    go = "necklace"
elseif object.id == 367 then
    pendantstage = 8
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 584 and object.id == 29) then
    pendantstage = 8
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 557 and object.id == 38) then
    pendantstage = 8
    item = "gem"
    go = "necklace"
elseif object.id == 368 then
    pendantstage = 9
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 520 and object.id == 10) then
    pendantstage = 9
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 557 and object.id == 39) then
    pendantstage = 9
    item = "gem"
    go = "necklace"
else
    _return_value = true
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:say("What is this for?")
    return _return_value
end
if go == "hunt" then
    if actor:get_quest_stage("dragon_slayer") == "stage" and actor:get_quest_var("dragon_slayer:hunt") == "dead" then
        local anti = "Anti-Paladin"
        wait(2)
        world.destroy(object)
        self:command("cheer")
        actor:send(tostring(self.name) .. " says, 'Congratulations!  Here's your reward.'")
        local money = stage * 10
        self:command("give " .. tostring(money) .. " platinum " .. tostring(actor))
        local expcap
        if stage == 1 then
            expcap = 5
        else
            local bonus = (stage - 1) * 10
            expcap = bonus
        end
        local expmod
        if expcap < 9 then
            expmod = (((expcap * expcap) + expcap) / 2) * 55
        elseif expcap < 17 then
            expmod = 440 + ((expcap - 8) * 125)
        elseif expcap < 25 then
            expmod = 1440 + ((expcap - 16) * 175)
        elseif expcap < 34 then
            expmod = 2840 + ((expcap - 24) * 225)
        elseif expcap < 49 then
            expmod = 4640 + ((expcap - 32) * 250)
        elseif expcap < 90 then
            expmod = 8640 + ((expcap - 48) * 300)
        else
            expmod = 20940 + ((expcap - 89) * 600)
        end
        -- switch on person.class
        local expmod
        if person.class == "warrior" or person.class == "berserker" then
            expmod = (expmod + (expmod / 10))
        elseif person.class == "paladin" or person.class == "anti-paladin" or person.class == "ranger" then
            expmod = (expmod + ((expmod * 2) / 15))
        elseif person.class == "sorcerer" or person.class == "pyromancer" or person.class == "cryomancer" or person.class == "illusionist" or person.class == "bard" then
            expmod = (expmod + (expmod / 5))
        elseif person.class == "necromancer" or person.class == "monk" then
            expmod = (expmod + (expmod * 2) / 5)
        else
            expmod = expmod
        end
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 3 do
            actor:award_exp(setexp)
            loop = loop + 1
        end
        actor:set_quest_var("dragon_slayer", "target1", 0)
        actor:set_quest_var("dragon_slayer", "hunt", 0)
        wait(2)
        if stage < 10 then
            actor:advance_quest("dragon_slayer")
            actor:send(tostring(self.name) .. " says, 'Check in again if you have time for more work.'")
        else
            actor:complete_quest("dragon_slayer")
            actor:send(tostring(self.name) .. " says, 'You have earned your place among the greatest dragon slayers in the realm!'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'I bestow upon you this crest in recognition of your might.  Wear this proudly.'")
            self.room:spawn_object(4, 149)
            self:command("give crest " .. tostring(actor))
        end
        if (string.find(actor.class, "paladin") or string.find(actor.class, "anti")) and actor:get_quest_stage("paladin_pendant") == 0 then
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I think you've earned this too.'")
            self.room:spawn_object(2, 160)
            self:command("give necklace " .. tostring(actor))
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Necklaces like these are proof of your devotion to your causes.'")
            actor:start_quest("paladin_pendant")
            wait(2)
            if actor.level > 9 then
                actor:send(tostring(self.name) .. " says, 'This is an opportune time to further prove your <b:cyan>[devotion]</>.'")
            else
                actor:send(tostring(self.name) .. " says, 'Come back with that necklace after you reach level 10.  We can discuss acts of devotion then.'")
            end
        end
    elseif actor:get_quest_stage("dragon_slayer") > stage then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses the notice.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You already killed this dragon!'")
    elseif actor:get_quest_stage("dragon_slayer") < stage then
        wait(2)
        self:command("eye " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
        self.room:send(tostring(self.name) .. " rips up the notice!")
        world.destroy(object)
    elseif actor:get_quest_var("dragon_slayer:hunt") ~= "dead" then
        _return_value = true
        self.room:send(tostring(self.name) .. " refuses the notice.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You have to slay the dragon first!  " .. tostring(victim1) .. " is still out there.")
    end
elseif go == "necklace" then
    if actor:get_quest_stage("dragon_slayer") < actor:get_quest_stage("paladin_pendant") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Slay some more dragons first.'")
    elseif actor.level < (actor:get_quest_stage("paladin_pendant") * 10) then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You need to gain some more experience first.'")
    elseif pendantstage > actor:get_quest_stage("paladin_pendant") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Your devotional act doesn't involve that yet.  Be patient!'")
    elseif pendantstage < actor:get_quest_stage("paladin_pendant") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You've already performed that act of devotion.'")
    else
        local accept
        if item == "quest" then
            local job1 = actor:get_quest_var("paladin_pendant:necklacetask1")
            local job2 = actor:get_quest_var("paladin_pendant:necklacetask2")
            local job3 = actor:get_quest_var("paladin_pendant:necklacetask3")
            local job4 = actor:get_quest_var("paladin_pendant:necklacetask4")
            if job1 and job2 and job3 and job4 then
                wait(2)
                local reward = object.id + 1
                world.destroy(object)
                self:command("nod")
                actor:send(tostring(self.name) .. " says, 'Well done!  You've proven your devotion.'")
                self.room:spawn_object(math.floor(reward / 100), reward % 100)
                self:command("give necklace " .. tostring(actor))
                local expcap = pendantstage * 10
                local expmod
                if expcap < 17 then
                    expmod = 440 + ((expcap - 8) * 125)
                elseif expcap < 25 then
                    expmod = 1440 + ((expcap - 16) * 175)
                elseif expcap < 34 then
                    expmod = 2840 + ((expcap - 24) * 225)
                elseif expcap < 49 then
                    expmod = 4640 + ((expcap - 32) * 250)
                elseif expcap < 90 then
                    expmod = 8640 + ((expcap - 48) * 300)
                else
                    expmod = 20940 + ((expcap - 89) * 600)
                end
                expmod = expmod + ((expmod * 2) / 15)
                actor:send("<b:yellow>You gain experience!</>")
                local setexp = (expmod * 10)
                local loop = 0
                while loop < 7 do
                    actor:award_exp(setexp)
                    loop = loop + 1
                end
                local number = 1
                while number < 5 do
                    actor:set_quest_var("paladin_pendant", "necklacetask%number%", 0)
                    number = number + 1
                end
                if actor:get_quest_stage("paladin_pendant") < 9 then
                    actor:advance_quest("paladin_pendant")
                else
                    actor:complete_quest("paladin_pendant")
                end
            else
                _return_value = true
                self:command("shake")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'You need to do everything else before you offer up your necklace!'")
            end
        elseif item == "necklace" then
            if actor:get_quest_var("paladin_pendant:necklacetask2") == object.id then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("paladin_pendant", "necklacetask2", object.id)
            end
        elseif item == "gem" then
            if actor:get_quest_var("paladin_pendant:necklacetask3") == object.id then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("paladin_pendant", "necklacetask3", object.id)
            end
        end
        if accept == "no" then
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'You already gave me that.'")
        elseif accept == "yes" then
            wait(2)
            world.destroy(object)
            local job1 = actor:get_quest_var("paladin_pendant:necklacetask1")
            local job2 = actor:get_quest_var("paladin_pendant:necklacetask2")
            local job3 = actor:get_quest_var("paladin_pendant:necklacetask3")
            local job4 = actor:get_quest_var("paladin_pendant:necklacetask4")
            if job1 and job2 and job3 and job4 then
                actor:send(tostring(self.name) .. " says, 'Excellent.  Now turn over your current necklace as the final proof of your devotion.'")
            else
                actor:send(tostring(self.name) .. " says, 'Good, now finish the rest.'")
            end
        end
    end
end
return _return_value$trig$, '51b4e414326c4db661a5d47f8a16244b'),
  -- data/triggers/030/030_87_paladin_pendant_isilynor_speech.lua
  (30, 87, $trig$-- Converted from DG Script #3087: Paladin pendant Isilynor speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: devotion
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "devotion")) then
    return true  -- No matching keywords
end
local anti = "Anti-Paladin"
local pendantstage = actor:get_quest_stage("paladin_pendant")
local huntstage = actor:get_quest_stage("dragon_slayer")
local job1 = actor:get_quest_var("paladin_pendant:necklacetask1")
local job2 = actor:get_quest_var("paladin_pendant:necklacetask2")
local job3 = actor:get_quest_var("paladin_pendant:necklacetask3")
local job4 = actor:get_quest_var("paladin_pendant:necklacetask4")
wait(2)
if actor.class ~= "paladin" and actor.class ~= "anti-paladin" then
    self:command("shake")
    actor:send(tostring(self.name) .. " says, 'Such acts are only for warriors of Justice or Destruction.'")
    return _return_value
elseif actor.level < 10 then
    actor:send(tostring(self.name) .. " says, 'You aren't ready for such an act yet.  Come back when you've grown a bit.'")
    return _return_value
elseif actor.level < (pendantstage * 10) then
    self:say("You aren't ready for another devotional act yet.  Come back when you've gained some more experience.")
    return _return_value
elseif actor:get_has_completed("paladin_pendant") then
    actor:send(tostring(self.name) .. " says, 'You've already proven your devotion as much as possible!'")
    return _return_value
end
if pendantstage == 0 then
    self.room:send(tostring(self.name) .. " says, 'Sure.  You must <b:cyan>[hunt]</> a dragon first though.'")
    return _return_value
elseif (pendantstage >= huntstage) and not actor:get_has_completed("dragon_slayer") then
    actor:send(tostring(self.name) .. " says, 'Slay a few more dragons then we can talk.'")
    return _return_value
elseif job1 and job2 and job3 and job4 then
    actor:send(tostring(self.name) .. " says, 'You're all ready, just give me your old necklace.'")
    return _return_value
end
-- switch on pendantstage
local place, hint
if pendantstage == 1 then
    local necklace = 12003
    local gem = 55582
    place = "The Mist Temple Altar"
    hint = "in the Misty Caverns."
elseif pendantstage == 2 then
    local necklace = 23708
    local gem = 55590
    place = "Chamber of Chaos"
    hint = "in the Temple of Chaos."
elseif pendantstage == 3 then
    local necklace = 58005
    local gem = 55622
    place = "Altar of Borgan"
    hint = "in the lost city of Nymrill."
elseif pendantstage == 4 then
    local necklace = 48123
    local gem = 55654
    place = "A Hidden Altar Room"
    hint = "in a cave in South Caelia's Wailing Mountains."
elseif pendantstage == 5 then
    local necklace = 12336
    local gem = 55662
    place = "The Altar of the Snow Leopard Order"
    hint = "buried deep in Mt. Frostbite"
elseif pendantstage == 6 then
    local necklace = 43019
    local gem = 55677
    place = "Chapel Altar"
    hint = "deep underground in a lost castle."
elseif pendantstage == 7 then
    local necklace = 37015
    local gem = 55709
    place = "A Cliffside Altar"
    hint = "tucked away in the land of Dreams."
elseif pendantstage == 8 then
    local necklace = 58429
    local gem = 55738
    place = "Dark Altar"
    hint = "entombed with an ancient evil king."
elseif pendantstage == 9 then
    local necklace = 52010
    local gem = 55739
    place = "An Altar"
    hint = "far away in the Plane of Air."
end
local attacks = pendantstage * 100
self:command("nod")
actor:send(tostring(self.name) .. " says, 'With each act of devotion you'll earn a new necklace.  Undertake the following:")
actor:send("- Attack <b:yellow>" .. tostring(attacks) .. "</> times while wearing your current necklace.")
actor:send("- Find <b:yellow>" .. "%get.obj_shortdesc[%necklace%]%</> as the base for the new necklace.")
actor:send("- Find <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</> for decoration.")
actor:send("</>")
actor:send("You also need to take your necklace and <b:yellow>[pray]</> in a sanctified space.")
actor:send("Find \"<b:yellow>" .. tostring(place) .. "</>\".  It's " .. tostring(hint))
actor:send("</>")
actor:send("You can ask about your <b:cyan>[progress]</> at any time.'")$trig$, '452e062a20af45c555f7c69f14938b03'),
  -- data/triggers/030/030_88_paladin_pendant_command_pray.lua
  (30, 88, $trig$-- Converted from DG Script #3088: Paladin pendant command pray
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: pray
if not (cmd == "pray") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
if cmd == "p" then
    _return_value = true
    return _return_value
end
local anti = "Anti-Paladin"
local pendantstage = actor:get_quest_stage("paladin_pendant")
-- switch on self.id
local continue
if actor.room == 5479 and pendantstage == 1 then
    if self.id == 360 then
        continue = "yes"
    end
    if (actor.room == 17345 or actor.room == 17346 or actor.room == 17351 or actor.room == 17352) and pendantstage == 2 then
    elseif self.id == 361 then
        continue = "yes"
    end
    if actor.room == 49516 and pendantstage == 3 then
    elseif self.id == 362 then
        continue = "yes"
    end
    if actor.room == 2408 and pendantstage == 4 then
    elseif self.id == 363 then
        continue = "yes"
    end
    if actor.room == 55105 and pendantstage == 5 then
    elseif self.id == 364 then
        continue = "yes"
    end
    if actor.room == 53159 and pendantstage == 6 then
    elseif self.id == 365 then
        continue = "yes"
    end
    if actor.room == 58424 and pendantstage == 7 then
    elseif self.id == 366 then
        continue = "yes"
    end
    if actor.room == 48032 and pendantstage == 8 then
    elseif self.id == 367 then
        continue = "yes"
    end
    if actor.room == 48880 and pendantstage == 9 then
    elseif self.id == 368 then
        continue = "yes"
    end
end
if continue == "yes" then
    actor:command("pray")
    wait(2)
    if actor.class == "paladin" then
        actor:send("<b:yellow>You have gained new insights on your righteous cause!</>")
    elseif actor.class == "anti-paladin" then
        actor:send("<b:red>You have gained new insights on your ruinouse cause!</>")
    end
    actor:set_quest_var("paladin_pendant", "necklacetask4", 1)
else
    _return_value = true
end
return _return_value$trig$, '0e6fbb0c808f62a41f571f8aa1948d20'),
  -- data/triggers/053/053_13_beast_master_ranger_trophy_receive.lua
  (53, 13, $trig$-- Converted from DG Script #5313: Beast Master Ranger Trophy receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- hunt notices here
local stage, victim1, go, trophystage, item
if (object.zone_id == 53 and object.id == 0) then
    stage = 1
    victim1 = "an abominable slime creature"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 1) then
    stage = 2
    victim1 = "a large buck"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 2) then
    stage = 3
    victim1 = "the giant scorpion"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 3) then
    stage = 4
    victim1 = "a monstrous canopy spider"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 4) then
    stage = 5
    victim1 = "the chimera"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 5) then
    stage = 6
    victim1 = "the drider king"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 6) then
    stage = 7
    victim1 = "a beholder"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 7) then
    stage = 8
    victim1 = "the Banshee"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 8) then
    stage = 9
    victim1 = "Baba Yaga"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 9) then
    stage = 10
    victim1 = "the medusa"
    go = "hunt"
    -- ranger trophy items start here
elseif object.id == 370 then
    trophystage = 1
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 16 and object.id == 7) then
    trophystage = 1
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 555 and object.id == 79) then
    trophystage = 1
    item = "gem"
    go = "trophy"
elseif object.id == 371 then
    trophystage = 2
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 178 and object.id == 6) then
    trophystage = 2
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 555 and object.id == 91) then
    trophystage = 2
    item = "gem"
    go = "trophy"
elseif object.id == 372 then
    trophystage = 3
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 18 and object.id == 5) then
    trophystage = 3
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 556 and object.id == 28) then
    trophystage = 3
    item = "gem"
    go = "trophy"
elseif object.id == 373 then
    trophystage = 4
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 625 and object.id == 13) then
    trophystage = 4
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 556 and object.id == 52) then
    trophystage = 4
    item = "gem"
    go = "trophy"
elseif object.id == 374 then
    trophystage = 5
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 238 and object.id == 3) then
    trophystage = 5
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 556 and object.id == 64) then
    trophystage = 5
    item = "gem"
    go = "trophy"
elseif object.id == 375 then
    trophystage = 6
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 430 and object.id == 9) then
    trophystage = 6
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 556 and object.id == 85) then
    trophystage = 6
    item = "gem"
    go = "trophy"
elseif object.id == 376 then
    trophystage = 7
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 470 and object.id == 8) then
    trophystage = 7
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 557 and object.id == 5) then
    trophystage = 7
    item = "gem"
    go = "trophy"
elseif object.id == 377 then
    trophystage = 8
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 533 and object.id == 23) or (object.zone_id == 533 and object.id == 11) then
    trophystage = 8
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 557 and object.id == 29) then
    trophystage = 8
    item = "gem"
    go = "trophy"
elseif object.id == 378 then
    trophystage = 9
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 520 and object.id == 14) then
    trophystage = 9
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 557 and object.id == 41) then
    trophystage = 9
    item = "gem"
    go = "trophy"
else
    _return_value = true
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:say("What is this for?")
    return _return_value
end
if go == "hunt" then
    if actor:get_quest_stage("beast_master") == "stage" and actor:get_quest_var("beast_master:hunt") == "dead" then
        wait(2)
        world.destroy(object)
        self:command("cheer")
        actor:send(tostring(self.name) .. " says, 'Congratulations!  Here's your reward.'")
        local money = stage * 10
        self:command("give " .. tostring(money) .. " platinum " .. tostring(actor))
        local expcap
        if stage == 1 then
            expcap = 5
        else
            local bonus = (stage - 1) * 10
            expcap = bonus
        end
        local expmod
        if expcap < 9 then
            expmod = (((expcap * expcap) + expcap) / 2) * 55
        elseif expcap < 17 then
            expmod = 440 + ((expcap - 8) * 125)
        elseif expcap < 25 then
            expmod = 1440 + ((expcap - 16) * 175)
        elseif expcap < 34 then
            expmod = 2840 + ((expcap - 24) * 225)
        elseif expcap < 49 then
            expmod = 4640 + ((expcap - 32) * 250)
        elseif expcap < 90 then
            expmod = 8640 + ((expcap - 48) * 300)
        else
            expmod = 20940 + ((expcap - 89) * 600)
        end
        local anti = "Anti-Paladin"
        -- switch on person.class
        local expmod
        if person.class == "warrior" or person.class == "berserker" then
            expmod = (expmod + (expmod / 10))
        elseif person.class == "paladin" or person.class == "anti-paladin" or person.class == "ranger" then
            expmod = (expmod + ((expmod * 2) / 15))
        elseif person.class == "sorcerer" or person.class == "pyromancer" or person.class == "cryomancer" or person.class == "illusionist" or person.class == "bard" then
            expmod = (expmod + (expmod / 5))
        elseif person.class == "necromancer" or person.class == "monk" then
            expmod = (expmod + (expmod * 2) / 5)
        else
            expmod = expmod
        end
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 3 do
            actor:award_exp(setexp)
            loop = loop + 1
        end
        actor:set_quest_var("beast_master", "target1", 0)
        actor:set_quest_var("beast_master", "hunt", 0)
        wait(2)
        if stage < 10 then
            actor:advance_quest("beast_master")
            actor:send(tostring(self.name) .. " says, 'Check in again if you have time for more hunts.'")
        else
            actor:complete_quest("beast_master")
            actor:send(tostring(self.name) .. " says, 'You have earned your place among the greatest Beast Masters in the realm!'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Take these gloves.  Wear them to show everyone your unstoppable prowess.'")
            self.room:spawn_object(4, 13)
            self:command("give gloves " .. tostring(actor))
        end
        if (string.find(actor.class, "ranger") or string.find(actor.class, "warrior") or string.find(actor.class, "berserker") or string.find(actor.class, "Mercenary")) and actor:get_quest_stage("ranger_trophy") == 0 then
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I think you've earned this too.'")
            self.room:spawn_object(2, 170)
            self:command("give trophy " .. tostring(actor))
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Trophies like these are proof of your skill as a hunter.'")
            actor:start_quest("ranger_trophy")
            wait(2)
            if actor.level > 9 then
                actor:send(tostring(self.name) .. " says, 'This is an opportune time to further demonstrate your <b:cyan>[skill]</>.'")
            else
                actor:send(tostring(self.name) .. " says, 'Come back with that trophy after you reach level 10.  We can discuss your skills then.'")
            end
        end
    elseif actor:get_quest_stage("beast_master") > stage then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses the notice.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You already killed this creature!'")
    elseif actor:get_quest_stage("beast_master") < stage then
        wait(2)
        self:command("eye " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
        self.room:send(tostring(self.name) .. " rips up the notice!")
        world.destroy(object)
    elseif actor:get_quest_var("beast_master:hunt") ~= "dead" then
        _return_value = true
        self.room:send(tostring(self.name) .. " refuses the notice.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You have to slay kill the beast first!  " .. tostring(victim1) .. " is still out there.")
    end
elseif go == "trophy" then
    if actor.class ~= "warrior" and actor.class ~= "ranger" and actor.class ~= "mercenary" and actor.class ~= "berserker" then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, '" .. tostring(actor.class) .. "s aren't fit for these kinds of tests.'")
    elseif actor:get_quest_stage("beast_master") < actor:get_quest_stage("ranger_trophy") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Defeat some more monsters first.'")
    elseif actor.level < (actor:get_quest_stage("ranger_trophy") * 10) then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You need to gain some more experience first.'")
    elseif trophystage > actor:get_quest_stage("ranger_trophy") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You don't need that to demonstrate your skills yet.  Be patient!'")
    elseif trophystage < actor:get_quest_stage("ranger_trophy") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You've already used that as proof.'")
    else
        local accept
        if item == "quest" then
            local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
            local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
            local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
            local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
            if job1 and job2 and job3 and job4 then
                wait(2)
                local reward = object.id + 1
                world.destroy(object)
                self:command("nod")
                actor:send(tostring(self.name) .. " says, 'Well done!  You've demonstrated your skills well.'")
                self.room:spawn_object(math.floor(reward / 100), reward % 100)
                self:command("give trophy " .. tostring(actor))
                local expcap = trophystage * 10
                local expmod
                if expcap < 17 then
                    expmod = 440 + ((expcap - 8) * 125)
                elseif expcap < 25 then
                    expmod = 1440 + ((expcap - 16) * 175)
                elseif expcap < 34 then
                    expmod = 2840 + ((expcap - 24) * 225)
                elseif expcap < 49 then
                    expmod = 4640 + ((expcap - 32) * 250)
                elseif expcap < 90 then
                    expmod = 8640 + ((expcap - 48) * 300)
                else
                    expmod = 20940 + ((expcap - 89) * 600)
                end
                -- switch on person.class
                local expmod
                if person.class == "warrior" or person.class == "berserker" then
                    expmod = (expmod + (expmod / 10))
                elseif person.class == "ranger" then
                    expmod = (expmod + ((expmod * 2) / 15))
                else
                    expmod = expmod
                end
                actor:send("<b:yellow>You gain experience!</>")
                local setexp = (expmod * 10)
                local loop = 0
                while loop < 7 do
                    actor:award_exp(setexp)
                    loop = loop + 1
                end
                local number = 1
                while number < 5 do
                    actor:set_quest_var("ranger_trophy", "trophytask%number%", 0)
                    number = number + 1
                end
                if actor:get_quest_stage("ranger_trophy") < 9 then
                    actor:advance_quest("ranger_trophy")
                else
                    actor:complete_quest("ranger_trophy")
                end
            else
                _return_value = true
                self:command("shake")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'You need to do everything else before you exchange your trophy!'")
            end
        elseif item == "trophy" then
            local task2 = actor:get_quest_var("ranger_trophy:trophytask2")
            if task2 == object.id or ((object.zone_id == 533 and object.id == 11) and task2 == 53323) or ((object.zone_id == 533 and object.id == 23) and task2 == 53311) then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("ranger_trophy", "trophytask2", object.id)
            end
        elseif item == "gem" then
            if actor:get_quest_var("ranger_trophy:trophytask3") == object.id then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("ranger_trophy", "trophytask3", object.id)
            end
        end
        if accept == "no" then
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'You already gave me that.'")
        elseif accept == "yes" then
            wait(2)
            world.destroy(object)
            local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
            local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
            local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
            local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
            if job1 and job2 and job3 and job4 then
                actor:send(tostring(self.name) .. " says, 'Excellent.  Now give me your current trophy.'")
            else
                actor:send(tostring(self.name) .. " says, 'Good, now finish the rest.'")
            end
        end
    end
end
return _return_value$trig$, '2a197cd66debd70fb6300ce3fbf795b8'),
  -- data/triggers/053/053_17_ranger_trophy_pumahl_speech_skill.lua
  (53, 17, $trig$-- Converted from DG Script #5317: Ranger Trophy Pumahl speech skill
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: skill
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "skill")) then
    return true  -- No matching keywords
end
local trophystage = actor:get_quest_stage("ranger_trophy")
local huntstage = actor:get_quest_stage("beast_master")
local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
wait(2)
if actor.class ~= "warrior" and actor.class ~= "ranger" and actor.class ~= "berserker" and actor.class ~= "mercenary" then
    self:command("shake")
    actor:send(tostring(self.name) .. " says, 'Only warriors, rangers, berserkers, and mercenaries possess the skills required for this.'")
    return _return_value
elseif actor.level < 10 then
    actor:send(tostring(self.name) .. " says, 'You aren't ready for this test yet.  Come back when you've grown a bit.'")
    return _return_value
elseif actor.level < (trophystage * 10) then
    actor:send(tostring(self.name) .. " says, 'You aren't ready for another test yet.  Come back when you've gained some more experience.'")
    return _return_value
elseif actor:get_has_completed("ranger_trophy") then
    actor:send(tostring(self.name) .. " says, 'You've already proven your skills as much as possible!'")
    return _return_value
end
if trophystage == 0 then
    self.room:send(tostring(self.name) .. " says, 'Sure.  You must <b:cyan>[hunt]</> a great beast first though.'")
    return _return_value
elseif (trophystage >= huntstage) and not actor:get_has_completed("beast_master") then
    actor:send(tostring(self.name) .. " says, 'Prove your dominion over some more great beasts first then we can talk.'")
    return _return_value
elseif job1 and job2 and job3 and job4 then
    actor:send(tostring(self.name) .. " says, 'You're all ready, just give me your old trophy.'")
    return _return_value
end
-- switch on trophystage
local place, hint
if trophystage == 1 then
    local trophy = 1607
    local gem = 55579
    place = "A Coyote's Den"
    hint = "near the Kingdom of the Meer Cats."
elseif trophystage == 2 then
    local trophy = 17806
    local gem = 55591
    place = "In the Lions' Den"
    hint = "in the western reaches of Gothra."
elseif trophystage == 3 then
    local trophy = 1805
    local gem = 55628
    place = "either of the two Gigantic Roc Nests"
    hint = "in the Wailing Mountains."
elseif trophystage == 4 then
    local trophy = 62513
    local gem = 55652
    place = "Chieftain's Lair"
    hint = "in Nukreth Spire in South Caelia."
elseif trophystage == 5 then
    local trophy = 23803
    local gem = 55664
    place = "The Heart of the Den"
    hint = "where the oldest unicorn in South Caelia makes its home."
elseif trophystage == 6 then
    local trophy = 43009
    local gem = 55685
    place = "Giant Lynx's Lair"
    hint = "far to the north beyond Mt. Frostbite."
elseif trophystage == 7 then
    local trophy = 47008
    local gem = 55705
    place = "Giant Griffin's Nest"
    hint = "tucked away in a secluded and well guarded corner of Griffin Island."
elseif trophystage == 8 then
    local trophy = 53323
    local gem = 55729
    place = "Witch's Den"
    hint = "entombed with an ancient evil king."
elseif trophystage == 9 then
    local trophy = 52014
    local gem = 55741
    place = "Dargentan's Lair"
    hint = "at the pinnacle of his flying fortress."
end
local attacks = trophystage * 100
self:command("nod")
actor:send(tostring(self.name) .. " says, 'With each act mission you'll earn a new trophy.  Undertake the following:")
actor:send("- Attack <b:green>" .. tostring(attacks) .. "</> times while wearing your current trophy.")
actor:send("- Find <b:green>" .. "%get.obj_shortdesc[%trophy%]%</> as another demonstration of mastery over the beasts of the wild.")
actor:send("- Find <b:green>" .. "%get.obj_shortdesc[%gem%]%</> for decoration.")
actor:send("</>")
actor:send("You also need to take your trophy and <b:green>[forage]</> in a great beast's home.")
actor:send("Find \"<b:green>" .. tostring(place) .. "</>\".  It's " .. tostring(hint))
actor:send("</>")
actor:send("You can ask about your <b:cyan>[progress]</> at any time.'")$trig$, '10cb2b5e69833de35c692d67b6a552dc'),
  -- data/triggers/053/053_19_ranger_trophy_pumahl_progress.lua
  (53, 19, $trig$-- Converted from DG Script #5319: Ranger Trophy Pumahl progress
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"status", "progress"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
actor:send("<b:green>Beast Masters</>")
if actor:get_has_completed("beast_master") then
    actor:send(tostring(self.name) .. " says, 'You've already proven your dominion over the beasts of Ethilien!'")
elseif actor.level >= (actor:get_quest_stage("beast_master") - 1) * 10 then
    if actor:get_quest_var("beast_master:hunt") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't on a hunt at the moment.'")
    else
        -- switch on actor:get_quest_stage("beast_master")
        if actor:get_quest_stage("beast_master") == 1 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Slay an abominable slime creature in the sewers beneath Mielikki.'")
        elseif actor:get_quest_stage("beast_master") == 2 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Hunt down a large buck in the forests just outside of Mielikki.'")
        elseif actor:get_quest_stage("beast_master") == 3 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Track down the giant scorpion of Gothra.'")
        elseif actor:get_quest_stage("beast_master") == 4 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Head far to the south and kill a monstrous canopy spider.'")
        elseif actor:get_quest_stage("beast_master") == 5 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Behead the famed chimera of Fiery Island.'")
        elseif actor:get_quest_stage("beast_master") == 6 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Slay the \"king\" of the abominations known as driders.'")
        elseif actor:get_quest_stage("beast_master") == 7 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Close the eyes of a beholder from under Mt. Frostbite.'")
        elseif actor:get_quest_stage("beast_master") == 8 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Lay the Banshee to eternal rest.'")
        elseif actor:get_quest_stage("beast_master") == 9 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Put an end to Baba Yaga's dreamy witchcraft.'")
        elseif actor:get_quest_stage("beast_master") == 10 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Defeat the medusa below the city of Templace.'")
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'Unfortunately I don't have any beasts for you to pursue at the moment.  Check back later!'")
end
if actor.class == "warrior" or actor.class == "ranger" or actor.class == "berserker" or actor.class == "mercenary" then
    actor:send("</>")
    actor:send("<b:green>Eye of the Tiger</>")
    local huntstage = actor:get_quest_stage("beast_master")
    local trophystage = actor:get_quest_stage("ranger_trophy")
    local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
    local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
    local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
    local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
    if actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for this test yet.  Come back when you've grown a bit.'")
        return _return_value
    elseif actor.level < (trophystage * 10) then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for another test yet.  Come back when you've gained some more experience.'")
        return _return_value
    elseif actor:get_has_completed("ranger_trophy") then
        actor:send(tostring(self.name) .. " says, 'You've already proven your skills as much as possible!'")
        return _return_value
    end
    if trophystage == 0 then
        actor:send(tostring(self.name) .. " says, 'You must <b:cyan>[hunt]</> a great beast to demonstrate your skills first.'")
        return _return_value
    elseif (trophystage >= huntstage) and not actor:get_has_completed("beast_master") then
        actor:send(tostring(self.name) .. " says, 'Prove your dominion over some more great beasts first then we can talk.'")
        return _return_value
    end
    -- switch on trophystage
    local place, hint
    if trophystage == 1 then
        local trophy = 1607
        local gem = 55579
        place = "A Coyote's Den"
        hint = "near the Kingdom of the Meer Cats."
    elseif trophystage == 2 then
        local trophy = 17806
        local gem = 55591
        place = "In the Lions' Den"
        hint = "in the western reaches of Gothra."
    elseif trophystage == 3 then
        local trophy = 1805
        local gem = 55628
        place = "either of the two Gigantic Roc Nests"
        hint = "in the Wailing Mountains."
    elseif trophystage == 4 then
        local trophy = 62513
        local gem = 55652
        place = "Chieftain's Lair"
        hint = "in Nukreth Spire in South Caelia."
    elseif trophystage == 5 then
        local trophy = 23803
        local gem = 55664
        place = "The Heart of the Den"
        hint = "where the oldest unicorn in South Caelia makes its home."
    elseif trophystage == 6 then
        local trophy = 43009
        local gem = 55685
        place = "Giant Lynx's Lair"
        hint = "far to the north beyond Mt. Frostbite."
    elseif trophystage == 7 then
        local trophy = 47008
        local gem = 55705
        place = "Giant Griffin's Nest"
        hint = "tucked away in a secluded and well guarded corner of Griffin Island."
    elseif trophystage == 8 then
        local trophy = 53323
        local gem = 55729
        place = "Witch's Den"
        hint = "entombed with an ancient evil king."
    elseif trophystage == 9 then
        local trophy = 52014
        local gem = 55741
        place = "Dargentan's Lair"
        hint = "at the pinnacle of his flying fortress."
    end
    local attack = trophystage * 100
    if job1 or job2 or job3 or job4 then
        actor:send(tostring(self.name) .. " says, 'You've done the following:'")
        if job1 then
            actor:send("- attacked " .. tostring(attack) .. " times")
        end
        if job2 then
            actor:send("- found " .. "%get.obj_shortdesc[%trophy%]%")
        end
        if job3 then
            actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
        end
        if job4 then
            actor:send("- foraged in " .. tostring(place))
        end
    end
    -- (empty send to actor)
    actor:send("You need to:")
    if job1 and job2 and job3 and job4 then
        actor:send("Just give me your old trophy.")
        return _return_value
    end
    if not job1 then
        local remaining = attack - actor:get_quest_var("ranger_trophy:attack_counter")
        actor:send("- attack <b:green>" .. tostring(remaining) .. "</> more times while wearing your trophy.")
    end
    if not job2 then
        actor:send("- find <b:green>" .. "%get.obj_shortdesc[%trophy%]%</>")
    end
    if not job3 then
        actor:send("- find <b:green>" .. "%get.obj_shortdesc[%gem%]%</>")
    end
    if not job4 then
        actor:send("- <b:green>forage</> in a place called \"<b:green>" .. tostring(place) .. "</>\".")
        actor:send("</>   It's <b:green>" .. tostring(hint) .. "</>")
    end
end$trig$, '96022e6afcf90d7c98a936844d275ac0'),
  -- data/triggers/053/053_23_honus_order_receive.lua
  (53, 23, $trig$-- Converted from DG Script #5323: Honus order receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- hunt orders here
local stage, treasure1
if (object.zone_id == 53 and object.id == 10) then
    stage = 1
    treasure1 = "a singing chain"
elseif (object.zone_id == 53 and object.id == 11) then
    stage = 2
    treasure1 = "a fire ring"
elseif (object.zone_id == 53 and object.id == 12) then
    stage = 3
    treasure1 = "a sandstone ring"
elseif (object.zone_id == 53 and object.id == 13) then
    stage = 4
    treasure1 = "a crimson-tinged electrum hoop"
elseif (object.zone_id == 53 and object.id == 14) then
    stage = 5
    treasure1 = "a Rainbow Shell"
elseif (object.zone_id == 53 and object.id == 15) then
    stage = 6
    treasure1 = "the Stormshield"
elseif (object.zone_id == 53 and object.id == 16) then
    stage = 7
    treasure1 = "the Snow Leopard Cloak"
elseif (object.zone_id == 53 and object.id == 17) then
    stage = 8
    treasure1 = "a coiled rope ladder"
elseif (object.zone_id == 53 and object.id == 18) then
    stage = 9
    treasure1 = "a glowing phoenix feather"
elseif (object.zone_id == 53 and object.id == 19) then
    stage = 10
    treasure1 = "a piece of sleet armor"
end
if actor:get_quest_stage("treasure_hunter") == "stage" and actor:get_quest_var("treasure_hunter:hunt") == "returned" then
    local anti = "Anti-Paladin"
    wait(2)
    world.destroy(object)
    self:command("cheer")
    actor:send(tostring(self.name) .. " says, 'Congratulations!  Here's your reward.'")
    local money = stage * 10
    self:command("give " .. tostring(money) .. " platinum " .. tostring(actor))
    local expcap
    if stage == 1 then
        expcap = 5
    else
        local bonus = (stage - 1) * 10
        expcap = bonus
    end
    local expmod
    if expcap < 9 then
        expmod = (((expcap * expcap) + expcap) / 2) * 55
    elseif expcap < 17 then
        expmod = 440 + ((expcap - 8) * 125)
    elseif expcap < 25 then
        expmod = 1440 + ((expcap - 16) * 175)
    elseif expcap < 34 then
        expmod = 2840 + ((expcap - 24) * 225)
    elseif expcap < 49 then
        expmod = 4640 + ((expcap - 32) * 250)
    elseif expcap < 90 then
        expmod = 8640 + ((expcap - 48) * 300)
    else
        expmod = 20940 + ((expcap - 89) * 600)
    end
    -- switch on person.class
    local expmod
    if person.class == "warrior" or person.class == "berserker" then
        expmod = (expmod + (expmod / 10))
    elseif person.class == "paladin" or person.class == "anti-paladin" or person.class == "ranger" then
        expmod = (expmod + ((expmod * 2) / 15))
    elseif person.class == "sorcerer" or person.class == "pyromancer" or person.class == "cryomancer" or person.class == "illusionist" or person.class == "bard" then
        expmod = (expmod + (expmod / 5))
    elseif person.class == "necromancer" or person.class == "monk" then
        expmod = (expmod + (expmod * 2) / 5)
    else
        expmod = expmod
    end
    actor:send("<b:yellow>You gain experience!</>")
    local setexp = (expmod * 10)
    local loop = 0
    while loop < 3 do
        actor:award_exp(setexp)
        loop = loop + 1
    end
    actor:set_quest_var("treasure_hunter", "treasure1", 0)
    actor:set_quest_var("treasure_hunter", "hunt", 0)
    wait(2)
    if stage < 10 then
        actor:advance_quest("treasure_hunter")
        actor:send(tostring(self.name) .. " says, 'Check in again if you have time for more work.'")
    else
        actor:complete_quest("treasure_hunter")
        actor:send(tostring(self.name) .. " says, 'You have earned your place among the greatest treasure hunters in the realm!'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Here, take this bracelet as payment for all you've done.  Wear this proudly.'")
        self.room:spawn_object(123, 117)
        self:command("give bracelet " .. tostring(actor))
    end
    if (string.find(actor.class, "Rogue") or string.find(actor.class, "Thief") or string.find(actor.class, "Bard")) and actor:get_quest_stage("rogue_cloak") == 0 then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'I think you've earned this too.'")
        self.room:spawn_object(2, 180)
        self:command("give cloak " .. tostring(actor))
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Cloaks like these show off your rank in the various cloak and dagger guilds.'")
        actor:start_quest("rogue_cloak")
        wait(2)
        if actor.level > 9 then
            actor:send(tostring(self.name) .. " says, 'This puts you in line for a <b:cyan>[promotion]</>.'")
        else
            actor:send(tostring(self.name) .. " says, 'Come back with that cloak after you reach level 10.  We can discuss a promotion then.'")
        end
    end
elseif actor:get_quest_stage("treasure_hunter") > stage then
    _return_value = true
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses the order.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You already stole - er, recovered this treasure!'")
elseif actor:get_quest_stage("treasure_hunter") < stage then
    wait(2)
    self:command("eye " .. tostring(actor))
    actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
    self.room:send(tostring(self.name) .. " rips up the order!")
    world.destroy(object)
elseif actor:get_quest_var("treasure_hunter:hunt") == "running" then
    _return_value = true
    self.room:send(tostring(self.name) .. " refuses the order.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You have to find the treasure still!  " .. tostring(treasure1) .. " is still out there.")
elseif actor:get_quest_var("treasure_hunter:hunt") == "found" then
    _return_value = true
    self.room:send(tostring(self.name) .. " refuses the order.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You have to give me the treasure first!  You still have " .. tostring(treasure1) .. " in your possession.'")
end
return _return_value$trig$, '4bebbe4396ad0919f2c974341912c665'),
  -- data/triggers/053/053_28_honus_speech_promotion.lua
  (53, 28, $trig$-- Converted from DG Script #5328: Honus speech promotion
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: promotion
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "promotion")) then
    return true  -- No matching keywords
end
local cloakstage = actor:get_quest_stage("rogue_cloak")
local huntstage = actor:get_quest_stage("treasure_hunter")
local job1 = actor:get_quest_var("rogue_cloak:cloaktask1")
local job2 = actor:get_quest_var("rogue_cloak:cloaktask2")
local job3 = actor:get_quest_var("rogue_cloak:cloaktask3")
local job4 = actor:get_quest_var("rogue_cloak:cloaktask4")
wait(2)
if actor.class ~= "rogue" and actor.class ~= "bard" and actor.class ~= "thief" then
    self:command("shake")
    actor:send(tostring(self.name) .. " says, 'We only promote within the cloak and dagger guilds.  Sorry.'")
    return _return_value
elseif actor.level < 10 then
    actor:send(tostring(self.name) .. " says, 'You aren't ready for a promotion yet.  Come back when you've grown a bit.'")
    return _return_value
elseif actor.level < (cloakstage * 10) then
    actor:send(tostring(self.name) .. " says, 'You aren't ready for another promotion yet.  Come back when you've gained some more experience.'")
    return _return_value
elseif actor:get_has_completed("rogue_cloak") then
    actor:send(tostring(self.name) .. " says, 'You've already been promoted as high as you can go!'")
    return _return_value
end
if cloakstage == 0 then
    self.room:send(tostring(self.name) .. " says, 'Sure.  You gotta <b:cyan>[hunt]</> down more treasure first though.'")
    return _return_value
elseif (cloakstage >= huntstage) and not actor:get_has_completed("treasure_hunter") then
    actor:send(tostring(self.name) .. " says, 'Find some more treasures then we can talk.'")
    return _return_value
elseif job1 and job2 and job3 and job4 then
    actor:send(tostring(self.name) .. " says, 'You're all ready, just give me your old cloak.'")
    return _return_value
end
-- switch on cloakstage
local place, hint
if cloakstage == 1 then
    local cloak = 58801
    local gem = 55585
    place = "A Storage Room"
    hint = "in the house on the hill."
elseif cloakstage == 2 then
    local cloak = 17307
    local gem = 55593
    place = "A Small Alcove"
    hint = "in the holy library."
elseif cloakstage == 3 then
    local cloak = 10308
    local gem = 55619
    place = "either Treasure Room"
    hint = "in the paladin fortress."
elseif cloakstage == 4 then
    local cloak = 12325
    local gem = 55659
    place = "The Treasure Room"
    hint = "beyond the Tower in the Wastes."
elseif cloakstage == 5 then
    local cloak = 43022
    local gem = 55663
    place = "Treasury"
    hint = "in the ghostly fortress."
elseif cloakstage == 6 then
    local cloak = 23810
    local gem = 55674
    place = "either Treasure Room with a chest"
    hint = "lost in the sands."
elseif cloakstage == 7 then
    local cloak = 51013
    local gem = 55714
    place = "Mesmeriz's Secret Treasure Room"
    hint = "hidden deep underground."
elseif cloakstage == 8 then
    local cloak = 58410
    local gem = 55740
    place = "Treasure Room"
    hint = "sunken in the swamp."
elseif cloakstage == 9 then
    local cloak = 52009
    local gem = 55741
    place = "Treasure Room"
    hint = "buried with an ancient king."
end
local attacks = cloakstage * 100
self:command("nod")
actor:send(tostring(self.name) .. " says, 'With each promotion you'll earn a new cloak to signify your new station.  Undertake the following:")
actor:send("- Attack <b:yellow>" .. tostring(attacks) .. "</> times while wearing your current cloak.")
actor:send("- Find <b:yellow>" .. "%get.obj_shortdesc[%cloak%]%</> as the base for the new cloak.")
actor:send("- Find <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</> for decoration.")
actor:send("</>")
actor:send("You also need to take your cloak and <b:yellow>[search]</> in various treasure rooms.")
actor:send("Find \"<b:yellow>" .. tostring(place) .. "</>\".  It's " .. tostring(hint))
actor:send("</>")
actor:send("You can ask about your <b:cyan>[progress]</> at any time.'")$trig$, 'b33997166019f4f324ffbe9216cd264e'),
  -- data/triggers/053/053_30_rogue_cloak_progress.lua
  (53, 30, $trig$-- Converted from DG Script #5330: Rogue Cloak Progress
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: status progress
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "status") or string.find(string.lower(speech), "progress")) then
    return true  -- No matching keywords
end
wait(2)
actor:send("<b:green>Treasure Hunters</>")
if actor:get_has_completed("treasure_hunter") then
    actor:send(tostring(self.name) .. " says, 'Only great treasures, the stuff of legend, still wait out there!'")
elseif not actor:get_quest_stage("treasure_hunter") then
    actor:send(tostring(self.name) .. " says, 'You aren't doing anything for me right now.'")
elseif actor:get_quest_var("treasure_hunter:hunt") == "found" then
    actor:send(tostring(self.name) .. " says, 'Give me your current order first.'")
elseif actor.level >= (actor:get_quest_stage("treasure_hunter") - 1) * 10 then
    if actor:get_quest_var("treasure_hunter:hunt") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't doing anything for me right now.'")
    else
        -- switch on actor:get_quest_stage("treasure_hunter")
        if actor:get_quest_stage("treasure_hunter") == 1 then
            actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find that singing chain and I'll pay you for your time.'")
        elseif actor:get_quest_stage("treasure_hunter") == 2 then
            actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find one of the true fire rings the theatre in Anduin gives out.  Not the fake prop ones most of the performers carry around, but the real ones they give out at their grand finale.'")
        elseif actor:get_quest_stage("treasure_hunter") == 3 then
            actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find a sandstone ring in the caves to the west.'")
        elseif actor:get_quest_stage("treasure_hunter") == 4 then
            actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Recover the electrum hoop lost in the bayou shipwreck.'")
        elseif actor:get_quest_stage("treasure_hunter") == 5 then
            actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Bring me back a Rainbow Shell from the volcanic islands.'")
        elseif actor:get_quest_stage("treasure_hunter") == 6 then
            actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Raid Mystwatch and bring back the legendary Stormshield.'")
        elseif actor:get_quest_stage("treasure_hunter") == 7 then
            actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Get your hands on a Snow Leopard Cloak.'")
        elseif actor:get_quest_stage("treasure_hunter") == 8 then
            actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find a magic ladder that uncoils itself.'")
        elseif actor:get_quest_stage("treasure_hunter") == 9 then
            actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Seek out a glowing phoenix feather.'")
        elseif actor:get_quest_stage("treasure_hunter") == 10 then
            actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Secure a piece of sleet armor.'")
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'There's still plenty of treasure out there, but it's too dangerous without more experience.  Come back when you've grown a little more.'")
end
if actor.class == "rogue" or actor.class == "bard" or actor.class == "thief" then
    actor:send("</>")
    actor:send("<b:green>Cloak and Shadow</>")
    local huntstage = actor:get_quest_stage("treasure_hunter")
    local cloakstage = actor:get_quest_stage("rogue_cloak")
    local job1 = actor:get_quest_var("rogue_cloak:cloaktask1")
    local job2 = actor:get_quest_var("rogue_cloak:cloaktask2")
    local job3 = actor:get_quest_var("rogue_cloak:cloaktask3")
    local job4 = actor:get_quest_var("rogue_cloak:cloaktask4")
    if actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for an promotion yet.  Come back when you've grown a bit.'")
        return _return_value
    elseif actor.level < (cloakstage * 10) then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for another promotion yet.  Come back when you've gained some more experience.'")
        return _return_value
    elseif actor:get_has_completed("rogue_cloak") then
        actor:send(tostring(self.name) .. " says, 'You've already been promoted as high as you can go!'")
        return _return_value
    end
    if cloakstage == 0 then
        self.room:send(tostring(self.name) .. " says, 'Sure.  You gotta <b:cyan>[hunt]</> down more treasure first though.'")
        return _return_value
    elseif (cloakstage >= huntstage) and not actor:get_has_completed("treasure_hunter") then
        actor:send(tostring(self.name) .. " says, 'Find some more treasures then we can talk.'")
        return _return_value
    end
    -- switch on cloakstage
    local place, hint
    if cloakstage == 1 then
        local cloak = 58801
        local gem = 55585
        place = "A Storage Room"
        hint = "in the house on the hill."
    elseif cloakstage == 2 then
        local cloak = 17307
        local gem = 55593
        place = "A Small Alcove"
        hint = "in the holy library."
    elseif cloakstage == 3 then
        local cloak = 10308
        local gem = 55619
        place = "either Treasure Room"
        hint = "in the paladin fortress."
    elseif cloakstage == 4 then
        local cloak = 12325
        local gem = 55659
        place = "The Treasure Room"
        hint = "beyond the Tower in the Wastes."
    elseif cloakstage == 5 then
        local cloak = 43022
        local gem = 55663
        place = "Treasury"
        hint = "in the ghostly fortress."
    elseif cloakstage == 6 then
        local cloak = 23810
        local gem = 55674
        place = "either Treasure Room with a chest"
        hint = "lost in the sands."
    elseif cloakstage == 7 then
        local cloak = 51013
        local gem = 55714
        place = "Mesmeriz's Secret Treasure Room"
        hint = "hidden deep underground."
    elseif cloakstage == 8 then
        local cloak = 58410
        local gem = 55740
        place = "Treasure Room"
        hint = "sunken in the swamp."
    elseif cloakstage == 9 then
        local cloak = 52009
        local gem = 55741
        place = "Treasure Room"
        hint = "buried with an ancient king."
    end
    local attack = cloakstage * 100
    if job1 or job2 or job3 or job4 then
        actor:send(tostring(self.name) .. " says, 'You've done the following:'")
        if job1 then
            actor:send("- attacked " .. tostring(attack) .. " times")
        end
        if job2 then
            actor:send("- found " .. "%get.obj_shortdesc[%cloak%]%")
        end
        if job3 then
            actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
        end
        if job4 then
            actor:send("- searched in " .. tostring(place))
        end
    end
    -- (empty send to actor)
    actor:send("You need to:")
    if job1 and job2 and job3 and job4 then
        actor:send("Just give me your old cloak.")
        return _return_value
    end
    if not job1 then
        local remaining = attack - actor:get_quest_var("rogue_cloak:attack_counter")
        actor:send("- attack <b:yellow>" .. tostring(remaining) .. "</> more times while wearing your cloak.")
    end
    if not job2 then
        actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%cloak%]%</>")
    end
    if not job3 then
        actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</>")
    end
    if not job4 then
        actor:send("- <b:yellow>search</> in a place called \"<b:yellow>" .. tostring(place) .. "</>\".")
        actor:send("</>   It's <b:yellow>" .. tostring(hint) .. "</>")
    end
end$trig$, '19a9572df359075395aa8c0f24acb06a'),
  -- data/triggers/053/053_38_elemental_chaos_hakujo_mission_receive.lua
  (53, 38, $trig$-- Converted from DG Script #5338: Elemental Chaos Hakujo mission receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- mission targets here
local stage, target1
if (object.zone_id == 53 and object.id == 20) then
    stage = 1
    target1 = "an imp"
elseif (object.zone_id == 53 and object.id == 21) then
    stage = 2
    target1 = "the Leading Player"
elseif (object.zone_id == 53 and object.id == 22) then
    stage = 3
    target1 = "the Chaos"
elseif (object.zone_id == 53 and object.id == 23) then
    stage = 4
    target1 = "whatever waits at the end of the shaman's vision quest"
elseif (object.zone_id == 53 and object.id == 24) then
    stage = 5
    target1 = "the Fangs of Yeenoghu"
elseif (object.zone_id == 53 and object.id == 25) then
    stage = 6
    target1 = "the fire elemental lord"
elseif (object.zone_id == 53 and object.id == 26) then
    stage = 7
    target1 = "an acolyte of Betrayal"
elseif (object.zone_id == 53 and object.id == 27) then
    stage = 8
    target1 = "for Cyprianum the Reaper"
elseif (object.zone_id == 53 and object.id == 28) then
    stage = 9
    target1 = "a Chaos Demon"
elseif (object.zone_id == 53 and object.id == 29) then
    stage = 10
    target1 = "the Norhamen"
end
if actor:get_quest_stage("elemental_chaos") == "stage" and actor:get_quest_var("elemental_chaos:bounty") == "dead" then
    local anti = "Anti-Paladin"
    wait(2)
    world.destroy(object)
    self:command("bow")
    actor:send(tostring(self.name) .. " says, 'Harmony follows your actions.'")
    local money = stage * 10
    self:command("give " .. tostring(money) .. " platinum " .. tostring(actor))
    local expcap
    if stage == 1 then
        expcap = 5
    else
        local bonus = (stage - 1) * 10
        expcap = bonus
    end
    local expmod
    if expcap < 9 then
        expmod = (((expcap * expcap) + expcap) / 2) * 55
    elseif expcap < 17 then
        expmod = 440 + ((expcap - 8) * 125)
    elseif expcap < 25 then
        expmod = 1440 + ((expcap - 16) * 175)
    elseif expcap < 34 then
        expmod = 2840 + ((expcap - 24) * 225)
    elseif expcap < 49 then
        expmod = 4640 + ((expcap - 32) * 250)
    elseif expcap < 90 then
        expmod = 8640 + ((expcap - 48) * 300)
    else
        expmod = 20940 + ((expcap - 89) * 600)
    end
    -- switch on person.class
    local expmod
    if person.class == "warrior" or person.class == "berserker" then
        expmod = (expmod + (expmod / 10))
    elseif person.class == "paladin" or person.class == "anti-paladin" or person.class == "ranger" then
        expmod = (expmod + ((expmod * 2) / 15))
    elseif person.class == "sorcerer" or person.class == "pyromancer" or person.class == "cryomancer" or person.class == "illusionist" or person.class == "bard" then
        expmod = (expmod + (expmod / 5))
    elseif person.class == "necromancer" or person.class == "monk" then
        expmod = (expmod + (expmod * 2) / 5)
    else
        expmod = expmod
    end
    actor:send("<b:yellow>You gain experience!</>")
    local setexp = (expmod * 10)
    local loop = 0
    while loop < 3 do
        actor:award_exp(setexp)
        loop = loop + 1
    end
    actor:set_quest_var("elemental_chaos", "target1", 0)
    actor:set_quest_var("elemental_chaos", "bounty", 0)
    wait(2)
    if stage < 10 then
        actor:advance_quest("elemental_chaos")
        actor:send(tostring(self.name) .. " says, 'I will investigate further.  Return later and I shall tell you my findings.'")
    else
        actor:complete_quest("elemental_chaos")
        actor:send(tostring(self.name) .. " says, 'You have done Balance a great service.'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'May this ring ever remind you to ever walk the Way.'")
        self.room:spawn_object(123, 106)
        self:command("give ring " .. tostring(actor))
    end
    if string.find(actor.class, "Monk") and actor:get_quest_stage("monk_vision") == 0 then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You are ready to begin your own path to <b:cyan>[Enlightenment]</>.'")
        self.room:spawn_object(2, 190)
        self:command("give vision " .. tostring(actor))
        wait(1)
        actor:send(tostring(self.name) .. " says, 'These markings represent your voyage.'")
        actor:start_quest("monk_vision")
        wait(2)
        if actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'Come back with that vision after you reach level 10.  We can discuss your voyage toward enlightenment then.'")
        end
    end
elseif actor:get_quest_stage("elemental_chaos") > stage then
    _return_value = true
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses the mission.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You already accomplished this!'")
elseif actor:get_quest_stage("elemental_chaos") < stage then
    wait(2)
    self:command("eye " .. tostring(actor))
    actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
    self.room:send(tostring(self.name) .. " rips up the mission!")
    world.destroy(object)
elseif actor:get_quest_var("elemental_chaos:bounty") == "running" then
    _return_value = true
    self.room:send(tostring(self.name) .. " refuses the mission.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You have to complete your mission first!")
    if stage == 5 then
        actor:send(tostring(target1) .. " are still out there.'")
    else
        actor:send(tostring(target1) .. " is still out there.'")
    end
end
return _return_value$trig$, '8b49681594633d1571038100c3d2572a'),
  -- data/triggers/053/053_41_monk_vision_hakujo_speech_vision.lua
  (53, 41, $trig$-- Converted from DG Script #5341: Monk Vision Hakujo speech vision
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: vision enlightenment
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "vision") or string.find(string.lower(speech), "enlightenment")) then
    return true  -- No matching keywords
end
local visionstage = actor:get_quest_stage("monk_vision")
local missionstage = actor:get_quest_stage("elemental_chaos")
local job1 = actor:get_quest_var("monk_vision:visiontask1")
local job2 = actor:get_quest_var("monk_vision:visiontask2")
local job3 = actor:get_quest_var("monk_vision:visiontask3")
local job4 = actor:get_quest_var("monk_vision:visiontask4")
wait(2)
if actor.class ~= "monk" then
    self:command("shake")
    actor:send(tostring(self.name) .. " says, 'Only monks have the mental fortitude to seek Enlightenment.'")
    return _return_value
elseif actor.level < 10 then
    actor:send(tostring(self.name) .. " says, 'You aren't ready to start a journey to Enlightenment yet.  Come back when you've grown a bit.'")
    return _return_value
elseif actor.level < (visionstage * 10) then
    actor:send(tostring(self.name) .. " says, 'You aren't ready for another vision yet.  Come back when you've gained more experience.'")
    return _return_value
elseif actor:get_has_completed("monk_vision") then
    actor:send(tostring(self.name) .. " says, 'You are already awakened to the Illusion of Reality!'")
    return _return_value
end
if visionstage == 0 then
    self.room:send(tostring(self.name) .. " says, 'You must undertake a <b:cyan>[mission]</> in service of Balance first.'")
    return _return_value
elseif (visionstage >= missionstage) and not actor:get_has_completed("elemental_chaos") then
    actor:send(tostring(self.name) .. " says, 'You must walk further along the Way in service of Balance first.'")
    return _return_value
elseif job1 and job2 and job3 and job4 then
    actor:send(tostring(self.name) .. " says, 'Just give me your current vision mark.'")
    return _return_value
end
-- switch on visionstage
local place, hint
if visionstage == 1 then
    local book = 59006
    local gem = 55582
    local room = get_room("4328")
    place = room.name
    hint = "in a place to perform."
elseif visionstage == 2 then
    local book = 18505
    local gem = 55591
    local room = get_room("58707")
    place = room.name
    hint = "near a sandy beach."
elseif visionstage == 3 then
    local book = 8501
    local gem = 55623
    local room = get_room("18597")
    place = room.name
    hint = "in a cloistered library."
elseif visionstage == 4 then
    local book = 12532
    local gem = 55655
    local room = get_room("58102")
    place = room.name
    hint = "on my home island."
elseif visionstage == 5 then
    local book = 16209
    local gem = 55665
    local room = get_room("16057")
    place = room.name
    hint = "in the ghostly fortress."
elseif visionstage == 6 then
    local book = 43013
    local gem = 55678
    local room = get_room("59054")
    place = room.name
    hint = "in the fortress of the zealous."
elseif visionstage == 7 then
    local book = 53009
    local gem = 55710
    local room = get_room("49079")
    place = room.name
    hint = "off-shore of the island of great beasts."
elseif visionstage == 8 then
    local book = 58415
    local gem = 55722
    local room = get_room("11820")
    place = room.name
    hint = "beyond the Blue-Fog Trail."
elseif visionstage == 9 then
    local book = 58412
    local gem = 55741
    local room = get_room("52075")
    place = room.name
    hint = "in the shattered citadel of Templace."
end
local attacks = visionstage * 100
self:command("nod")
if visionstage == 1 then
    actor:send(tostring(self.name) .. " says, 'You will undertake a series of vision quests, gathering esoteric works of philosophy, history, and magic.  With each vision quest you'll earn a new marking to signify your path toward Enlightenment.'")
    actor:send("</>")
end
actor:send(tostring(self.name) .. " says, 'For your vision quest do the following:")
actor:send("- Attack <b:yellow>" .. tostring(attacks) .. "</> times while wearing your current vision marking.")
actor:send("- Find <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</> to awaken your Third Eye charka and <b:yellow>%get.obj_shortdesc[%book%]%</>.")
actor:send("- While donning your vision marking, take gem and text to a place of deep reflection and <b:yellow>[read]</> the text to broaden your awareness.")
actor:send("</>  Go to \"<b:yellow>" .. tostring(place) .. "</>\".  It's " .. tostring(hint))
actor:send("</>")
actor:send("Once you have, bring the gem, text, and your vision marking back to me.")
actor:send("</>")
actor:send("You can ask about your <b:cyan>[progress]</> at any time.'")$trig$, '7820442749f47363c7a3401a02f2a4f5'),
  -- data/triggers/060/060_53_berix_bounty_hunt_receive.lua
  (60, 53, $trig$-- Converted from DG Script #6053: Berix bounty hunt receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Hoisted: branch-scoped `local` would not be visible to the rest of the script.
local stage, victim1, victim2, victim3, go, maskstage, item
-- switch on object.id
-- bounty contracts here
if (object.zone_id == 60 and object.id == 50) then
    stage = 1
    victim1 = "The King of the Meer Cats"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 51) then
    stage = 2
    victim1 = "the Noble"
    victim2 = "the Abbot"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 52) then
    stage = 3
    victim1 = "the O'Connor Chieftain"
    victim2 = "the McLeod Chieftain"
    victim3 = "the Cameron Chieftain"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 53) then
    stage = 4
    victim1 = "The Frakati Leader"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 54) then
    stage = 5
    victim1 = "Cyrus"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 55) then
    stage = 6
    victim1 = "Lord Venth"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 56) then
    stage = 7
    victim1 = "The high druid of Anlun Vale"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 57) then
    stage = 8
    victim1 = "The Lizard King"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 58) then
    stage = 9
    victim1 = "Sorcha"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 59) then
    stage = 10
    victim1 = "The Goblin King"
    go = "hunt"
    -- assassin mask items start here
elseif object.id == 350 then
    maskstage = 1
    item = "quest"
    go = "mask"
elseif (object.zone_id == 45 and object.id == 0) then
    maskstage = 1
    item = "mask"
    go = "mask"
elseif (object.zone_id == 555 and object.id == 92) then
    maskstage = 1
    item = "gem"
    go = "mask"
elseif object.id == 351 then
    maskstage = 2
    item = "quest"
    go = "mask"
elseif (object.zone_id == 178 and object.id == 9) then
    maskstage = 2
    item = "mask"
    go = "mask"
elseif (object.zone_id == 555 and object.id == 94) then
    maskstage = 2
    item = "gem"
    go = "mask"
elseif object.id == 352 then
    maskstage = 3
    item = "quest"
    go = "mask"
elseif (object.zone_id == 590 and object.id == 23) then
    maskstage = 3
    item = "mask"
    go = "mask"
elseif (object.zone_id == 556 and object.id == 20) then
    maskstage = 3
    item = "gem"
    go = "mask"
elseif object.id == 353 then
    maskstage = 4
    item = "quest"
    go = "mask"
elseif (object.zone_id == 103 and object.id == 4) then
    maskstage = 4
    item = "mask"
    go = "mask"
elseif (object.zone_id == 556 and object.id == 38) then
    maskstage = 4
    item = "gem"
    go = "mask"
elseif object.id == 354 then
    maskstage = 5
    item = "quest"
    go = "mask"
elseif (object.zone_id == 162 and object.id == 0) then
    maskstage = 5
    item = "mask"
    go = "mask"
elseif (object.zone_id == 556 and object.id == 66) then
    maskstage = 5
    item = "gem"
    go = "mask"
elseif object.id == 355 then
    maskstage = 6
    item = "quest"
    go = "mask"
elseif (object.zone_id == 430 and object.id == 17) then
    maskstage = 6
    item = "mask"
    go = "mask"
elseif (object.zone_id == 556 and object.id == 75) then
    maskstage = 6
    item = "gem"
    go = "mask"
elseif object.id == 356 then
    maskstage = 7
    item = "quest"
    go = "mask"
elseif (object.zone_id == 510 and object.id == 75) then
    maskstage = 7
    item = "mask"
    go = "mask"
elseif (object.zone_id == 556 and object.id == 93) then
    maskstage = 7
    item = "gem"
    go = "mask"
elseif object.id == 357 then
    maskstage = 8
    item = "quest"
    go = "mask"
elseif (object.zone_id == 490 and object.id == 62) then
    maskstage = 8
    item = "mask"
    go = "mask"
elseif (object.zone_id == 557 and object.id == 19) then
    maskstage = 8
    item = "gem"
    go = "mask"
elseif object.id == 358 then
    maskstage = 9
    item = "quest"
    go = "mask"
elseif (object.zone_id == 484 and object.id == 27) then
    maskstage = 9
    item = "mask"
    go = "mask"
elseif (object.zone_id == 557 and object.id == 43) then
    maskstage = 9
    item = "gem"
    go = "mask"
else
    _return_value = true
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:say("What is this for?")
    return _return_value
end
if go == "hunt" then
    -- Bug fix: the converter compared quest_stage to the string "stage" instead of
    -- the local variable `stage` set above; restore the variable comparison.
    if actor:get_quest_stage("bounty_hunt") == stage and actor:get_quest_var("bounty_hunt:bounty") == "dead" then
        wait(2)
        world.destroy(object)
        self:command("nod")
        actor:send(tostring(self.name) .. " says, 'Well done.  Here's your payment.'")
        local money = stage * 10
        self:command("give " .. tostring(money) .. " platinum " .. tostring(actor))
        -- Hoisted: branch-scoped `local` would not be visible later.
        local expcap, expmod
        if stage == 1 then
            expcap = 5
        else
            expcap = (stage - 1) * 10
        end
        if expcap < 9 then
            expmod = (((expcap * expcap) + expcap) / 2) * 55
        elseif expcap < 17 then
            expmod = 440 + ((expcap - 8) * 125)
        elseif expcap < 25 then
            expmod = 1440 + ((expcap - 16) * 175)
        elseif expcap < 34 then
            expmod = 2840 + ((expcap - 24) * 225)
        elseif expcap < 49 then
            expmod = 4640 + ((expcap - 32) * 250)
        elseif expcap < 90 then
            expmod = 8640 + ((expcap - 48) * 300)
        else
            expmod = 20940 + ((expcap - 89) * 600)
        end
        -- Bug fix: original referred to `person.class` but `person` is undefined
        -- here; use `actor.class`.
        if actor.class == "warrior" or actor.class == "berserker" then
            expmod = (expmod + (expmod / 10))
        elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
            expmod = (expmod + ((expmod * 2) / 15))
        elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
            expmod = (expmod + (expmod / 5))
        elseif actor.class == "necromancer" or actor.class == "monk" then
            expmod = (expmod + (expmod * 2) / 5)
        end
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 3 do
            actor:award_exp(setexp)
            loop = loop + 1
        end
        actor:set_quest_var("bounty_hunt", "target1", 0)
        actor:set_quest_var("bounty_hunt", "target2", 0)
        actor:set_quest_var("bounty_hunt", "target3", 0)
        actor:set_quest_var("bounty_hunt", "bounty", 0)
        wait(2)
        if stage < 10 then
            actor:advance_quest("bounty_hunt")
            actor:send(tostring(self.name) .. " says, 'Check in again if you have time for more work.'")
        else
            actor:complete_quest("bounty_hunt")
            actor:send(tostring(self.name) .. " says, 'Congratulations, you've really proven yourself out there!  'Fraid there ain't much more we can toss your way.'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Take this to commemorate your hunt.'")
            self.room:spawn_object(4, 43)
            self:command("give shroud " .. tostring(actor))
        end
        if string.find(actor.class, "Assassin") and actor:get_quest_stage("assassin_mask") == 0 then
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I think you've earned this too.'")
            self.room:spawn_object(2, 150)
            self:command("give mask " .. tostring(actor))
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Masks like these show the rank of members of the Assassin Guild.'")
            actor:start_quest("assassin_mask")
            wait(2)
            if actor.level > 9 then
                actor:send(tostring(self.name) .. " says, 'This might be a good time to talk about a <b:cyan>[promotion]</>.'")
            else
                actor:send(tostring(self.name) .. " says, 'Come back with that mask after you reach level 10 and let's talk about a promotion.'")
            end
        end
    elseif actor:get_quest_stage("bounty_hunt") > stage then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses the contract.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You already completed this contract!'")
    elseif actor:get_quest_stage("bounty_hunt") < stage then
        wait(2)
        self:command("eye " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
        self.room:send(tostring(self.name) .. " rips up the contract!")
        world.destroy(object)
    elseif actor:get_quest_var("bounty_hunt:bounty") ~= "dead" then
        _return_value = true
        self.room:send(tostring(self.name) .. " refuses the contract.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You have to finish the job first!'")
        if stage ~= 2 and stage ~= 3 then
            actor:send(tostring(victim1) .. " is still out there.")
        elseif stage == 2 or stage == 3 then
            if not actor:get_quest_var("bounty_hunt:target1") then
                actor:send(tostring(victim1) .. " is still out there.")
            end
            if not actor:get_quest_var("bounty_hunt:target2") then
                actor:send(tostring(victim2) .. " is still out there.")
            end
            if stage == 3 and not actor:get_quest_var("bounty_hunt:target3") then
                actor:send(tostring(victim3) .. " is still out there.")
            end
        end
    end
elseif go == "mask" then
    if actor:get_quest_stage("bounty_hunt") < actor:get_quest_stage("assassin_mask") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Complete some more contract jobs first.'")
    elseif actor.level < (actor:get_quest_stage("assassin_mask") * 10) then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You need to gain some more experience first.'")
    elseif maskstage > actor:get_quest_stage("assassin_mask") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Your mask doesn't involve that yet.  Be patient!'")
    elseif maskstage < actor:get_quest_stage("assassin_mask") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You've already gained that rank.'")
    else
        if item == "quest" then
            local job1 = actor:get_quest_var("assassin_mask:masktask1")
            local job2 = actor:get_quest_var("assassin_mask:masktask2")
            local job3 = actor:get_quest_var("assassin_mask:masktask3")
            local job4 = actor:get_quest_var("assassin_mask:masktask4")
            if job1 and job2 and job3 and job4 then
                wait(2)
                local reward = object.id + 1
                world.destroy(object)
                self:command("nod")
                actor:send(tostring(self.name) .. " says, 'Well done!  You've proven your qualifications.'")
                self.room:spawn_object(math.floor(reward / 100), reward % 100)
                self:command("give mask " .. tostring(actor))
                local expcap = maskstage * 10
                -- Hoisted: branch-scoped `local expmod` would not be visible.
                local expmod
                if expcap < 17 then
                    expmod = 440 + ((expcap - 8) * 125)
                elseif expcap < 25 then
                    expmod = 1440 + ((expcap - 16) * 175)
                elseif expcap < 34 then
                    expmod = 2840 + ((expcap - 24) * 225)
                elseif expcap < 49 then
                    expmod = 4640 + ((expcap - 32) * 250)
                elseif expcap < 90 then
                    expmod = 8640 + ((expcap - 48) * 300)
                else
                    expmod = 20940 + ((expcap - 89) * 600)
                end
                actor:send("<b:yellow>You gain experience!</>")
                local setexp = (expmod * 10)
                local loop = 0
                while loop < 7 do
                    actor:award_exp(setexp)
                    loop = loop + 1
                end
                local number = 1
                while number < 5 do
                    -- Bug fix: DG `%number%` interpolation; use Lua concat.
                    actor:set_quest_var("assassin_mask", "masktask" .. tostring(number), 0)
                    number = number + 1
                end
                if actor:get_quest_stage("assassin_mask") < 9 then
                    actor:advance_quest("assassin_mask")
                else
                    actor:complete_quest("assassin_mask")
                end
            else
                _return_value = true
                self:command("shake")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'You need to do everything else before you give me your guild mask!'")
            end
        end
        -- Hoisted: branch-scoped `local accept` would not be visible to the
        -- accept-check below. Default nil (skips the `accept` ladder when
        -- the item == "quest" branch above was taken).
        local accept
        if item == "mask" then
            if actor:get_quest_var("assassin_mask:masktask2") == object.id then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("assassin_mask", "masktask2", object.id)
            end
        elseif item == "gem" then
            if actor:get_quest_var("assassin_mask:masktask3") == object.id then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("assassin_mask", "masktask3", object.id)
            end
        end
        if accept == "no" then
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'You already gave me that.'")
        elseif accept == "yes" then
            wait(2)
            world.destroy(object)
            local job1 = actor:get_quest_var("assassin_mask:masktask1")
            local job2 = actor:get_quest_var("assassin_mask:masktask2")
            local job3 = actor:get_quest_var("assassin_mask:masktask3")
            local job4 = actor:get_quest_var("assassin_mask:masktask4")
            if job1 and job2 and job3 and job4 then
                actor:send(tostring(self.name) .. " says, 'Excellent.  Now give me your guild mask for your promotion.'")
            else
                actor:send(tostring(self.name) .. " says, 'Good, now finish the rest.'")
            end
        end
    end
end
return _return_value$trig$, '6ee898d400df4c4c4e78de46dd1dbd64'),
  -- data/triggers/060/060_57_berix_assassin_mask_promotion_speech.lua
  (60, 57, $trig$-- Converted from DG Script #6057: Berix assassin mask promotion speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: promotion
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "promotion")) then
    return true  -- No matching keywords
end
local maskstage = actor:get_quest_stage("assassin_mask")
local bountystage = actor:get_quest_stage("bounty_hunt")
local job1 = actor:get_quest_var("assassin_mask:masktask1")
local job2 = actor:get_quest_var("assassin_mask:masktask2")
local job3 = actor:get_quest_var("assassin_mask:masktask3")
local job4 = actor:get_quest_var("assassin_mask:masktask4")
wait(2)
if actor.class ~= "assassin" then
    self.room:send(tostring(self.name) .. " scoffs in disgust.")
    actor:send(tostring(self.name) .. " says, 'You ain't part of the Guild.  Get lost.'")
    return _return_value
elseif actor.level < 10 then
    actor:send(tostring(self.name) .. " says, 'You ain't ready for a promotion yet.  Come back when you've grown a bit.'")
    return _return_value
elseif actor.level < (maskstage * 10) then
    self:say("You ain't ready for another promotion yet.  Come back when you've gained some more experience.")
    return _return_value
elseif actor:get_has_completed("assassin_mask") then
    actor:send(tostring(self.name) .. " says, 'You've already gone as high as you can go!'")
    return _return_value
end
if maskstage == 0 then
    self.room:send(tostring(self.name) .. " says, 'Sure.  You gotta do a <b:cyan>[job]</> for me first though.'")
    return _return_value
elseif (maskstage >= bountystage) and not actor:get_has_completed("bounty_hunt") then
    actor:send(tostring(self.name) .. " says, 'Complete some more contract jobs then we can talk.'")
    return _return_value
elseif job1 and job2 and job3 and job4 then
    actor:send(tostring(self.name) .. " says, 'You're all ready, just give me your old mask.'")
    return _return_value
end
-- switch on maskstage
-- Hoisted: branch-scoped `local` here would not be visible to the
-- code below that uses mask/gem/place/hint.
local mask, gem, place, hint
if maskstage == 1 then
    mask = 4500
    gem = 55592
    place = "The Shadowy Lair"
    hint = "in the Misty Caverns."
elseif maskstage == 2 then
    mask = 17809
    gem = 55594
    place = "The Dark Chamber"
    hint = "behind a desert door."
elseif maskstage == 3 then
    mask = 59023
    gem = 55620
    place = "A Dark Tunnel"
    hint = "on the way to a dark, hidden city."
elseif maskstage == 4 then
    mask = 10304
    gem = 55638
    place = "Dark Chamber"
    hint = "hidden below a ghostly fortress."
elseif maskstage == 5 then
    mask = 16200
    gem = 55666
    place = "Darkness......"
    hint = "inside an enchanted closet."
elseif maskstage == 6 then
    mask = 43017
    gem = 55675
    place = "Surrounded by Darkness"
    hint = "in a volcanic shaft."
elseif maskstage == 7 then
    mask = 51075
    gem = 55693
    place = "Dark Indecision"
    hint = "before an altar in a fallen maze."
elseif maskstage == 8 then
    mask = 49062
    gem = 55719
    place = "Heart of Darkness"
    hint = "buried deep in an ancient tomb."
elseif maskstage == 9 then
    mask = 48427
    gem = 55743
    place = "A Dark Room"
    hint = "under the ruins of a shop in an ancient city."
end
local attacks = maskstage * 100
self:command("nod")
actor:send(tostring(self.name) .. " says, 'Sure, I can help you climb the ranks.  Each new station you'll earn a new mask.  Do the following:")
actor:send("- Attack &9<blue>" .. tostring(attacks) .. "</> times while wearing your current mask.")
-- TODO(parity): %get.obj_shortdesc[%mask%]% / %get.obj_shortdesc[%gem%]%
-- DG remnants. `mask` and `gem` are legacy global vnums (e.g. 4500, 55592)
-- and need to be split into (zone, local) before calling
-- objects.template(zone, id).name. Showing raw IDs as a placeholder.
actor:send("- Find &9<blue>object id " .. tostring(mask) .. "</> as the base for the new mask.")
actor:send("- Find &9<blue>object id " .. tostring(gem) .. "</> for decoration.")
actor:send("</>")
actor:send("You also need to take your mask and &9<blue>[hide]</> in a secret, dark, shadowy place.")
actor:send("Find \"&9<blue>" .. tostring(place) .. "</>\".  It's " .. tostring(hint))
actor:send("</>")
actor:send("You can ask about your <b:cyan>[mask progress]</> at any time.'")$trig$, '50fd85d042e39585fc427f84e9da3822'),
  -- data/triggers/060/060_59_assassin_mask_progress_checker.lua
  (60, 59, $trig$-- Converted from DG Script #6059: Assassin mask progress checker
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"status", "progress"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
actor:send("<b:green>Contract Killers</>")
if actor:get_has_completed("bounty_hunt") then
    actor:send(tostring(self.name) .. " says, 'You know, I'm fresh out of work for you.  Good luck!'")
elseif not actor:get_quest_stage("bounty_hunt") then
    actor:send(tostring(self.name) .. " says, 'You aren't doing a job for me.'")
elseif actor:get_quest_var("bounty_hunt:bounty") == "dead" then
    actor:send(tostring(self.name) .. " says, 'Give me your current contract.'")
elseif actor.level >= (actor:get_quest_stage("bounty_hunt") - 1) * 10 then
    if actor:get_quest_var("bounty_hunt:bounty") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't doing a job for me.'")
    else
        -- switch on actor:get_quest_stage("bounty_hunt")
        if actor:get_quest_stage("bounty_hunt") == 1 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Best get on killing that cat-king or whatever first.'")
        elseif actor:get_quest_stage("bounty_hunt") == 2 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Take out the Noble and the Abbot  sheltering him at the Abbey of St. George.'")
        elseif actor:get_quest_stage("bounty_hunt") == 3 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Take out the three Chieftains in the southwestern Highlands.'")
        elseif actor:get_quest_stage("bounty_hunt") == 4 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Find the Frakati Leader and kill him.'")
        elseif actor:get_quest_stage("bounty_hunt") == 5 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Infiltrate the Sacred Haven and take out the number two in command, Cyrus.'")
        elseif actor:get_quest_stage("bounty_hunt") == 6 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Disappear Lord Venth down south.'")
        elseif actor:get_quest_stage("bounty_hunt") == 7 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Send the high druid on a permanent pilgrimage.'")
        elseif actor:get_quest_stage("bounty_hunt") == 8 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Kill the Lizard King.  If you can even find him...'")
        elseif actor:get_quest_stage("bounty_hunt") == 9 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Take out the leader of the Ice Cult up north before they get wind of it.'")
        elseif actor:get_quest_stage("bounty_hunt") == 10 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  End the reign of the Goblin King.  We'll all probably dream a little more soundly then.'")
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'All my other jobs are too risky for someone without moreexperience.  Come back when you've seen a little more.'")
end
if actor.class == "assassin" then
    actor:send("</>")
    actor:send("<b:green>Deadly Promotion</>")
    local bountystage = actor:get_quest_stage("bounty_hunt")
    local maskstage = actor:get_quest_stage("assassin_mask")
    local job1 = actor:get_quest_var("assassin_mask:masktask1")
    local job2 = actor:get_quest_var("assassin_mask:masktask2")
    local job3 = actor:get_quest_var("assassin_mask:masktask3")
    local job4 = actor:get_quest_var("assassin_mask:masktask4")
    wait(2)
    if actor.class ~= "assassin" then
        self.room:send(tostring(self.name) .. " scoffs in disgust.")
        actor:send(tostring(self.name) .. " says, 'You ain't part of the Guild.  Get lost.'")
        return _return_value
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'You ain't ready for a promotion yet.  Come back when you've grown a bit.'")
        return _return_value
    elseif actor.level < (maskstage * 10) then
        actor:send(tostring(self.name) .. " says, 'You ain't ready for another promotion yet.  Come back when you've gained some more experience.'")
        return _return_value
    elseif actor:get_has_completed("assassin_mask") then
        actor:send(tostring(self.name) .. " says, 'You've already gone as high as you can go!'")
        return _return_value
    end
    if maskstage == 0 then
        actor:send(tostring(self.name) .. " says, 'Sure.  You gotta do a <b:cyan>[job]</> for me first though.'")
        return _return_value
    elseif (maskstage >= bountystage) and not actor:get_has_completed("bounty_hunt") then
        actor:send(tostring(self.name) .. " says, 'Complete some more contract jobs then we can talk.'")
        return _return_value
    end
    -- switch on maskstage
    -- Hoisted: branch-scoped `local` here would not be visible to the
    -- code below that uses mask/gem/place/hint.
    local mask, gem, place, hint
    if maskstage == 1 then
        mask = 4500
        gem = 55592
        place = "The Shadowy Lair"
        hint = "in the Misty Caverns."
    elseif maskstage == 2 then
        mask = 17809
        gem = 55594
        place = "The Dark Chamber"
        hint = "behind a desert door."
    elseif maskstage == 3 then
        mask = 59023
        gem = 55620
        place = "A Dark Tunnel"
        hint = "on the way to a dark, hidden city."
    elseif maskstage == 4 then
        mask = 10304
        gem = 55638
        place = "Dark Chamber"
        hint = "hidden below a ghostly fortress."
    elseif maskstage == 5 then
        mask = 16200
        gem = 55666
        place = "Darkness......"
        hint = "inside an enchanted closet."
    elseif maskstage == 6 then
        mask = 43017
        gem = 55675
        place = "Surrounded by Darkness"
        hint = "in a volcanic shaft."
    elseif maskstage == 7 then
        mask = 51075
        gem = 55693
        place = "Dark Indecision"
        hint = "before an altar in a fallen maze."
    elseif maskstage == 8 then
        mask = 49062
        gem = 55719
        place = "Heart of Darkness"
        hint = "buried deep in an ancient tomb."
    elseif maskstage == 9 then
        mask = 48427
        gem = 55743
        place = "A Dark Room"
        hint = "under the ruins of a shop in an ancient city."
    end
    local attack = maskstage * 100
    if job1 or job2 or job3 or job4 then
        actor:send(tostring(self.name) .. " says, You've done the following:'")
        if job1 then
            actor:send("- attacked " .. tostring(attack) .. " times")
        end
        if job2 then
            -- TODO(parity): DG %get.obj_shortdesc[%mask%]% — needs (zone, local) split.
            actor:send("- found object id " .. tostring(mask))
        end
        if job3 then
            -- TODO(parity): DG %get.obj_shortdesc[%gem%]% — needs (zone, local) split.
            actor:send("- found object id " .. tostring(gem))
        end
        if job4 then
            actor:send("- hidden in " .. tostring(place))
        end
    end
    -- (empty send to actor)
    actor:send("You need to:")
    if job1 and job2 and job3 and job4 then
        actor:send("Just give me your old mask.")
        return _return_value
    end
    if not job1 then
        local remaining = attack - actor:get_quest_var("assassin_mask:attack_counter")
        actor:send("- attack &9<blue>" .. tostring(remaining) .. "</> more times while wearing your mask.")
    end
    if not job2 then
        -- TODO(parity): DG %get.obj_shortdesc[%mask%]% — needs (zone, local) split.
        actor:send("- find &9<blue>object id " .. tostring(mask) .. "</>")
    end
    if not job3 then
        -- TODO(parity): DG %get.obj_shortdesc[%gem%]% — needs (zone, local) split.
        actor:send("- find &9<blue>object id " .. tostring(gem) .. "</>")
    end
    if not job4 then
        actor:send("- &9<blue>hide in a place called \"&9<blue>" .. tostring(place) .. "</>\".")
        actor:send("</>   It's &9<blue>" .. tostring(hint) .. "</>")
    end
end$trig$, 'ad525a365786237667d5eac08b8806a5'),
  -- data/triggers/103/103_04_rianne-quest-receive.lua
  (103, 4, $trig$local function obj_key(o)
    return tostring(o.zone_id) .. "_" .. tostring(o.local_id)
end

-- ---------------------------------------------------------------
-- Daedela group_heal sub-branch (added 3-9-2021)
-- ---------------------------------------------------------------
if actor:get_quest_stage("group_heal") == 5 then
    local self_key = "group_heal:" .. tostring(self.zone_id) .. "_" .. tostring(self.local_id)
    local already = actor:get_quest_var(self_key)
    -- 18514 is a book — naive vnum mapping is (185, 14)
    if object.zone_id == 185 and object.local_id == 14 then
        if already and already ~= 0 and already ~= "" and already ~= "0" then
            self:say("I've told you everything I can.  Good luck!")
            return true
        end
        actor:set_quest_var("group_heal", tostring(self.zone_id) .. "_" .. tostring(self.local_id), 1)
        self:say("Well you've definitely come to the right place!")
        wait(4)
        self:emote("reads over the ritual recipe.")
        wait(4)
        self.room:send(self.name .. " says, 'Oh my, what a challenge.  No wonder someone would need help with this.'")
        wait(3)
        self.room:send(self.name .. " says, 'The names for many of these ingredients have changed since...  How old is this recipe anyway??'")
        wait(1)
        self:command("beam")
        self:say("I love it.")
        wait(3)
        self:emote("begins writing down a list of notes.")
        wait(1)
        self:say("... and this is called this...")
        wait(1)
        self:say("... this can be substituted with this...")
        wait(2)
        self.room:send(self.name .. " says, '... that's been extinct for over a century, so perhaps this will do...?'")
        wait(4)
        self:emote("finishes her list.")
        self.room:spawn_object(185, 20)
        self:command("give notes " .. actor.name)
        wait(2)
        self:say("That should help you.  I can't wait to hear how it goes!")
        self:command("wave " .. actor.name)
        return true
    end
end

-- ---------------------------------------------------------------
-- resort_cooking
-- ---------------------------------------------------------------
local stage = actor:get_quest_stage("resort_cooking")
local recipe, next_recipe
local ingredients  -- list of {zone, id} for the seven slots
local slot_count

-- Per-stage ingredient tables. Each row is {zone, id}; rows 1..N
-- must match the original item1..itemN vnums. nil-tail rows are
-- absent slots for that stage.
if stage == 1 then
    recipe, next_recipe = "Peach Cobbler", "Seafood Salad"
    ingredients = {{615, 1}, {237, 54}, {30, 114}, {350, 1}}
    slot_count = 4
elseif stage == 2 then
    recipe, next_recipe = "Seafood Salad", "Fish Stew"
    ingredients = {{490, 24}, {237, 50}, {237, 22}, {80, 3}, {125, 15}, {16, 6}}
    slot_count = 6
elseif stage == 3 then
    recipe, next_recipe = "Fish Stew", "Honey-Glazed Ham"
    ingredients = {{552, 13}, {300, 2}, {100, 30}, {125, 52}, {237, 57}, {185, 9}, {103, 11}}
    slot_count = 7
elseif stage == 4 then
    recipe, next_recipe = "Honey-Glazed Ham", "Saffroned Jasmine Rice"
    ingredients = {{410, 11}, {83, 50}, {20, 1}, {502, 7}, {61, 6}}
    slot_count = 5
elseif stage == 5 then
    recipe = "Saffroned Jasmine Rice"
    ingredients = {{580, 19}, {370, 13}, {237, 60}}
    slot_count = 3
else
    self:say("I don't have time for that right now.")
    self:emote("refuses your item.")
    return false
end

-- Which slot does the offered object match?
local matched_slot
for i = 1, slot_count do
    local row = ingredients[i]
    if row and object.zone_id == row[1] and object.local_id == row[2] then
        matched_slot = i
        break
    end
end
if not matched_slot then
    self.room:send(self.name .. " says, 'The recipe doesn't call for this!  Perhaps you should consult the recipe on the wall to refresh your memory.'")
    return false
end

-- Already turned this one in?
local slot_key = "item" .. tostring(matched_slot)
local already = actor:get_quest_var("resort_cooking:" .. slot_key)
if already and already ~= 0 and already ~= "" and already ~= "0" then
    self.room:send(self.name .. " says, 'You already brought in " .. tostring(object.shortdesc) .. ", so we don't need more.'")
    self:emote("hands your item back to you.")
    return false
end

wait(1)
world.destroy(object)
wait(4)
self.room:send(self.name .. " says, 'Just what we need for <b:white>" .. recipe .. "</>!'")
actor:set_quest_var("resort_cooking", slot_key, 1)

-- All per-stage slots collected?
local complete = true
for i = 1, slot_count do
    local v = actor:get_quest_var("resort_cooking:item" .. tostring(i))
    if not v or v == 0 or v == "" or v == "0" then
        complete = false
        break
    end
end

if complete then
    actor:advance_quest("resort_cooking")
    -- Reset the per-stage slot vars
    for i = 1, slot_count do
        actor:set_quest_var("resort_cooking", "item" .. tostring(i), 0)
    end
    self:say("I think I can start preparing it now.")
    wait(1)
    self:emote("gets the other ingredients from the icebox.")
    self:emote("begins mixing them together.")
    wait(2)

    if stage == 5 then
        -- Final reward
        self.room:send(self.name .. " says, 'You've been such a great help, " .. actor.name .. "!  Now I'm almost prepared for this huge dinner party, thanks!'")
        wait(3)
        self:say("I'd like you to have this.")
        wait(5)
        self.room:send(self.name .. " says, 'It was enchanted by a good friend of mine, so I hope it will help you as much as you've helped me.'")
        self.room:spawn_object(103, 15)
        for _ = 1, 3 do
            -- TODO(parity): original spawned random.gem from a 55736+1..11
            -- contiguous range; runtime has no slot range helper, so we
            -- approximate with the same numeric range mapped to (557, 36..46).
            self.room:spawn_object(557, 36 + random(1, 11))
        end
        self:command("give all.gem " .. actor.name)

        -- Class-adjusted experience curve, preserved verbatim
        local expcap = actor.level
        if expcap > 65 then expcap = 65 end
        local expmod
        if expcap < 9 then
            expmod = (((expcap * expcap) + expcap) / 2) * 55
        elseif expcap < 17 then
            expmod = 440 + ((expcap - 8) * 125)
        elseif expcap < 25 then
            expmod = 1440 + ((expcap - 16) * 175)
        elseif expcap < 34 then
            expmod = 2840 + ((expcap - 24) * 225)
        elseif expcap < 49 then
            expmod = 4640 + ((expcap - 32) * 250)
        elseif expcap < 90 then
            expmod = 8640 + ((expcap - 48) * 300)
        else
            expmod = 20940 + ((expcap - 89) * 600)
        end

        local cls = actor.class
        if cls == "warrior" or cls == "berserker" then
            expmod = expmod + (expmod / 10)
        elseif cls == "paladin" or cls == "anti-paladin" or cls == "ranger" then
            expmod = expmod + ((expmod * 2) / 15)
        elseif cls == "sorcerer" or cls == "pyromancer" or cls == "cryomancer"
            or cls == "illusionist" or cls == "bard" then
            expmod = expmod + (expmod / 5)
        elseif cls == "necromancer" or cls == "monk" then
            expmod = expmod + (expmod * 2) / 5
        end

        actor:send("<b:yellow>You gain experience!</>")
        local setexp = expmod * 10
        for _ = 1, 10 do
            actor:award_exp(setexp)
        end
        actor:complete_quest("resort_cooking")
    else
        self.room:send(self.name .. " says, 'I'll keep preparing this while you collect items for the next recipe.'")
        self:command("ponder")
        wait(1)
        self:say("The next dish is " .. tostring(next_recipe) .. ".")
        wait(2)
        self:say("Here's the recipe.  Please take a look at it.")
        self:emote("points out a slip of paper hanging on the wall.")
    end
else
    self:emote("puts the item into the icebox.")
    wait(1)
    self:say("Thanks!  Quickly, bring the rest!")
end

self:command("drop all")
return true$trig$, 'e845951d7a1808ae454a96a062c93146'),
  -- data/triggers/103/103_08_hot-spring.lua
  (103, 8, $trig$local who = actor
if not who then
    if room and self.room.actors and #self.room.actors > 0 then
        who = self.room.actors[random(1, #self.room.actors)]
    end
end
if not who or not who.is_player then
    return true
end

local heat_resistant = who:has_effect(Effect.HeatResistance)
if who.class == "pyromancer" or heat_resistant then
    return true
end

local damage = random(1, 10) + random(1, 10)
self.room:send_except(who, who.name .. " starts to look a bit woozy from the extreme heat.")
who:send("The water is too hot for you....")
who:damage(damage)  -- physical heat damage
return true$trig$, '35ab4083f39789d35fe5352b60c6bcf5'),
  -- data/triggers/120/120_03_druid_receive.lua
  (120, 3, $trig$local stage = actor:get_quest_stage("twisted_sorrow")

-- Quest already complete: politely refuse.
if stage > 1 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(8)
    self:say("No further offerings are necessary.")
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- Quest not yet started: refuse with confusion.
if stage ~= 1 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(8)
    self:say("Why do you give me this?")
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- Stage 1: must be a liquid container.
if object.type ~= "DRINKCONTAINER" then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(4)
    self:say("This is not a liquid container.")
    wait(4)
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- Druid's home grove (no tree): redirect player.
if self.room == 12015 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(4)
    self:say("Let us move to one of the mighty Rhells first, friend.")
    wait(4)
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- Empty container: refuse.
if object.val1 == 0 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(4)
    self:emote("peers into " .. object.shortdesc .. ".")
    wait(4)
    self:say("This won't do at all!  It's empty.")
    wait(4)
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- This tree already satisfied: refuse.
if actor:get_quest_var("twisted_sorrow:satisfied_tree:" .. tostring(self.room)) == 1 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(4)
    self:say("This tree is already satisfied, my friend.")
    wait(4)
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- Otherwise: druid consumes the offering and may advance the quest.
wait(1)
self:emote("peers into " .. object.shortdesc .. ".")
wait(2)
self:command("nod")
wait(2)
self:command("kneel")
self:emote("places his hands on the mighty Rhell's roots.")
wait(5)
self:emote("continues to kneel, making no sound.")
wait(7)
self:command("stand")

-- Match liquid type to tree (object.val2 = liquid type code).
local success = false
if self.room == 12016 and object.val2 == 11 then            -- Tree of Luck: tea
    success = true
elseif self.room == 12017 and object.val2 > 0 and object.val2 < 5 then  -- Reverence: alcohol
    success = true
elseif self.room == 12018 and object.val2 == 0 then          -- Self-reliance: water
    success = true
elseif self.room == 12014 and object.val2 == 12 then         -- Nimbleness: coffee
    success = true
elseif self.room == 12046 and object.val2 == 10 then         -- Kindness: milk
    success = true
end

self.room:send(self.name .. " carefully pours out " .. object.shortdesc .. " onto the Rhell's roots.")
wait(1)
world.destroy(object)
wait(8)

if not success then
    self:command("sigh")
    wait(8)
    self:say("The tree is not responding.")
    wait(1)
    self:say("I fear it has little liking for that drink.")
    return false
end

local num_trees = 1 + actor:get_quest_var("twisted_sorrow:num_trees")
actor:set_quest_var("twisted_sorrow", "num_trees", num_trees)
actor:set_quest_var("twisted_sorrow", "satisfied_tree:" .. tostring(self.room), 1)
self.room:send("A deep throbbing hum is emanating from the ground.")
wait(3)
self.room:send("The hum gets louder and louder, causing twigs and leaves to dance upon the ground!")
self.room:send("It is overwhelming, yet soothing.")
wait(5)
self.room:send("The hum fades slowly away, and all is quiet again.")
wait(3)
self:command("smile")
wait(2)

if num_trees < 4 then
    self:say("You have done this tree a great service.")
elseif num_trees == 4 then
    self:say("I sense that yet another tree waits in loneliness.")
    wait(1)
    self:say("There can be no peace until it, too, is satisfied.")
elseif num_trees == 5 then
    self:say("Excellent, my friend!  The trees are satisfied.")
    wait(8)
    self:say("Please take this gift on their behalf.")
    wait(8)
    self.room:spawn_object(120, 18)
    self:command("give sleeves-sorrow " .. actor.name)
    wait(4)
    self:emote("walks away quietly.")
    actor:complete_quest("twisted_sorrow")

    -- Compute experience award scaled by capped level.
    local expcap
    if actor.level < 10 then
        expcap = actor.level
    else
        expcap = 10
    end
    local expmod
    if expcap < 9 then
        expmod = (((expcap * expcap) + expcap) / 2) * 55
    elseif expcap < 17 then
        expmod = 440 + ((expcap - 8) * 125)
    elseif expcap < 25 then
        expmod = 1440 + ((expcap - 16) * 175)
    elseif expcap < 34 then
        expmod = 2840 + ((expcap - 24) * 225)
    elseif expcap < 49 then
        expmod = 4640 + ((expcap - 32) * 250)
    elseif expcap < 90 then
        expmod = 8640 + ((expcap - 48) * 300)
    else
        expmod = 20940 + ((expcap - 89) * 600)
    end

    -- Class scaling so all classes receive the same proportionate amount.
    if actor.class == "warrior" or actor.class == "berserker" then
        expmod = expmod + (expmod / 10)                       -- 110%
    elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
        expmod = expmod + ((expmod * 2) / 15)                 -- 115%
    elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
        expmod = expmod + (expmod / 5)                        -- 120%
    elseif actor.class == "necromancer" or actor.class == "monk" then
        expmod = expmod + ((expmod * 2) / 5)                  -- 130%
    end

    actor:send("<b:yellow>You gain experience!</>")
    -- Legacy DG awarded expmod ten times in a loop; preserved for parity.
    for _ = 1, 10 do
        actor:award_exp(expmod)
    end
    self:teleport(get_room(120, 15))
end

return false$trig$, 'c8d83aeeeba0ac478e8422ebb29d54bc'),
  -- data/triggers/123/123_23_megalith_quest_mother_act_kneel_rewards.lua
  (123, 23, $trig$-- Converted from DG Script #12323: megalith_quest_mother_act_kneel_rewards
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: kneel
if not (cmd == "kneel") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- Legacy `return 0` comes first: the typed kneel always goes ahead.
_return_value = true
allow_command()
wait(2)
local bad1 = (actor:get_quest_var("megalith_quest:bad1") == 1) and 1 or 0
local bad2 = (actor:get_quest_var("megalith_quest:bad2") == 1) and 1 or 0
local bad3 = (actor:get_quest_var("megalith_quest:bad3") == 1) and 1 or 0
if actor:get_quest_stage("megalith_quest") == 5 then
    local total = bad1 + bad2 + bad3
    if total == 0 then
        actor:send(tostring(self.name) .. " gently leans forward and kisses your brow.")
        self.room:send_except(actor, tostring(self.name) .. " gently leans forward and kisses " .. tostring(actor.name) .. "'s brow.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'I bestow upon you the gifts of stars.  May their light")
        self.room:send("</>guide you the rest of your days.'")
        self.room:spawn_object(123, 98)
        self.room:spawn_object(123, 99)
        self:command("give belt-stars " .. tostring(actor.name))
        self:command("give starseed " .. tostring(actor.name))
        local gem = 0
        while gem < 3 do
            -- TODO(parity): the original drop pool used legacy 5-digit
            -- vnums 55736..55747. After the (zone, local_id) split, this
            -- gem set should live at zone 557 ids 36..47. Verify.
            self.room:spawn_object(557, 36 + random(1, 11))
            gem = gem + 1
        end
        self:command("give all.gem " .. tostring(actor.name))
    elseif total > 0 then
        actor:send(tostring(self.name) .. " places her hand on your shoulder.")
        self.room:send_except(actor, tostring(self.name) .. " places her hand on " .. tostring(actor.name) .. "'s shoulder.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'I bestow upon you a gift of stars.  May its light")
        self.room:send("</>guide you the rest of your days.'")
        local pick = random(1, 2)
        if pick == 1 then
            self.room:spawn_object(123, 98)
        elseif pick == 2 then
            self.room:spawn_object(123, 99)
        end
        local gem = 0
        while gem < 3 do
            self.room:spawn_object(557, 36 + random(1, 11))
            gem = gem + 1
        end
        self:command("give all " .. tostring(actor.name))
        wait(4)
        self:command("bow " .. tostring(actor.name))
    end
    -- Clear all the Bads, just in case.
    for slot = 1, 5 do
        actor:set_quest_var("megalith_quest", "bad" .. tostring(slot), 0)
    end
    actor:complete_quest("megalith_quest")
    -- Set X to the level of the award.
    local expcap
    if actor.level < 70 then
        expcap = actor.level
    else
        expcap = 70
    end
    local expmod
    if expcap < 9 then
        expmod = (((expcap * expcap) + expcap) / 2) * 55
    elseif expcap < 17 then
        expmod = 440 + ((expcap - 8) * 125)
    elseif expcap < 25 then
        expmod = 1440 + ((expcap - 16) * 175)
    elseif expcap < 34 then
        expmod = 2840 + ((expcap - 24) * 225)
    elseif expcap < 49 then
        expmod = 4640 + ((expcap - 32) * 250)
    elseif expcap < 90 then
        expmod = 8640 + ((expcap - 48) * 300)
    else
        expmod = 20940 + ((expcap - 89) * 600)
    end
    -- Adjust exp award by class so all classes receive the same proportionate amount.
    if actor.class == "warrior" or actor.class == "berserker" then
        -- 110% of standard
        expmod = expmod + (expmod / 10)
    elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
        -- 115% of standard
        expmod = expmod + ((expmod * 2) / 15)
    elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
        -- 120% of standard
        expmod = expmod + (expmod / 5)
    elseif actor.class == "necromancer" or actor.class == "monk" then
        -- 130% of standard
        expmod = expmod + (expmod * 2) / 5
    end
    actor:send("<b:yellow>You gain experience!</>")
    local setexp = (expmod * 10)
    local loop = 0
    while loop < 10 do
        actor:award_exp(setexp)
        loop = loop + 1
    end
end
return _return_value$trig$, '5728e78f3abb01e3475251360354c9ca'),
  -- data/triggers/125/125_19_brothersreunion.lua
  (125, 19, $trig$-- Converted from DG Script #12519: BrothersReunion
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if object.zone_id == 125 and object.local_id == 2 then
    _return_value = false
    if actor:get_quest_stage("krisenna_quest") == 4 then
        self:destroy_item("warhammer")
        wait(1)
        self:emote("weeps as he realizes that his brother is dead.")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'Thank you for finding him.  I will take word to my")
        self.room:send("</>family.'")
        wait(1)
        self:say("Please, take this for your efforts.")
        wait(1)
        self:say("It was our great grandfather's.")
        self.room:spawn_object(125, 50)
        self:command("give monocle " .. tostring(actor.name))
        wait(2)
        self:say("And take these as well.")
        local gem = 0
        while gem < 3 do
            self.room:spawn_object(557, 3 + random(1, 11))
            gem = gem + 1
        end
        self:command("give all.gem " .. tostring(actor.name))
        actor:complete_quest("krisenna_quest")
        --
        -- Set X to the level of the award - code does not run without it
        --
        local expcap
        if actor.level < 40 then
            expcap = actor.level
        else
            expcap = 40
        end
        local expmod = 0
        if expcap < 9 then
            expmod = (((expcap * expcap) + expcap) / 2) * 55
        elseif expcap < 17 then
            expmod = 440 + ((expcap - 8) * 125)
        elseif expcap < 25 then
            expmod = 1440 + ((expcap - 16) * 175)
        elseif expcap < 34 then
            expmod = 2840 + ((expcap - 24) * 225)
        elseif expcap < 49 then
            expmod = 4640 + ((expcap - 32) * 250)
        elseif expcap < 90 then
            expmod = 8640 + ((expcap - 48) * 300)
        else
            expmod = 20940 + ((expcap - 89) * 600)
        end
        --
        -- Adjust exp award by class so all classes receive the same proprotionate amount
        --
        -- switch on actor.class
        if actor.class == "warrior" or actor.class == "berserker" then
            --
            -- 110% of standard
            --
            expmod = (expmod + (expmod / 10))
        elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
            --
            -- 115% of standard
            --
            expmod = (expmod + ((expmod * 2) / 15))
        elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
            --
            -- 120% of standard
            --
            expmod = (expmod + (expmod / 5))
        elseif actor.class == "necromancer" or actor.class == "monk" then
            --
            -- 130% of standard
            --
            expmod = (expmod + (expmod * 2) / 5)
        end
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 10 do
            -- 
            -- Xexp must be replaced by mexp, oexp, or wexp for this code to work
            -- Pick depending on what is running the trigger
            -- 
            actor:award_exp(setexp)
            loop = loop + 1
        end
        wait(2)
        self.room:send(tostring(self.name) .. " becomes very silent.")
    else
        wait(2)
        self:say("Why yes, this -was- mine, thanks!")
        self:destroy_item("warhammer")
    end
else
    _return_value = true
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    wait(8)
    self:say("I don't want this.")
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
end
return _return_value$trig$, '5c87cd405c18911be602663083c46d00'),
  -- data/triggers/169/169_00_necromancer_guild.lua
  (169, 0, $trig$-- Converted from DG Script #16900: necromancer_guild
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
-- for 16950
if actor.class == "necromancer" then
    wait(1)
    get_room(169, 50):exit("up"):set_state({hidden = false})
    self.room:send("The ceiling slides open silently.")
    wait(30)
    get_room(169, 50):exit("up"):set_state({hidden = true})
    self.room:send("The ceiling slides closed with a click.")
end$trig$, '27eca167bcd8efad07949a7ab2e676df'),
  -- data/triggers/188/188_70_smart_combat.lua
  (188, 70, $trig$local now = timestamp()
local level = self.level
local class = self.class
local flags = self.flags
local is_sor = class == "sorcerer"
local is_cry = class == "cryomancer"
local is_pyr = class == "pyromancer"
local is_nec = class == "necromancer"
local is_arc = is_sor  or  is_cry  or  is_pyr  or  is_nec
local is_war = class == "warrior"
local is_ran = class == "ranger"
local is_pal = class == "paladin"
local is_ant = class ~= nil and string.find(tostring(class), "Anti") ~= nil
local is_mon = class == "monk"
local is_com = is_ran  or  is_pal  or  is_ant
local is_fig = is_war  or  is_mon  or  is_com
local is_rog = class == "rogue"
local is_thi = class == "thief"
local is_ass = class == "assassin"
local is_mer = class == "mercenary"
local is_bac = is_rog  or  is_thi  or  is_ass  or  is_mer
local is_cle = class == "cleric"
local is_pri = class == "priest"
local is_dia = class == "diabolist"
local is_dru = class == "druid"
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
            local victim = self.room.actors[random(1, #self.room.actors)]
            if victim and (victim.is_npc) and (victim.class ~= "warrior") and (victim.class ~= "ranger") and (not (string.find(victim.class, "Anti"))) and (victim.class ~= "paladin") and (victim.class ~= "monk") then
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
globals.action = now$trig$, '21ffaa08d9b585f3284749375cfa3ec9'),
  -- data/triggers/188/188_91_summon_dragon.lua
  (188, 91, $trig$-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: summon
if not (cmd == "summon") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
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
    if actor.class == "paladin" then
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
return _return_value$trig$, '9b8e31bd9a4b40642356e665de8d7281'),
  -- data/triggers/188/188_93_dragonegg_hatch.lua
  (188, 93, $trig$-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: hatch
if not (cmd == "hatch") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
if cmd == "h" or cmd == "ha" then
    _return_value = true
    return _return_value
end
local color, obj_id
if actor.class == "paladin" then
    color = "golden"
    obj_id = 90
elseif string.find(actor.class, "Anti") then
    color = "black"
    obj_id = 91
else
    actor:send("You get the feeling that this egg is not meant for you.")
end
if color then
    actor:send("As you rub the egg, a crack begins to form...")
    self.room:send_except(actor, "As " .. tostring(actor.name) .. " rubs " .. tostring(self.shortdesc) .. ", a crack begins to form...")
    wait(3)
    self.room:send("The crack continues to grow, branching into hundreds of smaller cracks!")
    wait(6)
    self.room:send("A talon suddenly breaks through the egg shell!")
    wait(3)
    self.room:send("Slowly, the head of a " .. tostring(color) .. " dragon pushes through the shell.")
    wait(2)
    self.room:send("The dragon egg continues to split into pieces.")
    wait(2)
    self.room:send("A small, " .. tostring(color) .. " dragon emerges from the broken egg shell.")
    self.room:spawn_mobile(188, obj_id)
    actor:send("The " .. tostring(color) .. " dragon looks at you.")
    self.room:send_except(actor, "The " .. tostring(color) .. " dragon looks at " .. tostring(actor.name) .. ".")
    wait(3)
    local dragon_name = color .. "-dragon"
    local dragon = self.room:find_actor(dragon_name)
    if dragon then
        dragon:command("bow")
        if actor.gender == "Female" then
            dragon:say("Mistress, thank you for protecting me.")
        else
            dragon:say("Master, thank you for protecting me.")
        end
        dragon:say("Henceforth shall I be at your command.  Merely call and I shall answer!")
    end
    wait(5)
    if dragon then dragon:emote("looks around itself.") end
    self.room:send("In a rush of wind, the dragon beats its wings, launching itself into the air.")
    if dragon then world.destroy(dragon) end
    wait(2)
    actor:send("A strange-looking helmet falls from behind the dragon, landing near you.")
    self.room:send_except(actor, "A strange-looking helmet falls from behind the dragon, landing near " .. tostring(actor.name) .. ".")
    self.room:spawn_object(188, obj_id)
    if actor:get_quest_stage("quest_items") == 0 then
        actor:start_quest("quest_items")
    end
    actor:set_quest_var("quest_items", tostring(obj_id), 1)
    actor:command("get dragonhelm")
    world.destroy(self)
end
return _return_value$trig$, '8f526ff762027ad4882acd2a23defda1'),
  -- data/triggers/237/237_28_serin-receive.lua
  (237, 28, $trig$-- Converted from DG Script #23728: serin-receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- Responding to trigger 23723 after they actually have the items.
-- Tracks each treasure individually via quest vars; on the third real piece,
-- advances and completes the quest with an XP/badge reward.

-- Helper: identify which elven treasure (zone 520) was offered.
-- Returns one of: "boots", "cloak", "ring", "cursed_boots", "cursed_cloak",
-- "cursed_ring", or nil for anything else.
local function identify_treasure(obj)
    if obj.zone_id ~= 520 then
        return nil
    end
    local id = obj.local_id
    if id == 8 then return "boots"
    elseif id == 24 then return "cursed_boots"
    elseif id == 9 then return "cloak"
    elseif id == 26 then return "cursed_cloak"
    elseif id == 1 then return "ring"
    elseif id == 18 then return "cursed_ring"
    end
    return nil
end

if actor.is_npc then
    return true
end
if actor.level > 99 then
    wait(1)
    self:command("eyebrow")
    return true
end

local boots = actor:get_quest_var("sunfire_rescue:boots") or 0
local cloak = actor:get_quest_var("sunfire_rescue:cloak") or 0
local ring = actor:get_quest_var("sunfire_rescue:ring") or 0

if actor:get_has_completed("sunfire_rescue") then
    self:say("You have already helped me.  I am grateful to you.")
    return true
end

if actor:get_quest_stage("sunfire_rescue") ~= 1 then
    self:say("What are you doing?")
    return true
end

local kind = identify_treasure(object)

-- Reject cursed items outright.
if kind == "cursed_boots" then
    self:emote("looks at the boots carefully.")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self.room:send(tostring(self.name) .. " says, 'These are the cursed boots.  If you have the real ones,")
    self.room:send("</>please...  These cannot help me at all.  Do you have the real ones?  I need")
    self.room:send("</>them.'")
    return true
elseif kind == "cursed_cloak" then
    self:emote("runs his hands over the cloak quickly.")
    self:say("This is the cursed cloak!")
    self:emote("looks angry.")
    actor:send("shoves " .. tostring(object.shortdesc) .. " back in your face.")
    self.room:send_except(actor, "shoves " .. tostring(object.shortdesc) .. " back in " .. tostring(actor.name) .. "'s face.")
    wait(1)
    self:say("Well?  Do you have the real cloak to give to me?")
    self:emote("taps his foot impatiently.")
    return true
elseif kind == "cursed_ring" then
    self:command("frown " .. tostring(actor.name))
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:say("What kind of cruel trick is this?")
    wait(1)
    self:say("Well, do you have the real one to give to me?")
    return true
end

-- Real treasures: accept each at most once.
if kind == "boots" then
    if boots == 1 then
        self:say("You have already given me these.")
        return true
    end
    actor:set_quest_var("sunfire_rescue", "boots", 1)
    boots = 1
    wait(2)
    world.destroy(object)
    self:command("smile " .. tostring(actor.name))
    self:say("Thank you.")
    wait(1)
elseif kind == "cloak" then
    if cloak == 1 then
        self:say("You have already given me the cloak.")
        return true
    end
    actor:set_quest_var("sunfire_rescue", "cloak", 1)
    cloak = 1
    wait(2)
    world.destroy(object)
    self:emote("carefully looks at the cloak.")
    self:say("This is it!  Thank you!")
    wait(1)
    self:say("Then I can finally escape....")
elseif kind == "ring" then
    if ring == 1 then
        self:say("You have already given me this ring.")
        return true
    end
    actor:set_quest_var("sunfire_rescue", "ring", 1)
    ring = 1
    wait(2)
    self.room:send("Looking at the ring, the prisoner looks overwhelmed with emotion.")
    self:say("Escape is so close I can feel it!")
    world.destroy(object)
else
    self:say("This isnt going to help me!")
    self:command("roll")
    return true
end

-- Has the player now turned in all three treasures?
local total = boots + cloak + ring
if total < 3 then
    wait(1)
    self:say("Do you have the other treasures of my people?")
    return true
end

-- All three -- complete the quest.
wait(2)
self:emote("slips his feet out of the shackles and wears the boots.")
wait(2)
self:emote("unshackles his arms and wears the cloak on his shoulders.")
wait(2)
self.room:send("Looking hesitant, the prisoner slowly slides the ring onto his finger.")
actor:advance_quest("sunfire_rescue")
self.room:spawn_object(237, 16)
self:destroy_item("all.elven")
wait(3)
self:emote("vanishes from sight.")

-- The badge reward is level 50, but the players have to be 70 or so
-- to handle the boots, cloak etc anyway.
local expcap
if actor.level < 85 then
    expcap = actor.level
else
    expcap = 85
end

local expmod
if expcap < 9 then
    expmod = (((expcap * expcap) + expcap) / 2) * 55
elseif expcap < 17 then
    expmod = 440 + ((expcap - 8) * 125)
elseif expcap < 25 then
    expmod = 1440 + ((expcap - 16) * 175)
elseif expcap < 34 then
    expmod = 2840 + ((expcap - 24) * 225)
elseif expcap < 49 then
    expmod = 4640 + ((expcap - 32) * 250)
elseif expcap < 90 then
    expmod = 8640 + ((expcap - 48) * 300)
else
    expmod = 20940 + ((expcap - 89) * 600)
end

-- Adjust exp award by class so all classes receive the same proportionate amount.
if actor.class == "warrior" or actor.class == "berserker" then
    -- 110% of standard
    expmod = expmod + (expmod / 10)
elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
    -- 115% of standard
    expmod = expmod + ((expmod * 2) / 15)
elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
    -- 120% of standard
    expmod = expmod + (expmod / 5)
elseif actor.class == "necromancer" or actor.class == "monk" then
    -- 130% of standard
    expmod = expmod + ((expmod * 2) / 5)
end

actor:send("<b:yellow>You gain experience!</>")
local setexp = expmod * 10
for _ = 1, 10 do
    actor:award_exp(setexp)
end
actor:complete_quest("sunfire_rescue")
wait(2)
actor:send(tostring(self.name) .. " whispers to you, 'Thank you for your help!  Please wear this badge as a token of my respect.'")
self:command("give badge " .. tostring(actor.name))
wait(2)
self.room:send("A voice softly echos, 'Good-bye...'")
world.destroy(self.room:find_actor("serin"))
return true$trig$, 'd83480956c934b489dccd722e751320b'),
  -- data/triggers/237/237_52_receive-rewards.lua
  (237, 52, $trig$-- Converted from DG Script #23752: receive-rewards
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- Vilekka receives the heart (stage 1 -> 2), the drider king's head
-- (stage 3 -> 4), or the ten herbs/spices (stage 5 completion).

-- Helper: is this object one of the accepted spices for stage 5?
-- Returns the canonical spice key (string) or nil.
local function spice_key(obj)
    local z, id = obj.zone_id, obj.local_id
    if z == 125 and id == 52 then return "12552" end
    if z == 490 and id == 22 then return "49022" end
    if z == 237 and id >= 50 and id <= 60 then
        return tostring(23700 + id)
    end
    return nil
end

local accepted = false

-- Stage 1 -> 2: drow master's heart (object 237/21).
if object.zone_id == 237 and object.local_id == 21 then
    for _, person in ipairs(actor.group) do
        if person.room == self.room and person:get_quest_stage("vilekka_stew") == 1 then
            person:advance_quest("vilekka_stew")
            person:send("<b:white>You have advanced the quest!</>")
            accepted = true
        end
    end
    if accepted then
        wait(1)
        self:destroy_item("all.heart")
        self:say("Excellent!")
        wait(1)
        self.room:send("The High Priestess takes the heart and places it gently on the altar.")
        self:command("smirk")
        wait(1)
        self:say("You have done me and my city a great service!  Do you wish to continue or stop now?")
        self:command("tap")
        self.room:send("<b:white>All characters must choose individually.</>")
        return true
    end
end

-- Stage 3 -> 4: drider king's head (object 237/20).
if object.zone_id == 237 and object.local_id == 20 then
    for _, person in ipairs(actor.group) do
        if person.room == self.room and person:get_quest_stage("vilekka_stew") == 3 then
            person:advance_quest("vilekka_stew")
            person:send("<b:white>You have advanced the quest!</>")
            accepted = true
            -- Cross-quest credit for hell_trident.
            if not person:get_quest_var("hell_trident:helltask6")
                and person:get_quest_stage("hell_trident") == 1 then
                person:set_quest_var("hell_trident", "helltask6", 1)
                person:send("<magenta>You have successfully assisted " .. tostring(self.name) .. " in service of Lolth!</>")
            end
        end
    end
    if accepted then
        wait(1)
        self:destroy_item("all.head")
        actor:send(tostring(self.name) .. " says, 'You are quite resourceful!  This is a great benefit to the entire city.'")
        self:emote("places the severed head on the altar, where it lolls around.")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'But your work may not yet be finished...  Do you wish to continue, or stop here?'")
        self.room:send("<b:white>All characters must choose individually.</>")
        return true
    end
end

-- Stage 5: spices and herbs.
if actor:get_quest_stage("vilekka_stew") == 5 then
    local key = spice_key(object)
    local is_spice = key ~= nil
    -- Reject duplicates.
    local already_given = key
        and actor:get_quest_var("vilekka_stew:got_spice:" .. key) == 1
    if (not is_spice) or already_given then
        self:emote("refuses to accept " .. tostring(object.shortdesc) .. ".")
        wait(1)
        if is_spice then
            actor:send(tostring(self.name) .. " says, 'You have already given me " .. tostring(object.shortdesc) .. ".'")
        else
            actor:send(tostring(self.name) .. " says, 'What is this?  I need the spices!'")
        end
        return true
    end
    wait(1)
    local num_spices = 1 + (actor:get_quest_var("vilekka_stew:num_spices") or 0)
    actor:set_quest_var("vilekka_stew", "num_spices", num_spices)
    actor:set_quest_var("vilekka_stew", "got_spice:" .. key, 1)
    accepted = true
    if num_spices < 10 then
        self:destroy_item("herb")
        -- Per-spice progress acknowledgement.
        if num_spices == 1 then
            actor:send(tostring(self.name) .. " says, 'Very good!  But I still need nine more.'")
        elseif num_spices == 2 then
            self:command("lick")
            actor:send(tostring(self.name) .. " says, 'Eight more....'")
        elseif num_spices == 3 then
            actor:send(tostring(self.name) .. " says, 'Seven more spices, and my stew will be perfect!'")
        elseif num_spices == 4 then
            self:emote("is starting to look excited.")
            actor:send(tostring(self.name) .. " says, 'Six more!'")
        elseif num_spices == 5 then
            self:command("grin")
            actor:send(tostring(self.name) .. " says, 'You're halfway there!  Five more!'")
        elseif num_spices == 6 then
            self:emote("sniffs the spices carefully.")
            actor:send(tostring(self.name) .. " says, 'Yes!  Only four more!'")
        elseif num_spices == 7 then
            actor:send(tostring(self.name) .. " says, 'Three more!  Give them to me!'")
        elseif num_spices == 8 then
            self:emote("looks very excited now.")
            actor:send(tostring(self.name) .. " says, 'Two more spices!'")
        elseif num_spices == 9 then
            actor:send(tostring(self.name) .. " says, 'One more!  Give it to me!'")
        end
        return true
    end

    -- num_spices >= 10: complete the quest.
    self:command("cackle")
    actor:send(tostring(self.name) .. " says, 'Most excellent!  Now I may complete the will of my Queen!'")
    wait(1)
    self:emote("puts all the ingredients for the nasty stew into a small bag.")
    self.room:send("A servant silently enters and bows.")
    self:emote("gives a small bag to the servant.")
    self.room:send("The servant leaves.")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Oh yes, your reward....'")
    -- Reward boots depend on whether saffron (23760) and salt (23756) were
    -- among the ten spices delivered.
    local has_saffron = actor:get_quest_var("vilekka_stew:got_spice:23760") == 1
    local has_salt = actor:get_quest_var("vilekka_stew:got_spice:23756") == 1
    local expcap
    if has_saffron and has_salt then
        self.room:spawn_object(237, 98)
        expcap = math.min(actor.level, 60)
    elseif has_saffron then
        self.room:spawn_object(237, 99)
        expcap = math.min(actor.level, 85)
    elseif has_salt then
        self.room:spawn_object(237, 96)
        expcap = math.min(actor.level, 50)
    else
        self.room:spawn_object(237, 97)
        expcap = math.min(actor.level, 55)
    end

    local expmod
    if expcap < 9 then
        expmod = (((expcap * expcap) + expcap) / 2) * 55
    elseif expcap < 17 then
        expmod = 440 + ((expcap - 8) * 125)
    elseif expcap < 25 then
        expmod = 1440 + ((expcap - 16) * 175)
    elseif expcap < 34 then
        expmod = 2840 + ((expcap - 24) * 225)
    elseif expcap < 49 then
        expmod = 4640 + ((expcap - 32) * 250)
    elseif expcap < 90 then
        expmod = 8640 + ((expcap - 48) * 300)
    else
        expmod = 20940 + ((expcap - 89) * 600)
    end

    -- Class proportional adjustment.
    if actor.class == "warrior" or actor.class == "berserker" then
        -- 110% of standard
        expmod = expmod + (expmod / 10)
    elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
        -- 115% of standard
        expmod = expmod + ((expmod * 2) / 15)
    elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
        -- 120% of standard
        expmod = expmod + (expmod / 5)
    elseif actor.class == "necromancer" or actor.class == "monk" then
        -- 130% of standard
        expmod = expmod + ((expmod * 2) / 5)
    end

    actor:send("<b:yellow>You gain experience!</>")
    local setexp = expmod * 10
    for _ = 1, 10 do
        actor:award_exp(setexp)
    end
    self:command("give boots " .. tostring(actor.name))
    wait(1)
    self:command("smile")
    actor:send(tostring(self.name) .. " says, 'Wear them proudly!'")
    actor:complete_quest("vilekka_stew")
    return true
end

if not accepted then
    actor:send(tostring(self.name) .. " haughtily refuses your gift.")
    self.room:send_except(actor, tostring(self.name) .. " refuses to accept " .. tostring(object.shortdesc) .. " from " .. tostring(actor.name) .. ".")
    wait(1)
    self:say("No thank you.")
end
return true$trig$, '603764a5c976c6f54520ae50b05f9148'),
  -- data/triggers/302/302_02_sliding_into_the_abyss.lua
  (302, 2, $trig$-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
if #self.room.actors == 0 then
    return true
end
local victim = self.room.actors[random(1, #self.room.actors)]
if not victim or victim.is_npc then
    return true
end
local startroom = victim.room
-- Don't bother flying or levitating people.
if victim:has_effect(Effect.Flying) or victim:has_effect(Effect.Feather_Fall) then
    return true
end
-- Consider rangers and druids as too sure-footed to lose their footing.
if victim.class == "ranger" or victim.class == "druid" then
    self.room:send_except(victim, tostring(victim.name) .. "'s foot slips on a rock, but " .. tostring(victim.name) .. " quickly steps to one side.")
    victim:send("A rock shifts under your foot, and you step to steadier ground.")
    return true
end
wait(4)
if victim.room ~= startroom then
    return true
end
self.room:send_except(victim, tostring(victim.name) .. " slips on a loose rock, and begins to slide downward!")
victim:send("Your foot slips on a loose rock.  You are sliding downward!")
wait(3)
if victim.room ~= startroom then
    return true
end
self.room:send_except(victim, tostring(victim.name) .. " is sliding straight toward a sheer dropoff!")
victim:send("You are sliding right toward a deep ravine!")
wait(2)
if victim.room ~= startroom then
    return true
end
self.room:send_except(victim, tostring(victim.name) .. " disappears off the edge with a yelp!")
victim:send("You slide off the edge into thin air!")
victim:teleport(get_room(302, 55))$trig$, '421cd670b24f46a6bc68696bd8cbd1fc'),
  -- data/triggers/302/302_03_sliding_into_the_abyss_ii.lua
  (302, 3, $trig$-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
if #self.room.actors == 0 then
    return true
end
local victim = self.room.actors[random(1, #self.room.actors)]
if not victim or victim.is_npc then
    return true
end
local startroom = victim.room
-- Don't bother flying or levitating people.
if victim:has_effect(Effect.Flying) or victim:has_effect(Effect.Feather_Fall) then
    return true
end
-- Consider rangers and druids as too sure-footed to lose their footing.
if victim.class == "ranger" or victim.class == "druid" then
    self.room:send_except(victim, "A rock shifts under " .. tostring(victim.name) .. "'s foot, but " .. tostring(victim.name) .. " quickly steps to one side.")
    victim:send("A rock shifts under your foot, and you step to steadier ground.")
    return true
end
wait(4)
if victim.room ~= startroom then
    return true
end
self.room:send_except(victim, tostring(victim.name) .. " slips on a loose rock, and begins to slide downward!")
victim:send("Your foot slips on a loose rock.  You are sliding downward!")
wait(3)
if victim.room ~= startroom then
    return true
end
self.room:send_except(victim, tostring(victim.name) .. " is sliding straight toward a sheer dropoff!")
victim:send("You are sliding right toward a deep ravine!")
wait(2)
if victim.room ~= startroom then
    return true
end
self.room:send_except(victim, tostring(victim.name) .. " disappears off the edge with a yelp!")
victim:send("You slide off the edge into thin air!")
victim:teleport(get_room(302, 51))$trig$, '87d6dd277c9d3c9cea3e73ee72b9757b'),
  -- data/triggers/302/302_04_a_mild_avalanche.lua
  (302, 4, $trig$-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
if #self.room.actors == 0 then
    return true
end
local victim = self.room.actors[random(1, #self.room.actors)]
if not victim or victim.is_npc then
    return true
end
local startroom = victim.room
self.room:send("A quiet noise from above attracts your attention.")
wait(2)
self.room:send("A few small pebbles and stones are falling down the hillside.")
self.room:send("They clatter as they tumble.")
wait(2)
self.room:send("Large rocks are tumbling past you!  They look heavy!")
wait(1)
local dest_local
if self.id == 34 then
    dest_local = self.id + 1
else
    dest_local = self.id - 1
end
local damage
if victim.level < 10 then
    damage = 3 + random(1, 5)
elseif victim.level < 20 then
    damage = 10 + random(1, 8)
elseif victim.level < 40 then
    damage = 30 + random(1, 30)
else
    damage = 80 + random(1, 50)
end
if victim.room == startroom then
    if victim.class == "ranger" then
        self.room:send_except(victim, tostring(victim.name) .. " is nearly smacked by a large rock, but " .. tostring(victim.name) .. " steps aside at the last moment.")
        victim:send("A big rock comes hurtling toward you, but you step smoothly aside.")
    else
        local damage_dealt = victim:damage(damage)  -- type: crush
        if damage_dealt == 0 then
            self.room:send_except(victim, "The rocks seem to pass right through " .. tostring(victim.name) .. ".")
            victim:send("The rocks seem to pass right through you.")
        else
            self.room:send_except(victim, "A big rock hits " .. tostring(victim.name) .. " right in the chest, and " .. tostring(victim.name) .. " is knocked over! (<blue>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(victim, tostring(victim.name) .. " tumbles downhill!")
            victim:send("You try to dodge the boulders, but a large stone whacks you in the chest! (<red>" .. tostring(damage_dealt) .. "</>)")
            victim:send("You are knocked down!")
            victim:teleport(get_room(302, dest_local))
            self.room:send_except(victim, tostring(victim.name) .. " tumbles down the trail from above, and comes to a rest.")
            wait(1)
        end
    end
end
self.room:send("The remnants of the avalanche tumble past, then silence returns to the mountains.")$trig$, '60d4c92b6b6a97b6011d357a1eb340ca'),
  -- data/triggers/481/481_45_fiery_island_quest_grant_rewards.lua
  (481, 45, $trig$-- Converted from DG Script #48145: Fiery_Island_Quest_Grant_rewards
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(1)
for _, person in ipairs(self:get_people()) do
    if person:get_quest_var("fieryisle_quest:reward") == "yes" and not person:get_has_completed("fieryisle_quest") then
        person:send("You notice special glittering gems amongst the chamber's crystals!")
        -- 
        -- Set X to the level of the award - code does not run without it
        -- Fiery Island, X = 55
        local expcap
        if person.level < 55 then
            expcap = person.level
        else
            expcap = 55
        end
        local expmod = 0
        if expcap < 9 then
            expmod = (((expcap * expcap) + expcap) / 2) * 55
        elseif expcap < 17 then
            expmod = 440 + ((expcap - 8) * 125)
        elseif expcap < 25 then
            expmod = 1440 + ((expcap - 16) * 175)
        elseif expcap < 34 then
            expmod = 2840 + ((expcap - 24) * 225)
        elseif expcap < 49 then
            expmod = 4640 + ((expcap - 32) * 250)
        elseif expcap < 90 then
            expmod = 8640 + ((expcap - 48) * 300)
        else
            expmod = 20940 + ((expcap - 89) * 600)
        end
        --
        -- Adjust exp award by class so all classes receive the same proportionate amount
        --
        if person.class == "warrior" or person.class == "berserker" then
            -- 110% of standard
            expmod = (expmod + (expmod / 10))
        elseif person.class == "paladin" or person.class == "anti-paladin" or person.class == "ranger" then
            -- 115% of standard
            expmod = (expmod + ((expmod * 2) / 15))
        elseif person.class == "sorcerer" or person.class == "pyromancer" or person.class == "cryomancer" or person.class == "illusionist" or person.class == "bard" then
            -- 120% of standard
            expmod = (expmod + (expmod / 5))
        elseif person.class == "necromancer" or person.class == "monk" then
            -- 130% of standard
            expmod = (expmod + (expmod * 2) / 5)
        end
        person:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 10 do
            -- 
            -- Xexp must be replaced by mexp, oexp, or wexp for this code to work
            -- Pick depending on what is running the trigger
            -- Fiery Island, xexp = wexp
            person:award_exp(setexp)
            loop = loop + 1
        end
        local gem = 0
        while gem < 3 do
            self.room:spawn_object(557, 36 + random(1, 11))
            gem = gem + 1
        end
        person:command("get all.gem")
        person:complete_quest("fieryisle_quest")
    end
end$trig$, 'ee641b8db0fd610e462f7b6a2be1237f'),
  -- data/triggers/484/484_105_mighty_druid_entanglement.lua
  (484, 105, $trig$-- Converted from DG Script #48505: mighty_druid entanglement
-- Original: MOB trigger, flags: FIGHT, probability: 100%
-- TODO(parity): the converter emitted branch-scoped `local chance`,
--   `local victim`, `local secondary_victim`, `local paralysis_victim_N`,
--   and `local paralysis_expire_N` declarations inside if/elseif blocks,
--   so the outer `if chance > 3 then` and `if victim.is_player then`
--   tests reference undefined names and the per-victim slot bookkeeping
--   never escapes its branch. The body also still contains a
--   `bash %victim.name%` DG token. The whole entanglement state machine
--   needs a rewrite once we have a stable globals API for per-mob
--   paralysis tracking.
local now = time.stamp
if paralysis_victim_1 and ((paralysis_victim_1.room ~= self.room) or (paralysis_expire_1 <= now)) then
    -- Clear paralysis on expired victim
    if paralysis_victim_1.room == self.room then
        self.room:send_except(paralysis_victim_1, "<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_1.name) .. " from its grasp.</>")
        paralysis_victim_1:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
    else
        self.room:send("<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_1.name) .. " from its grasp.</>")
    end
    paralysis_victim_1 = nil
end
if paralysis_victim_2 and ((paralysis_victim_2.room ~= self.room) or (paralysis_expire_2 <= now)) then
    -- Clear paralysis on expired victim
    if paralysis_victim_2.room == self.room then
        self.room:send_except(paralysis_victim_2, "<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_2.name) .. " from its grasp.</>")
        paralysis_victim_2:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
    else
        self.room:send("<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_2.name) .. " from its grasp.</>")
    end
    paralysis_victim_2 = nil
end
if paralysis_victim_3 and ((paralysis_victim_3.room ~= self.room) or (paralysis_expire_3 <= now)) then
    -- Clear paralysis on expired victim
    if paralysis_victim_3.room == self.room then
        self.room:send_except(paralysis_victim_3, "<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_3.name) .. " from its grasp.</>")
        paralysis_victim_3:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
    else
        self.room:send("<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_3.name) .. " from its grasp.</>")
    end
    paralysis_victim_3 = nil
end
if paralysis_victim_4 and ((paralysis_victim_4.room ~= self.room) or (paralysis_expire_4 <= now)) then
    -- Clear paralysis on expired victim
    if paralysis_victim_4.room == self.room then
        self.room:send_except(paralysis_victim_4, "<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_4.name) .. " from its grasp.</>")
        paralysis_victim_4:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
    else
        self.room:send("<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_4.name) .. " from its grasp.</>")
    end
    paralysis_victim_4 = nil
end
-- 25% chance to do creeping doom proc
local mode = random(1, 4)
if mode == 1 then
    wait(2)
    run_room_trigger(484, 103)
    return _return_value
end
-- 75% chance to attempt to entangle
if (not paralysis_victim_1) or (not paralysis_victim_2) or (not paralysis_victim_3) or (not paralysis_victim_4) then
    local chance
    if paralysis_victim_1 then
        if paralysis_victim_2 then
            if paralysis_victim_3 then
                if paralysis_victim_4 then
                    -- quit if four people already entangled
                    return _return_value
                else
                    -- 20% chance if three people are entangled
                    chance = random(1, 10)
                end
            else
                -- 25% chance if two people are entangled
                chance = random(1, 8)
            end
        else
            -- 33% chance if one person is already entangled
            chance = random(1, 6)
        end
    else
        -- 50% chance if no one is already entangled
        chance = random(1, 4)
    end
    if chance > 3 then
        return _return_value
    end
    local max_tries = 10
    while max_tries >= 0 do
        -- find a victim, preferably an assassin
        -- but will settle for any player if no assassin found
        local victim = self.room.actors[random(1, #self.room.actors)]
        if victim.is_player then
            if (paralysis_victim_1 and (paralysis_victim_1.name == victim.name)) or (paralysis_victim_2 and (paralysis_victim_2.name == victim.name)) or (paralysis_victim_3 and (paralysis_victim_3.name == victim.name)) then
                local victim = self
            elseif victim.class == "assassin" then
                max_tries = 0
            else
                local secondary_victim = victim
            end
        end
        max_tries = max_tries - 1
    end
    -- quit if no players
    local victim
    if victim.is_player then
    elseif secondary_victim then
        victim = secondary_victim
    else
        return _return_value
    end
    wait(2)
    self.room:send_except(victim, tostring(self.name) .. " snarls and waves a hand at the ground at " .. tostring(victim.name) .. "'s feet.")
    victim:send(tostring(self.name) .. " snarls at you and waves a hand at the ground around your feet!")
    self.room:send_except(victim, "<green>A crop of wriggling roots bursts from the ground, entangling " .. tostring(victim.name) .. "!</>")
    victim:send("<green>A crop of wriggling roots bursts from the ground, entangling you!</>")
    -- declare paralysis message
    local message = "&2The roots lock you in place, preventing movement!&0"
    globals.message = globals.message or true
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
    self.room:find_actor("bashing-roots"):command("bash %victim.name%")
    self.room:find_actor("bashing-roots"):destroy_item("shield")
    world.destroy(self.room:find_actor("bashing-roots"))
    -- reinitiate combat if victim was tanking
    if actor.name == victim.name then
        wait(2)
        combat.engage(self, victim.name)
    end
    -- save victim variable
    if paralysis_victim_1 then
        if paralysis_victim_2 then
            if paralysis_victim_3 then
                local paralysis_victim_4 = victim
                globals.paralysis_victim_4 = globals.paralysis_victim_4 or true
                local paralysis_expire_4 = now + 1
                globals.paralysis_expire_4 = globals.paralysis_expire_4 or true
            else
                local paralysis_victim_3 = victim
                globals.paralysis_victim_3 = globals.paralysis_victim_3 or true
                local paralysis_expire_3 = now + 1
                globals.paralysis_expire_3 = globals.paralysis_expire_3 or true
            end
        else
            local paralysis_victim_2 = victim
            globals.paralysis_victim_2 = globals.paralysis_victim_2 or true
            local paralysis_expire_2 = now + 1
            globals.paralysis_expire_2 = globals.paralysis_expire_2 or true
        end
    else
        local paralysis_victim_1 = victim
        globals.paralysis_victim_1 = globals.paralysis_victim_1 or true
        local paralysis_expire_1 = now + 1
        globals.paralysis_expire_1 = globals.paralysis_expire_1 or true
    end
end$trig$, '77ab80e1edd0ed7163ba637e716ccae3'),
  -- data/triggers/484/484_235_leviathan_fight.lua
  (484, 235, $trig$-- Converted from DG Script #48635: leviathan fight
-- Original: MOB trigger, flags: FIGHT, probability: 50%

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
wait(2)
local mode = random(1, 10)
if mode < 6 then
    self:command("sweep")
else
    local victim = self.room.actors[random(1, #self.room.actors)]
    if (victim.name ~= actor.name) and ((victim.class == "warrior") or (string.find(victim.class, "Anti")) or (victim.class == "ranger") or (victim.class == "paladin") or (victim.class == "monk") or (victim.class == "mercenary") or (victim.class == "berserker")) then
        if victim.room == self.room then
            self:teleport(get_room(11, 0))
            self:teleport(actor.room)
            self.room:send("<b:white>The Leviathan thrashes about madly, switching opponents!</>")
            combat.engage(self, victim.name)
        end
    end
end$trig$, 'e0cabb656d18040ab29a453cb0b10afd'),
  -- data/triggers/489/489_25_dark_servant_fight.lua
  (489, 25, $trig$-- Stop combat if our current target is another doom mobile (48900-48999)
-- and rest in a holding room while we recover.
if (actor.zone_id == 489) then
    wait(1)
    get_room(11, 0):at(function()
        self.room:find_actor("dark-servant"):heal(1000)
    end)
end
wait(2)
local chance = random(1, 10)
if chance > 3 then
    -- 70% chance to do nothing this round.
    return true
elseif chance == 1 then
    -- 10% chance to hitall
    self:attack_all()
    return true
elseif (chance == 2) and (self.zone_id == 489 and self.id == 9) then
    -- 10% chance for the warrior dark-servant to re-target onto an
    -- Assassin or Thief in the room.
    local victim
    for _ = 1, 9 do
        local candidate = self.room.actors[random(1, #self.room.actors)]
        if candidate and (candidate.class == "assassin" or candidate.class == "thief") then
            victim = candidate
            break
        end
    end
    if victim and victim.is_player then
        combat.engage(victim)
    end
    return true
else
    -- Warrior servant: 10% chill-drain. Non-warrior servants: 20% chill-drain.
    -- Pick a non-doom player; fall back to the current attacker if it's the
    -- dark-servant's current victim and is itself a doom mob (matches the
    -- DG fallback path).
    local victim
    for _ = 1, 5 do
        local candidate = self.room.actors[random(1, #self.room.actors)]
        if candidate and (candidate.zone_id ~= 489) then
            victim = candidate
            break
        end
    end
    if not victim then
        if actor and (actor.zone_id == 489 and actor.id >= 1 and actor.id <= 98) then
            victim = actor
        else
            return true
        end
    end
    local casters = "Sorcerer Cryomancer Pyromancer Necromancer Cleric Priest Diabolist Druid Conjurer Shaman"
    -- Be nice to casters
    local damage
    if string.find(casters, tostring(victim.class)) then
        damage = 200 + random(1, 30)
    else
        damage = 380 + random(1, 30)
    end
    local damage_dealt = victim:damage(damage)  -- type: heal
    if damage_dealt == 0 then
        self.room:send_except(victim, tostring(self.name) .. " reaches a <blue>&9shadowy</> limb towards " .. tostring(victim.name) .. ", but cannot draw out any life. (<blue>" .. tostring(damage_dealt) .. "</>)")
        victim:send(tostring(self.name) .. " reaches a <blue>&9shadowy</> limb towards you, but cannot draw out any life. (<b:red>" .. tostring(damage_dealt) .. "</>)")
    else
        self.room:send_except(victim, tostring(self.name) .. " reaches a <blue>&9shadowy</> limb towards " .. tostring(victim.name) .. ", <b:blue>chilling</> " .. tostring(victim.object) .. " to the <b:white>bone</>! (<blue>" .. tostring(damage_dealt) .. "</>)")
        victim:send(tostring(self.name) .. " reaches a <blue>&9shadowy</> limb towards you, <b:blue>chilling</> you to the <b:white>bone</>! (<b:red>" .. tostring(damage_dealt) .. "</>)")
    end
    local amount = damage_dealt * 2
    self.room:find_actor("dark-servant"):heal(amount)
end$trig$, '18742f95fdf321f8c7682c51c81cc6b0'),
  -- data/triggers/490/490_09_griffin_island_quest_exp_rewards.lua
  (490, 9, $trig$-- Converted from DG Script #49009: Griffin Island Quest exp rewards
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(1)
local stage = 9
for _, person in ipairs(self:get_people()) do
    if person:get_quest_stage("griffin_quest") == stage then
        --
        -- Set X to the level of the award - code does not run without it
        -- Griffin Isle, X = 60
        local expcap
        if person.level < 60 then
            expcap = person.level
        else
            expcap = 60
        end
        local expmod
        if expcap < 9 then
            expmod = (((expcap * expcap) + expcap) / 2) * 55
        elseif expcap < 17 then
            expmod = 440 + ((expcap - 8) * 125)
        elseif expcap < 25 then
            expmod = 1440 + ((expcap - 16) * 175)
        elseif expcap < 34 then
            expmod = 2840 + ((expcap - 24) * 225)
        elseif expcap < 49 then
            expmod = 4640 + ((expcap - 32) * 250)
        elseif expcap < 90 then
            expmod = 8640 + ((expcap - 48) * 300)
        else
            expmod = 20940 + ((expcap - 89) * 600)
        end
        --
        -- Adjust exp award by class so all classes receive the same proportionate amount
        --
        if person.class == "warrior" or person.class == "berserker" then
            -- 110% of standard
            expmod = (expmod + (expmod / 10))
        elseif person.class == "paladin" or person.class == "anti-paladin" or person.class == "ranger" then
            -- 115% of standard
            expmod = (expmod + ((expmod * 2) / 15))
        elseif person.class == "sorcerer" or person.class == "pyromancer" or person.class == "cryomancer" or person.class == "illusionist" or person.class == "bard" then
            -- 120% of standard
            expmod = (expmod + (expmod / 5))
        elseif person.class == "necromancer" or person.class == "monk" then
            -- 130% of standard
            expmod = (expmod + (expmod * 2) / 5)
        end
        person:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 10 do
            -- Griffin Isle, xexp = wexp
            person:award_exp(setexp)
            loop = loop + 1
        end
        local gem = 0
        while gem < 3 do
            self.room:spawn_object(557, 36 + random(1, 11))
            gem = gem + 1
            person:command("get gem")
        end
        person:complete_quest("griffin_quest")
    end
end$trig$, 'f1208868dbbbd869522e116b25260182'),
  -- data/triggers/554/554_33_phase_2_warrior_boots.lua
  (554, 33, $trig$-- Converted from DG Script #55433: phase_2_warrior_boots
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Boots ya ask?
-- 
-- This is for warriors only
if actor.class == "warrior" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Boots ya ask? Well now I can make a fine pair of boots for the\"")
    actor:send(tostring(self.name) .. " tells you, \"warrior types but I'll need 3 quantities of some opal dust, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Crushed Plate Boots. Return these things to me in any\"")
    actor:send(tostring(self.name) .. " tells you, \"order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for warriors only.")
end$trig$, '3c760061630a10480759d8d3a580fc22'),
  -- data/triggers/557/557_00_phase_armor_-_greet.lua
  (557, 0, $trig$-- Converted from DG Script #55700: Phase Armor - Greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
local _return_value = true  -- Default: allow action
wait(2)
local anti = "Anti-Paladin"
if not actor or not actor.can_be_seen then
    _return_value = true
else
    if actor.level <= (20 * (phase - 1)) then
        _return_value = true
    elseif not string.find(classes, actor.class) or (classes == anti and actor.class == "paladin") then
        _return_value = true
    elseif actor:get_quest_stage("phase_armor") == (phase - 1) then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Welcome, would you like to do some armor quests?  If so, just ask me about them.'")
    end
end
if string.find(self.class, "necromancer") then
    if actor:get_quest_stage("shift_corpse") then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'May Death guide your hunt for Lokari.'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'If you need a new crystal, msend " .. tostring(actor) .. " " .. tostring(self.name) .. " says, &9<blue>\"I need a new crystal\"</>.'")
    end
elseif string.find(self.class, "pyromancer") then
    if actor:get_quest_stage("supernova") == 2 and (actor:has_item(489, 17) or actor:has_equipped(489, 17)) then
        actor:advance_quest("supernova")
        local step3, step4, step5, step6
        local rnd1 = random(1, 3)
        if rnd1 == 1 then
            step3 = 4318
        elseif rnd1 == 2 then
            step3 = 10316
        elseif rnd1 == 3 then
            step3 = 58062
        end
        actor:set_quest_var("supernova", "step3", step3)
        local rnd2 = random(1, 3)
        if rnd2 == 1 then
            step4 = 18577
        elseif rnd2 == 2 then
            step4 = 17277
        elseif rnd2 == 3 then
            step4 = 8561
        end
        actor:set_quest_var("supernova", "step4", step4)
        local rnd3 = random(1, 3)
        if rnd3 == 1 then
            step5 = 53219
        elseif rnd3 == 2 then
            step5 = 47343
        elseif rnd3 == 3 then
            step5 = 16278
        end
        actor:set_quest_var("supernova", "step5", step5)
        local rnd4 = random(1, 3)
        if rnd4 == 1 then
            step6 = 58657
        elseif rnd4 == 2 then
            step6 = 35119
        elseif rnd4 == 3 then
            step6 = 55422
        end
        actor:set_quest_var("supernova", "step6", step6)
        local step7 = random(1, 3)
        actor:set_quest_var("supernova", "step7", step7)
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Ah I see you found one of Phayla's lamps!'")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Phayla likes to visit the material plane to engage in her favorite leisure activities.'")
        wait(2)
        local clue = actor:get_quest_var("supernova:step3")
        -- switch on clue
        if clue == 4318 then
            actor:send(tostring(self.name) .. " says, 'Recently, she was spotted in Anduin, taking in a show from the best seat in the house.'")
        elseif clue == 10316 then
            actor:send(tostring(self.name) .. " says, 'I understand she frequents the hottest spring at the popular resort up north.'")
        elseif clue == 58062 then
            actor:send(tostring(self.name) .. " says, 'She occasionally visits a small remote island theatre, where she enjoys meditating in their reflecting room.'")
        end
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You may be able to find a clue to her whereabouts there.'")
    end
elseif (self.class == "cleric" or self.class == "priest" or self.class == "diabolist") and macestep then
    if actor:get_quest_stage("phase_mace") == "macestep" then
        local minlevel = macestep * 10
        if actor.level >= minlevel then
            wait(2)
            if actor:get_quest_var("phase_mace:greet") == 0 then
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
        wait(2)
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
        if actor:get_quest_var("hell_trident:greet") == 0 then
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
return _return_value$trig$, '2841308b7b545f642a0009450ddc277e'),
  -- data/triggers/557/557_01_phase_armor_-_start.lua
  (557, 1, $trig$-- Converted from DG Script #55701: Phase Armor - Start
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
wait(2)
local anti = "Anti-Paladin"
if not actor or not actor.can_be_seen then
    self:command("peer")
    self:say("I can't help you if I can't see you.")
    return _return_value
elseif not string.find(classes, actor.class) or (classes == anti and actor.class == "paladin") then
    if string.find(classes, "and") then
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the")
        actor:send("</>" .. tostring(classes))
        actor:send("</>classes only.'")
    else
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the")
        actor:send("</>" .. tostring(classes))
        actor:send("</>class only.'")
    end
    return _return_value
elseif actor.level <= 20 * (phase - 1) then
    actor:send(tostring(self.name) .. " tells you, 'Sorry, why don't you come back when you've")
    actor:send("</>gained more experience?'")
    return _return_value
elseif actor:get_quest_stage("phase_armor") < phase - 1 then
    actor:send(tostring(self.name) .. " tells you, 'I don't think you're ready for my quests yet.'")
    return _return_value
end
if actor:get_quest_stage("phase_armor") == 0 then
    actor:start_quest("phase_armor")
elseif actor:get_quest_stage("phase_armor") == phase - 1 then
    actor:advance_quest("phase_armor")
end
actor:send(tostring(self.name) .. " tells you, 'Excellent.  I can make " .. tostring(hands_name) .. ", " .. tostring(feet_name) .. ",")
actor:send("</>a " .. tostring(wrist_name) .. ", a " .. tostring(head_name) .. ", " .. tostring(arms_name) .. ", " .. tostring(legs_name) .. ", or a " .. tostring(body_name) .. ".'")
wait(2)
actor:send(tostring(self.name) .. " tells you, 'If you want to know about how to quest for")
actor:send("</>one, ask me about it and I will tell you the components you need to get for me")
actor:send("</>in order to receive your reward.'")
wait(2)
actor:send(tostring(self.name) .. " tells you, 'Remember, you can ask me <b:cyan>armor progress</> at any")
actor:send("</>time and I'll tell you what you have given me so far.'")
wait(2)
if not actor:has_item(2, 99) and not actor:has_equipped(2, 99) then
    actor:send("You can also track the progress of all your quests in this journal.")
    self.room:spawn_object(2, 99)
    self:command("give quest-journal " .. tostring(actor.name))
    wait(2)
    actor:send("<b:cyan>[Look]</> at the journal for instructions on how to use it.")
end$trig$, 'f8c06c2b4811b195da4222f4bf8f4535'),
  -- data/triggers/557/557_02_phase_armor_-_armor.lua
  (557, 2, $trig$-- Converted from DG Script #55702: Phase Armor - Armor
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
wait(2)
local anti = "Anti-Paladin"
-- If you add more types of armor, you need to add their
-- keywords in the argument field for this trigger.
if not actor or not actor.can_be_seen then
    self:command("peer")
    self:say("I can't help you if I can't see you.")
    return true
elseif not string.find(classes, actor.class) or (classes == anti and actor.class == "paladin") then
    if string.find(classes, "and") then
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the")
        actor:send("</>" .. tostring(classes))
        actor:send("</>classes only.'")
    else
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the")
        actor:send("</>" .. tostring(classes))
        actor:send("</>class only.'")
    end
    return true
elseif actor.level <= 20 * (phase - 1) then
    actor:send(tostring(self.name) .. " tells you, 'Sorry, why don't you come back when you've")
    actor:send("</>gained more experience?'")
    return true
elseif actor:get_quest_stage("phase_armor") < phase then
    actor:send(tostring(self.name) .. " tells you, 'I don't think you're ready for my quests yet.'")
    return true
end
-- TODO(parity): converter inverted the original `==` checks to `~=`
-- across this slot-dispatch cascade. Original DG selected the slot
-- whose `<slot>_name` matched the speech keyword; the lines below
-- preserve the suspicious `~=` form pending legacy verification.
local name, gem_id, armor_id
if hands_name ~= speech then
    name = "pair of " .. tostring(hands_name)
    gem_id = hands_gem
    armor_id = hands_armor
elseif feet_name ~= speech then
    name = "pair of " .. tostring(feet_name)
    gem_id = feet_gem
    armor_id = feet_armor
elseif wrist_name ~= speech then
    name = wrist_name
    gem_id = wrist_gem
    armor_id = wrist_armor
elseif head_name ~= speech then
    name = head_name
    gem_id = head_gem
    armor_id = head_armor
elseif arms_name ~= speech then
    name = "pair of " .. tostring(arms_name)
    gem_id = arms_gem
    armor_id = arms_armor
elseif legs_name ~= speech then
    name = "pair of " .. tostring(legs_name)
    gem_id = legs_gem
    armor_id = legs_armor
elseif body_name ~= speech then
    name = body_name
    gem_id = body_gem
    armor_id = body_armor
end
if name then
    -- TODO(parity): DG `%get.obj_shortdesc[%armor_id%]%` /
    -- `%get.obj_pldesc[%gem_id%]%` left as literal placeholder text.
    -- Replace with `objects.template(zone, id).name` lookups once the
    -- gem/armor ids are split into (zone, local_id) pairs.
    actor:send(tostring(self.name) .. " tells you, 'Well, I can make a fine " .. tostring(name) .. " for you, but")
    actor:send("</>I'll need <b:cyan>" .. "%get.obj_shortdesc[%armor_id%]%</> and <b:cyan>three %get.obj_pldesc[%gem_id%]%</>.")
    actor:send("</>Bring these things to me in any order, at any time, and I will reward you.'")
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'You will find them on creatures across the world.")
    if phase == 1 then
        actor:send("</>Creatures <b:cyan>up to level 20</> will drop them.'")
    elseif phase == 2 then
        actor:send("</>Creatures <b:cyan>level 20 to 40</> will drop them.'")
    elseif phase == 3 then
        actor:send("</>Creatures <b:cyan>level 40 to 70</> will drop them.'")
    end
else
    actor:send(tostring(self.name) .. " peers at you oddly.")
    self.room:send_except(actor, tostring(self.name) .. " peers at " .. tostring(actor.name) .. " oddly.")
    actor:send(tostring(self.name) .. " tells you, 'I don't think I can make that for you.'")
end$trig$, 'b808dafc28cd632d2baa34869a76c60c'),
  -- data/triggers/557/557_03_phase_armor_-_receive.lua
  (557, 3, $trig$-- Converted from DG Script #55703: Phase Armor - Receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- TODO(parity): converter left every per-slot id comparison as a
-- string literal (e.g. `object.id == "%hands_armor%"`). They will
-- never match a real numeric object.id and the entire turn-in path
-- below is dead code until rewritten. Replace with comparisons
-- against the locals seeded by the LOAD trigger (e.g.
-- `object.id == hands_armor`) once it's confirmed whether stored
-- ids are local_id or composite (zone, id).
if object.id == hands_armor or object.id == hands_gem or object.id == feet_armor or object.id == feet_gem or object.id == wrist_armor or object.id == wrist_gem or object.id == head_armor or object.id == head_gem or object.id == arms_armor or object.id == arms_gem or object.id == legs_armor or object.id == legs_gem or object.id == body_armor or object.id == body_gem then
    local anti = "Anti-Paladin"
    if not actor or not actor.can_be_seen then
        _return_value = true
        self:command("peer")
        actor:send(tostring(self.name) .. " says, 'I can't help you if I can't see you.'")
        return _return_value
    end
    if not string.find(classes, actor.class) or (classes == anti and actor.class == "paladin") then
        _return_value = true
        if string.find(classes, "and") then
            actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the " .. tostring(classes) .. " classes only.'")
        else
            actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the " .. tostring(classes) .. " class only.'")
        end
        return _return_value
    elseif actor.level <= 20 * (phase - 1) then
        _return_value = true
        actor:send(tostring(self.name) .. " tells you, 'Sorry, why don't you come back when you've gained more experience?'")
        actor:send(tostring(self.name) .. " refuses your item.")
        return _return_value
    elseif actor:get_quest_stage("phase_armor") < phase then
        _return_value = true
        actor:send(tostring(self.name) .. " tells you, 'I don't think you're ready for my armor quests yet.'")
        actor:send(tostring(self.name) .. " refuses your item.")
        return _return_value
    end
    local object_id = object.id
    local is_armor, exp_x, reward_id
    if object_id == hands_armor then
        is_armor = 1
    elseif object_id == hands_gem then
        exp_x = 1
        reward_id = hands_reward
    elseif object_id == feet_armor then
        is_armor = 1
    elseif object_id == feet_gem then
        exp_x = 2
        reward_id = feet_reward
    elseif object_id == wrist_armor then
        is_armor = 1
    elseif object_id == wrist_gem then
        exp_x = 3
        reward_id = wrist_reward
    elseif object_id == head_armor then
        is_armor = 1
    elseif object_id == head_gem then
        exp_x = 4
        reward_id = head_reward
    elseif object_id == arms_armor then
        is_armor = 1
    elseif object_id == arms_gem then
        exp_x = 6
        reward_id = arms_reward
    elseif object_id == legs_armor then
        is_armor = 1
    elseif object_id == legs_gem then
        exp_x = 8
        reward_id = legs_reward
    elseif object_id == body_armor then
        is_armor = 1
    elseif object_id == body_gem then
        exp_x = 10
        reward_id = body_reward
    end
    -- TODO(parity): DG `%get.obj_*[%object_id%]%` placeholders below
    -- are emitted as literal text. Substitute via
    -- `objects.template(zone, id).name` once the per-slot ids are
    -- promoted to (zone, local_id) tuples.
    if is_armor then
        local armor_key = tostring(object_id) .. "_armor_acquired"
        local armor_count = actor:get_quest_var("phase_armor:" .. armor_key) or 0
        if armor_count < 1 then
            _return_value = false
            wait(1)
            world.destroy(object)
            armor_count = armor_count + 1
            actor:set_quest_var("phase_armor", armor_key, armor_count)
            actor:send(tostring(self.name) .. " tells you, 'Hey now, what have we here!?")
            actor:send("</>I've been looking for this for some time.")
            actor:send("</>You have now given me " .. "%get.obj_shortdesc[%object_id%]%.'")
        else
            _return_value = true
            wait(2)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'Hey now, you've already given me one of these!'")
            actor:send(tostring(self.name) .. " refuses your item.")
            return _return_value
        end
    else
        local gem_key = tostring(object_id) .. "_gems_acquired"
        local gem_count = actor:get_quest_var("phase_armor:" .. gem_key) or 0
        if gem_count < 3 then
            _return_value = false
            wait(1)
            world.destroy(object)
            gem_count = gem_count + 1
            actor:set_quest_var("phase_armor", gem_key, gem_count)
            actor:send(tostring(self.name) .. " tells you, 'Hey, very nice.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'It is good to see that adventurers are out conquering the realm.'")
            wait(2)
            if gem_count == 1 then
                actor:send(tostring(self.name) .. " tells you, 'You have given me 1 " .. "%get.obj_noadesc[%object_id%]%.'")
            else
                actor:send(tostring(self.name) .. " tells you, 'You have given me " .. tostring(gem_count) .. " " .. "%get.obj_pldesc[%object_id%]%.'")
            end
        else
            _return_value = true
            wait(1)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'Hey now, you've already given me " .. tostring(gem_count) .. " of these!'")
            actor:send(tostring(self.name) .. " refuses your item.")
            return _return_value
        end
    end
    --
    -- Check to see if the quest is complete and if the reward can be given.
    -- The original DG looked up `<gem_id>_gems_acquired` and
    -- `<armor_id>_armor_acquired`; we mirror that using the same
    -- `<id>_..._acquired` keying pattern used above. Per-slot pairing
    -- is derived from whichever gem/armor slot matches `object_id`.
    --
    local function _slot_for(oid)
        if oid == hands_armor or oid == hands_gem then return hands_armor, hands_gem end
        if oid == feet_armor  or oid == feet_gem  then return feet_armor,  feet_gem  end
        if oid == wrist_armor or oid == wrist_gem then return wrist_armor, wrist_gem end
        if oid == head_armor  or oid == head_gem  then return head_armor,  head_gem  end
        if oid == arms_armor  or oid == arms_gem  then return arms_armor,  arms_gem  end
        if oid == legs_armor  or oid == legs_gem  then return legs_armor,  legs_gem  end
        if oid == body_armor  or oid == body_gem  then return body_armor,  body_gem  end
    end
    local slot_armor_id, slot_gem_id = _slot_for(object_id)
    if slot_armor_id
       and (actor:get_quest_var("phase_armor:" .. tostring(slot_gem_id) .. "_gems_acquired") == 3)
       and (actor:get_quest_var("phase_armor:" .. tostring(slot_armor_id) .. "_armor_acquired") == 1) then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Excellent work, intrepid adventurer!")
        actor:send("</>You have provided me with all I need to reward you with:")
        actor:send("</>" .. "%get.obj_shortdesc[%reward_id%]%!'")
        wait(2)
        actor:send("<b:white>You gain experience!</>")
        local exp
        if actor.class == "warrior" or actor.class == "berserker" then
            exp = 7590
        elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
            exp = 7935
        elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
            exp = 8280
        elseif actor.class == "necromancer" or actor.class == "monk" then
            exp = 8970
        else
            exp = 6900
        end
        if phase == 2 then
            exp = math.floor(exp * 608 / 100)
        elseif phase == 3 then
            exp = math.floor(exp * 1340 / 100)
        end
        local lap = 1
        while lap <= exp_x do
            actor:award_exp(exp)
            lap = lap + 1
        end
        self.room:spawn_object(math.floor(reward_id / 100), reward_id % 100)
        self:command("give all " .. tostring(actor.name))
        self:command("drop all")
        actor:save()
    end
end  -- auto-close block
return _return_value$trig$, '8dffe5ac2103f1362f27d6bdf9367a73'),
  -- data/triggers/557/557_04_phase_armor_-_status.lua
  (557, 4, $trig$-- Converted from DG Script #55704: Phase Armor - Status
-- Original: MOB trigger, flags: SPEECH_TO, probability: 0%
-- TODO(parity): the per-slot output lines below still emit literal
-- DG placeholders like `%get.obj_shortdesc[%hands_armor%]%`.
-- Replace with `objects.template(zone, id).name` once each slot id
-- is known as a (zone, local_id) tuple.
local anti = "Anti-Paladin"
wait(2)
if not actor or not actor.can_be_seen then
    self:command("peer")
    self:say("I can't help you if I can't see you.")
    return true
elseif not string.find(classes, actor.class) or (classes == anti and actor.class == "paladin") then
    if string.find(classes, "and") then
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the")
        actor:send("</>" .. tostring(classes))
        actor:send("</>classes only.'")
    else
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the")
        actor:send("</>" .. tostring(classes))
        actor:send("</>class only.'")
    end
    return true
elseif actor.level <= 20 * (phase - 1) then
    actor:send(tostring(self.name) .. " tells you, 'Sorry, why don't you come back when you've")
    actor:send("</>gained more experience?'")
    return true
elseif actor:get_quest_stage("phase_armor") < phase then
    actor:send(tostring(self.name) .. " tells you, 'I don't think you're ready for my quests yet.'")
    return true
end
local got_hands = actor:get_quest_var("phase_armor:hands_armor_armor_acquired")
local got_feet = actor:get_quest_var("phase_armor:feet_armor_armor_acquired")
local got_wrist = actor:get_quest_var("phase_armor:wrist_armor_armor_acquired")
local got_head = actor:get_quest_var("phase_armor:head_armor_armor_acquired")
local got_arms = actor:get_quest_var("phase_armor:arms_armor_armor_acquired")
local got_legs = actor:get_quest_var("phase_armor:legs_armor_armor_acquired")
local got_body = actor:get_quest_var("phase_armor:body_armor_armor_acquired")
local hands_count = actor:get_quest_var("phase_armor:hands_gem_gems_acquired")
local feet_count = actor:get_quest_var("phase_armor:feet_gem_gems_acquired")
local wrist_count = actor:get_quest_var("phase_armor:wrist_gem_gems_acquired")
local head_count = actor:get_quest_var("phase_armor:head_gem_gems_acquired")
local arms_count = actor:get_quest_var("phase_armor:arms_gem_gems_acquired")
local legs_count = actor:get_quest_var("phase_armor:legs_gem_gems_acquired")
local body_count = actor:get_quest_var("phase_armor:body_gem_gems_acquired")
local done_hands = got_hands == 1  and  hands_count == 3
local done_feet = got_feet == 1  and  feet_count == 3
local done_wrist = got_wrist == 1  and  wrist_count == 3
local done_head = got_head == 1  and  head_count == 3
local done_arms = got_arms == 1  and  arms_count == 3
local done_legs = got_legs == 1  and  legs_count == 3
local done_body = got_body == 1  and  body_count == 3
-- Coerce nils to 0 so arithmetic and comparisons below are safe.
got_hands = got_hands or 0; got_feet = got_feet or 0; got_wrist = got_wrist or 0
got_head  = got_head  or 0; got_arms = got_arms or 0; got_legs  = got_legs  or 0
got_body  = got_body  or 0
hands_count = hands_count or 0; feet_count = feet_count or 0
wrist_count = wrist_count or 0; head_count = head_count or 0
arms_count  = arms_count  or 0; legs_count = legs_count or 0
body_count  = body_count  or 0
local given = got_hands + got_feet + got_wrist + got_head + got_arms + got_legs + got_body
given = given + hands_count + feet_count + wrist_count + head_count + arms_count + legs_count + body_count
-- Count slots that have any partial progress but aren't fully rewarded
-- (i.e. armor + 3 gems = 4 turn-ins).
local function _b2i(b) if b then return 1 else return 0 end end
local unrewarded = _b2i(got_hands + hands_count ~= 4) + _b2i(got_feet + feet_count ~= 4) + _b2i(got_wrist + wrist_count ~= 4)
unrewarded = unrewarded + _b2i(got_head + head_count ~= 4) + _b2i(got_arms + arms_count ~= 4)
unrewarded = unrewarded + _b2i(got_legs + legs_count ~= 4) + _b2i(got_body + body_count ~= 4)
actor:send(tostring(self.name) .. " tells you, 'Look for treasures from creatures:")
if phase == 1 then
    actor:send("<b:cyan>below level 20</>.'_")
elseif phase == 2 then
    actor:send("<b:cyan>level 20 to 40</>.'_")
elseif phase == 3 then
    actor:send("<b:cyan>level 40 to 70</>.'_")
end
if not given then
    actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
    return true
elseif unrewarded then
    actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
end
if got_hands and not done_hands then
    actor:send("</>  " .. "%get.obj_shortdesc[%hands_armor%]%")
end
if hands_count and not done_hands then
    actor:send("</>  " .. tostring(hands_count) .. " of " .. "%get.obj_shortdesc[%hands_gem%]%")
end
if got_feet and not done_feet then
    actor:send("</>  " .. "%get.obj_shortdesc[%feet_armor%]%")
end
if feet_count and not done_feet then
    actor:send("</>  " .. tostring(feet_count) .. " of " .. "%get.obj_shortdesc[%feet_gem%]%")
end
if got_wrist and not done_wrist then
    actor:send("</>  " .. "%get.obj_shortdesc[%wrist_armor%]%")
end
if wrist_count and not done_wrist then
    actor:send("</>  " .. tostring(wrist_count) .. " of " .. "%get.obj_shortdesc[%wrist_gem%]%")
end
if got_head and not done_head then
    actor:send("</>  " .. "%get.obj_shortdesc[%head_armor%]%")
end
if head_count and not done_head then
    actor:send("</>  " .. tostring(head_count) .. " of " .. "%get.obj_shortdesc[%head_gem%]%")
end
if got_arms and not done_arms then
    actor:send("</>  " .. "%get.obj_shortdesc[%arms_armor%]%")
end
if arms_count and not done_arms then
    actor:send("</>  " .. tostring(arms_count) .. " of " .. "%get.obj_shortdesc[%arms_gem%]%")
end
if got_legs and not done_legs then
    actor:send("</>  " .. "%get.obj_shortdesc[%legs_armor%]%")
end
if legs_count and not done_legs then
    actor:send("</>  " .. tostring(legs_count) .. " of " .. "%get.obj_shortdesc[%legs_gem%]%")
end
if got_body and not done_body then
    actor:send("</>  " .. "%get.obj_shortdesc[%body_armor%]%")
end
if body_count and not done_body then
    actor:send("</>  " .. tostring(body_count) .. " of " .. "%get.obj_shortdesc[%body_gem%]%")
end
if done_hands and done_feet and done_wrist and done_head and done_arms and done_legs and done_body then
    actor:send("_")
    actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
end
if done_hands then
    actor:send("</>  " .. "%get.obj_shortdesc[%hands_reward%]%")
end
if done_feet then
    actor:send("</>  " .. "%get.obj_shortdesc[%feet_reward%]%")
end
if done_wrist then
    actor:send("</>  " .. "%get.obj_shortdesc[%wrist_reward%]%")
end
if done_head then
    actor:send("</>  " .. "%get.obj_shortdesc[%head_reward%]%")
end
if done_arms then
    actor:send("</>  " .. "%get.obj_shortdesc[%arms_reward%]%")
end
if done_legs then
    actor:send("</>  " .. "%get.obj_shortdesc[%legs_reward%]%")
end
if done_body then
    actor:send("</>  " .. "%get.obj_shortdesc[%body_reward%]%")
end$trig$, 'ecf285b3d78c36e3a30f2fc0372a7072'),
  -- data/triggers/557/557_05_phase_armor_-_where.lua
  (557, 5, $trig$-- Converted from DG Script #55705: Phase Armor - Where
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
local anti = "Anti-Paladin"
local max_phase = 3
if not actor or not actor.can_be_seen then
    self:command("peer")
    self:say("I can't help you if I can't see you.")
    return true
elseif not string.find(classes, actor.class) or (classes == anti and actor.class == "paladin") then
    if string.find(classes, "and") then
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the " .. tostring(classes) .. " classes only.'")
    else
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the " .. tostring(classes) .. " class only.'")
    end
    return true
elseif actor.level <= 20 * (phase - 1) then
    actor:send(tostring(self.name) .. " tells you, 'Sorry, why don't you come back when you've gained more experience?'")
    return true
elseif actor:get_quest_stage("phase_armor") < phase - 1 then
    actor:send(tostring(self.name) .. " tells you, 'I don't think you're ready for my quests yet.'")
    return true
end
local low_level = (phase - 1) * 20 + 1
local high_level = phase * 20
wait(2)
actor:send(tostring(self.name) .. " tells you, 'You can find the items I seek by playing and adventuring in areas appropriate to your level.'")
actor:send(tostring(self.name) .. " tells you, 'My quests are for those from level " .. tostring(low_level) .. " to " .. tostring(high_level) .. ", so the items I desire can be found in areas of that difficulty.'")
if phase < max_phase then
    actor:send(tostring(self.name) .. " tells you, 'Once you have agreed to take on my quests you can seek another like me for tasks a bit more difficult.'")
end$trig$, 'd4e8849d794da94c6a0d5f9b70351d16'),
  -- data/triggers/583/583_80_holy_burn_the_wicked.lua
  (583, 80, $trig$if actor.class == "paladin" then
    if actor.alignment < 750 then
        wait(2)
        self.room:send("The holy blade of Godly vigor dulls in appearance.")
        actor:send("You are no longer holy enough to use this sacred weapon, you can no longer wield it.")
        self.room:send_except(actor, tostring(actor.name) .. "'s blade grows dull, unglowing.")
        actor:command("remove vigor")
    else  -- alignment >= 750
        wait(2)
        self.room:send("The holy blade of Godly vigor glows with a soft, white light.")
        actor:send("Your eyes widen with awe and splendor as you hold the holy blade of Godly vigor.")
        self.room:send_except(actor, tostring(actor.name) .. " is surrounded by a holy glow.")
    end
else  -- Non-paladin wielder
    if actor.alignment < -350 then
        wait(2)
        self.room:send("The holy blade of Godly vigor glows violently!")
        actor:send("The pain in your body is excruciating, you feel death.")
        local var_dam = random(1, 50) + 1517
        self.room:send_except(actor, tostring(actor.name) .. " convulses and life drains from his body. (<yellow>" .. tostring(var_dam) .. "</>)")
        actor:damage(var_dam)  -- type: physical
        -- Note: original DG warned this oforce can syserror if damage kills the victim.
        actor:command("remove vigor")
    else  -- alignment >= -350
        wait(2)
        self.room:send("The holy blade of Godly vigor vibrates unsteadily.")
        actor:send("This blade clearly is not happy to be in your hands.  Take care.")
        self.room:send_except(actor, tostring(actor.name) .. "'s hands shake unsteadily as he holds the blade.")
        actor:command("remove vigor")
    end
end$trig$, '1dbeabff10ad828552b0301f6ddac566'),
  -- data/triggers/590/590_15_stop_south_38.lua
  (590, 15, $trig$-- Converted from DG Script #59015: stop_south_38
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: south
if not (cmd == "south") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if actor.class == "paladin" then
    _return_value = true
else
    actor:send(tostring(self.name) .. " puts a hand in your face, stopping you in your tracks.")
    self.room:send_except(actor, tostring(self.name) .. " puts a hand in " .. tostring(actor.name) .. "'s face, stopping " .. tostring(actor.object) .. " from going south.")
    _return_value = false  -- block the south movement
end
return _return_value$trig$, '7050953ec02e72c243d3fa30181b0a1b'),
  -- data/triggers/590/590_17_stop_east_58.lua
  (590, 17, $trig$-- Converted from DG Script #59017: stop_east_58
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: open
if not (cmd == "open") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if actor.class == "paladin" then
    _return_value = true
else
    -- switch on arg
    if arg == "door" or arg == "door e" or arg == "door ea" or arg == "door eas" or arg == "door east" then
        self.room:send_except(actor, tostring(self.name) .. " slaps " .. tostring(actor.name) .. "'s hand away from the door.")
        actor:send(tostring(self.name) .. " slaps your hand away from the door.")
        _return_value = false  -- block the open
    else
        actor:send("There doesn't seem to be an " .. tostring(arg) .. " here.")
        _return_value = false  -- block, since we already echoed our own response
    end
end
return _return_value$trig$, '48eac4180633227a4430f58974232a69'),
  -- data/triggers/590/590_21_stop_west_r69.lua
  (590, 21, $trig$-- Converted from DG Script #59021: stop_west_R69
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: west
if not (cmd == "west") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if actor.class == "paladin" then
    _return_value = true
else
    actor:send(tostring(self.name) .. " jumps in front of you, preventing you from getting by.")
    self.room:send_except(actor, tostring(self.name) .. " jumps in front of " .. tostring(actor.name) .. ", preventing " .. tostring(actor.object) .. " from getting past.")
    _return_value = false  -- block the west movement
end
return _return_value$trig$, 'b281f6210162a5520ec7176193d29bdb'),
  -- data/triggers/590/590_33_stop_flee3.lua
  (590, 33, $trig$-- Converted from DG Script #59033: stop_flee3
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: flee
if not (cmd == "flee") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if actor.class == "paladin" then
    _return_value = true
else
    _return_value = false
    local rnd = random(1, 10)
    -- switch on rnd
    if rnd == 1 or rnd == 2 or rnd == 3 or rnd == 4 or rnd == 5 then
        self.room:send_except(actor, tostring(actor.name) .. " panics, and attempts to flee!")
        self.room:send_except(actor, tostring(actor.name) .. " leaves north.")
        actor:teleport(get_room(590, 35))
        self.room:send_except(actor, tostring(actor.name) .. " enters from the south.")
        -- actor looks around
        actor:send("You panic and flee north!")
    elseif rnd == 6 or rnd == 7 or rnd == 8 or rnd == 9 or rnd == 10 then
        actor:send("PANIC!  You couldn't escape!")
    end
end
return _return_value$trig$, '07361565dc699a994382aabb1ade2247'),
  -- data/triggers/590/590_43_sacred_haven_paladin_enter.lua
  (590, 43, $trig$-- Converted from DG Script #59043: sacred_haven_paladin_enter
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
if actor.alignment >= 350 then
    if actor.class == "paladin" or actor.class == "priest" or actor.class == "cleric" then
        wait(2)
        self:command("rem key")
        self:command("unlock door")
        wait(2)
        self:command("open door")
        self:command("hold key")
        wait(2)
        self:command("bow " .. tostring(actor.name))
        self:say("Welcome to the Sacred Haven, fellow warrior.")
    end
end$trig$, '5472ca77fabb6cf7fa7fc2ed194147b2'),
  -- data/triggers/590/590_45_group_armor_forgemaster_speech.lua
  (590, 45, $trig$-- Converted from DG Script #59045: group_armor_forgemaster_speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes yes! yep okay sure
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "yes!") or string.find(string.lower(speech), "yep") or string.find(string.lower(speech), "okay") or string.find(string.lower(speech), "sure")) then
    return true  -- No matching keywords
end
local stage = actor:get_quest_stage("group_armor")
wait(2)
if (string.find(actor.class, "Cleric") and actor.level > 72) or (string.find(actor.class, "Priest") and actor.level > 56) then
    if stage == 0 then
        actor:start_quest("group_armor")
        self:say("Then welcome aboard!")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'First, I need four things that cast the Armor")
        self.room:send("</>spell to amplify my prayers to Moradin:'")
        self.room:send("<b:yellow>" .. tostring(objects.template(61, 18).name) .. "</>")
        self.room:send("<b:yellow>" .. tostring(objects.template(117, 4).name) .. "</>")
        self.room:send("<b:yellow>" .. tostring(objects.template(117, 7).name) .. "</>")
        self.room:send("<b:yellow>" .. tostring(objects.template(169, 6).name) .. "</>")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'Moradin watch over your travels!")
        self.room:send("</>If you need an update, ask me about your <b:white>[progress]</>.'")
    elseif stage == 1 then
        self:say("Let me see what you have!")
    elseif stage == 2 then
        self:say("Thank you so much!")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Bring back a forging hammer then I can tell")
        self.room:send("</>you what to do next.'")
    elseif stage == 3 or stage == 4 then
        self:say("Let me test out the new hammer then!")
    elseif stage == 6 then
        self:say("Let me see what you've brought!")
    end
elseif (string.find(actor.class, "Cleric") and actor.level < 72) or (string.find(actor.class, "Priest") and actor.level < 56) then
    self.room:send(tostring(self.name) .. " says, 'I don't think you're quite ready to be a forge")
    self.room:send("</>acolyte yet.'")
    self:command("laugh")
    actor:send(tostring(self.name) .. " claps you on the back with his mighty hand!")
    self.room:send_except(actor, tostring(self.name) .. " claps " .. tostring(actor.name) .. " on the back with his mighty hand.")
elseif actor.class ~= "cleric" or actor.class ~= "priest" then
    self.room:send(tostring(self.name) .. " says, 'You may wish to prove your worth but I can only")
    self.room:send("</>work with those dedicated to divinity.'")
end$trig$, '6d1bd22a0de5b91416485d40ee4c0a81'),
  -- data/triggers/625/625_04_ursa_s_room.lua
  (625, 4, $trig$-- Converted from DG Script #62504: ursa's room
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
--
-- Called from 625_09 (Ursa's GREET/FIGHT). `self` is the room.
-- Ursa lets out a roar; everyone in the room except Ursa
-- takes damage scaled to their level. Rangers and druids are
-- invigorated rather than hurt; Ursa himself (mild form 62507
-- and enraged form 62550) is exempt; high-level (>=100) chars
-- are exempt as well.
local ursa = self.room:find_actor("Ursa")
self.room:send_except(ursa, "&9<blue>Ursa makes your frame quake with a vicious <red>ROOOOOAAAAAARRRRRR!</>")
for _, target in ipairs(self.actors) do
    local is_ursa = (target.zone_id == 625 and (target.local_id == 7 or target.local_id == 50))
    if not is_ursa and target.level < 100 then
        local dam = math.floor(1.5 * target.level - random(1, 12))
        if target.class == "ranger" or target.class == "druid" then
            target:send("<yellow>Ursa's roar invigorates your wild spirit!<b:yellow></> (<b:red>0</>)")
            self.room:send_except(target, "<yellow>Ursa's roar invigortates " .. tostring(target.name) .. "'s wild spirit!</> (<b:red>0</>)")
        else
            local damage_dealt = target:damage(dam)  -- type: physical
            target:send("<b:yellow>You shrink in pain at Ursa's mighty roar!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(target, "<yellow>Ursa's roar causes " .. tostring(target.name) .. " to shrink in pain.</> (<blue>" .. tostring(damage_dealt) .. "</>)")
        end
    end
end$trig$, 'cb7aee996772a33ba21cad2264f1f385'),
  -- data/triggers/625/625_50_quest_room.lua
  (625, 50, $trig$-- Converted from DG Script #62550: quest room
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
--
-- Called from 625_34/35/36/37 once the player has handed in the
-- final quest item. `self` is the room. Locate the player who
-- is at stage 6 of ursa_quest and run the matching cinematic.
local quester
for _, person in ipairs(self.actors) do
    if person.is_player and person:get_quest_stage("ursa_quest") == 6 then
        quester = person
        break
    end
end
if not quester then
    self.room:find_actor("mild"):say("Where did you go?")
    return true
end
if quester:get_quest_stage("ursa_quest") == 6 then
    -- now find the right script to run, based on that players questvar: choice
    if quester:get_quest_var("ursa_quest:choice") == 1 then
        wait(5)
        self.room:send("The mild mannered merchant says, 'Fantastic.  Now let's see what miracle the Emperor has found.'")
        self.room:find_actor("mild"):emote("digs a slight divot into the ground with the end of the thorny staff.")
        self.room:find_actor("mild"):emote("places the pepper and plant into the divot.")
        self.room:find_actor("mild"):emote("leaves the thorny staff standing erect out of the ground.")
        wait(2)
        self.room:find_actor("mild"):command("hold pitcher")
        self.room:find_actor("mild"):command("pour pitcher out")
        self.room:find_actor("mild"):emote("gently fills the pitcher from the Sacred Spring.")
        wait(1)
        self.room:find_actor("mild"):emote("pours sacred water over the thorny staff.")
        self.room:send("The ground at the base of the staff quickly soaks up the water as it trickles down.")
        wait(3)
        self.room:send("At the base of the <white>thorny staff</> <b:green>life</> breaks forth!")
        self.room:send("A <green>vine</> crawls up the <white>staff</>, weaving between the <white>thorns</>.")
        wait(1)
        self.room:send("The <green>vine completely covers the </><white>thorny</> <green>staff.</>")
        wait(2)
        self.room:send("The mild mannered merchant reaches out his hand and grasps the <white>thorny</> <green>staff</>.")
        self.room:send("The <green>vine</> soaks up the <red>blood</> as the <white>thorns</> pierce the merchant's hand.")
        wait(2)
        self.room:send("<yellow>The merchant contorts wildly, shifting unevenly between man and beast, but retains his grasp on the <green>staff.</>")
        wait(2)
        self.room:send("The mild mannered merchant removes his wounded hand, and the <green>vine</> recedes back into the earth, taking with it the blood and the thorns.")
        self.room:find_actor("mild"):emote("takes a moment to catch his breath.")
        wait(3)
        self.room:find_actor("merchant"):emote("pulls <green>The Redeeming Staff</> from the ground.")
        -- load staff and give it to the player
        wait(2)
        self.room:spawn_object(625, 9)
        self.room:find_actor("mild"):command("get staff")
        self.room:find_actor("mild"):emote("runs his hand down the smooth staff.")
        wait(2)
        self.room:send("The mild mannered merchant says, 'I can not thank you enough!  I have myself back!'")
        wait(1)
        self.room:find_actor("mild"):command("give staff " .. tostring(quester))
        self.room:send("The mild mannered merchant says, 'I feel a lot of power in this staff.  I hope it can serve you well.'")
        wait(2)
        self.room:find_actor("mild"):say("And have these as a show of my gratitude.")
        for _ = 1, 3 do
            self.room:find_actor("mild"):spawn_object(557, 36 + random(1, 11))
        end
        self.room:find_actor("mild"):command("give all.gem " .. tostring(quester))
        self.room:find_actor("mild"):command("tip " .. tostring(quester))
        self.room:find_actor("mild"):emote("leaves north toward Blue Fog Trail.")
        world.destroy(self.room:find_actor("merchant"))
    elseif quester:get_quest_var("ursa_quest:choice") == 2 then
        wait(1)
        self.room:find_actor("mild"):say("Good enough.")
        self.room:find_actor("mild"):command("wear " .. tostring(object))
        self.room:find_actor("mild"):command("drink firebreather")
        wait(2)
        self.room:find_actor("mild"):emote("suddenly falls face-down on the ground, holding the dagger in place.")
        self.room:send("The dagger drives home!")
        wait(1)
        self.room:send("The mild mannered merchant contorts wildly, flashing, his form unclear.")
        wait(1)
        self.room:send("More beast than man, <yellow>Ursa roars in pain,</> the dagger gleaming in his heart.")
        wait(2)
        self.room:find_actor("mild"):emote("slumps silently to the ground, and the dagger clatters to the ground beside him.")
        wait(5)
        self.room:find_actor("mild"):command("groan")
        wait(3)
        self.room:find_actor("mild"):emote("looks himself up down.")
        wait(1)
        self.room:find_actor("mild"):say("It worked!  I did it!")
        wait(1)
        self.room:find_actor("mild"):emote("removes each of the king's items, many of them having undergone radical changes in the ordeal.")
        self.room:find_actor("mild"):emote("tosses them one by one into the pool, letting them sink to the bottom.")
        wait(1)
        self.room:find_actor("mild"):say("Thanks, pal!")
        self.room:find_actor("mild"):emote("disappears up the trail toward Blue-Fog Trail.")
        world.destroy(self.room:find_actor("mild"))
        wait(2)
        self.room:send("on the banks of the pool, something catches your eye.")
        wait(1)
        self.room:send("The diadem, having formed into hollow but hard glass, washes to the shore.")
        self.room:send("Upon second inspection you can see the form of the enraged Ursa, as if it were trying to escape its new glass home.")
        self.room:send("Several glittering gems wash up along with it.")
        for _ = 1, 3 do
            self.room:spawn_object(557, 36 + random(1, 11))
        end
        self.room:spawn_object(625, 8)
    elseif quester:get_quest_var("ursa_quest:choice") == 3 then
        wait(1)
        self.room:find_actor("mild"):emote("tosses the anvil to the ground with a grunt.")
        wait(3)
        self.room:find_actor("mild"):emote("places the ring of stolen life on the anvil.")
        wait(1)
        self.room:find_actor("mild"):emote("wields the Golden Druidstaff.")
        wait(3)
        self.room:send("<b:green>The mild mannered merchant </><b:red>CRUSHES</><b:green> the ring of stolen life with a swift blow.</>")
        wait(2)
        self.room:find_actor("mild"):emote("gathers the powdered ring into the milk, gives it a swirl, and drinks the milk to the last drop.")
        wait(2)
        self.room:send("The mild mannered merchant says, 'That should do the job.  I'm feeling better already!'")
        wait(4)
        self.room:send("You hear a deep grumbling, from the direction of the merchant.")
        wait(4)
        self.room:find_actor("merchant"):emote("frantically pulls a misty blue sword from his things.")
        self.room:send("The mild mannered merchant says, 'It's coming back!  I don't think I'll be able to regain control!'")
        self.room:send("A mild mannered merchant falls on his own sword! (<b:red>564</>)")
        wait(2)
        self.room:send("<yellow>A mild mannered merchant lets out a disturbing <blue>ROAR</><yellow> as the last of his humanity slips away.</>")
        world.destroy(self.room:find_actor("mild"))
        self.room:spawn_mobile(625, 50)
        self.room:spawn_object(625, 7)
        self.room:find_actor("ursa"):command("get sword")
        self.room:find_actor("ursa"):command("wi sword")
        for _ = 1, 3 do
            self.room:find_actor("ursa"):spawn_object(557, 36 + random(1, 11))
        end
    end
    --
    -- Compute experience reward, capped at level 50, scaled by class.
    --
    local expcap
    if quester.level < 50 then
        expcap = quester.level
    else
        expcap = 50
    end
    local expmod
    if expcap < 9 then
        expmod = (((expcap * expcap) + expcap) / 2) * 55
    elseif expcap < 17 then
        expmod = 440 + ((expcap - 8) * 125)
    elseif expcap < 25 then
        expmod = 1440 + ((expcap - 16) * 175)
    elseif expcap < 34 then
        expmod = 2840 + ((expcap - 24) * 225)
    elseif expcap < 49 then
        expmod = 4640 + ((expcap - 32) * 250)
    elseif expcap < 90 then
        expmod = 8640 + ((expcap - 48) * 300)
    else
        expmod = 20940 + ((expcap - 89) * 600)
    end
    --
    -- Adjust exp award by class so all classes receive the same proportionate amount.
    --
    if quester.class == "warrior" or quester.class == "berserker" then
        -- 110% of standard
        expmod = expmod + (expmod / 10)
    elseif quester.class == "paladin" or quester.class == "anti-paladin" or quester.class == "ranger" then
        -- 115% of standard
        expmod = expmod + ((expmod * 2) / 15)
    elseif quester.class == "sorcerer" or quester.class == "pyromancer" or quester.class == "cryomancer" or quester.class == "illusionist" or quester.class == "bard" then
        -- 120% of standard
        expmod = expmod + (expmod / 5)
    elseif quester.class == "necromancer" or quester.class == "monk" then
        -- 130% of standard
        expmod = expmod + ((expmod * 2) / 5)
    end
    quester:send("<b:yellow>You gain experience!</>")
    local setexp = expmod * 10
    for _ = 1, 10 do
        quester:award_exp(setexp)
    end
    quester:complete_quest("ursa_quest")
end$trig$, '84e81ef16c1c0c87fcb917ae7d83856b')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
