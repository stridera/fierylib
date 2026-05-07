-- Trigger: Guild Armor Phase One progress journal
-- Zone: 4, ID: 11
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
-- TODO(parity): contains literal DG remnants like %get.obj_shortdesc[...]% or %actor.quest_variable[...]% that the converter left as raw text inside actor:send(...) calls. These need to be rewritten as proper Lua splices using objects.template(zone, id).name and actor:get_quest_var(...) before players see correct output.
--
-- Original DG Script: #411

-- Converted from DG Script #411: Guild Armor Phase One progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if ((string.find(arg, "guild") or string.find(arg, "phase") or string.find(arg, "armor")) and (string.find(arg, "one") or string.find(arg, "1"))) or string.find(arg, "guild_armor_phase_one") or string.find(arg, "guild_armor_phase_1") or string.find(arg, "phase_armor_one") or string.find(arg, "phase_armor_1") then
    _return_value = true
    actor:send("<b:green>&uGuild Armor Phase One</>")
    actor:send("Mininum Level: 1")
    actor:send("Items for this quest drop from mobs between level 1 and 20.")
    if actor:get_quest_stage("phase_armor") then
        local sorcererclasses = "Sorcerer Cryomancer Pyromancer Illusionist Necromancer"
        local clericclasses = "Cleric Priest Druid Diabolist"
        local warriorclasses = "Warrior Anti-Paladin Ranger Paladin Monk Berserker"
        local rogueclasses = "Rogue Mercenary Assassin Thief Bard"
        local feet_gem
        local head_gem
        local hands_gem
        local arms_gem
        local legs_gem
        local body_gem
        local wrist_gem
        local feet_armor
        local head_armor
        local hands_armor
        local arms_armor
        local legs_armor
        local body_armor
        local wrist_armor
        local feet_reward
        local head_reward
        local hands_reward
        local arms_reward
        local legs_reward
        local body_reward
        local wrist_reward
        local master
        if string.find(sorcererclasses, actor.class) then
            feet_gem = 55571
            head_gem = 55579
            hands_gem = 55567
            arms_gem = 55583
            legs_gem = 55587
            body_gem = 55591
            wrist_gem = 55575
            feet_armor = 55306
            head_armor = 55314
            hands_armor = 55302
            arms_armor = 55318
            legs_armor = 55322
            body_armor = 55326
            wrist_armor = 55310
            feet_reward = 55402
            head_reward = 55398
            hands_reward = 55404
            arms_reward = 55399
            legs_reward = 55401
            body_reward = 55400
            wrist_reward = 55403
            master = "the Archmage of Mielikki and Gagar"
        elseif string.find(clericclasses, actor.class) then
            feet_gem = 55570
            head_gem = 55578
            hands_gem = 55566
            arms_gem = 55582
            legs_gem = 55586
            body_gem = 55590
            wrist_gem = 55574
            feet_armor = 55304
            head_armor = 55312
            hands_armor = 55300
            arms_armor = 55316
            legs_armor = 55320
            body_armor = 55324
            wrist_armor = 55308
            feet_reward = 55395
            head_reward = 55391
            hands_reward = 55397
            arms_reward = 55392
            legs_reward = 55394
            body_reward = 55393
            wrist_reward = 55396
            master = "the High Priestess of Mielikki and Rorgdush"
        elseif string.find(warriorclasses, actor.class) then
            feet_gem = 55573
            head_gem = 55581
            hands_gem = 55569
            arms_gem = 55585
            legs_gem = 55589
            body_gem = 55593
            wrist_gem = 55577
            feet_armor = 55304
            head_armor = 55312
            hands_armor = 55300
            arms_armor = 55316
            legs_armor = 55320
            body_armor = 55324
            wrist_armor = 55308
            feet_reward = 55388
            head_reward = 55384
            hands_reward = 55390
            arms_reward = 55385
            legs_reward = 55387
            body_reward = 55386
            wrist_reward = 55389
            master = "the Warrior Coach of Mielikki and Grort"
        elseif string.find(rogueclasses, actor.class) then
            feet_gem = 55572
            head_gem = 55580
            hands_gem = 55568
            arms_gem = 55584
            legs_gem = 55588
            body_gem = 55592
            wrist_gem = 55576
            feet_armor = 55305
            head_armor = 55313
            hands_armor = 55301
            arms_armor = 55317
            legs_armor = 55321
            body_armor = 55325
            wrist_armor = 55309
            feet_reward = 55409
            head_reward = 55405
            hands_reward = 55411
            arms_reward = 55406
            legs_reward = 55408
            body_reward = 55407
            wrist_reward = 55410
            master = "the Master Rogue of Mielikki and Tinilas"
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
return _return_value