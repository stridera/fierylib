-- Trigger: Equipment quests
-- Zone: 4, ID: 2
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 34 if statements
--   Large script: 12613 chars
--
-- Original DG Script: #402

-- Converted from DG Script #402: Equipment quests
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "equipment") then
    _return_value = false
    local anti = "Anti-Paladin"
    local hunterclasses = "Warrior Ranger Berserker Mercenary"
    local sorcererclasses = "Sorcerer Illusionist Cryomancer Pyromancer Necromancer"
    actor:send("<yellow>=========== EQUIPMENT QUESTS ==========</>")
    actor:send("These quests often take a large amount of time to complete, spanning dozens of levels.")
    actor:send("Characters should expect to need large numbers of unique and hard-to-find items.")
    actor:send("They are generally not intended to be completed quickly.")
    actor:send("<b:yellow>[Look]</> at the key words in a quest title for your current status.")
    actor:send("<yellow>=======================================</>_")
    actor:send("<b:green>AVAILABLE QUESTS:</>_")
    actor:send("<b:green>&uGuild Armor Phase One</>")
    actor:send("Crafters across Ethilien will ask you to bring them gems and junked up armor so they can fix it up and present you with something new.")
    actor:send("Your home guild master is always the best place to start.")
    actor:send("Min Level: 1")
    if actor:get_quest_stage("phase_armor") then
        local status = "In Progress"
    else
        local status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    actor:send("<b:green>&uGuild Armor Phase Two</>")
    actor:send("Crafters across Ethilien will ask you to bring them gems and junked up armor so they can fix it up and present you with something new.")
    actor:send("Min Level: 21")
    if actor:get_quest_stage("phase_armor") >= 2 then
        local status = "In Progress"
    else
        local status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    actor:send("<b:green>&uGuild Armor Phase Three</>")
    actor:send("Crafters across Ethilien will ask you to bring them gems and junked up armor so they can fix it up and present you with something new.")
    actor:send("Min Level: 41")
    if actor:get_quest_stage("phase_armor") >= 3 then
        local status = "In Progress"
    else
        local status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    if string.find(sorcererclasses, "actor.class") then
        actor:send("<b:green>&uAcid Wand</>")
        actor:send("Masters of earth will help you create and upgrade a new mystic weapon.")
        if actor:get_has_completed("acid_wand") then
            local status = "Completed!"
        elseif actor:get_quest_stage("acid_wand") then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        actor:send("<b:green>&uAir Wand</>")
        actor:send("Masters of air will help you create and upgrade a new mystic weapon.")
        if actor:get_has_completed("air_wand") then
            local status = "Completed!"
        elseif actor:get_quest_stage("air_wand") then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        actor:send("<b:green>&uFire Wand</>")
        actor:send("Masters of fire will help you create and upgrade a new mystic weapon.")
        if actor:get_has_completed("fire_wand") then
            local status = "Completed!"
        elseif actor:get_quest_stage("fire_wand") then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        actor:send("<b:green>&uIce Wand</>")
        actor:send("Masters of ice and water will help you create and upgrade a new mystic weapon.")
        if actor:get_has_completed("ice_wand") then
            local status = "Completed!"
        elseif actor:get_quest_stage("ice_wand") then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if string.find(actor.class, "Assassin") then
        actor:send("<b:green>&uDeadly Promotion</>")
        actor:send("Assassins who have proven to be efficient bounty hunters can work their way up in the Guild to earn special masks.")
        if actor:get_has_completed("assassin_mask") then
            local status = "Completed!"
        elseif actor:get_quest_stage("assassin_mask") then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if string.find(actor.class, "Priest") or string.find(actor.class, "Cleric") then
        actor:send("Clerics and priests can make pilgrimages to various spiritual masters to craft weapons to smite the undead.")
        actor:send("<b:green>&uSpirit Maces</>")
        if actor:get_has_completed("phase_mace") then
            local status = "Completed!"
        elseif actor:get_quest_stage("phase_mace") then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if string.find(actor.class, "Paladin") or actor.class == "anti" then
        actor:send("<b:green>&uDivine Devotion</>")
        actor:send("Prove your devotion to your cause after slaying a dragon, be it justtice or destruction, and receive a divine reward.")
        if actor:get_has_completed("paladin_pendant") then
            local status = "Completed!"
        elseif actor:get_quest_stage("paladin_pendant") then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if string.find(hunterclasses, "actor.class") then
        actor:send("<b:green>&uEye of the Tiger</>")
        actor:send("Mighty warriors who have bested the biggest beasts can further prove their skills to earn special trophies.")
        if actor:get_has_completed("ranger_trophy") then
            local status = "Completed!"
        elseif actor:get_quest_stage("ranger_trophy") then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if string.find(actor.class, "thief") or string.find(actor.class, "rogue") or string.find(actor.class, "bard") then
        actor:send("<b:green>&uCloak and Shadow</>")
        actor:send("Work your way up the ranks of the cloak and dagger guilds.")
        if actor:get_has_completed("ranger_trophy") then
            local status = "Completed!"
        elseif actor:get_quest_stage("ranger_trophy") then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if actor.level >= 25 then
        actor:send("<b:green>&uIn Service of Lolth</>")
        actor:send("Carry out the bidding of the hideous Spider Queen and her malevolent servants.")
        actor:send("This quest is only available to neutral and evil-aligned characters.")
        actor:send("Recommended Level: 90")
        actor:send("- This quest starts at level 25 and continues through level 90.")
        if actor:get_has_completed("vilekka_stew") then
            local status = "Completed!"
        elseif actor:get_quest_stage("vilekka_stew") then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        actor:send("<b:green>&uInfiltrate the Sacred Haven</>")
        actor:send("A shadowy figure lurks outside a holy fortress, intent on getting back what belongs to them.")
        actor:send("This quest is only available to neutral and evil-aligned characters.")
        actor:send("Recommended Level: 35")
        if actor:get_quest_stage("sacred_haven") then
            local status = "Repeatable"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if actor.level >= 35 then
        actor:send("<b:green>&uMystery of the Rhell Forest</>")
        actor:send("Find the sick merchant in the Rhell Forest and help end his distress.")
        actor:send("Recommended Level: 45")
        if actor:get_has_completed("ursa_quest") then
            local status = "Completed!"
        elseif actor:get_quest_stage("ursa_quest") then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if actor.level >= 45 then
        if string.find(actor.race, "Troll") then
            actor:send("<b:green>&uTribal Trouble</>")
            actor:send("Trolls need to stick together!")
            actor:send("Return lost symbols of station and be greatly rewarded.")
            actor:send("Minimum Level: 55")
            if actor:get_has_completed("troll_quest") then
                local status = "Completed!"
            elseif actor:get_quest_stage("troll_mask") then
                local status = "In Progress"
            else
                local status = "Not Started"
            end
            actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        end
    end
    if actor.level >= 50 then
        actor:send("<b:green>&uThe Great Rite</>")
        actor:send("A group of witches has uncovered a powerful set of massive standing stones.")
        actor:send("Help them with their mystic ritual.")
        actor:send("Recommended Level: 70")
        actor:send("- This quest can be started at any level but requires level 70 to finish.")
        if actor:get_has_completed("megalith_quest") then
            local status = "Completed!"
        elseif actor:get_has_failed("megalith_quest") then
            local status = "Failed"
        elseif actor:get_quest_stage("megalith_quest") then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        actor:send("<b:green>&uPhoenix Sous Chef</>")
        actor:send("Create the meal of a lifetime!")
        actor:send("Recommended Level: 90")
        actor:send("- This quest can be started at any level but level 90+ is the intended finishing point.")
        if actor:get_has_completed("resort_cooking") then
            local status = "Completed!"
        elseif actor:get_quest_stage("resort_cooking") then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if actor.level >= 75 then
        actor:send("<b:green>&uPower of Flame</>")
        actor:send("Reunite the flame to hold its power in your hand.")
        actor:send("Recommended Level: 85")
        actor:send("- This quest can be started at any level but requires level 85 to finish.")
        actor:send("- This quest is repeatable.")
        if actor:get_has_completed("emmath_flameball") then
            local status = "Completed!"
        elseif actor:get_quest_stage("emmath_flameball") then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if actor.level >= 80 then
        actor:send("<b:green>&uSunfire Rescue</>")
        actor:send("Recover ancient relics and rescue a long-lost prisoner.")
        actor:send("This quest is only available to good-aligned characters.")
        actor:send("Recommended Level: 85")
        actor:send("- This quest can be started at any level but requires level 85 to finish.")
        if actor:get_has_completed("sunfire_rescue") then
            local status = "Completed!"
        elseif actor:get_quest_stage("sunfire_rescue") then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
end
return _return_value