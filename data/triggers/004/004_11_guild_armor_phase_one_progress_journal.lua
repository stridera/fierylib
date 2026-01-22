-- Trigger: Guild Armor Phase One progress journal
-- Zone: 4, ID: 11
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 27 if statements
--   Large script: 11289 chars
--
-- Original DG Script: #411

-- Converted from DG Script #411: Guild Armor Phase One progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if ((string.find(arg, "guild") or string.find(arg, "phase") or string.find(arg, "armor")) and (string.find(arg, "one") or string.find(arg, "1"))) or string.find(arg, "guild_armor_phase_one") or string.find(arg, "guild_armor_phase_1") or string.find(arg, "phase_armor_one") or string.find(arg, "phase_armor_1") then
    _return_value = false
    actor:send("<b:green>&uGuild Armor Phase One</>")
    actor:send("Mininum Level: 1")
    actor:send("Items for this quest drop from mobs between level 1 and 20.")
    if actor:get_quest_stage("phase_armor") then
        local sorcererclasses = "Sorcerer Cryomancer Pyromancer Illusionist Necromancer"
        local clericclasses = "Cleric Priest Druid Diabolist"
        local warriorclasses = "Warrior Anti-Paladin Ranger Paladin Monk Berserker"
        local rogueclasses = "Rogue Mercenary Assassin Thief Bard"
        if string.find(sorcererclasses, "actor.class") then
            local feet_gem = 55571
            local head_gem = 55579
            local hands_gem = 55567
            local arms_gem = 55583
            local legs_gem = 55587
            local body_gem = 55591
            local wrist_gem = 55575
            local feet_armor = 55306
            local head_armor = 55314
            local hands_armor = 55302
            local arms_armor = 55318
            local legs_armor = 55322
            local body_armor = 55326
            local wrist_armor = 55310
            local feet_reward = 55402
            local head_reward = 55398
            local hands_reward = 55404
            local arms_reward = 55399
            local legs_reward = 55401
            local body_reward = 55400
            local wrist_reward = 55403
            local master = "the Archmage of Mielikki and Gagar"
        elseif string.find(clericclasses, "actor.class") then
            local feet_gem = 55570
            local head_gem = 55578
            local hands_gem = 55566
            local arms_gem = 55582
            local legs_gem = 55586
            local body_gem = 55590
            local wrist_gem = 55574
            local feet_armor = 55304
            local head_armor = 55312
            local hands_armor = 55300
            local arms_armor = 55316
            local legs_armor = 55320
            local body_armor = 55324
            local wrist_armor = 55308
            local feet_reward = 55395
            local head_reward = 55391
            local hands_reward = 55397
            local arms_reward = 55392
            local legs_reward = 55394
            local body_reward = 55393
            local wrist_reward = 55396
            local master = "the High Priestess of Mielikki and Rorgdush"
        elseif string.find(warriorclasses, "actor.class") then
            local feet_gem = 55573
            local head_gem = 55581
            local hands_gem = 55569
            local arms_gem = 55585
            local legs_gem = 55589
            local body_gem = 55593
            local wrist_gem = 55577
            local feet_armor = 55304
            local head_armor = 55312
            local hands_armor = 55300
            local arms_armor = 55316
            local legs_armor = 55320
            local body_armor = 55324
            local wrist_armor = 55308
            local feet_reward = 55388
            local head_reward = 55384
            local hands_reward = 55390
            local arms_reward = 55385
            local legs_reward = 55387
            local body_reward = 55386
            local wrist_reward = 55389
            local master = "the Warrior Coach of Mielikki and Grort"
        elseif string.find(rogueclasses, "actor.class") then
            local feet_gem = 55572
            local head_gem = 55580
            local hands_gem = 55568
            local arms_gem = 55584
            local legs_gem = 55588
            local body_gem = 55592
            local wrist_gem = 55576
            local feet_armor = 55305
            local head_armor = 55313
            local hands_armor = 55301
            local arms_armor = 55317
            local legs_armor = 55321
            local body_armor = 55325
            local wrist_armor = 55309
            local feet_reward = 55409
            local head_reward = 55405
            local hands_reward = 55411
            local arms_reward = 55406
            local legs_reward = 55408
            local body_reward = 55407
            local wrist_reward = 55410
            local master = "the Master Rogue of Mielikki and Tinilas"
        end
        local got_hands = actor.quest_variable[phase_armor:hands_armor_armor_acquired]
        local got_feet = actor.quest_variable[phase_armor:feet_armor_armor_acquired]
        local got_wrist = actor.quest_variable[phase_armor:wrist_armor_armor_acquired]
        local got_head = actor.quest_variable[phase_armor:head_armor_armor_acquired]
        local got_arms = actor.quest_variable[phase_armor:arms_armor_armor_acquired]
        local got_legs = actor.quest_variable[phase_armor:legs_armor_armor_acquired]
        local got_body = actor.quest_variable[phase_armor:body_armor_armor_acquired]
        local hands_count = actor.quest_variable[phase_armor:hands_gem_gems_acquired]
        local feet_count = actor.quest_variable[phase_armor:feet_gem_gems_acquired]
        local wrist_count = actor.quest_variable[phase_armor:wrist_gem_gems_acquired]
        local head_count = actor.quest_variable[phase_armor:head_gem_gems_acquired]
        local arms_count = actor.quest_variable[phase_armor:arms_gem_gems_acquired]
        local legs_count = actor.quest_variable[phase_armor:legs_gem_gems_acquired]
        local body_count = actor.quest_variable[phase_armor:body_gem_gems_acquired]
        local done_hands = got_hands == 1  and  hands_count == 3
        local done_feet = got_feet == 1  and  feet_count == 3
        local done_wrist = got_wrist == 1  and  wrist_count == 3
        local done_head = got_head == 1  and  head_count == 3
        local done_arms = got_arms == 1  and  arms_count == 3
        local done_legs = got_legs == 1  and  legs_count == 3
        local done_body = got_body == 1  and  body_count == 3
        local given = got_hands + got_feet + got_wrist + got_head + got_arms + got_legs + got_body
        local given = given + hands_count + feet_count + wrist_count + head_count + arms_count + legs_count + body_count
        local unrewarded = (got_hands + hands_count  ~=  4) + (got_feet + feet_count  ~=  4) + (got_wrist + wrist_count  ~=  4)
        local unrewarded = unrewarded + (got_head + head_count  ~=  4) + (got_arms + arms_count  ~=  4)
        local unrewarded = unrewarded + (got_legs + legs_count  ~=  4) + (got_body + body_count  ~=  4)
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
        if done_hands or done_feet or done_wrist or done_head or done_arms or done_legs or done_body then
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