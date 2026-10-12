-- Trigger class checks: string.find against lowercase class plain names
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
  -- data/triggers/004/004_02_equipment_quests.lua
  (4, 2, $trig$-- Converted from DG Script #402: Equipment quests
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "equipment") then
    _return_value = true
    local anti = "Anti-Paladin"
    local hunterclasses = "Warrior Ranger Berserker Mercenary"
    local sorcererclasses = "Sorcerer Illusionist Cryomancer Pyromancer Necromancer"
    actor:send("<yellow>=========== EQUIPMENT QUESTS ========<==/>")
    actor:send("These quests often take a large amount of time to complete, spanning dozens of levels.")
    actor:send("Characters should expect to need large numbers of unique and hard-to-find items.")
    actor:send("They are generally not intended to be completed quickly.")
    actor:send("<b:yellow>[Look]</> at the key words in a quest title for your current status.")
    actor:send("<yellow>=====================================<==/>_")
    actor:send("<b:green>AVAILABLE QUESTS:</>_")
    actor:send("<b:green>&uGuild Armor Phase One</>")
    actor:send("Crafters across Ethilien will ask you to bring them gems and junked up armor so they can fix it up and present you with something new.")
    actor:send("Your home guild master is always the best place to start.")
    actor:send("Min Level: 1")
    local status
    if actor:get_quest_stage("phase_armor") then
        status = "In Progress"
    else
        status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    actor:send("<b:green>&uGuild Armor Phase Two</>")
    actor:send("Crafters across Ethilien will ask you to bring them gems and junked up armor so they can fix it up and present you with something new.")
    actor:send("Min Level: 21")
    local status
    if actor:get_quest_stage("phase_armor") >= 2 then
        status = "In Progress"
    else
        status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    actor:send("<b:green>&uGuild Armor Phase Three</>")
    actor:send("Crafters across Ethilien will ask you to bring them gems and junked up armor so they can fix it up and present you with something new.")
    actor:send("Min Level: 41")
    local status
    if actor:get_quest_stage("phase_armor") >= 3 then
        status = "In Progress"
    else
        status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
        actor:send("<b:green>&uAcid Wand</>")
        actor:send("Masters of earth will help you create and upgrade a new mystic weapon.")
        local status
        if actor:get_has_completed("acid_wand") then
            status = "Completed!"
        elseif actor:get_quest_stage("acid_wand") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        actor:send("<b:green>&uAir Wand</>")
        actor:send("Masters of air will help you create and upgrade a new mystic weapon.")
        local status
        if actor:get_has_completed("air_wand") then
            status = "Completed!"
        elseif actor:get_quest_stage("air_wand") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        actor:send("<b:green>&uFire Wand</>")
        actor:send("Masters of fire will help you create and upgrade a new mystic weapon.")
        local status
        if actor:get_has_completed("fire_wand") then
            status = "Completed!"
        elseif actor:get_quest_stage("fire_wand") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        actor:send("<b:green>&uIce Wand</>")
        actor:send("Masters of ice and water will help you create and upgrade a new mystic weapon.")
        local status
        if actor:get_has_completed("ice_wand") then
            status = "Completed!"
        elseif actor:get_quest_stage("ice_wand") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if string.find(actor.class, "assassin") then
        actor:send("<b:green>&uDeadly Promotion</>")
        actor:send("Assassins who have proven to be efficient bounty hunters can work their way up in the Guild to earn special masks.")
        local status
        if actor:get_has_completed("assassin_mask") then
            status = "Completed!"
        elseif actor:get_quest_stage("assassin_mask") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if string.find(actor.class, "priest") or string.find(actor.class, "cleric") then
        actor:send("Clerics and priests can make pilgrimages to various spiritual masters to craft weapons to smite the undead.")
        actor:send("<b:green>&uSpirit Maces</>")
        local status
        if actor:get_has_completed("phase_mace") then
            status = "Completed!"
        elseif actor:get_quest_stage("phase_mace") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if string.find(actor.class, "paladin") or actor.class == "anti-paladin" then
        actor:send("<b:green>&uDivine Devotion</>")
        actor:send("Prove your devotion to your cause after slaying a dragon, be it justtice or destruction, and receive a divine reward.")
        local status
        if actor:get_has_completed("paladin_pendant") then
            status = "Completed!"
        elseif actor:get_quest_stage("paladin_pendant") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if string.find(string.lower(hunterclasses), actor.class, 1, true) then
        actor:send("<b:green>&uEye of the Tiger</>")
        actor:send("Mighty warriors who have bested the biggest beasts can further prove their skills to earn special trophies.")
        local status
        if actor:get_has_completed("ranger_trophy") then
            status = "Completed!"
        elseif actor:get_quest_stage("ranger_trophy") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if string.find(actor.class, "thief") or string.find(actor.class, "rogue") or string.find(actor.class, "bard") then
        actor:send("<b:green>&uCloak and Shadow</>")
        actor:send("Work your way up the ranks of the cloak and dagger guilds.")
        local status
        if actor:get_has_completed("ranger_trophy") then
            status = "Completed!"
        elseif actor:get_quest_stage("ranger_trophy") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if actor.level >= 25 then
        actor:send("<b:green>&uIn Service of Lolth</>")
        actor:send("Carry out the bidding of the hideous Spider Queen and her malevolent servants.")
        actor:send("This quest is only available to neutral and evil-aligned characters.")
        actor:send("Recommended Level: 90")
        actor:send("- This quest starts at level 25 and continues through level 90.")
        local status
        if actor:get_has_completed("vilekka_stew") then
            status = "Completed!"
        elseif actor:get_quest_stage("vilekka_stew") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        actor:send("<b:green>&uInfiltrate the Sacred Haven</>")
        actor:send("A shadowy figure lurks outside a holy fortress, intent on getting back what belongs to them.")
        actor:send("This quest is only available to neutral and evil-aligned characters.")
        actor:send("Recommended Level: 35")
        local status
        if actor:get_quest_stage("sacred_haven") then
            status = "Repeatable"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if actor.level >= 35 then
        actor:send("<b:green>&uMystery of the Rhell Forest</>")
        actor:send("Find the sick merchant in the Rhell Forest and help end his distress.")
        actor:send("Recommended Level: 45")
        local status
        if actor:get_has_completed("ursa_quest") then
            status = "Completed!"
        elseif actor:get_quest_stage("ursa_quest") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if actor.level >= 45 then
        if string.find(actor.race, "Troll") then
            actor:send("<b:green>&uTribal Trouble</>")
            actor:send("Trolls need to stick together!")
            actor:send("Return lost symbols of station and be greatly rewarded.")
            actor:send("Minimum Level: 55")
            local status
            if actor:get_has_completed("troll_quest") then
                status = "Completed!"
            elseif actor:get_quest_stage("troll_mask") then
                status = "In Progress"
            else
                status = "Not Started"
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
        local status
        if actor:get_has_completed("megalith_quest") then
            status = "Completed!"
        elseif actor:get_has_failed("megalith_quest") then
            status = "Failed"
        elseif actor:get_quest_stage("megalith_quest") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        actor:send("<b:green>&uPhoenix Sous Chef</>")
        actor:send("Create the meal of a lifetime!")
        actor:send("Recommended Level: 90")
        actor:send("- This quest can be started at any level but level 90+ is the intended finishing point.")
        local status
        if actor:get_has_completed("resort_cooking") then
            status = "Completed!"
        elseif actor:get_quest_stage("resort_cooking") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if actor.level >= 75 then
        actor:send("<b:green>&uPower of Flame</>")
        actor:send("Reunite the flame to hold its power in your hand.")
        actor:send("Recommended Level: 85")
        actor:send("- This quest can be started at any level but requires level 85 to finish.")
        actor:send("- This quest is repeatable.")
        local status
        if actor:get_has_completed("emmath_flameball") then
            status = "Completed!"
        elseif actor:get_quest_stage("emmath_flameball") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if actor.level >= 80 then
        actor:send("<b:green>&uSunfire Rescue</>")
        actor:send("Recover ancient relics and rescue a long-lost prisoner.")
        actor:send("This quest is only available to good-aligned characters.")
        actor:send("Recommended Level: 85")
        actor:send("- This quest can be started at any level but requires level 85 to finish.")
        local status
        if actor:get_has_completed("sunfire_rescue") then
            status = "Completed!"
        elseif actor:get_quest_stage("sunfire_rescue") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
end
return _return_value$trig$, '2f9bd6d2bf2c38b9cf7d6a119d3f967f'),
  -- data/triggers/004/004_04_spell_quests.lua
  (4, 4, $trig$-- Converted from DG Script #404: Spell quests
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "spell") or string.find(arg, "spells") or string.find(arg, "chant") or string.find(arg, "chants") or string.find(arg, "song") or string.find(arg, "songs") or string.find(arg, "music") then
    _return_value = true
    local relocateclasses = "Sorcerer Cryomancer Pyromancer"
    local spellquestclasses = "Ranger Druid Sorcerer Illusionist Cryomancer Pyromancer Diabolist Cleric Priest Bard Necromancer Monk"
    actor:send("<yellow>==== SPELL, CHANT, AND SONG QUESTS ==<==/>")
    if string.find(string.lower(spellquestclasses), actor.class, 1, true) then
        actor:send("<b:yellow>[Look]</> at the key words in a quest title for your current status.")
        actor:send("<yellow>=====================================<==/>_")
        actor:send("<b:green>AVAILABLE QUESTS:</>_")
        if actor.level >= 30 then
            if string.find(actor.class, "monk") then
                actor:send("<b:green>&uTremors of Saint Augustine</>")
                actor:send("Minimum Level: 30")
                local status
                if actor:get_quest_stage("monk_chants") > 1 then
                    status = "Completed!"
                elseif actor:get_quest_stage("monk_chants") == 1 then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
                actor:send("<b:green>&uTempest of Saint Augustine</>")
                actor:send("Minimum Level: 40")
                local status
                if actor:get_quest_stage("monk_chants") > 2 then
                    status = "Completed!"
                elseif actor:get_quest_stage("monk_chants") == 2 then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
                actor:send("<b:green>&uBlizzards of Saint Augustine</>")
                actor:send("Minimum Level: 50")
                local status
                if actor:get_quest_stage("monk_chants") > 3 then
                    status = "Completed!"
                elseif actor:get_quest_stage("monk_chants") == 3 then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(string.lower(relocateclasses), actor.class, 1, true) then
                actor:send("<b:green>&uMajor Globe</>")
                actor:send("Minimum Level: 57")
                local status
                if actor:get_has_completed("major_globe_spell") then
                    status = "Completed!"
                elseif actor:get_quest_stage("major_globe_spell") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "priest") or string.find(actor.class, "cleric") or string.find(actor.class, "diabolist") then
                actor:send("<b:green>&uGroup Heal</>")
                actor:send("Minimum Level: 57")
                local status
                if actor:get_has_completed("group_heal") then
                    status = "Completed!"
                elseif actor:get_quest_stage("group_heal") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "priest") then
                actor:send("<b:green>&uGroup Armor</>")
                actor:send("Minimum Level: 57")
                local status
                if actor:get_has_completed("group_armor") then
                    status = "Completed!"
                elseif actor:get_quest_stage("group_armor") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "cryomancer") then
                actor:send("<b:green>&uWall of Ice</>")
                actor:send("Minimum Level: 57")
                local status
                if actor:get_has_completed("wall_ice") then
                    status = "Completed!"
                elseif actor:get_quest_stage("wall_ice") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "illusionist") or string.find(actor.class, "bard") then
                actor:send("<b:green>&uIllusory Wall</>")
                actor:send("Minimum Level: 57")
                local status
                if actor:get_has_completed("illusory_wall") then
                    status = "Completed!"
                elseif actor:get_quest_stage("illusory_wall") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "diabolist") then
                actor:send("<b:green>&uHellfire and Brimstone&")
                actor:send("Minimum Level: 57")
                local status
                if actor:get_has_completed("hellfire_brimstone") then
                    status = "Completed!"
                elseif actor:get_quest_stage("hellfire_brimstone") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "monk") then
                actor:send("<b:green>&uAria of Dissonance</>")
                actor:send("Minimum Level: 60")
                local status
                if actor:get_quest_stage("monk_chants") > 4 then
                    status = "Completed!"
                elseif actor:get_quest_stage("monk_chants") == 4 then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
        end
        if actor.level >= 60 then
            if string.find(string.lower(relocateclasses), actor.class, 1, true) then
                actor:send("<b:green>&uRelocate</>")
                actor:send("Minimum Level: 65")
                local status
                if actor:get_has_completed("relocate_spell_quest") then
                    status = "Completed!"
                elseif actor:get_quest_stage("relocate_spell_quest") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "priest") or string.find(actor.class, "diabolist") then
                actor:send("<b:green>&uBanish</>")
                actor:send("Minimum Level: 65")
                local status
                if actor:get_has_completed("banish") then
                    status = "Completed!"
                elseif actor:get_quest_stage("banish") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
        end
        if actor.level >= 65 then
            if string.find(actor.class, "bard") then
                actor:send("<b:green>&uHearthsong</>")
                actor:send("Minimum Level: 70")
                actor:send("Note: This chant must be granted directly by the gods and cannot be tracked in the quest journal._")
            end
            if string.find(actor.class, "cleric") then
                actor:send("<b:green>&uGroup Armor</>")
                actor:send("Minimum Level: 73")
                local status
                if actor:get_has_completed("group_armor") then
                    status = "Completed!"
                elseif actor:get_quest_stage("group_armor") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
                actor:send("<b:green>&uGroup Recall</>")
                actor:send("Minimum Level: 73")
                actor:send("Note: This chant must be granted directly by the gods and cannot be tracked in the quest journal._")
            end
            if string.find(actor.class, "druid") then
                actor:send("<b:green>&uMoonwell</>")
                actor:send("Minimum Level: 73")
                local status
                if actor:get_has_completed("moonwell_spell_quest") then
                    status = "Completed!"
                elseif actor:get_quest_stage("moonwell_spell_quest") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "sorcerer") then
                actor:send("<b:green>&uMeteorswarm</>")
                actor:send("Minimum Level: 73")
                local status
                if actor:get_has_completed("meteorswarm") then
                    status = "Completed!"
                elseif actor:get_quest_stage("meteorswarm") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "bard") then
                actor:send("<b:green>&uMajor Paralysis</>")
                actor:send("Minimum Level: 73")
                actor:send("Note: This chant must be granted directly by the gods and cannot be tracked in the quest journal._")
            end
            if string.find(actor.class, "diabolist") or string.find(actor.class, "priest") then
                actor:send("<b:green>&uWord of Command</>")
                local status
                if actor:get_has_completed("word_command") then
                    status = "Completed!"
                elseif actor:get_quest_stage("word_command") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "cryomancer") then
                actor:send("<b:green>&uWaterform</>")
                actor:send("Minimum Level: 73")
                local status
                if actor:get_has_completed("waterform") then
                    status = "Completed!"
                elseif actor:get_quest_stage("waterform") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "monk") then
                actor:send("<b:green>&uApocalyptic Anthem</>")
                actor:send("Minimum Level: 75")
                local status
                if actor:get_quest_stage("monk_chants") > 5 then
                    status = "Completed!"
                elseif actor:get_quest_stage("monk_chants") == 5 then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
        end
        if actor.level >= 75 then
            if string.find(actor.class, "bard") then
                actor:send("<b:green>&uCrown of Madness</>")
                actor:send("Minimum Level: 80")
                actor:send("Note: This chant must be granted directly by the gods and cannot be tracked in the quest journal._")
            end
            if string.find(actor.class, "monk") then
                actor:send("<b:green>&uFires of Saint Augustine</>")
                actor:send("Minimum Level: 80")
                local status
                if actor:get_quest_stage("monk_chants") > 6 then
                    status = "Completed!"
                elseif actor:get_quest_stage("monk_chants") == 6 then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "ranger") then
                actor:send("<b:green>&uBlur</>")
                actor:send("Minimum Level: 81")
                local status
                if actor:get_has_completed("blur") then
                    status = "Completed!"
                elseif actor:get_has_failed("blur") then
                    status = "Failed"
                elseif actor:get_quest_stage("blur") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "druid") then
                actor:send("<b:green>&uCreeping Doom</>")
                actor:send("Minimum Level: 81")
                local status
                if actor:get_has_completed("creeping_doom") then
                    status = "Completed!"
                elseif actor:get_quest_stage("creeping_doom") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "necromancer") then
                actor:send("<b:green>&uDegeneration</>")
                actor:send("Minimum Level: 81")
                local status
                if actor:get_has_completed("degeneration") then
                    status = "Completed!"
                elseif actor:get_quest_stage("degeneration") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "cryomancer") then
                actor:send("<b:green>&uFlood</>")
                actor:send("Minimum Level: 81")
                local status
                if actor:get_has_completed("flood") then
                    status = "Completed!"
                elseif actor:get_quest_stage("flood") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "priest") then
                actor:send("<b:green>&uHeavens Gate</>")
                actor:send("Minimum Level: 81")
                local status
                if actor:get_has_completed("heavens_gate") then
                    status = "Completed!"
                elseif actor:get_quest_stage("heavens_gate") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "diabolist") then
                actor:send("<b:green>&uHell Gate</>")
                actor:send("Minimum Level: 81")
                local status
                if actor:get_has_completed("hell_gate") then
                    status = "Completed!"
                elseif actor:get_quest_stage("hell_gate") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "pyromancer") then
                actor:send("<b:green>&uMeteorswarm</>")
                actor:send("Minimum Level: 81")
                local status
                if actor:get_has_completed("meteorswarm") then
                    status = "Completed!"
                elseif actor:get_quest_stage("meteorswarm") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "cleric") or string.find(actor.class, "priest") or string.find(actor.class, "diabolist") then
                actor:send("<b:green>&uResurrection</>")
                actor:send("Minimum Level: 81")
                local status
                if actor:get_has_completed("resurrection_quest") then
                    status = "Completed!"
                elseif actor:get_quest_stage("resurrection_quest") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "sorcerer") then
                actor:send("<b:green>&uWizard Eye</>")
                actor:send("Minimum Level: 81")
                local status
                if actor:get_has_completed("wizard_eye") then
                    status = "Completed!"
                elseif actor:get_quest_stage("wizard_eye") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
        end
        if actor.level >= 85 then
            if string.find(actor.class, "sorcerer") or string.find(actor.class, "bard") or string.find(actor.class, "illusionist") then
                actor:send("<b:green>&uCharm Person</>")
                actor:send("Minimum Level: 89")
                local status
                if actor:get_has_completed("charm_person") then
                    status = "Completed!"
                elseif actor:get_quest_stage("charm_person") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "cleric") or string.find(actor.class, "priest") then
                actor:send("<b:green>&uDragons Health</>")
                actor:send("Minimum Level: 89")
                local status
                if actor:get_has_completed("dragons_health") then
                    status = "Completed!"
                elseif actor:get_quest_stage("dragons_health") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "ranger") then
                actor:send("<b:green>&uGreater Displacement</>")
                actor:send("Minimum Level: 89")
                actor:send("Note: This chant must be granted directly by the gods and cannot be tracked in the quest journal._")
            end
            if string.find(actor.class, "cryomancer") then
                actor:send("<b:green>&uIce Shards</>")
                actor:send("Minimum Level: 89")
                local status
                if actor:get_has_completed("ice_shards") then
                    status = "Completed!"
                elseif actor:get_quest_stage("ice_shards") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "pyromancer") then
                actor:send("<b:green>&uSupernova</>")
                actor:send("Minimum Level: 89")
                local status
                if actor:get_has_completed("supernova") then
                    status = "Completed!"
                elseif actor:get_quest_stage("supernova") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "bard") then
                actor:send("<b:green>&uEnrapture</>")
                actor:send("Minimum Level: 90")
                actor:send("Note: This chant must be granted directly by the gods and cannot be tracked in the quest journal._")
            end
        end
        if actor.level >= 90 then
            if string.find(actor.class, "necromancer") then
                actor:send("<b:green>&uShift Corpse</>")
                actor:send("Minimum Level: 97")
                local status
                if actor:get_has_completed("shift_corpse") then
                    status = "Completed!"
                elseif actor:get_quest_stage("shift_corpse") then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "monk") then
                actor:send("<b:green>&uSeed of Destruction</>")
                actor:send("Minimum Level: 99")
                local status
                if actor:get_quest_stage("monk_chants") > 7 then
                    status = "Completed!"
                elseif actor:get_quest_stage("monk_chants") == 7 then
                    status = "In Progress"
                else
                    status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
        end
    else
        actor:send("There are no spell, song, or chant quests available for " .. tostring(actor.class) .. " characters._")
        actor:send("<yellow>=====================================<==/>")
    end
end
return _return_value$trig$, 'fba96b8ae9aceb001a2fcedc6f15e962'),
  -- data/triggers/004/004_05_subclass_quests.lua
  (4, 5, $trig$-- Converted from DG Script #405: Subclass quests
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "subclass") then
    _return_value = true
    -- add RESTRICTED races to these defines here!!
    local necromancerraces = "faerie_seelie elf"
    local cryoraces = "arborean dragonborn_fire"
    local pyroraces = "arborean dragonborn_frost"
    local illusionraces = "none"
    local priestraces = "drow faerie_unseelie"
    local diabolistraces = "faerie_seelie elf"
    local druidraces = "none"
    local paladinraces = "drow faerie_unseelie"
    local antipaladinraces = "faerie_seelie elf"
    local rangerraces = "none"
    local berserkerraces = "none"
    local monkraces = "none"
    local assassinraces = "none"
    local mercenaryraces = "none"
    local thiefraces = "none"
    local bardraces = "none"
    actor:send("<yellow>=========== SUBCLASS QUESTS =========<==/>")
    if (string.find(actor.class, "cleric") and actor.level < 35) or (string.find(actor.class, "sorcerer") and actor.level < 45) or ((string.find(actor.class, "warrior") or string.find(actor.class, "rogue")) and actor.level < 25) then
        actor:send("Subclass quests involve finding a specific quest master and performing some kind of special deed.")
        actor:send("Eligibility for subclasses depends on your base class, your race, and your alignment.")
        actor:send("Characters must be at least level 10 to subclass._")
        actor:send("A character may only ever undertake a single subclass quest.")
        actor:send("Once a subclass quest has begun, it is not possible to start a different one.")
        actor:send("<yellow>=====================================<==/>_")
        actor:send("<b:green>AVAILABLE QUESTS:</>")
        local status
        if actor:get_quest_var("nec_dia_ant_subclass:subclass_name") == "Nec" then
            actor:send("- &9<blue>Necromancer</>")
            status = "running"
        elseif actor:get_quest_var("nec_dia_ant_subclass:subclass_name") == "Diabolist" then
            actor:send("- <magenta>Diabolist</>")
            status = "running"
        elseif actor:get_quest_var("nec_dia_ant_subclass:subclass_name") == "anti" then
            actor:send("- <b:red>Anti-Paladin</>")
            status = "running"
        elseif actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "Mercernary" then
            actor:send("- &9<blue>Mercenary</>")
            status = "running"
        elseif actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "Assassin" then
            actor:send("- <red>Assassin</>")
            status = "running"
        elseif actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "Thief" then
            actor:send("- <b:red>Thief</>")
            status = "running"
        elseif actor:get_quest_var("pri_pal_subclass:subclass_name") == "Priest" then
            actor:send("- <b:cyan>Priest</>")
            status = "running"
        elseif actor:get_quest_var("pri_pal_subclass:subclass_name") == "Paladin" then
            actor:send("- <b:white>Paladin</>")
            status = "running"
        elseif actor:get_quest_var("ran_dru_subclass:subclass_name") == "Ranger" then
            actor:send("- <b:green>Ranger</>")
            status = "running"
        elseif actor:get_quest_var("ran_dru_subclass:subclass_name") == "Druid" then
            actor:send("- <green>Druid</>")
            status = "running"
        elseif actor:get_quest_stage("monk_subclass") then
            actor:send("- <yellow>Monk</>")
            status = "running"
        elseif actor:get_quest_stage("pyromancer_subclass") then
            actor:send("- <b:red>Pyromancer</>")
            status = "running"
        elseif actor:get_quest_stage("cryomancer_subclass") then
            actor:send("- <b:blue>Cryomancer</>")
            status = "running"
        elseif actor:get_quest_stage("illusionist_subclass") then
            actor:send("- <b:magenta>Illusionist</>")
            status = "running"
        elseif actor:get_quest_stage("bard_subclass") then
            actor:send("- <b:magenta>Bard</>")
            status = "running"
        elseif actor:get_quest_stage("berserker_subclass") then
            actor:send("- &9<blue>Berserker</>")
            status = "running"
        else
            if string.find(actor.class, "sorcerer") then
                if not (string.find(cryoraces, actor.race)) then
                    actor:send("- <b:blue>Cryomancer</>_")
                end
                if not (string.find(illusionraces, actor.race)) then
                    actor:send("- <b:magenta>Illusionist</>_")
                end
                if not (string.find(necromancerraces, actor.race)) then
                    actor:send("- &9<blue>Necromancer</>")
                    actor:send("</>   <cyan>(This class is for evil characters only)</>_")
                end
                if not (string.find(pyroraces, actor.race)) then
                    actor:send("- <b:red>Pyromancer</>_")
                end
            elseif string.find(actor.class, "cleric") then
                if not (string.find(diabolistraces, actor.race)) then
                    actor:send("- <magenta>Diabolist</>")
                    actor:send("</>   <cyan>(This class is for evil characters only)</>_")
                end
                if not (string.find(druidraces, actor.race)) then
                    actor:send("- <green>Druid</>")
                    actor:send("</>   <cyan>(This class is for neutral characters only)</>_")
                end
                if not (string.find(priestraces, actor.race)) then
                    actor:send("- <b:cyan>Priest</>")
                    actor:send("</>   <cyan>(This class is for good characters only)</>_")
                end
            elseif string.find(actor.class, "rogue") then
                if not (string.find(assassinraces, actor.race)) then
                    actor:send("- <red>Assassin</>")
                    actor:send("</>   <cyan>(This class is for evil characters only)</>_")
                end
                if not (string.find(bardraces, actor.race)) then
                    actor:send("- <b:magenta>Bard</>_")
                end
                if not (string.find(mercenaryraces, actor.race)) then
                    actor:send("- &9<blue>Mercenary</>_")
                end
                if not (string.find(thiefraces, actor.race)) then
                    actor:send("- <b:red>Thief</>_")
                end
            elseif string.find(actor.class, "warrior") then
                if not (string.find(antipaladinraces, actor.race)) then
                    actor:send("- <b:red>Anti-Paladin</>")
                    actor:send("</>   <cyan>(This class is for evil characters only)</>_")
                end
                if not (string.find(berserkerraces, actor.race)) then
                    actor:send("- &9<blue>Berserker</>_")
                end
                if not (string.find(monkraces, actor.race)) then
                    actor:send("- <yellow>Monk</>_")
                end
                if not (string.find(paladinraces, actor.race)) then
                    actor:send("- <b:white>Paladin</>")
                    actor:send("</>   <cyan>(This class is for good characters only)</>_")
                end
                if not (string.find(rangerraces, actor.race)) then
                    actor:send("- <b:green>Ranger</>")
                    actor:send("</>   <cyan>(This class is for good characters only)</>_")
                end
            end
        end
        if status == "running" then
            actor:send("<cyan>Status: In Progress</>_")
        end
    else
        if string.find(actor.class, "warrior") or string.find(actor.class, "cleric") or string.find(actor.class, "sorcerer") or string.find(actor.class, "rogue") then
            actor:send("You have no subclass quests available.")
        else
            actor:send("You have already completed the quest to subclass to " .. tostring(actor.class) .. ".")
        end
    end
end
return _return_value$trig$, 'e63c0ccbe8d51d84890d72ebe1e1d6b3'),
  -- data/triggers/004/004_101_enlightenment_progress_journal.lua
  (4, 101, $trig$-- Converted from DG Script #501: Enlightenment progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "enlightenment") or string.find(arg, "monk vision") or string.find(arg, "monk_vision") then
    if string.find(actor.class, "monk") then
        _return_value = true
        local missionstage = actor:get_quest_stage("elemental_chaos")
        local visionstage = actor:get_quest_stage("monk_vision")
        local master = mobiles.template(53, 8).name
        local job1 = actor:get_quest_var("monk_vision:visiontask1")
        local job2 = actor:get_quest_var("monk_vision:visiontask2")
        local job3 = actor:get_quest_var("monk_vision:visiontask3")
        local job4 = actor:get_quest_var("monk_vision:visiontask4")
        actor:send("<b:green>&uEnlightenment</>")
        local level
        if not visionstage then
            level = 10
        else
            level = visionstage * 10
        end
        if not actor:get_has_completed("monk_vision") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        local status
        if actor:get_has_completed("monk_vision") then
            status = "Completed!"
        elseif visionstage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level then
            if visionstage == 0 then
                actor:send("You must undertake a <b:cyan>[mission]</> in service of Balance first.")
                return _return_value
            elseif (visionstage >= missionstage) and not actor:get_has_completed("elemental_chaos") then
                actor:send("You must walk further along the Way in service of Balance first.")
                return _return_value
            end
            -- switch on visionstage
            local book
            local gem
            local room
            local place
            local hint
            if visionstage == 1 then
                book = 59006
                gem = 55582
                room = get_room("4328")
                place = room.name
                hint = "in a place to perform."
            elseif visionstage == 2 then
                book = 18505
                gem = 55591
                room = get_room("58707")
                place = room.name
                hint = "near a sandy beach."
            elseif visionstage == 3 then
                book = 8501
                gem = 55623
                room = get_room("18597")
                place = room.name
                hint = "in a cloistered library."
            elseif visionstage == 4 then
                book = 12532
                gem = 55655
                room = get_room("58102")
                place = room.name
                hint = "on Hakujo's home island."
            elseif visionstage == 5 then
                book = 16209
                gem = 55665
                room = get_room("16057")
                place = room.name
                hint = "in the ghostly fortress."
            elseif visionstage == 6 then
                book = 43013
                gem = 55678
                room = get_room("59054")
                place = room.name
                hint = "in the fortress of the zealous."
            elseif visionstage == 7 then
                book = 53009
                gem = 55710
                room = get_room("49079")
                place = room.name
                hint = "off-shore of the island of great beasts."
            elseif visionstage == 8 then
                book = 58415
                gem = 55722
                room = get_room("11820")
                place = room.name
                hint = "beyond the Blue-Fog Trail."
            elseif visionstage == 9 then
                book = 58412
                gem = 55741
                room = get_room("52075")
                place = room.name
                hint = "in the shattered citadel of Templace."
            end
            local attack = visionstage * 100
            if job1 or job2 or job3 or job4 then
                actor:send("You've done the following:")
                if job1 then
                    actor:send("- attacked " .. tostring(attack) .. " times")
                end
                if job2 then
                    actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
                end
                if job3 then
                    actor:send("- found " .. "%get.obj_shortdesc[%book%]%")
                end
                if job4 then
                    actor:send("- read in " .. tostring(place))
                end
            end
            actor:send("</>")
            actor:send("You need to:")
            if job1 and job2 and job3 and job4 then
                actor:send("Give " .. tostring(master) .. " your current vision mark.")
                return _return_value
            end
            if not job1 then
                local remaining = attack - actor:get_quest_var("monk_vision:attack_counter")
                actor:send("- attack &9<blue>" .. tostring(remaining) .. "</> more times while wearing your vision mark.")
            end
            if not job4 then
                actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</> and <b:yellow>%get.obj_shortdesc[%book%]%</> and <b:yellow>read</> in a place called \"<b:yellow>%place%</>\".")
                actor:send("</>   It's <b:green>" .. tostring(hint) .. "</>")
            else
                if not job2 then
                    actor:send("- bring " .. tostring(master) .. " <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</>")
                end
                if not job3 then
                    actor:send("- bring " .. tostring(master) .. " <b:yellow>" .. "%get.obj_shortdesc[%book%]%</>")
                end
            end
        end
    end
end
return _return_value$trig$, 'b974c4f2f1adbce75446041d4686fcaa'),
  -- data/triggers/004/004_102_unused.lua
  (4, 102, $trig$-- Converted from DG Script #502: **UNUSED**
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "tremors") or string.find(arg, "tremors of saint augustine") or string.find(arg, "tremors_of_saint_augustine") then
    if string.find(actor.class, "monk") then
        _return_value = true
        local chantstage = actor:get_quest_stage("monk_chants")
        local visionstage = actor:get_quest_stage("monk_vision")
        local master = mobiles.template(53, 8).name
        local level = 30
        actor:send("<b:green>&uTremors of Saint Augustine</>")
        actor:send("Minimum Level: " .. tostring(level))
        local status
        if chantstage > 1 then
            status = "Completed!"
        elseif chantstage == 1 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level and chantstage == 1 then
            if chantstage >= (visionstage - 1) then
                actor:send("You must walk further along the Way in service of Balance first.")
                return _return_value
            end
            actor:send("You are looking for a book surrounded by trees and shadows.")
            actor:send("Take it and <b:cyan>[meditate]" .. "%</> in a place that is both natural and urban, serenely peaceful and profoundly sorrowful.")
        elseif actor.level >= level and not chantstage then
            actor:send("Ask " .. tostring(master) .. " about <b:cyan>[chants]" .. "%0 to get started.")
        end
    end
end
return _return_value$trig$, '14a421554538796e11409643965dbba3'),
  -- data/triggers/004/004_103_tempest_of_saint_augustine_progress_journal.lua
  (4, 103, $trig$-- Converted from DG Script #503: Tempest of Saint Augustine progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "tempest") or string.find(arg, "tempest of saint augustine") or string.find(arg, "tempest_of_saint_augustine") then
    if string.find(actor.class, "monk") then
        _return_value = true
        local chantstage = actor:get_quest_stage("monk_chants")
        local visionstage = actor:get_quest_stage("monk_vision")
        local master = mobiles.template(53, 8).name
        local level = 40
        actor:send("<b:green>&uTempest of Saint Augustine</>")
        actor:send("Minimum Level: " .. tostring(level))
        local status
        if chantstage > 2 then
            status = "Completed!"
        elseif chantstage == 2 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level and chantstage == 2 then
            if chantstage >= (visionstage - 1) then
                actor:send("You must walk further along the Way in service of Balance first.")
                return _return_value
            end
            actor:send("You are looking for a scroll, dedicated to this particular chant, guarded by a creature of the same elemental affinity.")
            actor:send("Take it and <b:cyan>[meditate]" .. "%</> on the peak of Urchet Pass.")
        end
    end
end
return _return_value$trig$, 'd7703d5c9393187ebddceb86a8581d6f'),
  -- data/triggers/004/004_104_unused.lua
  (4, 104, $trig$-- Converted from DG Script #504: **UNUSED**
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "blizzards") or string.find(arg, "blizzards of saint augustine") or string.find(arg, "blizzards_of_saint_augustine") then
    if string.find(actor.class, "monk") then
        _return_value = true
        local chantstage = actor:get_quest_stage("monk_chants")
        local visionstage = actor:get_quest_stage("monk_vision")
        local master = mobiles.template(53, 8).name
        local level = 50
        actor:send("<b:green>&uBlizzards of Saint Augustine</>")
        actor:send("Minimum Level: " .. tostring(level))
        local status
        if chantstage > 3 then
            status = "Completed!"
        elseif chantstage == 3 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level and chantstage == 3 then
            if chantstage >= (visionstage - 1) then
                actor:send("You must walk further along the Way in service of Balance first.")
                return _return_value
            end
            actor:send("You are looking for a book held by a master who in turn is a servant of a beast of winter.")
            actor:send("Take it and <b:cyan>[meditate]" .. "%</> in a temple shrouded in mists.")
        end
    end
end
return _return_value$trig$, '704d6fa72fbff27588dd089e4b9f56ae'),
  -- data/triggers/004/004_105_saint_augustine_clarification.lua
  (4, 105, $trig$-- Converted from DG Script #505: Saint Augustine clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "saint" or arg == "augustine" or arg == "saint augustine" then
    if actor.level >= 30 and string.find(actor.class, "monk") then
        _return_value = true
        actor:send("Please specify:")
        if actor.level >= 30 then
            actor:send("Tremors of Saint Augustine")
        end
        if actor.level >= 40 then
            actor:send("Tempest of Saint Augustine")
        end
        if actor.level >= 50 then
            actor:send("Blizzards of Saint Augustine")
        end
        if actor.level >= 80 then
            actor:send("Fires of Saint Augustine")
        end
    end
end
return _return_value$trig$, '4f5ce79a68536d73fa8629888d9be3a2'),
  -- data/triggers/004/004_106_unused.lua
  (4, 106, $trig$-- Converted from DG Script #506: **UNUSED**
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "fires") or string.find(arg, "fires of saint augustine") or string.find(arg, "fires_of_saint_augustine") then
    if string.find(actor.class, "monk") then
        _return_value = true
        local chantstage = actor:get_quest_stage("monk_chants")
        local visionstage = actor:get_quest_stage("monk_vision")
        local master = mobiles.template(53, 8).name
        local level = 80
        actor:send("<b:green>&uFires of Saint Augustine</>")
        actor:send("Minimum Level: " .. tostring(level))
        local status
        if chantstage > 6 then
            status = "Completed!"
        elseif chantstage == 6 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level and chantstage == 6 then
            if chantstage >= (visionstage - 1) then
                actor:send("You must walk further along the Way in service of Balance first.")
                return _return_value
            end
            actor:send("You are looking for a scroll of curses, carried by children of air in a floating fortress.")
            actor:send("Take it and <b:cyan>[meditate]" .. "%</> at an altar dedicated to fire's destructive forces.")
        end
    end
end
return _return_value$trig$, '355c3d0918a611c3cf4fa3bfae67e49b'),
  -- data/triggers/004/004_11_guild_armor_phase_one_progress_journal.lua
  (4, 11, $trig$-- Converted from DG Script #411: Guild Armor Phase One progress journal
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
        if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
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
        elseif string.find(string.lower(clericclasses), actor.class, 1, true) then
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
        elseif string.find(string.lower(warriorclasses), actor.class, 1, true) then
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
        elseif string.find(string.lower(rogueclasses), actor.class, 1, true) then
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
return _return_value$trig$, 'c812c177c405d973eb9f9ab911e22fc8'),
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
        if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
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
            if string.find(actor.class, "sorcerer") then
                master = "the Archmage of Ickle"
            elseif string.find(actor.class, "cryomancer") then
                master = "the Archmage of Ickle, the High Cryomancer, and the master cryomancer"
            elseif string.find(actor.class, "pyromancer") then
                master = "the Archmage of Ickle, the High Pyromancer, and the master pyromancer"
            elseif string.find(actor.class, "illusionist") then
                master = "the Archmage of Ickle, Erasmus, and Esh"
            end
        elseif string.find(actor.class, "necromancer") then
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
        elseif string.find(string.lower(clericclasses), actor.class, 1, true) then
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
        elseif string.find(actor.class, "diabolist") then
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
        elseif string.find(actor.class, "druid") then
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
        elseif string.find(actor.class, "warrior") then
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
        elseif string.find(actor.class, "ranger") then
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
        elseif string.find(actor.class, "monk") then
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
        elseif string.find(actor.class, "berserker") then
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
        elseif string.find(string.lower(rogueclasses), actor.class, 1, true) then
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
        elseif string.find(actor.class, "bard") then
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
return _return_value$trig$, 'd02dbfd53af2347941013ddfd6e37e19'),
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
        if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
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
            if string.find(actor.class, "sorcerer") then
                master = "the Archmage of Anduin"
            elseif string.find(actor.class, "cryomancer") then
                master = "a cryomancer in Anduin"
            elseif string.find(actor.class, "pyromancer") then
                master = "a pyromancer in Anduin"
            elseif string.find(actor.class, "illusionist") then
                master = "Aylana in Anduin"
            end
        elseif string.find(actor.class, "necromancer") then
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
        elseif string.find(string.lower(clericclasses), actor.class, 1, true) then
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
        elseif string.find(actor.class, "diabolist") then
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
        elseif string.find(actor.class, "druid") then
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
        elseif string.find(actor.class, "warrior") then
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
        elseif string.find(actor.class, "ranger") then
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
        elseif string.find(actor.class, "monk") then
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
        elseif string.find(actor.class, "berserker") then
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
        elseif string.find(string.lower(rogueclasses), actor.class, 1, true) then
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
        elseif string.find(actor.class, "bard") then
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
return _return_value$trig$, '4bdca5d35a2ddf10d152c1a87a2f4b36'),
  -- data/triggers/004/004_14_relocate_progress_journal.lua
  (4, 14, $trig$-- Converted from DG Script #414: Relocate progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "relocate") or string.find(arg, "relocate_spell_quest") then
    local relocateclasses = "Sorcerer Cryomancer Pyromancer"
    if (string.find(string.lower(relocateclasses), actor.class, 1, true)) and actor.level >= 60 then
        _return_value = true
        local stage = actor:get_quest_stage("relocate_spell_quest")
        actor:send("<b:green>&uRelocate</>")
        actor:send("Minimum Level: 65")
        local status
        if actor:get_has_completed("relocate_spell_quest") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("relocate_spell_quest") then
            local master1 = mobiles.template(492, 50).name .. " in the Black Ice Desert"
            local master2 = mobiles.template(492, 51).name
            -- switch on stage
            local next, place, master
            if stage == 1 or stage == 2 then
                next = "the Staff of the Mystics"
                place = "a druid hiding out beyond Anlun Vale"
                master = master1
                if actor:get_quest_var("relocate_spell_quest:greet") == 0 then
                elseif stage == 3 or stage == 4 then
                    next = "the Crystal Telescope"
                    place = "an observer of the cold village"
                    master = master1
                else
                    next = "a glass globe"
                    place = "the Valley of the Frost Elves"
                    master = master2
                end
            elseif stage == 5 then
                next = "the Crystal Telescope"
                master = master1
            elseif stage == 6 then
                next = "a silver-trimmed spellbook"
                place = "a tower within a destroyed land"
                master = master1
            elseif stage == 7 then
                next = "a map"
                place = "from a mapper in South Caelia"
                master = master1
            elseif stage == 8 or stage == 9 then
                next = "the Golden Quill"
                place = "the forest near Baba Yaga's hut"
                master = master1
            end
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            if stage ~= 2 and stage ~= 4 and stage ~= 5 and stage ~= 9 then
                actor:send("You are trying to retrieve:")
                actor:send("<b:yellow>" .. tostring(next) .. "</> from <b:green>" .. tostring(place) .. ".</>")
            else
                actor:send("Return <b:yellow>" .. tostring(next) .. "</> to " .. tostring(master) .. ".")
            end
        end
    end
end
return _return_value$trig$, '1f69d5b3ac9a782fb2f52c150ac35d08'),
  -- data/triggers/004/004_15_moonwell_progress_journal.lua
  (4, 15, $trig$-- Converted from DG Script #415: Moonwell progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "moonwell") or string.find(arg, "moonwell_spell_quest") then
    if string.find(actor.class, "druid") and actor.level >= 65 then
        _return_value = true
        local stage = actor:get_quest_stage("moonwell_spell_quest")
        local master = mobiles.template(163, 16).name
        actor:send("<b:green>&uMoonwell</>")
        actor:send("Minimum Level: 73")
        local status
        if actor:get_has_completed("moonwell_spell_quest") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("moonwell_spell_quest") then
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            -- switch on stage
            local item
            local place
            if stage == 1 or stage == 2 then
                -- Vine of Mielikki
                item = 16350
                place = "an island of lava and fire"
            elseif stage == 3 then
                -- The Heartstone
                item = 48024
                place = "an ancient burial site far to the north"
            elseif stage == 4 then
                -- Flask of Eleweiss
                item = 16356
                place = "the cult of the ice dragon"
            elseif stage == 5 then
                -- Flask of Eleweiss
                item = 16356
                place = "the cult of the ice dragon"
            elseif stage == 6 then
                -- Glittering ruby ring
                item = 5201
                place = "a temple dedicated to fire"
            elseif stage == 7 then
                -- Orb of Winds
                item = 16006
                place = "a dark fortress to the east"
            elseif stage == 8 then
                -- Jade ring
                item = 49011
                place = "a wood nymph on an island of our brothers beset by beasts"
            elseif stage == 10 then
                -- Chaos Orb
                item = 4003
                place = "a great dragon hidden in a hellish labyrinth"
            elseif stage == 11 then
                -- Granite Ring
                item = 55020
                place = "a large temple hidden in a mountain"
            end
            if stage < 6 or (stage >= 6 and not actor:get_quest_var("moonwell_spell_quest:map")) then
                actor:send("Bring " .. "%get.obj_shortdesc[%item%]% from %place%.")
            else
                actor:send("Bring " .. tostring(master) .. " your bark map.")
            end
            if stage > 6 then
                actor:send("</>")
                actor:send("If you need a new map, return to " .. tostring(master) .. " and say \"<b:green>I lost my map</>\".")
            end
        end
    end
end
return _return_value$trig$, 'b89c0cd2a37518f2a4d9a3d3cbb967de'),
  -- data/triggers/004/004_19_major_globe_progress_journal.lua
  (4, 19, $trig$-- Converted from DG Script #419: Major Globe progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "major globe") or string.find(arg, "globe") or string.find(arg, "major_globe") or string.find(arg, "major_globe_spell") then
    local relocateclasses = "Sorcerer Cryomancer Pyromancer"
    if actor.level >= 50 and string.find(string.lower(relocateclasses), actor.class, 1, true) then
        _return_value = true
        local stage = actor:get_quest_stage("major_globe_spell")
        actor:send("<b:green>&uMajor Globe</>")
        actor:send("Minimum Level: 57")
        local status
        if actor:get_has_completed("major_globe_spell") then
            status = "Completed!"
        elseif actor:get_quest_stage("major_globe_spell") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("major_globe_spell") then
            -- switch on stage
            if stage == 1 then
                local master = mobiles.template(534, 50).name
                local task = "Find Earle and tell him \"Lirne sends me.\""
            elseif stage == 2 then
                local master = mobiles.template(490, 8).name
                local task = "Find shale on Fiery Island."
            elseif stage == 3 then
                local master = mobiles.template(490, 8).name
                local task = "Find sake in Odaishyozen."
            elseif stage == 4 then
                local master = mobiles.template(490, 8).name
                local task = "Find a marigold poultice on a healer in South Caelia."
            elseif stage == 5 then
                local master = mobiles.template(534, 50).name
                local task = "Bring " .. tostring(master) .. " the salve Earle prepared."
            elseif stage == 6 then
                local master = mobiles.template(534, 50).name
                local task = "&6&bSearch&0 in each &2&blibrary&0 or &2&bstack&0 to find the lost spellbook."
            elseif stage == 7 then
                local master = mobiles.template(534, 50).name
                local task = "Bring " .. tostring(objects.template(534, 52).name) .. " to " .. tostring(master) .. "."
            elseif stage == 8 then
                local master = mobiles.template(534, 50).name
                local plant = actor:get_quest_var("major_globe_spell:ward_53453")
                local mist = actor:get_quest_var("major_globe_spell:ward_53454")
                local water = actor:get_quest_var("major_globe_spell:ward_53455")
                local flame = actor:get_quest_var("major_globe_spell:ward_53456")
                local ice = actor:get_quest_var("major_globe_spell:ward_53457")
                local wards_left = 5 - actor:get_quest_var("major_globe_spell:ward_count")
                local task = "Bring " .. tostring(master) .. " &3&bwards_left more elemental wards&0, one each from a mist, a water, an ice, a flame, and a plant elemental."
            elseif stage == 9 then
                local master = mobiles.template(534, 50).name
                local final_item = actor:get_quest_var("major_globe_spell:final_item")
                -- switch on final_item
                local place
                if final_item == 53458 then
                    place = "in a border keep"
                elseif final_item == 53459 then
                    place = "on an emerald isle"
                elseif final_item == 53460 then
                    place = "within a misty fortress"
                else
                    place = "in an underground city"
                end
                local task = "Find get.obj_shortdesc[final_item] in place."
                local master = mobiles.template(534, 50).name
                local final_item = actor:get_quest_var("major_globe_spell:final_item")
                local task = "Deliver get.obj_shortdesc[final_item] to " .. tostring(master) .. "."
                actor:send("Quest Master: " .. tostring(master))
                actor:send("</>")
                actor:send(tostring(task))
                if stage == 8 then
                    if wards_left < 5 then
                        actor:send("You have found:")
                        if plant == 2 then
                            actor:send(tostring(objects.template(534, 53).name))
                        end
                        if mist == 2 then
                            actor:send(tostring(objects.template(534, 54).name))
                        end
                        if water == 2 then
                            actor:send(tostring(objects.template(534, 55).name))
                        end
                        if flame == 2 then
                            actor:send(tostring(objects.template(534, 56).name))
                        end
                        if ice == 2 then
                            actor:send(tostring(objects.template(534, 57).name))
                        end
                    end
                end
            end
        end
    end
end  -- auto-close block
return _return_value$trig$, 'e256cfbd9fa2aca900fe82327dcacea1'),
  -- data/triggers/004/004_25_resurrection_progress_journal.lua
  (4, 25, $trig$-- Converted from DG Script #425: Resurrection progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "resurrection") or string.find(arg, "resurrect") or string.find(arg, "resurrection_quest") or string.find(arg, "res") then
    if string.find(actor.class, "cleric") or string.find(actor.class, "priest") or string.find(actor.class, "diabolist") and actor.level >= 75 then
        _return_value = true
        local stage = actor:get_quest_stage("resurrection_quest")
        actor:send("<b:green>&uResurrection</>")
        actor:send("Minimum Level: 81")
        local status
        if actor:get_has_completed("resurrection_quest") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        local hunt, item
        if stage > 0 and not actor:get_has_completed("resurrection_quest") then
            actor:send("Quest Master: " .. tostring(mobiles.template(85, 50).name))
            actor:send("</>")
            -- switch on stage
            if stage == 1 then
                actor:send("Ask Norisent about payment.")
                return _return_value
            elseif stage == 2 then
                actor:send("Norisent told you:")
                actor:send("Do something to interfere with Ziijhan.  I hear he has a bishop locked up in the Cathedral dungeon.")
                return _return_value
            elseif stage == 3 then
                actor:send("Return to Norisent.")
                return _return_value
            elseif stage == 4 then
                hunt = tostring(mobiles.template(40, 4).name) .. ", " .. tostring(mobiles.template(40, 3).name) .. ", and " .. tostring(mobiles.template(40, 16).name)
                local mob1 = 4004
                local mob2 = 4003
                local mob3 = 4016
                item = objects.template(40, 8).name
            elseif stage == 5 then
                item = objects.template(40, 8).name
            elseif stage == 6 then
                hunt = "2 Xeg-Yi and " .. tostring(mobiles.template(533, 8).name)
                local mob2 = 53411
                local mob1 = 53308
                item = objects.template(533, 7).name
            elseif stage == 7 then
                item = objects.template(533, 7).name
            elseif stage == 8 or stage == 9 then
                hunt = tostring(mobiles.template(510, 5).name) .. ", " .. tostring(mobiles.template(530, 1).name) .. ", and " .. tostring(mobiles.template(510, 14).name)
                local mob1 = 51005
                local mob2 = 53001
                local mob3 = 51014
                if string.find(actor.class, "cleric") or string.find(actor.class, "priest") then
                    item = "a large book on healing from Nordus"
                elseif string.find(actor.class, "diabolist") then
                    item = objects.template(510, 28).name
                end
            elseif stage == 10 then
                hunt = tostring(mobiles.template(520, 3).name) .. " and " .. tostring(mobiles.template(520, 15).name)
                local mob1 = 52003
                local mob2 = 52015
                item = objects.template(520, 1).name
            elseif stage == 11 then
                item = objects.template(520, 1).name
            elseif stage == 12 then
                actor:send("Destroy Norisent!")
                return _return_value
            end
        end
        if stage == 4 or stage == 6 or stage == 8 or stage == 10 then
            local target1 = actor:get_quest_var("resurrection_quest:mob1")
            local target2 = actor:get_quest_var("resurrection_quest:mob2")
            local target3
            if stage ~= 6 and stage ~= 10 then
                target3 = actor:get_quest_var("resurrection_quest:mob3")
            end
            actor:send("You must eliminate:")
            actor:send(tostring(hunt))
            if stage == 4 or stage == 8 then
                if target1 and target2 and target3 then
                    actor:send("</>")
                    actor:send("Show Norisent the death talisman.")
                    return _return_value
                end
            elseif stage == 6 then
                if target1 and (target2 == 2) then
                    actor:send("</>")
                    actor:send("Show Norisent the death talisman.")
                    return _return_value
                end
            else
                if target1 and target2 then
                    actor:send("</>")
                    actor:send("Show Norisent the death talisman.")
                    return _return_value
                end
            end
            if target1 or target2 or target3 then
                actor:send("</>")
                actor:send("You have destroyed:")
                if target1 then
                    actor:send("- " .. "%get.mob_shortdesc[%mob1%]%")
                end
                if stage == 6 then
                    actor:send("- " .. tostring(target2) .. " " .. "%get.mob_shortdesc[%mob2%]%")
                else
                    if target2 then
                        actor:send("- " .. "%get.mob_shortdesc[%mob2%]%")
                    end
                end
                if stage == 4 or stage == 8 then
                    if target3 then
                        actor:send("- " .. "%get.mob_shortdesc[%mob3%]%")
                    end
                end
            end
            if (stage ~= 6 and (not target1 or not target2 or not target3)) or (stage == 6 and (not target1 or target2 < 2)) then
                actor:send("</>")
                actor:send("You still need to dispatch:")
                if not target1 then
                    actor:send("- " .. "%get.mob_shortdesc[%mob1%]%")
                end
                if stage == 6 then
                    if target2 < 2 then
                        local xeg = (2 - target2)
                        actor:send("- " .. tostring(xeg) .. " " .. "%get.mob_shortdesc[%mob2%]%")
                    end
                else
                    if not target2 then
                        actor:send("- " .. "%get.mob_shortdesc[%mob2%]%")
                    end
                end
                if stage ~= 6 and stage ~= 10 then
                    if not target3 then
                        actor:send("- " .. "%get.mob_shortdesc[%mob3%]%")
                    end
                end
                actor:send("</>")
                actor:send("Return " .. tostring(item) .. " as proof.")
            end
            actor:send("</>")
            actor:send("Don't forget the banishment phrase: <b:blue>Dhewsost Konre</>")
        elseif stage == 5 or stage == 7 or stage == 9 or stage == 11 then
            actor:send("Bring Norisent back " .. tostring(item) .. ".")
        end
        if stage >= 4 and not actor:get_has_completed("resurrection_quest") then
            actor:send("</>")
            actor:send("If you need a new talisman, return to Norisent and say &9<blue>\"I need a new talisman\"</>.")
        end
    end
end
return _return_value$trig$, 'df5384c019b326fb9c5f2364a05b3060'),
  -- data/triggers/004/004_26_group_heal_progress_journal.lua
  (4, 26, $trig$-- Converted from DG Script #426: Group Heal progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "group heal") or string.find(arg, "heal") or string.find(arg, "group_heal") then
    if actor.level >= 50 then
        if string.find(actor.class, "priest") or string.find(actor.class, "cleric") or string.find(actor.class, "diabolist") then
            _return_value = true
            local stage = actor:get_quest_stage("group_heal")
            actor:send("<b:green>&uGroup Heal</>")
            actor:send("Minimum Level: 57")
            local status
            if actor:get_has_completed("group_heal") then
                status = "Completed!"
            elseif stage then
                status = "In Progress"
            else
                status = "Not Started"
            end
            actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            if stage > 0 and not actor:get_has_completed("group_heal") then
                actor:send("Quest Master: " .. tostring(mobiles.template(185, 21).name))
                actor:send("</>")
                -- switch on stage
                if stage == 1 then
                    actor:send("Track down the bandit raider in the Gothra desert and recover the stolen medical supplies.")
                elseif stage == 2 then
                    actor:send("Return the medical supplies stolen by the bandit raider.")
                elseif stage == 3 or stage == 4 then
                    actor:send("Locate the records of a group healing ritual in a lost kitchen in the Great Northern Swamp.")
                elseif stage == 5 then
                    actor:send("Visit every <b:white>chef</> and <b:white>cook</> to get their notes on the healing ritual.")
                    actor:send("</>")
                    local recipe1 = actor:get_quest_var("group_heal:18515")
                    local recipe2 = actor:get_quest_var("group_heal:18516")
                    local recipe3 = actor:get_quest_var("group_heal:18517")
                    local recipe4 = actor:get_quest_var("group_heal:18518")
                    local recipe5 = actor:get_quest_var("group_heal:18519")
                    local recipe6 = actor:get_quest_var("group_heal:18520")
                    if recipe1 or recipe2 or recipe3 or recipe4 or recipe5 or recipe6 then
                        actor:send("You have already brought notes from:")
                        if recipe1 then
                            actor:send("- " .. tostring(mobiles.template(83, 7).name))
                        end
                        if recipe2 then
                            actor:send("- " .. tostring(mobiles.template(510, 7).name))
                        end
                        if recipe3 then
                            actor:send("- " .. tostring(mobiles.template(185, 12).name))
                        end
                        if recipe4 then
                            actor:send("- " .. tostring(mobiles.template(300, 3).name))
                        end
                        if recipe5 then
                            actor:send("- " .. tostring(mobiles.template(502, 3).name))
                        end
                        if recipe6 then
                            actor:send("- " .. tostring(mobiles.template(103, 8).name))
                        end
                        actor:send("</>")
                    end
                    local total = 6 - actor:get_quest_var("group_heal:total")
                    if total == 1 then
                        actor:send("Bring notes from " .. tostring(total) .. " more chef.")
                    else
                        actor:send("Bring notes from " .. tostring(total) .. " more chefs.")
                    end
                    actor:send("</>")
                    actor :send("If you need a new copy of the Rite, go to the doctor and say: <b:yellow>\"I lost the Rite\"</>.")
                    if actor:get_quest_var("group_heal:total") == 6 then
                    elseif stage == 6 then
                        actor:send("Give " .. tostring(objects.template(185, 14).name) .. " to the doctor.")
                        return _return_value
                    end
                    actor:send("You are delivering the medical packages to <b:white>injured</>, <b:white>wounded</>, <b:white>sick</>, or <b:white>hobbling</> creatures.")
                    local total = (5 - actor:get_quest_var("group_heal:total"))
                    local person1 = actor:get_quest_var("group_heal:18506")
                    local person2 = actor:get_quest_var("group_heal:46414")
                    local person3 = actor:get_quest_var("group_heal:43020")
                    local person4 = actor:get_quest_var("group_heal:12513")
                    local person5 = actor:get_quest_var("group_heal:36103")
                    local person6 = actor:get_quest_var("group_heal:58803")
                    local person7 = actor:get_quest_var("group_heal:30054")
                    actor:send("</>")
                    if person1 or person2 or person3 or person4 or person5 or person6 or person7 then
                        actor:send("You have aided:")
                        if person1 then
                            actor:send("- " .. tostring(mobiles.template(185, 6).name))
                        end
                        if person2 then
                            actor:send("- " .. tostring(mobiles.template(464, 14).name))
                        end
                        if person3 then
                            actor:send("- " .. tostring(mobiles.template(430, 20).name))
                        end
                        if person4 then
                            actor:send("- " .. tostring(mobiles.template(125, 13).name))
                        end
                        if person5 then
                            actor:send("- " .. tostring(mobiles.template(361, 3).name))
                        end
                        if person6 then
                            actor:send("- " .. tostring(mobiles.template(588, 3).name))
                        end
                        if person7 then
                            actor:send("- " .. tostring(mobiles.template(300, 54).name))
                        end
                        actor:send("</>")
                    end
                    if total == 1 then
                        actor:send("You need to deliver " .. tostring(total) .. " more packet.")
                    else
                        actor:send("You need to deliver " .. tostring(total) .. " more packets.")
                    end
                end
            end
        end
    end
end
return _return_value$trig$, '4a2da3783b43d9c31e6bc854a88d338b'),
  -- data/triggers/004/004_27_group_armor_progress_journal.lua
  (4, 27, $trig$-- Converted from DG Script #427: Group Armor progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "group armor") or string.find(arg, "group_armor") then
    if (actor.level >= 50 and string.find(actor.class, "priest")) or (actor.level >= 65 and string.find(actor.class, "cleric")) then
        _return_value = true
        local stage = actor:get_quest_stage("group_armor")
        actor:send("<b:green>&uGroup Armor</>")
        if string.find(actor.class, "priest") then
            actor:send("Minimum Level: 57")
        elseif string.find(actor.class, "cleric") then
            actor:send("Minimum Level: 65")
        end
        local status
        if actor:get_has_completed("group_armor") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("group_armor") then
            actor:send("Quest Master: " .. tostring(mobiles.template(590, 99).name))
            actor:send("</>")
            -- switch on stage
            local item1
            local item2
            local item3
            local item4
            local obj1
            local obj2
            local obj3
            local obj4
            local step
            if stage == 1 then
                item1 = actor:get_quest_var("group_armor:6118")
                item2 = actor:get_quest_var("group_armor:11704")
                item3 = actor:get_quest_var("group_armor:11707")
                item4 = actor:get_quest_var("group_armor:16906")
                obj1 = objects.template(61, 18).name
                obj2 = objects.template(117, 4).name
                obj3 = objects.template(117, 7).name
                obj4 = objects.template(169, 6).name
                step = "locate items that cast the spell &7&barmor&0"
            elseif stage == 2 then
                step = "find a new &7&bforging hammer&0"
            elseif stage == 3 or stage == 4 then
                step = "take the forging hammer where light reaches deep underground and &7&b[commune]&0"
            elseif stage == 5 then
                step = "find a suitable amulet to be the focus of this spell"
                item1 = actor:get_quest_var("group_armor:12500")
                obj1 = objects.template(125, 0).name
            elseif stage == 6 then
                step = "locate ethereal items to provide protective energy to the amulet"
                item1 = actor:get_quest_var("group_armor:47004")
                item2 = actor:get_quest_var("group_armor:47018")
                item3 = actor:get_quest_var("group_armor:53003")
                obj1 = objects.template(470, 4).name
                obj2 = objects.template(470, 18).name
                obj3 = objects.template(530, 3).name
            end
            actor:send("You are trying to " .. tostring(step) .. ".")
            if stage == 1 or stage == 5 or stage == 6 then
                if item1 or item2 or item3 or item4 then
                    actor:send("</>")
                    actor:send("You have already brought:")
                    if item1 then
                        actor:send("- " .. tostring(obj1))
                    end
                    if item2 then
                        actor:send("- " .. tostring(obj2))
                    end
                    if item3 then
                        actor:send("- " .. tostring(obj3))
                    end
                    if item4 then
                        actor:send("- " .. tostring(obj4))
                    end
                end
                actor:send("</>")
                actor:send("You still need to locate:")
                if not item1 then
                    actor:send("- <b:yellow>" .. tostring(obj1) .. "</>")
                end
                if stage == 1 or stage == 6 then
                    if not item2 then
                        actor:send("- <b:yellow>" .. tostring(obj2) .. "</>")
                    end
                    if not item3 then
                        actor:send("- <b:yellow>" .. tostring(obj3) .. "</>")
                    end
                    if stage == 1 then
                        if not item4 then
                            actor:send("- <b:yellow>" .. tostring(obj4) .. "</>")
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, '821b3d86b0dae85c2574b83acd8b91c4'),
  -- data/triggers/004/004_28_supernova_progress_journal.lua
  (4, 28, $trig$-- Converted from DG Script #428: Supernova progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "supernova") or string.find(arg, "nova") then
    if actor.level >= 85 and string.find(actor.class, "pyromancer") then
        _return_value = true
        local stage = actor:get_quest_stage("supernova")
        actor:send("<b:green>&uSupernova</>")
        actor:send("Minimum Level: 89")
        local status
        if actor:get_has_completed("supernova") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("supernova") then
            actor:send("Quest Master: the pyromancer guildmasters")
            actor:send("</>")
            actor:send("Your task is to:")
            -- switch on stage
            if stage == 1 then
                actor:send("Find one of Phayla's lamps.")
            elseif stage == 2 then
                actor:send("Return to a pyromancer guildmaster with Phayla's lamp and ask about Supernova.")
            elseif stage == 3 then
                actor:send("Find clues to Phayla's whereabouts.")
                actor:send("</>")
                actor:send("She likes to visit the material plane to engage in her favorite leisure activities.")
                local clue = actor:get_quest_var("supernova:step3")
                -- switch on clue
                if clue == 4318 then
                    actor:send("Recently, she was spotted in Anduin, taking in a show from the best seat in the house.")
                elseif clue == 10316 then
                    actor:send("I understand she frequents the hottest spring at the popular resort up north.")
                elseif clue == 58062 then
                    actor:send("She occasionally visits a small remote island theatre, where she enjoys meditating in their reflecting room.")
                end
                actor:send("Find further clues to Phayla's whereabouts.")
                actor:send("</>")
                -- switch on actor:get_quest_var("supernova:step4")
                local clue2
                if actor:get_quest_var("supernova:step4") == 18577 then
                    clue2 = "I continue my journey where the sun rises amidst a sea of swirling worlds."
                    -- The Abbey, the rising sun room
                elseif actor:get_quest_var("supernova:step4") == 17277 then
                    clue2 = "Atop a tower I visit a master who waits to give his final examination."
                    -- Citadel of Testing
                elseif actor:get_quest_var("supernova:step4") == 8561 then
                    clue2 = "I study in a secret place above a hall of misery beyond a gallery of horrors."
                    -- Cathedral of Betrayal near Norisent
                end
                -- end clue2 switch
                actor:send("Find yet another clue to Phayla's whereabouts.")
                actor:send("</>")
                -- switch on actor:get_quest_var("supernova:step5")
                local clue3
                if actor:get_quest_var("supernova:step5") == 53219 then
                    clue3 = "Where DID the lizard men get that throne from?  I'll see if I can find out."
                    -- Lizard King's throne room, Sunken
                elseif actor:get_quest_var("supernova:step5") == 47343 then
                    clue3 = "They often wonder what would happen if bones could talk.  I'll ask one who can make that happen!"
                    -- Kryzanthor, Graveyard
                elseif actor:get_quest_var("supernova:step5") == 16278 then
                    clue3 = "Waves of sand hold the remains of a child of the Sun God.  Supposedly.  I'll have to see for myself."
                    -- Imanhotep, Pyramid
                end
                -- end clue3 switch
                actor:send("Solve the riddle to deduce the location of the gateway to Phayla's realm.")
                actor:send("</>")
                local step7 = actor:get_quest_var("supernova:step7")
                -- switch on actor:get_quest_var("supernova:step6")
                if actor:get_quest_var("supernova:step6") == 58657 then
                    -- A Hummock of Grass in the Beachhead
                    local clue4
                    if step7 == 1 then
                        clue4 = "s pfqzqgc wq kecwk qy xug fwinlugev"
                    elseif step7 == 2 then
                        clue4 = "d hlwzsuc rf xbnwk aq tyo oisukhvkq"
                    elseif step7 == 3 then
                        clue4 = "s oidfgjy fy yyojl au hyx tlotazlou"
                    end
                elseif actor:get_quest_var("supernova:step6") == 35119 then
                    -- A Pile of Stones in the Brush Lands
                    local clue4
                    if step7 == 1 then
                        clue4 = "s xtpr qj kbzrru mf bsi otykp weafw"
                    elseif step7 == 2 then
                        clue4 = "d pzvr sx kwoeof mf lke sbhwz ddnuc"
                    elseif step7 == 3 then
                        clue4 = "s wwcx gm gkhflg zg los skmzv ctfkg"
                    end
                elseif actor:get_quest_var("supernova:step6") == 55422 then
                    -- The Trail Overlooking the Falls in the dark mountains
                    local clue4
                    if step7 == 1 then
                        clue4 = "lpp xecmd wgiensgstrt vlw nlpyu mf bsi qcvc uzyaveavd"
                    elseif step7 == 2 then
                        clue4 = "whv deead ovvbysgclnx dui xsolj sa xzw gaiu zsmfwazxf"
                    elseif step7 == 3 then
                        clue4 = "los kkspz fowyzfhcpbx mzl tredz we mzl rrkc tclglhwel"
                    end
                end
                -- end clue4 switch
                -- switch on step7
                local clue5
                if step7 == 1 then
                    clue5 = "What disappears as soon as you say its name?"
                    -- Answer: Silence
                elseif step7 == 2 then
                    clue5 = "The more there is, the less you see. What am I?"
                    -- Answer: Darkness
                elseif step7 == 3 then
                    clue5 = "What word becomes shorter when you add two to it?"
                    -- Answer: Short
                end
                -- end clue 5 switch
                actor:send("Talk to Phayla.")
            elseif stage > 3 then
                if actor:has_item("48917") or actor:has_equipped("48917") then
                    if stage == 4 then
                        actor:send("Learning is a life-long process.")
                        actor:send(tostring(clue2))
                    elseif stage == 5 then
                        actor:send("History is so fascinating!")
                        actor:send(tostring(clue3))
                    elseif stage == 6 then
                        actor:send("I know you're following me.  Answer this:")
                        actor:send("\"" .. tostring(clue5) .. "\"")
                        actor:send("With the answer you can find the gate to my home here:")
                        actor:send(tostring(clue4))
                        actor:send("</>")
                        actor:send("You will need additional solar energy to power the gate.")
                        actor:send("Hidden in the dimensional folds around Nordus is an appropriate source.")
                    end
                else
                    actor:send("Your notes are a jumble of unintelligible squiggles.")
                    actor:send("You must have " .. tostring(objects.template(489, 17).name) .. " to read them!")
                end
            end
        end
    end
end  -- auto-close block
return _return_value$trig$, '4d48ce16fb834a2635ac7f5e3296f8b5'),
  -- data/triggers/004/004_29_meteorswarm_progress_journal.lua
  (4, 29, $trig$-- Converted from DG Script #429: Meteorswarm progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "meteor") or string.find(arg, "meteorswarm") then
    if (string.find(actor.class, "sorcerer") and actor.level >= 65) or (string.find(actor.class, "pyromancer") and actor.level >= 75) then
        _return_value = true
        local stage = actor:get_quest_stage("meteorswarm")
        actor:send("<b:green>&uMeteorswarm</>")
        if string.find(actor.class, "sorcerer") then
            actor:send("Minimum Level: 73")
        elseif string.find(actor.class, "pyromancer") then
            actor:send("Minimum Level: 81")
        end
        local status
        if actor:get_has_completed("meteorswarm") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("meteorswarm") then
            actor:send("Quest Master: " .. tostring(mobiles.template(481, 150).name))
            actor:send("</>")
            if actor:get_quest_var("meteorswarm:new") ~= yes then
                actor:send("Go find a new meteorite.")
                return _return_value
            elseif actor:get_quest_var("meteorswarm:new") ~= no then
                actor:send("Bring the new meteorite to McCabe.")
                return _return_value
            end
            -- switch on stage
            local task
            if stage == 1 then
                task = "Find Jemnon and ask about the rock demon.  McCabe said, \"He's in some tavern, no doubt, waiting for some new blunder to embark on.\""
            elseif stage == 2 then
                task = "Find a suitable meteor focus from the rock demon in Templace."
                if actor:get_quest_var("meteorswarm:earth") == 0 then
                elseif stage == 3 then
                    task = "Show him the meteorite."
                else
                    if actor:get_quest_var("meteorswarm:fire") == 0 then
                        task = "Find and kill the high fire priest in the Lava Tunnels.  Then enter the lava bubble below his secret chambers."
                    else
                        task = "Find the lava bubble in the high fire priest's secret chambers."
                    end
                end
                if actor:get_quest_var("meteorswarm:fire") == 1 then
                elseif stage == 4 then
                    task = "Return to McCabe."
                elseif actor:get_quest_var("meteorswarm:fire") == 2 then
                    task = "Convince the ancient dragon Dargentan to teach you the ways of air magic."
                end
                if actor:get_quest_var("meteorswarm:air") == 0 then
                elseif stage == 5 then
                    task = "Show him the meteorite now that you have mastered earth, fire, and air."
                else
                    task = "Take your finished focus and unleash its potential!"
                end
            end
            actor:send("McCabe wants you to:")
            actor:send(tostring(task))
            if actor:get_quest_var("meteorswarm:earth") then
                actor:send("</>")
                actor:send("If you somehow lost the meteorite, return to McCabe and say <b:red>\"I lost <b:red>the meteorite\"</>.")
            end
        end
    end
end
return _return_value$trig$, '23abf9a293933669858c833a753cb195'),
  -- data/triggers/004/004_30_banish_progress_journal.lua
  (4, 30, $trig$-- Converted from DG Script #430: Banish progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "banish") then
    if actor.level >= 50 and (string.find(actor.class, "priest") or string.find(actor.class, "diabolist")) then
        _return_value = true
        local stage = actor:get_quest_stage("banish")
        local master = mobiles.template(302, 16).name
        actor:send("<b:green>&uBanish</>")
        actor:send("Minimum Level: 65")
        local status
        if actor:get_has_completed("banish") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("banish") then
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            -- switch on stage
            local known
            if stage == 1 then
                local mob = 41119
                local place = "her chamber under the ocean waves"
                known = "Nothing."
            elseif stage == 2 then
                local mob = 53313
                local place = "the frozen tunnels of the north"
                known = "v"
            elseif stage == 3 then
                local mob = 37000
                local place = "a deep and ancient mine"
                known = "vi"
            elseif stage == 4 then
                local mob = 48005
                local place = "a room filled with art in an ancient barrow"
                known = "vib"
            elseif stage == 5 then
                local mob = 53417
                local place = "the cold valley of the far north"
                known = "vibu"
            elseif stage == 6 then
                local mob = 23811
                local place = "a nearby fortress of clouds and crystals"
                known = "vibug"
            elseif stage == 7 then
                actor:send("Return to " .. tostring(mobiles.template(302, 16).name) .. " and speak the prayer aloud: <b:magenta>vibugp</>")
                return _return_value
            end
            if actor:get_quest_var("banish:greet") == 1 then
                actor:send("To learn Banish you must next kill " .. "%get.mob_shortdesc[%mob%]% in %place%.")
            else
                actor:send("Return to " .. tostring(master) .. " for further instruction.")
            end
            actor:send("</>")
            actor:send("</>Your knowledge of the prayer so far: <b:cyan>" .. tostring(known) .. "</>")
        end
    end
end
return _return_value$trig$, '74cb72b2060d7b0aeda4187cdaceea03'),
  -- data/triggers/004/004_32_word_of_command_progress_journal.lua
  (4, 32, $trig$-- Converted from DG Script #432: Word of Command progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "word") or string.find(arg, "command") or string.find(arg, "word of command") or string.find(arg, "word_command") then
    if actor.level >= 65 then
        local stage
        if string.find(actor.class, "diabolist") or string.find(actor.class, "priest") then
            _return_value = true
            stage = actor:get_quest_stage("word_command")
            actor:send("<b:green>&uWord of Command</>")
            local status
            if actor:get_has_completed("word_command") then
                status = "Completed!"
            elseif stage then
                status = "In Progress"
            else
                status = "Not Started"
            end
            actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        end
        if stage > 0 and not actor:get_has_completed("word_command") then
            actor:send("Quest Master: " .. tostring(mobiles.template(430, 21).name))
            actor:send("</>")
            actor:send("Help " .. tostring(mobiles.template(430, 21).name) .. " escape from Demise Keep!")
            actor:send("%get.mob_shortdesc[43017]% and its minions will stop at nothing to keep %get.mob_shortdesc[43021]% trapped in its clutches!")
        end
    end
end
return _return_value$trig$, '4b3a41cec05d5da1464e0b80be770dd1'),
  -- data/triggers/004/004_33_heavens_gate_progress_journal.lua
  (4, 33, $trig$-- Converted from DG Script #433: Heavens Gate progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "heavens gate") or string.find(arg, "heavens") or string.find(arg, "heaven's gate") or string.find(arg, "heaven's") or string.find(arg, "heavens_gate") or string.find(arg, "heaven's_gate") then
    if actor.level >= 75 and string.find(actor.class, "priest") then
        _return_value = true
        local stage = actor:get_quest_stage("heavens_gate")
        actor:send("<b:green>&uHeavens Gate</>")
        actor:send("Minimum Level: 81")
        local status
        if actor:get_has_completed("heavens_gate") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("heavens_gate") then
            actor:send(": Quest Master: " .. tostring(mobiles.template(133, 33).name))
            actor:send("</>")
            -- switch on stage
            if stage == 1 then
                actor:send("You received a vision a silver prayer bowl brought before the starlight and <b:cyan>[put] <b:white>on the <b:cyan>[pedestal]</>.")
            elseif stage == 2 then
                local key1 = actor:get_quest_var("heavens_gate:4005")
                local key2 = actor:get_quest_var("heavens_gate:12142")
                local key3 = actor:get_quest_var("heavens_gate:23709")
                local key4 = actor:get_quest_var("heavens_gate:47009")
                local key5 = actor:get_quest_var("heavens_gate:49008")
                local key6 = actor:get_quest_var("heavens_gate:52012")
                local key7 = actor:get_quest_var("heavens_gate:52013")
                actor:send("You received a vision of seven keys to seven gates brought to the pedestal before the starlight.")
                if key1 or key2 or key3 or key4 or key5 or key6 or key7 then
                    actor:send("</>")
                    actor:send("You have returned:")
                    if key1 then
                        actor:send(tostring(objects.template(40, 5).name))
                    end
                    if key2 then
                        actor:send(tostring(objects.template(120, 142).name))
                    end
                    if key3 then
                        actor:send(tostring(objects.template(237, 9).name))
                    end
                    if key4 then
                        actor:send(tostring(objects.template(470, 9).name))
                    end
                    if key5 then
                        actor:send(tostring(objects.template(490, 8).name))
                    end
                    if key6 then
                        actor:send(tostring(objects.template(520, 12).name))
                    end
                    if key7 then
                        actor:send(tostring(objects.template(520, 13).name))
                    end
                end
                actor:send("</>")
                actor:send("You must still seek out:")
                if not key1 then
                    actor:send("<b:cyan>A small skeleton key forged of night and shadow</>")
                    actor:send("</>hidden deep in a twisted labyrinth.</>")
                end
                if not key2 then
                    actor:send("</>")
                    actor:send("<b:cyan>A key made from a piece of the black and pitted wood</>")
                    actor:send("</>typical of trees in the Twisted Forest near Mielikki.</>")
                end
                if not key3 then
                    actor:send("</>")
                    actor:send("<b:cyan>A large, black key humming with magical energy</>")
                    actor:send("</>from a twisted cruel city in a huge underground cavern.</>")
                end
                if not key4 then
                    actor:send("</>")
                    actor:send("<b:cyan>A key covered in oil</>")
                    actor:send("</>kept by a long-dead caretaker in a necropolis.</>")
                end
                if not key5 then
                    actor:send("</>")
                    actor:send("<b:cyan>A rusted but well cared for key</>")
                    actor:send("</>carried by an enormous griffin.</>")
                end
                if not key7 then
                    actor:send("</>")
                    actor:send("<b:cyan>A golden plated, wrought-iron key</>")
                    actor:send("</>held at the gates to a desecrated city.</>")
                end
                if not key6 then
                    actor:send("</>")
                    actor:send("<b:cyan>One nearly impossible to see</>")
                    actor:send("</>guarded by a fiery beast with many heads.</>")
                end
            elseif stage == 3 then
                local sealed = actor:get_quest_var("heavens_gate:sealed")
                local seal1 = actor:get_quest_var("heavens_gate:51077")
                local seal2 = actor:get_quest_var("heavens_gate:16407")
                local seal3 = actor:get_quest_var("heavens_gate:16094")
                local seal4 = actor:get_quest_var("heavens_gate:55735")
                local seal5 = actor:get_quest_var("heavens_gate:49024")
                local seal6 = actor:get_quest_var("heavens_gate:55126")
                local seal7 = actor:get_quest_var("heavens_gate:55112")
                actor:send("You saw visions of seven rifts in the fabric of reality which you must <b:cyan>seal</>.")
                if seal1 or seal2 or seal3 or seal4 or seal5 or seal6 or seal7 then
                    actor:send("</>")
                    actor:send("You have already sealed the rifts in:")
                    if seal1 then
                        -- Nordus
                        local room = get_room("51077")
                        actor:send(tostring(room.name))
                    end
                    if seal2 then
                        -- Mystwatch demon
                        local room = get_room("16407")
                        actor:send(tostring(room.name))
                    end
                    if seal3 then
                        -- Mystwatch fortress
                        local room = get_room("16094")
                        actor:send(tostring(room.name))
                    end
                    if seal4 then
                        -- Black rock trail
                        local room = get_room("55735")
                        actor:send(tostring(room.name))
                    end
                    if seal5 then
                        -- Griffin
                        local room = get_room("49024")
                        actor:send(tostring(room.name))
                    end
                    if seal6 then
                        -- Huitzipia - war
                        local room = get_room("55126")
                        actor:send(tostring(room.name))
                    end
                    if seal7 then
                        -- Xapizo - death
                        local room = get_room("55112")
                        actor:send(tostring(room.name))
                    end
                end
                actor:send("</>")
                actor:send("You received visions of:")
                if not seal1 then
                    actor:send("<b:cyan>An arch hidden in another plane</>")
                    actor:send("</>granting demons access to an enchanted village of mutants.</>")
                    actor:send("</>")
                end
                if not seal2 then
                    actor:send("<b:cyan>An archway that delivers demons</>")
                    actor:send("</>to the fortress of the dead.</>")
                    actor:send("</>")
                end
                if not seal3 then
                    actor:send("<b:cyan>A portal from a fortress of the undead</>")
                    actor:send("</>to a realm of demons.</>")
                    actor:send("</>")
                end
                if not seal4 then
                    actor:send("<b:cyan>A portal from black rock</>")
                    actor:send("</>to black ice.</>")
                    actor:send("</>")
                end
                if not seal5 then
                    actor:send("<b:cyan>A pool hidden under a well</>")
                    actor:send("</>on an island filled with ferocious beasts.</>")
                    actor:send("</>")
                end
                if not seal6 then
                    actor:send("<b:cyan>A pool in a temple of ice and stone</>")
                    actor:send("</>leading to the realm of a war god.</>")
                    actor:send("</>")
                end
                if not seal7 then
                    actor:send("<b:cyan>A pool in a temple of ice and stone</>")
                    actor:send("</>leading to the realm of a death god.</>")
                    actor:send("</>")
                end
                -- switch on sealed
                local phrase
                if sealed == 1 then
                    phrase = "yamo lv"
                elseif sealed == 2 then
                    phrase = "yamo lv soeeiy"
                elseif sealed == 3 then
                    phrase = "yamo lv soeeiy vrtvln"
                elseif sealed == 4 then
                    phrase = "yamo lv soeeiy vrtvln eau okia khz"
                elseif sealed == 5 then
                    phrase = "yamo lv soeeiy vrtvln eau okia khz lrrvzryp"
                elseif sealed == 6 then
                    phrase = "yamo lv soeeiy vrtvln eau okia khz lrrvzryp gvxrj"
                elseif sealed == 7 then
                    phrase = "yamo lv soeeiy vrtvln eau okia khz lrrvzryp gvxrj bzjbie"
                else
                    return _return_value
                end
                if sealed then
                    actor:send("The words you captured from your vision: <b:cyan>" .. tostring(phrase) .. "</>")
                end
                actor:send("</>")
                actor:send("If you need a new Key, beseech the starlight, <b:cyan>\"Grant me a new key\"</>.")
                actor:send("The starlight manifested as a heavenly raven.")
                actor:send("This time, at last, it spake:_")
                actor:send("<b:cyan>'I I I I am the book.  Open me prophet; read; decypher.</>")
                actor:send("<b:cyan>On you, in you, in your blood, they write, have written.</>")
                actor:send("<b:cyan>Speak it but aloud to know the path of heaven for I I I I am the final key.</>")
                actor:send("<b:cyan>I I I I have shown you visions, and through me you shall read.'</>_")
                actor:send("<yellow>yamo lv soeeiy vrtvln eau okia khz lrrvzryp gvxrj bzjbie hi</>")
            end
        end
    end
end  -- auto-close block
return _return_value$trig$, 'f8df2cbf58602b5db29c61ab2cd99a2c'),
  -- data/triggers/004/004_34_dragons_health_progress_journal.lua
  (4, 34, $trig$-- Converted from DG Script #434: Dragons Health Progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "dragons") or string.find(arg, "dragon's") or string.find(arg, "health") or string.find(arg, "dragons_health") or string.find(arg, "dragon's_health") then
    if actor.level >= 85 and string.find(actor.class, "cleric") or string.find(actor.class, "priest") then
        _return_value = true
        local stage = actor:get_quest_stage("dragons_health")
        actor:send("<b:green>&uDragons Health</>")
        actor:send("Minimum Level: 89")
        local status
        if actor:get_has_completed("dragons_health") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("dragons_health") then
            actor:send("Quest Master: " .. tostring(mobiles.template(586, 10).name))
            actor:send("</>")
            -- switch on stage
            local dragon, treasure
            if stage == 1 then
                dragon = "the blue dragon in the Tower in the Wastes"
                treasure = "its crystal"
            elseif stage == 2 then
                dragon = "Tri-Aszp"
                treasure = "one of her scales"
            elseif stage == 3 then
                dragon = "Thelriki and Jerajai"
                treasure = "the jewel in their hoard"
            elseif stage == 4 then
                dragon = "Sagece"
                treasure = "her skins and shields"
            elseif stage == 5 then
                local total = 10000000 - actor:get_quest_var("dragons_health:hoard")
                local plat = total / 1000
                local gold = total / 100 - plat * 10
                local silv = total / 10 - plat * 100 - gold * 10
                local copp = total  - plat * 1000 - gold * 100 - silv * 10
                -- now the price can be reported
                actor:send("The new hatchling's hoard needs enriching._")
                actor:send("</><b:yellow>" .. tostring(plat) .. " platinum, " .. tostring(gold) .. " gold, " .. tostring(silv) .. " silver, " .. tostring(copp) .. " copper</>_")
                actor:send("</>more in treasure or coins ought to do it.")
                return _return_value
            end
            actor:send("You are trying to:")
            actor:send("- kill " .. tostring(dragon) .. " and return with " .. tostring(treasure) .. ".")
            if stage == 3 then
                local thelriki = actor:get_quest_var("dragons_health:thelriki")
                local jerajai = actor:get_quest_var("dragons_health:jerajai")
                if thelriki or jerajai then
                    actor:send("</>")
                    actor:send("You have slain:")
                    if thelriki then
                        actor:send("- Thelriki")
                    end
                    if jerajai then
                        actor:send("- Jerajai")
                    end
                end
                actor:send("</>")
                actor:send("You must still:")
                if not thelriki then
                    actor:send("- kill Thelriki")
                end
                if not jerajai then
                    actor:send("- kill Jerajai")
                end
                actor:send("- bring the jewel in their hoard")
            elseif stage == 4 then
                local item1 = actor:get_quest_var("dragons_health:52016")
                local item2 = actor:get_quest_var("dragons_health:52017")
                local item3 = actor:get_quest_var("dragons_health:52022")
                local item4 = actor:get_quest_var("dragons_health:52023")
                local sagece = actor:get_quest_var("dragons_health:sagece")
                if item1 or item2 or item3 or item4 or sagece then
                    actor:send("</>")
                    actor:send("You have already:")
                    if sagece then
                        actor:send("- slain Sagece of Raymif")
                    end
                    if item1 then
                        actor:send("- brought Sagece's skin")
                    end
                    if item2 then
                        actor:send("- brought Sagece's shield")
                    end
                    if item3 then
                        actor:send("- brought the skin from Sagece's hoard")
                    end
                    if item4 then
                        actor:send("- brought the shield from Sagece's hoard")
                    end
                end
                actor:send("</>")
                actor:send("You must still:")
                if not sagece then
                    actor:send("- kill Sagece of Raymif")
                end
                if not item1 then
                    actor:send("- bring Sagece's skin")
                end
                if not item2 then
                    actor:send("- bring Sagece's shield")
                end
                if not item3 then
                    actor:send("- find the skin in Sagece's hoard")
                end
                if not item4 then
                    actor:send("- find the shield in Sagece's hoard")
                end
            end
        end
    end
end
return _return_value$trig$, '13a4221ce19d8aafea68c91170426ba9'),
  -- data/triggers/004/004_35_creeping_doom_progress_journal.lua
  (4, 35, $trig$-- Converted from DG Script #435: Creeping Doom progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "creeping") or string.find(arg, "creeping doom") or string.find(arg, "creeping_doom") then
    if actor.level >= 75 and string.find(actor.class, "druid") then
        _return_value = true
        local stage = actor:get_quest_stage("creeping_doom")
        actor:send("<b:green>&uCreeping Doom</>")
        actor:send("Minimum Level: 81")
        local status
        if actor:get_has_completed("creeping_doom") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("creeping_doom") then
            actor:send("Quest Master: " .. tostring(mobiles.template(615, 27).name))
            actor:send("</>")
            -- switch on stage
            local step
            if stage == 1 then
                local item1 = 11812
                local place1 = "an assassin vine on Mist Mountain"
                local item2 = 16213
                local place2 = "the great pyramid"
                local item3 = 48029
                local place3 = "Rhalean's evil sister in the northern barrow"
                step = "gathering Nature's Rage"
            elseif stage == 2 then
                local essence = actor:get_quest_var("creeping_doom:spiders")
                local total = 11 - actor:get_quest_var("creeping_doom:spiders")
                actor:send("You are collecting essences of swarms from flies, insects, spiders, bugs, scorpions, giant ant people, etc.")
                actor:send("</>")
                actor:send("You have found " .. tostring(essence) .. " essences.")
                actor:send("You need to find " .. tostring(total) .. " more.")
                actor:send("</>")
                actor:send("Remember, the tougher the bug, the better your chances of finding essences.")
                return _return_value
            elseif stage == 3 then
                step = "locate three sources of Nature's Vengeance."
                local item1 = 48416
                local place1 = "the elder tremaen in the elemental Plane of Fire"
                local item2 = 52034
                local place2 = "the burning tree in Templace"
                local item3 = 62503
                local place3 = "the Treant in the eldest Rhell's forest"
            elseif stage == 4 then
                actor:send("Take the Essence of Nature's Vengeance and drop it at the entrance to the logging camp, then return to the angry pixie.")
                return _return_value
            elseif stage == 5 then
                actor:send("return to the very angry pixie.")
                return _return_value
            end
            local job1 = actor:get_quest_var("creeping_doom:item1")
            local job2 = actor:get_quest_var("creeping_doom:item2")
            local job3 = actor:get_quest_var("creeping_doom:item3")
            actor:send("You are trying to " .. tostring(step) .. ".")
            actor:send("</>")
            if job1 or job2 or job3 then
                actor:send("You have brought me:")
                if job1 then
                    actor:send("- " .. "%get.obj_shortdesc[%item1%]%")
                end
                if job2 then
                    actor:send("- " .. "%get.obj_shortdesc[%item2%]%")
                end
                if job3 then
                    actor:send("- " .. "%get.obj_shortdesc[%item3%]%")
                end
            end
            actor:send("</>")
            actor:send("You still need:")
            if not job1 then
                actor:send("- " .. "%get.obj_shortdesc[%item1%]% from %place1%.")
            end
            if not job2 then
                actor:send("- " .. "%get.obj_shortdesc[%item2%]% from %place2%.")
            end
            if not job3 then
                actor:send("- " .. "%get.obj_shortdesc[%item3%]% from %place3%.")
            end
        end
    end
end
return _return_value$trig$, '31834e913969da877352f28c7f195be8'),
  -- data/triggers/004/004_36_wall_of_ice_progress_journal.lua
  (4, 36, $trig$-- Converted from DG Script #436: Wall of Ice progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if (string.find(arg, "wall") and string.find(arg, "ice")) or string.find(arg, "wall of ice") or string.find(arg, "wall_ice") or string.find(arg, "wall_of_ice") then
    if string.find(actor.class, "cryomancer") and actor.level >= 50 then
        _return_value = true
        actor:send("<b:green>&uWall of Ice</>")
        actor:send("Minimum Level: 57")
        local status
        if actor:get_has_completed("wall_ice") then
            status = "Completed!"
        elseif actor:get_quest_stage("wall_ice") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor:get_quest_stage("wall_ice") == 1 then
            actor:send("Quest Master: " .. tostring(mobiles.template(533, 16).name))
            actor:send("</>")
            actor:send("Collect 20 blocks of living ice from ice creatures.")
            actor:send("Say \"Crystalize\" in their presence to cast the spell of living ice.")
            local have = actor:get_quest_var("wall_ice:blocks")
            local need = (20 - have)
            actor:send("</>")
            actor:send("You have brought <b:cyan>" .. tostring(have) .. " blocks of living ice.</>")
            actor:send("</>")
            actor:send("You still need <b:cyan>" .. tostring(need) .. "</> more.")
            actor:send("</>")
            actor:send("If you need a new copy of the spell of living ice, return to the sculptor and say, \"<b:cyan>please replace the spell</>\".")
        end
    end
end
return _return_value$trig$, 'aa55bb148215ca6ad899fff0702fd12e'),
  -- data/triggers/004/004_37_flood_progress_journal.lua
  (4, 37, $trig$-- Converted from DG Script #437: Flood progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "flood") then
    if string.find(actor.class, "cryomancer") and actor.level >= 75 then
        _return_value = true
        local stage = actor:get_quest_stage("flood")
        actor:send("<b:green>&uFlood</>")
        actor:send("Minimum Level: 81")
        local status
        if actor:get_has_completed("flood") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("flood") then
            actor:send("Quest Master: " .. tostring(mobiles.template(390, 12).name))
            actor:send("</>")
            if stage == 1 then
                local fog = "The Blue-Fog"
                local phoenix = "Phoenix Feather Hot Springs"
                local falls = "Three-Falls River"
                local green = "The Greengreen Sea"
                local witch = "Sea's Lullaby"
                local frost = "Frost Lake"
                local black = "The Black Lake"
                local kod = "The Dreaming River"
                local water1 = actor:get_quest_var("flood:water1")
                local water2 = actor:get_quest_var("flood:water2")
                local water3 = actor:get_quest_var("flood:water3")
                local water4 = actor:get_quest_var("flood:water4")
                local water5 = actor:get_quest_var("flood:water5")
                local water6 = actor:get_quest_var("flood:water6")
                local water7 = actor:get_quest_var("flood:water7")
                local water8 = actor:get_quest_var("flood:water8")
                local item2 = actor:get_quest_var("flood:item2")
                local item3 = actor:get_quest_var("flood:item3")
                local item4 = actor:get_quest_var("flood:item4")
                local item6 = actor:get_quest_var("flood:item6")
                local item7 = actor:get_quest_var("flood:item7")
                actor:send("Rally the Great Waters of Ethilien for " .. tostring(mobiles.template(390, 12).name) .. ".")
                actor:send("</>")
                if water1 or water2 or water3 or water4 or water5 or water6 or water7 or water8 then
                    actor:send("You have rallied:")
                    if water1 then
                        actor:send("- <blue>" .. tostring(fog) .. "</>")
                    end
                    if water2 then
                        actor:send("- <blue>" .. tostring(phoenix) .. "</>")
                    end
                    if water3 then
                        actor:send("- <blue>" .. tostring(falls) .. "</>")
                    end
                    if water4 then
                        actor:send("- <blue>" .. tostring(green) .. "</>")
                    end
                    if water5 then
                        actor:send("- <blue>" .. tostring(witch) .. "</>")
                    end
                    if water6 then
                        actor:send("- <blue>" .. tostring(frost) .. "</>")
                    end
                    if water7 then
                        actor:send("- <blue>" .. tostring(black) .. "</>")
                    end
                    if water8 then
                        actor:send("- <blue>" .. tostring(kod) .. "</>")
                    end
                    actor:send("</>")
                end
                -- list items to be returned
                actor:send("You must still convince:")
                if not water1 then
                    actor:send("- <b:blue>" .. tostring(fog) .. "</>")
                    actor:send("</>")
                end
                if not water2 then
                    actor:send("- <b:blue>" .. tostring(phoenix) .. "</>")
                    if item2 == 1 then
                        actor:send("</>    Bring it " .. tostring(objects.template(584, 1).name) .. " to heat its springs.")
                        actor:send("</>    Say <b:blue>Spirit I have returned</> when you return.")
                    end
                    actor:send("</>")
                end
                if not water3 then
                    actor:send("- <b:blue>" .. tostring(falls) .. "</>")
                    if item3 == 1 then
                        actor:send("</>    Find a bell and dance for them.")
                        actor:send("</>    Say <b:blue>Spirit I have returned</> when you return.")
                    end
                    actor:send("</>")
                end
                if not water4 then
                    actor:send("- <b:blue>" .. tostring(green) .. "</>")
                    if item4 == 1 then
                        actor:send("</>    Feed her as many different foods as you can until she is full.")
                        actor:send("</>    Say <b:blue>Spirit I have returned</> when you return.")
                    end
                    actor:send("</>")
                end
                if not water5 then
                    actor:send("- <b:blue>" .. tostring(witch) .. "</>")
                    actor:send("</>")
                end
                if not water6 then
                    actor:send("- <b:blue>" .. tostring(frost) .. "</>")
                    if item6 == 1 then
                        actor:send("</>    Force her to join the cause.")
                    end
                    actor:send("</>")
                end
                if not water7 then
                    actor:send("- <b:blue>" .. tostring(black) .. "</>")
                    if item7 == 1 then
                        actor:send("</>    Bring it an eternal light to swallow into its blackness.")
                        actor:send("</>    Say <b:blue>Spirit I have returned</> when you return.")
                    end
                    actor:send("</>")
                end
                if not water8 then
                    actor:send("- <b:blue>" .. tostring(kod) .. "</>")
                    actor:send("</>")
                end
                actor:send("Tell them: <b:blue>the Arabel Ocean calls for aid</> and longs for <b:blue>revenge</>.")
            elseif stage ==2 then
                actor:send("Return the Heart of the Ocean to " .. tostring(mobiles.template(390, 12).name) .. "!")
            end
            actor:send("</>")
            actor:send("If you lost the Heart, say <b:blue>I lost the heart</>.")
        end
    end
end
return _return_value$trig$, '14942e4186a7ff1a135ae2bb5c4e2941'),
  -- data/triggers/004/004_38_ice_shards_progress_journal.lua
  (4, 38, $trig$-- Converted from DG Script #438: Ice Shards progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "ice shards") or string.find(arg, "shards") or string.find(arg, "ice_shards") then
    if string.find(actor.class, "cryomancer") and actor.level >= 85 then
        _return_value = true
        local stage = actor:get_quest_stage("ice_shards")
        actor:send("<b:green>&uIce Shards</>")
        actor:send("Minimum Level: 89")
        local status
        if actor:get_has_completed("ice_shards") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("ice_shards") then
            actor:send("Quest Master: " .. tostring(mobiles.template(103, 0).name))
            actor:send("</>")
            -- switch on stage
            if stage == 1 then
                local book1 = actor:get_quest_var("ice_shards:16209")
                local book2 = actor:get_quest_var("ice_shards:18505")
                local book3 = actor:get_quest_var("ice_shards:55003")
                local book4 = actor:get_quest_var("ice_shards:58415")
                actor:send("You are looking for four books of mystic knowledge.")
                if book1 or book2 or book3 or book4 then
                    actor:send("</>")
                    actor:send("You have brought me:")
                    if book1 then
                        actor:send("- <b:yellow>" .. tostring(objects.template(162, 9).name) .. "</>")
                    end
                    if book2 then
                        actor:send("- <b:yellow>" .. tostring(objects.template(185, 5).name) .. "</>")
                    end
                    if book3 then
                        actor:send("- <b:yellow>" .. tostring(objects.template(550, 3).name) .. "</>")
                    end
                    if book4 then
                        actor:send("- <b:yellow> " .. tostring(objects.template(584, 15).name) .. "</>")
                    end
                end
                actor:send("</>")
                actor:send("You still need to find:")
                if not book1 then
                    actor:send("- <b:yellow>" .. tostring(objects.template(162, 9).name) .. "</>")
                end
                if not book2 then
                    actor:send("- <b:yellow>" .. tostring(objects.template(185, 5).name) .. "</>")
                end
                if not book3 then
                    actor:send("- <b:yellow>" .. tostring(objects.template(550, 3).name) .. "</>")
                end
                if not book4 then
                    actor:send("- <b:yellow>" .. tostring(objects.template(584, 15).name) .. "</>")
                end
            elseif stage == 2 then
                actor:send("Find the Codex of War.")
            elseif stage == 3 then
                actor:send("You are looking for any records or journals Commander Thraja keeps.")
            elseif stage == 4 then
                actor:send("Talk to the pawnbroker in Anduin about the Butcher of Anduin so you can find his map.")
            elseif stage == 5 then
                actor:send("Talk to Slevvirik in Ogakh about the Butcher of Anduin so you can find his map.")
            elseif stage == 6 then
                actor:send("Bring the map of Ickle from the Butcher of Anduin.")
            elseif stage == 7 then
                actor:send("You are looking for any kind of written clues about the library at Shiran in Ysgarran's Keep in Frost Valley.")
            elseif stage == 8 then
                actor:send("You are looking for the Book of Redemption, whatever that is.")
            elseif stage == 9 then
                actor:send("You are looking for the lost library of Shiran in Frost Valley!")
            elseif stage == 10 then
                actor:send("Bring Aqua Mundi to Khysan!")
            end
        end
    end
end
return _return_value$trig$, 'cd3576a6f6f50cd8380b06fb1d2cd9b5'),
  -- data/triggers/004/004_39_waterform_progress_journal.lua
  (4, 39, $trig$-- Converted from DG Script #439: Waterform progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "waterform") then
    if string.find(actor.class, "cryomancer") and actor.level >= 65 then
        _return_value = true
        local stage = actor:get_quest_stage("waterform")
        actor:send("<b:green>&uWaterform</>")
        actor:send("Minimum Level: 73")
        local status
        if actor:get_has_completed("waterform") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("waterform") then
            local master = mobiles.template(28, 10).name
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            -- switch on stage
            if stage == 1 then
                actor:send("Find a piece of armor made of water to serve as the basis of your new form.")
            elseif stage == 2 then
                actor:send("You need a special vessel to gather water in.  Kill Tri-Aszp and get a large bone from her.")
            elseif stage == 3 then
                actor:send("You need a special vessel to gather water in.  Give " .. tostring(master) .. " the large bone from a grown white dragon so it can make you one.")
            elseif stage == 4 then
                local region1 = actor:get_quest_var("waterform:region1")
                local region2 = actor:get_quest_var("waterform:region2")
                local region3 = actor:get_quest_var("waterform:region3")
                local region4 = actor:get_quest_var("waterform:region4")
                local region5 = actor:get_quest_var("waterform:region5")
                actor:send("Collect samples of living water from four different regions.")
                if region1 or region2 or region3 or region4 or region5 then
                    actor:send("</>")
                    actor:send("You already have samples from:")
                    if region1 then
                        actor:send("- <blue>The Blue Fog trails and waters</>")
                    end
                    if region2 then
                        actor:send("- <blue>Nordus</>")
                    end
                    if region3 then
                        actor:send("- <blue>Layveran Labyrinth</>")
                    end
                    if region4 then
                        actor:send("- <blue>The Elemental Plane of Water</>")
                    end
                    if region5 then
                        actor:send("- <blue>The sunken castle</>")
                    end
                end
                actor:send("</>")
                local samples = 4 - (region1 + region2 + region3 + region4 + region5)
                actor:send("You need <b:blue>" .. tostring(samples) .. "</> more.")
            elseif stage == 5 then
                actor:send("Give " .. tostring(master) .. " the cup so it can see the samples.")
            elseif stage == 6 then
                local water1 = actor:get_quest_var("waterform:3296")
                local water2 = actor:get_quest_var("waterform:58405")
                local water3 = actor:get_quest_var("waterform:53319")
                local water4 = actor:get_quest_var("waterform:55804")
                local water5 = actor:get_quest_var("waterform:58701")
                local water6 = actor:get_quest_var("waterform:37014")
                actor:send("You are looking for six unique sources of water.")
                if water1 or water2 or water3 or water4 or water5 or water6 then
                    actor:send("</>")
                    actor:send("You have already analyzed water from:")
                    if water1 then
                        actor:send("- <blue>a granite pool in the village of Mielikki</>")
                    end
                    if water2 then
                        actor:send("- <blue>a sparkling artesian well in the Realm of the King of Dreams</>")
                    end
                    if water3 then
                        actor:send("- <blue>a crystal clear fountain in the caverns of the Ice Cult</>")
                    end
                    if water4 then
                        actor:send("- <blue>the creek in the Eldorian Foothills</>")
                    end
                    if water5 then
                        actor:send("- <blue>the wishing well at the Dancing Dolphin in South Caelia</>")
                    end
                    if water6 then
                        actor:send("- <blue>an underground brook in the Minithawkin Mines</>")
                    end
                end
                actor:send("</>")
                actor:send("You still need to analyze water from:")
                if not water1 then
                    actor:send("- <b:cyan>a granite pool in the village of Mielikki</>")
                end
                if not water2 then
                    actor:send("- <b:cyan>a sparkling artesian well in the Realm of the King of Dreams</>")
                end
                if not water3 then
                    actor:send("- <b:cyan>a crystal clear fountain in the caverns of the Ice Cult</>")
                end
                if not water4 then
                    actor:send("- <b:cyan>the creek in the Eldorian Foothills</>")
                end
                if not water5 then
                    actor:send("- <b:cyan>the wishing well at the Dancing Dolphin in South Caelia</>")
                end
                if not water6 then
                    actor:send("- <b:cyan>an underground brook in the Minithawkin Mines</>")
                end
            elseif stage == 7 then
                actor:send("Just return the cup to " .. tostring(master) .. " and you're done!")
            end
            if stage > 3 then
                actor:send("</>")
                actor:send("If you need a new cup, return to " .. tostring(master) .. " and say \"<b:yellow>I need a new cup</>\".")
            end
        end
    end
end
return _return_value$trig$, '8b828a1b9747650a2ce6d34d891d5459'),
  -- data/triggers/004/004_40_shift_corpse_progress_journal.lua
  (4, 40, $trig$-- Converted from DG Script #440: Shift Corpse progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "shift") or string.find(arg, "corpse") or string.find(arg, "shift_corpse") then
    if string.find(actor.class, "necromancer") and actor.level >= 90 then
        _return_value = true
        local stage = actor:get_quest_stage("shift_corpse")
        actor:send("<b:green>&uShift Corpse</>")
        actor:send("Minimum Level: 97")
        local status
        if actor:get_has_completed("shift_corpse") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("shift_corpse") then
            actor:send("Quest Master: the necromancer guild masters")
            actor:send("</>")
            if stage == 1 then
                actor:send("Steal the divine spark of Lokari, God of the Moonless Night.")
                actor:send("</>")
                actor:send("Give him " .. tostring(objects.template(62, 28).name) .. ", then destroy him.")
                actor:send("</>")
                actor:send("If you need a new crystal, say &9<blue>\"I need a new crystal\"</>.")
            elseif stage == 2 then
                actor:send("Destroy Lokari!")
            end
        end
    end
end
return _return_value$trig$, '9db4e594d36a8131dde1aa513cf0cd4f'),
  -- data/triggers/004/004_41_degeneration_progress_journal.lua
  (4, 41, $trig$-- Converted from DG Script #441: Degeneration progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "degeneration") then
    if string.find(actor.class, "necromancer") and actor.level >= 75 then
        _return_value = true
        local stage = actor:get_quest_stage("degeneration")
        actor:send("<b:green>&uDegeneration</>")
        actor:send("Minimum Level: 81")
        local status
        if actor:get_has_completed("degeneration") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage and not actor:get_has_completed("degeneration") then
            actor:send("Quest Master: " .. tostring(mobiles.template(55, 26).name))
            actor:send("</>")
            -- switch on stage
            if stage == 1 then
                actor:send("Find Yajiro in Odaishyozen and bring back his book.")
            elseif stage == 2 then
                actor:send("Find Mesmeriz in the Minithawkin Mines and bring back his necklace.")
            elseif stage == 3 then
                actor:send("Find Luchiaans in Nordus and bring back his mask.")
            elseif stage == 4 then
                actor:send("Find Voliangloch in Demise Keep and bring back his rod.")
            elseif stage == 5 then
                actor:send("Find Kryzanthor in the Graveyard and bring back his robe.")
            elseif stage == 6 then
                actor:send("Find Ureal the Lich in the Barrow and bring back his statuette.")
            elseif stage == 7 or stage == 8 then
                actor:send("Find Norisent in the Cathedral of Betrayal and bring back his book.")
            elseif stage == 9 then
                actor:send("Find the enormous ruby hidden under a stairway.")
            end
        end
    end
end
return _return_value$trig$, '4ec0d9c9aed1db786359f1639dde0644'),
  -- data/triggers/004/004_42_wizard_eye_progress_journal.lua
  (4, 42, $trig$-- Converted from DG Script #442: Wizard Eye progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "wizard eye") or string.find(arg, "wizard") or string.find(arg, "wizard_eye") then
    if string.find(actor.class, "sorcerer") and actor.level >= 75 then
        _return_value = true
        local stage = actor:get_quest_stage("wizard_eye")
        local item1 = actor:get_quest_var("wizard_eye:item1")
        local item2 = actor:get_quest_var("wizard_eye:item2")
        local item3 = actor:get_quest_var("wizard_eye:item3")
        local item4 = actor:get_quest_var("wizard_eye:item4")
        actor:send("<b:green>&uWizard Eye</>")
        actor:send("Minimum Level: 81")
        local status
        if actor:get_has_completed("wizard_eye") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("wizard_eye") then
            local master = mobiles.template(550, 13).name
            -- switch on stage
            local task
            local thing1
            local thing2
            local thing3
            local thing4
            if stage == 1 then
                master = mobiles.template(324, 10).name
                task = "You are trying to find " .. tostring(master) .. " in South Caelia Highlands to ask her about Wizard Eye."
            elseif stage == 2 then
                task = "Find marigold poultice from a healer on the beachhead and give it to " .. tostring(master) .. "."
            elseif stage == 3 then
                master = mobiles.template(490, 3).name
                task = "Go visit " .. tostring(master) .. " of Griffin Isle to ask her about Wizard Eye and see what you need to do next."
            elseif stage == 4 then
                master = mobiles.template(490, 3).name
                task = "Have " .. tostring(master) .. " make you an herbal sachet."
                thing1 = objects.template(23, 29).name
                thing2 = objects.template(237, 53).name
                thing3 = objects.template(480, 5).name
            elseif stage == 5 then
                task = "Give " .. tostring(master) .. " the sachet."
            elseif stage == 6 then
                task = "You are looking for the apothecary in Anduin."
            elseif stage == 7 then
                master = mobiles.template(60, 22).name
                task = "Get The Green Woman to make you incense."
                thing1 = objects.template(237, 54).name
                thing2 = objects.template(30, 298).name
                thing3 = objects.template(238, 47).name
                thing4 = objects.template(180, 1).name
            elseif stage == 8 then
                task = "Give " .. tostring(master) .. " the incense."
            elseif stage == 9 or stage == 10 then
                master = mobiles.template(484, 10).name
                thing1 = objects.template(30, 218).name
                thing2 = objects.template(534, 24).name
                thing3 = objects.template(430, 21).name
                thing4 = objects.template(40, 3).name
                task = "See the Oracle of Justice."
            elseif stage == 11 then
                task = "Give " .. tostring(master) .. " the crystal ball."
            elseif stage == 12 then
                task = "Return to " .. tostring(master) .. " and lay back and go to sleep."
            end
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            actor:send(tostring(task))
            if stage == 4 or stage == 7 or stage == 10 then
                if item1 or item2 or item3 or item4 then
                    actor:send("</>")
                    actor:send("You have already brought:")
                    if item1 then
                        actor:send("- " .. tostring(thing1))
                    end
                    if item2 then
                        actor:send("- " .. tostring(thing2))
                    end
                    if item3 then
                        actor:send("- " .. tostring(thing3))
                    end
                    if item4 then
                        actor:send("- " .. tostring(thing4))
                    end
                end
                actor:send("</>")
                actor:send("You still need to bring:")
                if not item1 then
                    actor:send("- " .. tostring(thing1))
                end
                if not item2 then
                    actor:send("- " .. tostring(thing2))
                end
                if not item3 then
                    actor:send("- " .. tostring(thing3))
                end
                if stage ~= 4 then
                    if not item4 then
                        actor:send("- " .. tostring(thing4))
                    end
                end
            end
        end
    end
end
return _return_value$trig$, '358dbb1a8e3e0202bfb2c3ac55349f11'),
  -- data/triggers/004/004_43_blur_progress_journal.lua
  (4, 43, $trig$-- Converted from DG Script #443: Blur progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "blur") then
    if string.find(actor.class, "ranger") and actor.level >= 75 then
        _return_value = true
        local east = actor:get_quest_var("blur:east")
        local etimer = actor:get_quest_var("blur:east_timer")
        local west = actor:get_quest_var("blur:west")
        local wtimer = actor:get_quest_var("blur:west_timer")
        local north = actor:get_quest_var("blur:north")
        local ntimer = actor:get_quest_var("blur:north_timer")
        local south = actor:get_quest_var("blur:south")
        local stimer = actor:get_quest_var("blur:south_timer")
        local timer = actor:get_quest_var("blur:timer")
        local stage = actor:get_quest_stage("blur")
        local master = mobiles.template(18, 18).name
        actor:send("<b:green>&uBlur</>")
        actor:send("Minimum Level: 81")
        local status
        if actor:get_has_completed("blur") then
            status = "Completed!"
        elseif actor:get_has_failed("blur") then
            status = "Failed"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if not stage then
            actor:send("Heal the spirits in the Forest of Shadows.")
        elseif actor:get_has_failed("blur") then
            actor:send("Find " .. tostring(master) .. " to restart the races.")
        elseif not actor:get_has_completed("blur") then
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            -- switch on stage
            if stage == 1 then
                actor:send("Seek out the ranger of the Forest of Shadows.")
            elseif stage == 2 then
                actor:send("Seek out and kill the Syric Warder and bring me his sword.")
            elseif stage == 3 then
                actor:send("Give " .. tostring(master) .. " the Blade of the Forgotten Kings.")
            elseif stage == 4 then
                actor:send("It's time to race the four winds!")
                if actor:get_quest_var("blur:race") ~= "go" then
                    actor:send("Return to " .. tostring(master) .. " and say \"Let's begin\" to start the race.")
                else
                    local minutes = (timer / 60)
                    local seconds = timer - (minutes * 60)
                    actor:send("You have " .. tostring(minutes) .. " mins " .. tostring(seconds) .. " secs remaining to race all four winds!")
                    actor:send("</>")
                    if not north then
                        actor:send("The North Wind blows near the frozen town of Ickle.")
                    elseif north == 1 then
                        local room = get_room("30262")
                        actor:send("Beat the North Wind to " .. tostring(room.name) .. " in Bluebonnet Pass.")
                        local minutes = (ntimer / 60)
                        local seconds = ntimer - (minutes * 60)
                        actor:send("You have " .. tostring(minutes) .. " mins " .. tostring(seconds) .. " secs remaining to race the North Wind!")
                    elseif north == 2 then
                        actor:send("You have won the race against the North Wind!")
                    end
                    actor:send("</>")
                    if not south then
                        actor:send("The South Wind blows around the hidden standing stones in South Caelia.")
                    elseif south == 1 then
                        local room = get_room("53557")
                        actor:send("Beat the South Wind to " .. tostring(room.name) .. ".")
                        local minutes = (stimer / 60)
                        local seconds = stimer - (minutes * 60)
                        actor:send("You have " .. tostring(minutes) .. " mins " .. tostring(seconds) .. " secs remaining to race the South Wind!")
                    elseif south == 2 then
                        actor:send("You have won the race against the South Wind!")
                    end
                    actor:send("</>")
                    if not east then
                        actor:send("The East Wind blows through an enormous volcano in the sea.")
                    elseif east == 1 then
                        local room = get_room("12597")
                        actor:send("Beat the East Wind to " .. tostring(room.name) .. ".")
                        local minutes = (etimer / 60)
                        local seconds = etimer - (minutes * 60)
                        actor:send("You have " .. tostring(minutes) .. " mins " .. tostring(seconds) .. " secs remaining to race the East Wind!")
                    elseif east == 2 then
                        actor:send("You have won the race against the East Wind!")
                    end
                    actor:send("</>")
                    if not west then
                        actor:send("The West Wind blows through ruins across the vast Gothra plains.")
                    elseif west == 1 then
                        local room = get_room("4236")
                        actor:send("Beat the West Wind to " .. tostring(room.name) .. ".")
                        local minutes = (wtimer / 60)
                        local seconds = wtimer - (minutes * 60)
                        actor:send("You have " .. tostring(minutes) .. " mins " .. tostring(seconds) .. " secs remaining to race the West Wind!")
                    elseif west == 2 then
                        actor:send("You have won the race against the West Wind!")
                    end
                end
            end
        end
    end
end
return _return_value$trig$, 'bc2e193edbef5f8513a6e0601369148a'),
  -- data/triggers/004/004_44_charm_person_progress_journal.lua
  (4, 44, $trig$-- Converted from DG Script #444: Charm Person progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "charm") or string.find(arg, "person") or string.find(arg, "charm_person") then
    if actor.level >= 85 then
        if string.find(actor.class, "sorcerer") or string.find(actor.class, "bard") or string.find(actor.class, "illusionist") then
            _return_value = true
            local master = mobiles.template(580, 38).name
            local stage = actor:get_quest_stage("charm_person")
            actor:send("<b:green>&uCharm Person</>")
            actor:send("Minimum Level: 89")
            local status
            if actor:get_has_completed("charm_person") then
                status = "Completed!"
            elseif stage then
                status = "In Progress"
            else
                status = "Not Started"
            end
            actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            if stage > 0 and not actor:get_has_completed("charm_person") then
                actor:send("Quest Master: " .. tostring(master))
                actor:send("</>")
                -- switch on stage
                if stage == 1 then
                    actor:send("You must find the rod that casts Charm Person in the crypt in the Iron Hills.")
                elseif stage == 2 then
                    actor:send("Help the theatre company in Anduin perform their grand finale and bring back the unique fire ring they give out afterward.")
                    actor:send("</>")
                    actor:send("They have a number of problems which you will need to work out before you can seek out their replacement \"Pippin\" and lure him to his fiery grave.")
                elseif stage == 3 then
                    local item1 = actor:get_quest_var("charm_person:58017")
                    local item2 = actor:get_quest_var("charm_person:16312")
                    local item3 = actor:get_quest_var("charm_person:48925")
                    local item4 = actor:get_quest_var("charm_person:37012")
                    local item5 = actor:get_quest_var("charm_person:41119")
                    actor:send("Locate five musical instruments and bring them to " .. tostring(master) .. ".")
                    if item1 or item2 or item3 or item4 or item5 then
                        actor:send("</>")
                        actor:send("You have already brought:")
                        if item1 then
                            actor:send("- <magenta>" .. tostring(objects.template(580, 17).name) .. "</>")
                        end
                        if item2 then
                            actor:send("- <magenta>" .. tostring(objects.template(163, 12).name) .. "</>")
                        end
                        if item3 then
                            actor:send("- <magenta>" .. tostring(objects.template(489, 25).name) .. "</>")
                        end
                        if item4 then
                            actor:send("- <magenta>" .. tostring(objects.template(370, 12).name) .. "</>")
                        end
                        if item5 then
                            actor:send("- <magenta>" .. tostring(objects.template(411, 19).name) .. "</>")
                        end
                    end
                    actor:send("</>")
                    actor:send("You still need to find:")
                    if not item1 then
                        actor:send("- <b:magenta>" .. tostring(objects.template(580, 17).name) .. "</>")
                    end
                    if not item2 then
                        actor:send("- <b:magenta>" .. tostring(objects.template(163, 12).name) .. "</>")
                    end
                    if not item3 then
                        actor:send("- <b:magenta>" .. tostring(objects.template(489, 25).name) .. "</>")
                    end
                    if not item4 then
                        actor:send("- <b:magenta>" .. tostring(objects.template(370, 12).name) .. "</>")
                    end
                    if not item5 then
                        actor:send("- <b:magenta>" .. tostring(objects.template(411, 19).name) .. "</>")
                    end
                elseif stage == 4 then
                    local charm1 = actor:get_quest_var("charm_person:charm1")
                    local charm2 = actor:get_quest_var("charm_person:charm2")
                    local charm3 = actor:get_quest_var("charm_person:charm3")
                    local charm4 = actor:get_quest_var("charm_person:charm4")
                    local charm5 = actor:get_quest_var("charm_person:charm5")
                    actor:send("You must charm the five master charmers.  Ask them <b:white>[Let me serenade you]</>.")
                    if charm1 or charm2 or charm3 or charm4 or charm5 then
                        actor:send("</>")
                        actor:send("You have already charmed:")
                        if charm1 then
                            actor:send("- <magenta>" .. tostring(mobiles.template(30, 10).name) .. "</>")
                        end
                        if charm2 then
                            actor:send("- <magenta>" .. tostring(mobiles.template(580, 17).name) .. "</>")
                        end
                        if charm3 then
                            actor:send("- <magenta>" .. tostring(mobiles.template(43, 53).name) .. "</>")
                        end
                        if charm4 then
                            actor:send("- <magenta>" .. tostring(mobiles.template(237, 21).name) .. "</>")
                        end
                        if charm5 then
                            actor:send("- <magenta>" .. tostring(mobiles.template(584, 6).name) .. "</>")
                        end
                    end
                    actor:send("</>")
                    actor:send("You still need to find:")
                    if not charm1 then
                        actor:send("- <b:magenta>" .. tostring(mobiles.template(30, 10).name) .. "</>")
                    end
                    if not charm2 then
                        actor:send("- <b:magenta>" .. tostring(mobiles.template(580, 17).name) .. "</>")
                    end
                    if not charm3 then
                        actor:send("- <b:magenta>" .. tostring(mobiles.template(43, 53).name) .. "</>")
                    end
                    if not charm4 then
                        actor:send("- <b:magenta>" .. tostring(mobiles.template(237, 21).name) .. "</>")
                    end
                    if not charm5 then
                        actor:send("- <b:magenta>" .. tostring(mobiles.template(584, 6).name) .. "</>")
                    end
                end
            end
        end
    end
end
return _return_value$trig$, 'c8203b11a642f419d86c28028948e33b'),
  -- data/triggers/004/004_45_hell_gate_progress_journal.lua
  (4, 45, $trig$-- Converted from DG Script #445: Hell Gate progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "hell gate") or string.find(arg, "hell_gate") then
    if string.find(actor.class, "diabolist") and actor.level >= 75 then
        _return_value = true
        local stage = actor:get_quest_stage("hell_gate")
        local master = mobiles.template(564, 0).name
        actor:send("<b:green>&uHell Gate</>")
        actor:send("Minimum Level: 81")
        local status
        if actor:get_has_completed("hell_gate") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("hell_gate") then
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            -- switch on stage
            if stage == 1 then
                actor:send("You are preparing to open a door to Garl'lixxil and release one of the demon lords.  Find " .. tostring(objects.template(30, 213).name) .. ".")
            elseif stage == 2 then
                local key1 = actor:get_quest_var("hell_gate:8303")
                local key2 = actor:get_quest_var("hell_gate:23709")
                local key3 = actor:get_quest_var("hell_gate:49008")
                local key4 = actor:get_quest_var("hell_gate:52012")
                local key5 = actor:get_quest_var("hell_gate:52013")
                local key6 = actor:get_quest_var("hell_gate:53402")
                local key7 = actor:get_quest_var("hell_gate:58109")
                actor:send("Find seven keys to seven gates.")
                if key1 or key2 or key3 or key4 or key5 or key6 or key7 then
                    actor:send("</>")
                    actor:send("You have already found:")
                    if key1 then
                        actor:send("<red>" .. tostring(objects.template(83, 3).name) .. "</>")
                    end
                    if key2 then
                        actor:send("<red>" .. tostring(objects.template(237, 9).name) .. "</>")
                    end
                    if key3 then
                        actor:send("<red>" .. tostring(objects.template(490, 8).name) .. "</>")
                    end
                    if key4 then
                        actor:send("<red>" .. tostring(objects.template(520, 12).name) .. "</>")
                    end
                    if key5 then
                        actor:send("<red>" .. tostring(objects.template(520, 13).name) .. "</>")
                    end
                    if key6 then
                        actor:send("<red>" .. tostring(objects.template(534, 2).name) .. "</>")
                    end
                    if key7 then
                        actor:send("<red>" .. tostring(objects.template(580, 109).name) .. "</>")
                    end
                end
                actor:send("</>")
                actor:send("You must still find:")
                if not key1 then
                    actor:send("<b:red>A small, well-crafted key made of wood with the smell of rich sap</>")
                    actor:send("<b:red>Kept at the gate of a tribe's home.</>")
                    actor:send("</>")
                end
                if not key6 then
                    actor:send("<b:red>A key made of light silvery metal which only elves can work</>")
                    actor:send("<b:red>Deep in a frozen valley.</>")
                    actor:send("</>")
                end
                if not key2 then
                    actor:send("<b:red>A large, black key humming with magical energy</>")
                    actor:send("<b:red>From a twisted cruel city in a huge underground cavern.</>")
                    actor:send("</>")
                end
                if not key7 then
                    actor:send("<b:red>A simple lacquered iron key</>")
                    actor:send("<b:red>In the care of a radiant bird on an emerald island.</>")
                    actor:send("</>")
                end
                if not key3 then
                    actor:send("<b:red>A rusted but well cared for key</>")
                    actor:send("<b:red>Held by a winged captain on an island of magical beasts.</>")
                    actor:send("</>")
                end
                if not key5 then
                    actor:send("<b:red>A golden plated, wrought-iron key</>")
                    actor:send("<b:red>held at the gates to a desacrated city.</>")
                    actor:send("</>")
                end
                if not key4 then
                    actor:send("<b:red>One nearly impossible to see</>")
                    actor:send("<b:red>guarded by a fiery beast with many heads.</>")
                end
            elseif stage == 3 then
                local blood1 = actor:get_quest_var("hell_gate:56400")
                local blood2 = actor:get_quest_var("hell_gate:56401")
                local blood3 = actor:get_quest_var("hell_gate:56402")
                local blood4 = actor:get_quest_var("hell_gate:56403")
                local blood5 = actor:get_quest_var("hell_gate:56404")
                local blood6 = actor:get_quest_var("hell_gate:56405")
                local blood7 = actor:get_quest_var("hell_gate:56406")
                actor:send("Sacrifice seven different <b:red>children</>.")
                actor:send("</><b:white>[Drop]</> their <b:red>blood</> before " .. tostring(master) .. " to defile the keys.")
                if blood1 or blood2 or blood3 or blood4 or blood5 or blood6 or blood7 then
                    actor:send("</>")
                    actor:send("You have already found:")
                    if blood1 then
                        actor:send("<red>" .. tostring(objects.template(564, 0).name) .. "</>")
                    end
                    if blood2 then
                        actor:send("<red>" .. tostring(objects.template(564, 1).name) .. "</>")
                    end
                    if blood3 then
                        actor:send("<red>" .. tostring(objects.template(564, 2).name) .. "</>")
                    end
                    if blood4 then
                        actor:send("<red>" .. tostring(objects.template(564, 3).name) .. "</>")
                    end
                    if blood5 then
                        actor:send("<red>" .. tostring(objects.template(564, 4).name) .. "</>")
                    end
                    if blood6 then
                        actor:send("<red>" .. tostring(objects.template(564, 5).name) .. "</>")
                    end
                    if blood7 then
                        actor:send("<red>" .. tostring(objects.template(564, 6).name) .. "</>")
                    end
                end
                actor:send("</>")
                local total = (7 - (blood1 + blood2 + blood3 + blood4 + blood5 + blood6 + blood7))
                if total == 1 then
                    actor:send("Sacrifice the last child!")
                else
                    actor:send("Bring the blood of <red>" .. tostring(total) .. "</> more children.")
                end
                actor:send("</>")
                actor:send("If you need a new dagger, return to " .. tostring(master) .. " and say, <b:red>\"I need a new dagger\"</>.")
            elseif stage == 4 then
                actor:send("Give the spider-shaped dagger back to " .. tostring(master) .. ".")
            elseif stage == 5 then
                actor:send("Slay Larathiel and release the demon lord!")
            end
        end
    end
end
return _return_value$trig$, 'fd05e2b5ceba652c3dabfe85063c793d'),
  -- data/triggers/004/004_46_hellfire_and_brimstone_progress_journal.lua
  (4, 46, $trig$-- Converted from DG Script #446: Hellfire and Brimstone progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "hellfire") or string.find(arg, "brimstone") or string.find(arg, "hellfire_and_brimstone") or string.find(arg, "hellfire_brimstone") then
    if string.find(actor.class, "diabolist") and actor.level >= 50 then
        _return_value = true
        local master = mobiles.template(23, 11).name
        local stage = actor:get_quest_stage("hellfire_brimstone")
        actor:send("<b:green>&uHellfire and Brimstone</>")
        actor:send("Minimum Level: 57")
        local status
        if actor:get_has_completed("hellfire_brimstone") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("hellfire_brimstone") then
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            -- switch on stage
            if stage == 1 then
                local meat = actor:get_quest_var("hellfire_brimstone:meat")
                actor:send(tostring(master) .. " needs <b:red>meat</> for the fire.")
                local total = (6 - meat)
                if total == 1 then
                    actor:send("Drop <b:red>" .. tostring(total) .. "</> more pound of flesh from the paladins at the Sacred Haven into the bonfire.")
                else
                    actor:send("Drop <b:red>" .. tostring(total) .. "</> pounds of flesh from the paladins at the Sacred Haven into the bonfire.")
                end
            elseif stage == 2 then
                local brimstone = actor:get_quest_var("hellfire_brimstone:brimstone")
                actor:send(tostring(master) .. " needs <b:yellow>brimstone</> to trace out the sigils.")
                -- (empty send to actor)
                local total = (6 - brimstone)
                if total == 1 then
                    actor:send("Bring <b:yellow>" .. tostring(total) .. "</> more quantity of brimstone from fiery spirits on the volcanic island to the north and drop them into the bonfire.")
                else
                    actor:send("Bring <b:yellow>" .. tostring(total) .. "</> quantities of brimstone from fiery spirits on the volcanic island to the north and drop it into the bonfire.")
                end
            elseif stage == 3 then
                local item1 = actor:get_quest_var("hellfire_brimstone:4318")
                local item2 = actor:get_quest_var("hellfire_brimstone:5211")
                local item3 = actor:get_quest_var("hellfire_brimstone:5212")
                local item4 = actor:get_quest_var("hellfire_brimstone:17308")
                local item5 = actor:get_quest_var("hellfire_brimstone:48110")
                local item6 = actor:get_quest_var("hellfire_brimstone:53000")
                actor:send("You are to bring " .. tostring(master) .. " fiery tributes to the Dark One.")
                actor:send("</>")
                if item1 or item2 or item3 or item4 or item5 or item6 then
                    actor:send("You have already given him:")
                    if item1 then
                        actor:send("- " .. tostring(objects.template(43, 18).name))
                    end
                    if item2 then
                        actor:send("- " .. tostring(objects.template(52, 11).name))
                    end
                    if item3 then
                        actor:send("- " .. tostring(objects.template(52, 12).name))
                    end
                    if item4 then
                        actor:send("- " .. tostring(objects.template(173, 8).name))
                    end
                    if item5 then
                        actor:send("- " .. tostring(objects.template(481, 10).name))
                    end
                    if item6 then
                        actor:send("- " .. tostring(objects.template(530, 0).name))
                    end
                end
                actor:send("</>")
                actor:send("Now bring him:")
                if not item1 then
                    actor:send("- " .. tostring(objects.template(43, 18).name) .. "</> from an actress in Anduin.</>")
                end
                if not item2 then
                    actor:send("- <b:white>" .. tostring(objects.template(52, 11).name) .. "</> from a beam of starlight deep in mine.</>")
                end
                if not item3 then
                    actor:send("- <blue>" .. tostring(objects.template(52, 12).name) .. "</> from a devotee of neutrality on a hill.</>")
                end
                if not item4 then
                    actor:send("- &9<blue>" .. tostring(objects.template(173, 8).name) .. " from Chaos incarnate.</>")
                end
                if not item5 then
                    actor:send("- <b:red>" .. tostring(objects.template(481, 10).name) .. "</> from the volcano goddess.</>")
                end
                if not item6 then
                    actor:send("- " .. tostring(objects.template(530, 0).name) .. "</> from a king in a throne room crypt.</>")
                end
            end
        end
    end
end
return _return_value$trig$, '65584a9cd65e61a1faca8fd7d58dcaf0'),
  -- data/triggers/004/004_47_illusory_wall_progress_journal.lua
  (4, 47, $trig$-- Converted from DG Script #447: Illusory Wall progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "illusory") or string.find(arg, "illusory wall") or string.find(arg, "illusory_wall") then
    if (string.find(actor.class, "illusionist") or string.find(actor.class, "bard")) and actor.level >= 50 then
        _return_value = true
        local stage = actor:get_quest_stage("illusory_wall")
        local master = mobiles.template(364, 2).name
        actor:send("<b:green>&uIllusory Wall</>")
        actor:send("Minimum Level: 57")
        local status
        if actor:get_has_completed("illusory_wall") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("illusory_wall") then
            actor:send("Quest Master: " .. tostring(master))
            -- switch on stage
            if stage == 1 then
                local item1 = actor:get_quest_var("illusory_wall:10307")
                local item2 = actor:get_quest_var("illusory_wall:18511")
                local item3 = actor:get_quest_var("illusory_wall:41005")
                local item4 = actor:get_quest_var("illusory_wall:51017")
                actor:send("You're looking for things to make magical spectacles.")
                if item1 or item2 or item3 or item4 then
                    actor:send("</>")
                    actor:send("</>You have already brought me:")
                    if item1 then
                        actor:send("- <b:white>" .. tostring(objects.template(103, 7).name) .. "</>")
                    end
                    if item2 then
                        actor:send("- <b:white>" .. tostring(objects.template(185, 11).name) .. "</>")
                    end
                    if item3 then
                        actor:send("- <b:white>" .. tostring(objects.template(410, 5).name) .. "</>")
                    end
                    if item4 then
                        actor:send("- <b:white>" .. tostring(objects.template(510, 17).name) .. "</>")
                    end
                end
                actor:send("</>")
                actor:send("You still need to find:")
                if not item1 and not item2 then
                    actor:send("- <b:yellow>" .. "%get.obj_shortdesc[10307]%</> or <b:yellow>%get.obj_shortdesc[18511]%</>")
                end
                if not item3 then
                    actor:send("- <b:yellow>" .. tostring(objects.template(410, 5).name) .. "</>")
                end
                if not item4 then
                    actor:send("- <b:yellow>" .. tostring(objects.template(510, 17).name) .. "</>")
                end
            elseif stage == 2 then
                actor:send("Complete your study of doors in 20 regions.")
                actor:send("</>")
                local doors = actor:get_quest_var("illusory_wall:total")
                actor:send("You have examined doors in <b:magenta>" .. tostring(doors) .. "</> regions:")
                if actor:get_quest_var("illusory_wall:Outback") then
                    actor:send("- <blue>Rocky Outback</>")
                end
                if actor:get_quest_var("illusory_wall:Shadows") then
                    actor:send("- <blue>Forest of Shadows</>")
                end
                if actor:get_quest_var("illusory_wall:Merchant") then
                    actor:send("- <blue>Old Merchant Trail</>")
                end
                if actor:get_quest_var("illusory_wall:Caelia_West") then
                    actor:send("- <blue>South Caelia West</>")
                end
                if actor:get_quest_var("illusory_wall:River") then
                    actor:send("- <blue>Blue-Fog River</>")
                end
                if actor:get_quest_var("illusory_wall:Mielikki") then
                    actor:send("- <blue>The Village of Mielikki</>")
                end
                if actor:get_quest_var("illusory_wall:Mielikki_Forest") then
                    actor:send("- <blue>Mielikki's Forests</>")
                end
                if actor:get_quest_var("illusory_wall:Labyrinth") then
                    actor:send("- <blue>Laveryn Labyrinth</>")
                end
                if actor:get_quest_var("illusory_wall:Split") then
                    actor:send("- <blue>Split Skull</>")
                end
                if actor:get_quest_var("illusory_wall:Theatre") then
                    actor:send("- <blue>The Theatre in Anduin</>")
                end
                if actor:get_quest_var("illusory_wall:Rocky_Tunnels") then
                    actor:send("- <blue>Rocky Tunnels</>")
                end
                if actor:get_quest_var("illusory_wall:Lava") then
                    actor:send("- <blue>Lava Tunnels</>")
                end
                if actor:get_quest_var("illusory_wall:Misty") then
                    actor:send("- <blue>Misty Caverns</>")
                end
                if actor:get_quest_var("illusory_wall:Combat") then
                    actor:send("- <blue>Combat in Eldoria</>")
                end
                if actor:get_quest_var("illusory_wall:Anduin") then
                    actor:send("- <blue>The City of Anduin</>")
                end
                if actor:get_quest_var("illusory_wall:Pastures") then
                    actor:send("- <blue>Anduin Pastures</>")
                end
                if actor:get_quest_var("illusory_wall:Great_Road") then
                    actor:send("- <blue>The Great Road</>")
                end
                if actor:get_quest_var("illusory_wall:Nswamps") then
                    actor:send("- <blue>The Northern Swamps</>")
                end
                if actor:get_quest_var("illusory_wall:Farmlands") then
                    actor:send("- <blue>Mielikki Farmlands</>")
                end
                if actor:get_quest_var("illusory_wall:Frakati") then
                    actor:send("- <blue>Frakati Reservation</>")
                end
                if actor:get_quest_var("illusory_wall:Cathedral") then
                    actor:send("- <blue>Cathedral of Betrayal</>")
                end
                if actor:get_quest_var("illusory_wall:Meercats") then
                    actor:send("- <blue>Kingdom of the Meer Cats</>")
                end
                if actor:get_quest_var("illusory_wall:Logging") then
                    actor:send("- <blue>The Logging Camp</>")
                end
                if actor:get_quest_var("illusory_wall:Dairy") then
                    actor:send("- <blue>The Dairy Farm</>")
                end
                if actor:get_quest_var("illusory_wall:Ickle") then
                    actor:send("- <blue>Ickle</>")
                end
                if actor:get_quest_var("illusory_wall:Frostbite") then
                    actor:send("- <blue>Mount Frostbite</>")
                end
                if actor:get_quest_var("illusory_wall:Phoenix") then
                    actor:send("- <blue>Phoenix Feather Hot Spring</>")
                end
                if actor:get_quest_var("illusory_wall:Blue_Fog_Trail") then
                    actor:send("- <blue>Blue-Fog Trail</>")
                end
                if actor:get_quest_var("illusory_wall:Twisted") then
                    actor:send("- <blue>Twisted Forest</>")
                end
                if actor:get_quest_var("illusory_wall:Megalith") then
                    actor:send("- <blue>The Sacred Megalith</>")
                end
                if actor:get_quest_var("illusory_wall:Tower") then
                    actor:send("- <blue>The Tower in the Wasted</>")
                end
                if actor:get_quest_var("illusory_wall:Miner") then
                    actor:send("- <blue>The Miner's Cavern</>")
                end
                if actor:get_quest_var("illusory_wall:Morgan") then
                    actor:send("- <blue>Morgan Hill</>")
                end
                if actor:get_quest_var("illusory_wall:Mystwatch") then
                    actor:send("- <blue>The Fortress of Mystwatch</>")
                end
                if actor:get_quest_var("illusory_wall:Desert") then
                    actor:send("- <blue>Gothra Desert</>")
                end
                if actor:get_quest_var("illusory_wall:Pyramid") then
                    actor:send("- <blue>Gothra Pyramid</>")
                end
                if actor:get_quest_var("illusory_wall:Highlands") then
                    actor:send("- <blue>Highlands</>")
                end
                if actor:get_quest_var("illusory_wall:Haunted") then
                    actor:send("- <blue>The Haunted House</>")
                end
                if actor:get_quest_var("illusory_wall:Citadel") then
                    actor:send("- <blue>The Citadel of Testing</>")
                end
                if actor:get_quest_var("illusory_wall:Chaos") then
                    actor:send("- <blue>Temple of Chaos</>")
                end
                if actor:get_quest_var("illusory_wall:Canyon") then
                    actor:send("- <blue>Canyon</>")
                end
                if actor:get_quest_var("illusory_wall:Topiary") then
                    actor:send("- <blue>Mielikki's Topiary</>")
                end
                if actor:get_quest_var("illusory_wall:Abbey") then
                    actor:send("- <blue>The Abbey</>")
                end
                if actor:get_quest_var("illusory_wall:Plains") then
                    actor:send("- <blue>Gothra Plains</>")
                end
                if actor:get_quest_var("illusory_wall:Dheduu") then
                    actor:send("- <blue>Dheduu</>")
                end
                if actor:get_quest_var("illusory_wall:Dargentan") then
                    actor:send("- <blue>Dargentan's Lair</>")
                end
                if actor:get_quest_var("illusory_wall:Ogakh") then
                    actor:send("- <blue>Ogakh</>")
                end
                if actor:get_quest_var("illusory_wall:Bluebonnet") then
                    actor:send("- <blue>Bluebonnet Pass</>")
                end
                if actor:get_quest_var("illusory_wall:Caelia_East") then
                    actor:send("- <blue>South Caelia East</>")
                end
                if actor:get_quest_var("illusory_wall:Brush") then
                    actor:send("- <blue>Brush Lands</>")
                end
                if actor:get_quest_var("illusory_wall:Kaaz") then
                    actor:send("- <blue>Temple of the Kaaz</>")
                end
                if actor:get_quest_var("illusory_wall:SeaWitch") then
                    actor:send("- <blue>Sea's Lullaby</>")
                end
                if actor:get_quest_var("illusory_wall:Smuggler") then
                    actor:send("- <blue>Smuggler's Hideout</>")
                end
                if actor:get_quest_var("illusory_wall:Sirestis") then
                    actor:send("- <blue>Sirestis' Folly</>")
                end
                if actor:get_quest_var("illusory_wall:Ancient_Ruins") then
                    actor:send("- <blue>Ancient Ruins</>")
                end
                if actor:get_quest_var("illusory_wall:Minithawkin") then
                    actor:send("- <blue>Minithawkin Mines</>")
                end
                if actor:get_quest_var("illusory_wall:Arabel") then
                    actor:send("- <blue>Arabel Ocean</>")
                end
                if actor:get_quest_var("illusory_wall:Hive") then
                    actor:send("- <blue>Hive</>")
                end
                if actor:get_quest_var("illusory_wall:Demise") then
                    actor:send("- <blue>Demise Keep</>")
                end
                if actor:get_quest_var("illusory_wall:Aviary") then
                    actor:send("- <blue>Ickle's Aviary</>")
                end
                if actor:get_quest_var("illusory_wall:Graveyard") then
                    actor:send("- <blue>The Graveyard</>")
                end
                if actor:get_quest_var("illusory_wall:Earth") then
                    actor:send("- <blue>The Plane of Earth</>")
                end
                if actor:get_quest_var("illusory_wall:Water") then
                    actor:send("- <blue>The Plane of Water</>")
                end
                if actor:get_quest_var("illusory_wall:Fire") then
                    actor:send("- <blue>The Plane of Fire</>")
                end
                if actor:get_quest_var("illusory_wall:Barrow") then
                    actor:send("- <blue>The Barrow</>")
                end
                if actor:get_quest_var("illusory_wall:Fiery") then
                    actor:send("- <blue>Fiery Island</>")
                end
                if actor:get_quest_var("illusory_wall:Nukreth") then
                    actor:send("- <blue>Nukreth Spire</>")
                end
                if actor:get_quest_var("illusory_wall:Doom") then
                    actor:send("- <blue>An Ancient Forest and Pyramid</>")
                end
                if actor:get_quest_var("illusory_wall:Air") then
                    actor:send("- <blue>The Plane of Air</>")
                end
                if actor:get_quest_var("illusory_wall:Lokari") then
                    actor:send("- <blue>Lokari's Keep</>")
                end
                if actor:get_quest_var("illusory_wall:Griffin") then
                    actor:send("- <blue>Griffin Island</>")
                end
                if actor:get_quest_var("illusory_wall:BlackIce") then
                    actor:send("- <blue>Black-Ice Desert</>")
                end
                if actor:get_quest_var("illusory_wall:Nymrill") then
                    actor:send("- <blue>The Lost City of Nymrill</>")
                end
                if actor:get_quest_var("illusory_wall:Bayou") then
                    actor:send("- <blue>The Bayou</>")
                end
                if actor:get_quest_var("illusory_wall:Nordus") then
                    actor:send("- <blue>The Enchanted Village of Nordus</>")
                end
                if actor:get_quest_var("illusory_wall:Templace") then
                    actor:send("- <blue>Templace</>")
                end
                if actor:get_quest_var("illusory_wall:Sunken") then
                    actor:send("- <blue>Sunken Castle</>")
                end
                if actor:get_quest_var("illusory_wall:Cult") then
                    actor:send("- <blue>Ice Cult</>")
                end
                if actor:get_quest_var("illusory_wall:Frost") then
                    actor:send("- <blue>Frost Valley</>")
                end
                if actor:get_quest_var("illusory_wall:Technitzitlan") then
                    actor:send("- <blue>Technitzitlan</>")
                end
                if actor:get_quest_var("illusory_wall:Black_Woods") then
                    actor:send("- <blue>Black Woods</>")
                end
                if actor:get_quest_var("illusory_wall:Kaas_Plains") then
                    actor:send("- <blue>Kaas Plains</>")
                end
                if actor:get_quest_var("illusory_wall:Dark_Mountains") then
                    actor:send("- <blue>Dark Mountains</>")
                end
                if actor:get_quest_var("illusory_wall:Cold_Fields") then
                    actor:send("- <blue>Cold Fields</>")
                end
                if actor:get_quest_var("illusory_wall:Iron") then
                    actor:send("- <blue>Iron Hills</>")
                end
                if actor:get_quest_var("illusory_wall:Blackrock") then
                    actor:send("- <blue>Black Rock Trail</>")
                end
                if actor:get_quest_var("illusory_wall:Eldorian") then
                    actor:send("- <blue>Eldorian Foothills</>")
                end
                if actor:get_quest_var("illusory_wall:Blacklake") then
                    actor:send("- <blue>Black Lake</>")
                end
                if actor:get_quest_var("illusory_wall:Odz") then
                    actor:send("- <blue>Odaishyozen</>")
                end
                if actor:get_quest_var("illusory_wall:Syric") then
                    actor:send("- <blue>Syric Mountain Trail</>")
                end
                if actor:get_quest_var("illusory_wall:KoD") then
                    actor:send("- <blue>Kingdom of Dreams</>")
                end
                if actor:get_quest_var("illusory_wall:Beachhead") then
                    actor:send("- <blue>Beachhead</>")
                end
                if actor:get_quest_var("illusory_wall:Ice_Warrior") then
                    actor:send("- <blue>The Ice Warrior's Compound</>")
                end
                if actor:get_quest_var("illusory_wall:Haven") then
                    actor:send("- <blue>Sacred Haven</>")
                end
                if actor:get_quest_var("illusory_wall:Hollow") then
                    actor:send("- <blue>Enchanted Hollow</>")
                end
                if actor:get_quest_var("illusory_wall:Rhell") then
                    actor:send("- <blue>The Rhell Forest</>")
                end
                actor:send("</>")
                local remaining = (20 - doors)
                actor:send("Locate doors in <b:magenta>" .. tostring(remaining) .. "</> more regions.")
                actor:send("</>")
                actor:send("If you need new lenses return to " .. tostring(master) .. " and say, <b:magenta>\"I need new glasses\"</>.")
            end
        end
    end
end
return _return_value$trig$, '57dae9f3224b32f84d3b8db9f47417c4'),
  -- data/triggers/004/004_49_air_wand_progress_journal.lua
  (4, 49, $trig$-- Converted from DG Script #449: Air Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if (string.find(arg, "air") and (string.find(arg, "wand") or string.find(arg, "wands") or string.find(arg, "staff") or string.find(arg, "staves"))) or string.find(arg, "air_wand") or string.find(arg, "air_wands") or string.find(arg, "air_staff") then
    local sorcererclasses = "Sorcerer Illusionist Cryomancer Pyromancer Necromancer"
    if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
        _return_value = true
        local stage = actor:get_quest_stage("air_wand")
        local minlevel = (stage - 1) * 10
        if minlevel < 1 then
            minlevel = 1
        end
        actor:send("<b:green>&uAir Wand</>")
        actor:send("Masters of air will help you create and upgrade a new mystic weapon.")
        if not actor:get_has_completed("air_wand") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        local status
        if actor:get_has_completed("air_wand") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("air_wand") then
            local job1 = actor:get_quest_var("air_wand:wandtask1")
            local job2 = actor:get_quest_var("air_wand:wandtask2")
            local job3 = actor:get_quest_var("air_wand:wandtask3")
            local job4 = actor:get_quest_var("air_wand:wandtask4")
            local job5 = actor:get_quest_var("air_wand:wandtask5")
            local attack = (stage - 1) * 50
            local weapon
            if stage < 8 then
                weapon = "wand"
            else
                weapon = "staff"
            end
            local remaining = ((attack) - actor:get_quest_var("air_wand:attack_counter"))
            -- switch on stage
            local master
            local wandgem
            local hint
            local wandtask3
            local wandtask4
            if stage == 2 then
                master = mobiles.template(30, 13).name
                wandgem = 55577
            elseif stage == 3 then
                master = mobiles.template(185, 0).name
                hint = "Speak with the old Abbot in the Abbey of St. George."
                wandgem = 55591
                wandtask3 = 23750
            elseif stage == 4 then
                master = mobiles.template(586, 1).name
                hint = "The keeper of a southern coastal tower will have advice for you."
                wandgem = 55605
                wandtask3 = 2330
                wandtask4 = 37006
            elseif stage == 5 then
                master = mobiles.template(123, 5).name
                hint = "A master of air near the megalith in South Caelia will be able to help next."
                wandgem = 55644
                wandtask3 = 12509
                wandtask4 = "&7&bthe icy ledge outside Technitzitlan&0"
            elseif stage == 6 then
                master = mobiles.template(123, 2).name
                wandgem = 55665
                hint = "Seek out the warrior-witch at the center of the southern megalith."
                wandtask3 = 23800
                wandtask4 = 59040
            elseif stage == 7 then
                master = mobiles.template(490, 3).name
                wandgem = 55682
                hint = "She's hard to deal with, but the Seer of Griffin Isle should have some additional guidance for you."
                wandtask3 = 51014
                wandtask4 = 23710
            elseif stage == 8 then
                master = mobiles.template(85, 15).name
                hint = "In the diabolist's church is a seer who cannot see.  He's a good resource for this kind of work."
                wandgem = 55721
                wandtask3 = 11799
                wandtask4 = 53454
            elseif stage == 9 then
                master = mobiles.template(62, 16).name
                hint = "The guardian ranger of the Druid Guild in the Red City has some helpful crafting tips."
                wandgem = 55742
                wandtask3 = 49019
                wandtask4 = 23803
            elseif stage == 10 then
                master = mobiles.template(185, 81).name
                hint = "Silania will help you craft the finest of air weapons."
                wandgem = 11811
                wandtask3 = 52001
                wandtask4 = 48862
            end
            if stage == 1 then
                actor:send("Find " .. tostring(mobiles.template(30, 13).name) .. " and show him your wand.")
                return _return_value
            else
                if actor.level >= minlevel then
                    if actor:get_quest_var("air_wand:greet") == 0 and stage ~= 2 then
                        actor:send("Find the next master crafter and tell them why you have come.")
                        actor:send(tostring(hint))
                        return _return_value
                    else
                        actor:send("Quest Master: " .. tostring(master))
                        actor:send("</>")
                        if job1 or job2 or job3 or job4 then
                            actor:send("You've done the following:")
                            if job1 then
                                actor:send("- used your " .. tostring(weapon) .. " " .. tostring(attack) .. " times")
                            end
                            if job2 then
                                actor:send("- found " .. "%get.obj_shortdesc[%wandgem%]%")
                            end
                            if job3 then
                                if stage ~= 10 then
                                    actor:send("- found " .. "%get.obj_shortdesc[%wandtask3%]%")
                                else
                                    actor:send("- slayed " .. "%get.mob_shortdesc[%wandtask3%]%")
                                end
                            end
                            if job4 then
                                if stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- found " .. "%get.obj_shortdesc[%wandtask4%]%")
                                elseif stage == 5 then
                                    actor:send("- communed in " .. tostring(wandtask4))
                                elseif stage == 9 then
                                    actor:send("- slayed " .. "%get.mob_shortdesc[%wandtask4%]%")
                                end
                            end
                            actor:send("</>")
                        end
                        actor:send("You need to:")
                        if job1 and job2 then
                            if stage == 2 then
                                actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                            else
                                if job3 then
                                    if stage == 3 then
                                        actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    else
                                        if job4 then
                                            if stage ~= 6 and stage ~= 8 and stage ~= 10 then
                                                actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                            elseif stage == 6 then
                                                if not job5 then
                                                    actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    actor:send("- <b:cyan>play</> " .. "%get.obj_shortdesc[%wandtask4%]%")
                                                end
                                            elseif stage == 8 then
                                                if not job5 then
                                                    actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    local room = get.room[place]
                                                    actor:send("- imbue your " .. tostring(weapon) .. " at " .. tostring(room.name) .. ".")
                                                end
                                            elseif stage == 10 then
                                                local room = get.room[wandtask4]
                                                actor:send("- imbue your " .. tostring(weapon) .. " at " .. tostring(room.name) .. ".")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if not job1 then
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your " .. tostring(weapon) .. "</>")
                            end
                        end
                        if not job2 then
                            actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandgem%]%</>")
                        end
                        if stage > 2 then
                            if not job3 then
                                if stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandtask3%]%</>")
                                    if stage == 4 then
                                        actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                                        actor:send("</>    Search the far eastern edge of the continent.")
                                        actor:send("</>    The phrase to call the blessing is:")
                                        actor:send("</>    <b:white>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                                    end
                                else
                                    actor:send("- <b:yellow>slay " .. "%get.mob_shortdesc[%wandtask3%]%</>")
                                end
                            end
                            if not job4 then
                                if stage ~= 3 and stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandtask4%]%</>")
                                elseif stage == 5 then
                                    actor:send("- <b:yellow>imbue your " .. tostring(weapon) .. " on " .. tostring(wandtask4) .. "</>")
                                elseif stage == 9 then
                                    actor:send("- <b:yellow>slay " .. "%get.mob_shortdesc[%wandtask4%]%</>")
                                elseif stage == 10 then
                                    if job1 and job2 and job3 then
                                        actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, '22f86df4b582eb83e564cb0f1b9953f5'),
  -- data/triggers/004/004_50_fire_wand_progress_journal.lua
  (4, 50, $trig$-- Converted from DG Script #450: Fire Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if (string.find(arg, "fire") and (string.find(arg, "wand") or string.find(arg, "wands") or string.find(arg, "staff") or string.find(arg, "staves"))) or string.find(arg, "fire_wand") or string.find(arg, "fire_wands") or string.find(arg, "fire_staff") then
    local sorcererclasses = "Sorcerer Illusionist Cryomancer Pyromancer Necromancer"
    if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
        _return_value = true
        local stage = actor:get_quest_stage("fire_wand")
        local minlevel = (stage - 1) * 10
        if minlevel < 1 then
            minlevel = 1
        end
        actor:send("<b:green>&uFire Wand</>")
        actor:send("Masters of fire will help you create and upgrade a new mystic weapon.")
        if not actor:get_has_completed("fire_wand") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        local status
        if actor:get_has_completed("fire_wand") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("fire_wand") then
            local job1 = actor:get_quest_var("fire_wand:wandtask1")
            local job2 = actor:get_quest_var("fire_wand:wandtask2")
            local job3 = actor:get_quest_var("fire_wand:wandtask3")
            local job4 = actor:get_quest_var("fire_wand:wandtask4")
            local job5 = actor:get_quest_var("fire_wand:wandtask5")
            local attack = (stage - 1) * 50
            local weapon
            if stage < 8 then
                weapon = "wand"
            else
                weapon = "staff"
            end
            local remaining = ((attack) - actor:get_quest_var("fire_wand:attack_counter"))
            -- switch on stage
            local master
            local wandgem
            local hint
            local wandtask3
            local wandtask4
            local place
            if stage == 2 then
                master = mobiles.template(30, 13).name
                wandgem = 55575
            elseif stage == 3 then
                master = mobiles.template(41, 26).name
                hint = "A minion of the dark flame out east will know what to do."
                wandgem = 55590
                wandtask3 = 23752
            elseif stage == 4 then
                master = mobiles.template(103, 6).name
                hint = "There's a fire master in the frozen north who likes to spend his time at the hot springs."
                wandgem = 55612
                wandtask3 = 2331
                wandtask4 = 37006
            elseif stage == 5 then
                master = mobiles.template(123, 4).name
                hint = "A master of fire near the megalith in South Caelia will be able to help next."
                wandgem = 55639
                wandtask3 = 12526
                wandtask4 = "&1&bthe Lava Tunnels&0"
            elseif stage == 6 then
                master = mobiles.template(238, 11).name
                hint = "A seraph crafts with the power of the sun and sky.  It can be found in the floating fortress in South Caelia."
                wandgem = 55662
                wandtask3 = 5201
                wandtask4 = 32412
            elseif stage == 7 then
                master = mobiles.template(481, 5).name
                hint = "I hate to admit it, but Vulcera is your next crafter.  Good luck appeasing her though..."
                wandgem = 55689
                wandtask3 = 43018
                wandtask4 = 11705
            elseif stage == 8 then
                master = mobiles.template(481, 150).name
                hint = "You're headed back to Fiery Island.  Crazy old McCabe can help you improve your staff further."
                wandgem = 55716
                wandtask3 = 53000
                wandtask4 = 53456
                place = 5272
            elseif stage == 9 then
                master = mobiles.template(484, 12).name
                hint = "Seek out the one who speaks for the Sun near Anduin.  He can upgrade your wand."
                wandgem = 55739
                wandtask3 = 48126
                wandtask4 = 4013
            elseif stage == 10 then
                master = mobiles.template(52, 30).name
                hint = "Surely you've heard of Emmath Firehand.  He's the supreme artisan of fiery goods.  He can help you make the final improvements to your staff."
                wandgem = 23822
                wandtask3 = 52002
                wandtask4 = 47800
            end
            if stage == 1 then
                actor:send("Find " .. tostring(mobiles.template(30, 13).name) .. " and show him your wand.")
                return _return_value
            else
                if actor.level >= minlevel then
                    if actor:get_quest_var("fire_wand:greet") == 0 and stage ~= 2 then
                        actor:send("Find the next master crafter and tell them why you have come.")
                        actor:send(tostring(hint))
                        return _return_value
                    else
                        actor:send("Quest Master: " .. tostring(master))
                        actor:send("</>")
                        if job1 or job2 or job3 or job4 then
                            actor:send("You've done the following:")
                            if job1 then
                                actor:send("- used your " .. tostring(weapon) .. " " .. tostring(attack) .. " times")
                            end
                            if job2 then
                                actor:send("- found " .. "%get.obj_shortdesc[%wandgem%]%")
                            end
                            if job3 then
                                if stage ~= 10 then
                                    actor:send("- found " .. "%get.obj_shortdesc[%wandtask3%]%")
                                else
                                    actor:send("- slayed " .. "%get.mob_shortdesc[%wandtask3%]%")
                                end
                            end
                            if job4 then
                                if stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- found " .. "%get.obj_shortdesc[%wandtask4%]%")
                                elseif stage == 5 then
                                    actor:send("- communed in " .. tostring(wandtask4))
                                elseif stage == 9 then
                                    actor:send("- slayed " .. "%get.mob_shortdesc[%wandtask4%]%")
                                end
                            end
                            actor:send("</>")
                        end
                        actor:send("You need to:")
                        if job1 and job2 then
                            if stage == 2 then
                                actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                            else
                                if job3 then
                                    if stage == 3 then
                                        actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    else
                                        if job4 then
                                            if stage ~= 6 and stage ~= 8 and stage ~= 10 then
                                                actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                            elseif stage == 6 then
                                                if not job5 then
                                                    actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    actor:send("- <b:cyan>play</> " .. "%get.obj_shortdesc[%wandtask4%]%")
                                                end
                                            elseif stage == 8 then
                                                if not job5 then
                                                    actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    local room = get.room[place]
                                                    actor:send("- imbue your " .. tostring(weapon) .. " at " .. tostring(room.name) .. ".")
                                                end
                                            elseif stage == 10 then
                                                local room = get.room[wandtask4]
                                                actor:send("- imbue your " .. tostring(weapon) .. " at " .. tostring(room.name) .. ".")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if not job1 then
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your " .. tostring(weapon) .. "</>")
                            end
                        end
                        if not job2 then
                            actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandgem%]%</>")
                        end
                        if stage > 2 then
                            if not job3 then
                                if stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandtask3%]%</>")
                                    if stage == 4 then
                                        actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                                        actor:send("</>    Search the south point beyond Anlun Vale.")
                                        actor:send("</>    The phrase to call the blessing is:")
                                        actor:send("</>    <b:white>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                                    end
                                else
                                    actor:send("- <b:yellow>slay " .. "%get.mob_shortdesc[%wandtask3%]%</>")
                                end
                            end
                            if not job4 then
                                if stage ~= 3 and stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandtask4%]%</>")
                                elseif stage == 5 then
                                    actor:send("- <b:yellow>imbue your " .. tostring(weapon) .. " in " .. tostring(wandtask4) .. "</>")
                                elseif stage == 9 then
                                    actor:send("- <b:yellow>slay " .. "%get.mob_shortdesc[%wandtask4%]%</>")
                                elseif stage == 10 then
                                    if job1 and job2 and job3 then
                                        actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, 'fb25ac7173a498d50164d6e2a8729acd'),
  -- data/triggers/004/004_51_ice_wand_progress_journal.lua
  (4, 51, $trig$-- Converted from DG Script #451: Ice Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if ((string.find(arg, "ice") or string.find(arg, "water") or string.find(arg, "cold") or string.find(arg, "frost")) and (string.find(arg, "wand") or string.find(arg, "wands") or string.find(arg, "staff") or string.find(arg, "staves"))) or string.find(arg, "ice_wand") or string.find(arg, "ice_wands") or string.find(arg, "ice_staff") or string.find(arg, "water_wand") or string.find(arg, "water_wands") or string.find(arg, "water_staff") then
    local sorcererclasses = "Sorcerer Illusionist Cryomancer Pyromancer Necromancer"
    if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
        _return_value = true
        local stage = actor:get_quest_stage("ice_wand")
        local minlevel = (stage - 1) * 10
        if minlevel < 1 then
            minlevel = 1
        end
        actor:send("<b:green>&uIce Wand</>")
        actor:send("Masters of ice and water will help you create and upgrade a new mystic weapon.")
        if not actor:get_has_completed("ice_wand") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        local status
        if actor:get_has_completed("ice_wand") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("ice_wand") then
            local job1 = actor:get_quest_var("ice_wand:wandtask1")
            local job2 = actor:get_quest_var("ice_wand:wandtask2")
            local job3 = actor:get_quest_var("ice_wand:wandtask3")
            local job4 = actor:get_quest_var("ice_wand:wandtask4")
            local job5 = actor:get_quest_var("ice_wand:wandtask5")
            local attack = (stage - 1) * 50
            local weapon
            if stage < 8 then
                weapon = "wand"
            else
                weapon = "staff"
            end
            local remaining = ((attack) - actor:get_quest_var("ice_wand:attack_counter"))
            -- switch on stage
            local master
            local wandgem
            local hint
            local wandtask3
            local wandtask4
            local place
            if stage == 2 then
                master = mobiles.template(30, 13).name
                wandgem = 55574
            elseif stage == 3 then
                master = mobiles.template(178, 6).name
                hint = "The shaman near Three-Falls River has developed a powerful affinity for water from his life in the canyons.  Seek his advice."
                wandgem = 55592
                wandtask3 = 23753
            elseif stage == 4 then
                master = mobiles.template(23, 37).name
                hint = "Many of the best craftspeople aren't even mortal.  There is a water sprite of some renown deep in Anlun Vale."
                wandgem = 55607
                wandtask3 = 2333
                wandtask4 = 37006
            elseif stage == 5 then
                master = mobiles.template(550, 13).name
                hint = "A master of spirits in the far north will be able to help next."
                wandgem = 55640
                wandtask3 = 58018
                wandtask4 = "&6&bthe Arabel Ocean&0"
            elseif stage == 6 then
                master = mobiles.template(238, 2).name
                hint = "Your next crafter is a distant relative of the Sunfire clan.  He's been squatting in a flying fortress for many months, trying to unlock its secrets."
                wandgem = 55666
                wandtask3 = 49011
                wandtask4 = 17309
            elseif stage == 7 then
                master = mobiles.template(533, 16).name
                hint = "You'll need the advice of a master ice sculptor.  One works regularly up in Mt. Frostbite."
                wandgem = 55684
                wandtask3 = 55016
                wandtask4 = 23815
            elseif stage == 8 then
                master = mobiles.template(103, 0).name
                hint = "There's another distant relative of the Sunfire clan who runs the hot springs near Ickle.  He's book smart and knows a thing or two about jewel crafting."
                wandgem = 55717
                wandtask3 = 23847
                wandtask4 = 53457
                place = 55105
            elseif stage == 9 then
                master = mobiles.template(100, 12).name
                hint = "The guild guard for the Sorcerer Guild in Ickle has learned plenty of secrets from the inner sanctum.  Talk to him."
                wandgem = 55743
                wandtask3 = 48018
                wandtask4 = 53300
            elseif stage == 10 then
                master = mobiles.template(550, 20).name
                hint = "You must know Suralla Iceeye by now.  She's the master artisan of cold and ice.  She'll know how to make the final improvements to your staff."
                wandgem = 53314
                wandtask3 = 52005
                wandtask4 = 47708
            end
            if stage == 1 then
                actor:send("Find " .. tostring(mobiles.template(30, 13).name) .. " and show him your wand.")
                return _return_value
            else
                if actor.level >= minlevel then
                    if actor:get_quest_var("ice_wand:greet") == 0 and stage ~= 2 then
                        actor:send("Find the next master crafter and tell them why you have come.")
                        actor:send(tostring(hint))
                        return _return_value
                    else
                        actor:send("Quest Master: " .. tostring(master))
                        actor:send("</>")
                        if job1 or job2 or job3 or job4 then
                            actor:send("You've done the following:")
                            if job1 then
                                actor:send("- used your " .. tostring(weapon) .. " " .. tostring(attack) .. " times")
                            end
                            if job2 then
                                actor:send("- found " .. "%get.obj_shortdesc[%wandgem%]%")
                            end
                            if job3 then
                                if stage ~= 10 then
                                    actor:send("- found " .. "%get.obj_shortdesc[%wandtask3%]%")
                                else
                                    actor:send("- slayed " .. "%get.mob_shortdesc[%wandtask3%]%")
                                end
                            end
                            if job4 then
                                if stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- found " .. "%get.obj_shortdesc[%wandtask4%]%")
                                elseif stage == 5 then
                                    actor:send("- communed in " .. tostring(wandtask4))
                                elseif stage == 9 then
                                    actor:send("- slayed " .. "%get.mob_shortdesc[%wandtask4%]%")
                                end
                            end
                            actor:send("</>")
                        end
                        actor:send("You need to:")
                        if job1 and job2 then
                            if stage == 2 then
                                actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                            else
                                if job3 then
                                    if stage == 3 then
                                        actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    else
                                        if job4 then
                                            if stage ~= 6 and stage ~= 8 and stage ~= 10 then
                                                actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                            elseif stage == 6 then
                                                if not job5 then
                                                    actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    actor:send("- <b:cyan>play</> " .. "%get.obj_shortdesc[%wandtask4%]%")
                                                end
                                            elseif stage == 8 then
                                                if not job5 then
                                                    actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    local room = get.room[place]
                                                    actor:send("- imbue your " .. tostring(weapon) .. " at " .. tostring(room.name) .. ".")
                                                end
                                            elseif stage == 10 then
                                                local room = get.room[wandtask4]
                                                actor:send("- imbue your " .. tostring(weapon) .. " at " .. tostring(room.name) .. ".")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if not job1 then
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your " .. tostring(weapon) .. "</>")
                            end
                        end
                        if not job2 then
                            actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandgem%]%</>")
                        end
                        if stage > 2 then
                            if not job3 then
                                if stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandtask3%]%</>")
                                    if stage == 4 then
                                        actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                                        actor:send("</>    Search near the crystalline pool in Anlun Vale.")
                                        actor:send("</>    The phrase to call the blessing is:")
                                        actor:send("</>    <b:white>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                                    end
                                else
                                    actor:send("- <b:yellow>slay " .. "%get.mob_shortdesc[%wandtask3%]%</>")
                                end
                            end
                            if not job4 then
                                if stage ~= 3 and stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandtask4%]%</>")
                                elseif stage == 5 then
                                    actor:send("- <b:yellow>imbue your " .. tostring(weapon) .. " in " .. tostring(wandtask4) .. "</>")
                                elseif stage == 9 then
                                    actor:send("- <b:yellow>slay " .. "%get.mob_shortdesc[%wandtask4%]%</>")
                                elseif stage == 10 then
                                    if job1 and job2 and job3 then
                                        actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, 'f79b2736a807c541d62a758a460d06ba'),
  -- data/triggers/004/004_52_acid_wand_progress_journal.lua
  (4, 52, $trig$-- Converted from DG Script #452: Acid Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if ((string.find(arg, "acid") or string.find(arg, "earth")) and (string.find(arg, "wand") or string.find(arg, "wands") or string.find(arg, "staff") or string.find(arg, "staves"))) or string.find(arg, "acid_wand") or string.find(arg, "acid_wands") or string.find(arg, "acid_staff") or string.find(arg, "earth_wand") or string.find(arg, "earth_wands") or string.find(arg, "earth_staff") then
    local sorcererclasses = "Sorcerer Illusionist Cryomancer Pyromancer Necromancer"
    if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
        _return_value = true
        local stage = actor:get_quest_stage("acid_wand")
        local minlevel = (stage - 1) * 10
        if minlevel < 1 then
            minlevel = 1
        end
        actor:send("<b:green>&uAcid Wand</>")
        actor:send("Masters of earth will help you create and upgrade a new mystic weapon.")
        if not actor:get_has_completed("acid_wand") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        local status
        if actor:get_has_completed("acid_wand") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("acid_wand") then
            local job1 = actor:get_quest_var("acid_wand:wandtask1")
            local job2 = actor:get_quest_var("acid_wand:wandtask2")
            local job3 = actor:get_quest_var("acid_wand:wandtask3")
            local job4 = actor:get_quest_var("acid_wand:wandtask4")
            local job5 = actor:get_quest_var("acid_wand:wandtask5")
            local attack = (stage - 1) * 50
            local weapon
            if stage < 8 then
                weapon = "wand"
            else
                weapon = "staff"
            end
            local remaining = ((attack) - actor:get_quest_var("acid_wand:attack_counter"))
            -- switch on stage
            local master
            local wandgem
            local hint
            local wandtask3
            local wandtask4
            local place
            if stage == 2 then
                master = mobiles.template(30, 13).name
                wandgem = 55576
            elseif stage == 3 then
                master = mobiles.template(100, 56).name .. " in Ickle"
                hint = "First, seek the one who guards the eastern gates of Ickle."
                wandgem = 55593
                wandtask3 = 23751
            elseif stage == 4 then
                master = mobiles.template(625, 4).name .. " in the Rhell Forest"
                hint = "The next two artisans dwell in the Rhell Forest south-east of Mielikki."
                wandgem = 55606
                wandtask3 = 2332
                wandtask4 = 37006
            elseif stage == 5 then
                master = mobiles.template(625, 3).name
                hint = "Your next crafter isn't exactly part of the ranger network...  It's not actually a person at all.  Find the treant in the Rhell forest and ask it for guidance."
                wandgem = 55647
                wandtask3 = 16303
                wandtask4 = "&9&bthe Northern Swamps&0"
            elseif stage == 6 then
                master = mobiles.template(470, 75).name .. " in the Graveyard"
                hint = "The ranger who guards the massive necropolis near Anduin has wonderful insights on crafting with decay."
                wandgem = 55663
                wandtask3 = 55020
                wandtask4 = 16107
            elseif stage == 7 then
                master = mobiles.template(40, 17).name .. " in the Black-Ice Desert"
                hint = "Your next guide may be hard to locate...  I believe they guard the entrance to a long-lost kingdom beyond a frozen desert."
                wandgem = 55683
                wandtask3 = 16305
                wandtask4 = 37082
            elseif stage == 8 then
                master = mobiles.template(480, 29).name .. " in the Barrow"
                hint = "Next, consult with another ranger who guards a place crawling with the dead.  The dwarf ranger in the iron hills will know how to help you."
                wandgem = 55724
                wandtask3 = 58414
                wandtask4 = 53453
                place = 16355
            elseif stage == 9 then
                master = mobiles.template(35, 49).name .. " at the Ranger Guild"
                hint = "The guard of the only known Ranger Guild in the world is also an excellent craftswoman.  Consult with her."
                wandgem = 55740
                wandtask3 = 47006
                wandtask4 = 52018
            elseif stage == 10 then
                master = mobiles.template(163, 15).name
                hint = "Your last guide is the head of the ranger network himself, Eleweiss.  He can help make the final improvements to your staff."
                wandgem = 52031
                wandtask3 = 52007
                wandtask4 = 47672
            end
            if stage == 1 then
                actor:send("Find " .. tostring(mobiles.template(30, 13).name) .. " and show him your wand.")
                return _return_value
            else
                if actor.level >= minlevel then
                    if actor:get_quest_var("acid_wand:greet") == 0 and stage ~= 2 then
                        actor:send("Find the next master crafter and tell them why you have come.")
                        actor:send(tostring(hint))
                        return _return_value
                    else
                        actor:send("Quest Master: " .. tostring(master))
                        actor:send("</>")
                        if job1 or job2 or job3 or job4 then
                            actor:send("You've done the following:")
                            if job1 then
                                actor:send("- used your " .. tostring(weapon) .. " " .. tostring(attack) .. " times")
                            end
                            if job2 then
                                actor:send("- found " .. "%get.obj_shortdesc[%wandgem%]%")
                            end
                            if job3 then
                                if stage ~= 10 then
                                    actor:send("- found " .. "%get.obj_shortdesc[%wandtask3%]%")
                                else
                                    actor:send("- slayed " .. "%get.mob_shortdesc[%wandtask3%]%")
                                end
                            end
                            if job4 then
                                if stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- found " .. "%get.obj_shortdesc[%wandtask4%]%")
                                elseif stage == 5 then
                                    actor:send("- communed in " .. tostring(wandtask4))
                                elseif stage == 9 then
                                    actor:send("- slayed " .. "%get.mob_shortdesc[%wandtask4%]%")
                                end
                            end
                            actor:send("</>")
                        end
                        actor:send("You need to:")
                        if job1 and job2 then
                            if stage == 2 then
                                actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                            else
                                if job3 then
                                    if stage == 3 then
                                        actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    else
                                        if job4 then
                                            if stage ~= 6 and stage ~= 8 and stage ~= 10 then
                                                actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                            elseif stage == 6 then
                                                if not job5 then
                                                    actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    actor:send("- <b:cyan>play</> " .. "%get.obj_shortdesc[%wandtask4%]%")
                                                end
                                            elseif stage == 8 then
                                                if not job5 then
                                                    actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    local room = get.room[place]
                                                    actor:send("- imbue your " .. tostring(weapon) .. " at " .. tostring(room.name) .. ".")
                                                end
                                            elseif stage == 10 then
                                                local room = get.room[wandtask4]
                                                actor:send("- imbue your " .. tostring(weapon) .. " at " .. tostring(room.name) .. ".")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if not job1 then
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your " .. tostring(weapon) .. "</>")
                            end
                        end
                        if not job2 then
                            actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandgem%]%</>")
                        end
                        if stage > 2 then
                            if not job3 then
                                if stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandtask3%]%</>")
                                    if stage == 4 then
                                        actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                                        actor:send("</>    Search in the heart of the heart of the thorns.")
                                        actor:send("</>    The phrase to call the blessing is:")
                                        actor:send("</>    <b:white>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                                    end
                                else
                                    actor:send("- <b:yellow>slay " .. "%get.mob_shortdesc[%wandtask3%]%</>")
                                end
                            end
                            if not job4 then
                                if stage ~= 3 and stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandtask4%]%</>")
                                elseif stage == 5 then
                                    actor:send("- <b:yellow>imbue your " .. tostring(weapon) .. " in " .. tostring(wandtask4) .. "</>")
                                elseif stage == 9 then
                                    actor:send("- <b:yellow>slay " .. "%get.mob_shortdesc[%wandtask4%]%</>")
                                elseif stage == 10 then
                                    if job1 and job2 and job3 then
                                        actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, '6e06b5c08cffbf05e862ab2c59a05d95'),
  -- data/triggers/004/004_53_spirit_maces_progress_journal.lua
  (4, 53, $trig$-- Converted from DG Script #453: Spirit Maces progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if (string.find(arg, "spirit") and (string.find(arg, "mace") or string.find(arg, "maces"))) or string.find(arg, "phase_mace") or string.find(arg, "spirit_mace") then
    if string.find(actor.class, "priest") or string.find(actor.class, "cleric") then
        _return_value = true
        local stage = actor:get_quest_stage("phase_mace")
        local minlevel = stage * 10
        actor:send("Clerics and priests can make pilgrimages to various spiritual masters to craft weapons to smite the undead.")
        actor:send("<b:green>&uSpirit Maces</>")
        if not actor:get_has_completed("phase_mace") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        local status
        if actor:get_has_completed("phase_mace") then
            status = "Completed!"
        elseif stage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("phase_mace") then
            local job1 = actor:get_quest_var("phase_mace:macetask1")
            local job2 = actor:get_quest_var("phase_mace:macetask2")
            local job3 = actor:get_quest_var("phase_mace:macetask3")
            local job4 = actor:get_quest_var("phase_mace:macetask4")
            local job5 = actor:get_quest_var("phase_mace:macetask5")
            local job6 = actor:get_quest_var("phase_mace:macetask6")
            local attack = stage * 50
            local remaining = ((attack) - actor:get_quest_var("phase_mace:attack_counter"))
            -- switch on stage
            local master
            local maceitem2
            local maceitem3
            local maceitem4
            local maceitem5
            local hint
            local maceitem6
            if stage == 1 then
                master = mobiles.template(30, 25).name
                maceitem2 = 55577
                maceitem3 = 55211
                maceitem4 = 13614
                maceitem5 = 58809
                hint = "The Holy Templar Magistrate is a master of spiritual combat.  Perhaps he knows more."
            elseif stage == 2 then
                master = mobiles.template(185, 2).name
                maceitem2 = 55593
                maceitem3 = 18522
                maceitem4 = 18523
                maceitem5 = 18524
                maceitem6 = 18525
                hint = "Someone familiar with the grave will be able to work on this mace.  Seek out the Sexton in the Abbey west of the Village of Mielikki."
            elseif stage == 3 then
                master = mobiles.template(100, 0).name
                maceitem2 = 55604
                maceitem3 = 32409
                maceitem4 = 59022
                maceitem5 = 2327
                hint = "The Cleric Guild is capable of some miraculous crafting.  Visit the Cleric Guild Master in the Arctic Village of Ickle and talk to High Priest Zalish.  He should be able to help you."
            elseif stage == 4 then
                master = mobiles.template(62, 18).name
                maceitem2 = 55631
                maceitem3 = 16030
                maceitem4 = 47002
                maceitem5 = 5211
                hint = "Continue with the Cleric Guild Masters.  Check in with the High Priestess in the City of Anduin."
            elseif stage == 5 then
                master = mobiles.template(85, 1).name
                maceitem2 = 55660
                maceitem3 = 43007
                maceitem4 = 59012
                maceitem5 = 17308
                hint = "Sometimes to battle the dead, we need to use their own dark natures against them.  Few are as knowledgeable about the dark arts as Ziijhan, the Defiler, in the Cathedral of Betrayal."
            elseif stage == 6 then
                master = mobiles.template(185, 81).name
                maceitem2 = 55681
                maceitem3 = 23824
                maceitem4 = 53016
                maceitem5 = 16201
                hint = "Return again to the Abbey of St. George and seek out Silania.  Her mastry of spiritual matters will be necessary to improve this mace any further."
            elseif stage == 7 then
                master = mobiles.template(60, 7).name
                maceitem2 = 55708
                maceitem3 = 49502
                maceitem4 = 4008
                maceitem5 = 47017
                hint = "Of the few remaining who are capable of improving your mace, one is a priest of a god most foul.  Find Ruin Wormheart, that most heinous of Blackmourne's servators."
            elseif stage == 8 then
                master = mobiles.template(484, 12).name
                maceitem2 = 55737
                maceitem3 = 53305
                maceitem4 = 12307
                maceitem5 = 51073
                hint = "The most powerful force in the war against the dead is the sun itself.  Consult with the sun's Oracle in the ancient pyramid near Anduin."
            elseif stage == 9 then
                master = mobiles.template(30, 21).name
                maceitem2 = 55738
                maceitem3 = 48002
                maceitem4 = 52010
                maceitem5 = 3218
                hint = "With everything prepared, return to the very beginning of your journey.  The High Priestess of Mielikki, the very center of the Cleric Guild, will know what to do."
            end
            if actor.level >= minlevel then
                if actor:get_quest_var("phase_mace:greet") == 0 then
                    actor:send("Find the next master crafter and tell them why you have come.")
                    actor:send(tostring(hint))
                    return _return_value
                else
                    actor:send("Quest Master: " .. tostring(master))
                    actor:send("</>")
                    if job1 or job2 or job3 or job4 or job5 or job6 then
                        actor:send("</>")
                        actor:send("You've done the following:")
                        if job1 then
                            actor:send("- attacked " .. tostring(attack) .. " times")
                        end
                        if job2 then
                            actor:send("- found " .. "%get.obj_shortdesc[%maceitem2%]%")
                        end
                        if job3 then
                            actor:send("- found " .. "%get.obj_shortdesc[%maceitem3%]%")
                        end
                        if job4 then
                            actor:send("- found " .. "%get.obj_shortdesc[%maceitem4%]%")
                        end
                        if job5 then
                            actor:send("- found " .. "%get.obj_shortdesc[%maceitem5%]%")
                        end
                        if job6 then
                            actor:send("- found " .. "%get.obj_shortdesc[%maceitem6%]%")
                        end
                    end
                    actor:send("</>")
                    actor:send("You need to:")
                    if job1 and job2 and job3 and job4 and job5 then
                        if macestep ~= 2 then
                            actor:send("Bring " .. tostring(master) .. " your mace.")
                            return _return_value
                        else
                            if job6 then
                                actor:send("Bring " .. tostring(master) .. " your mace.")
                                return _return_value
                            end
                        end
                    end
                    if not job1 then
                        if remaining > 1 then
                            actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your mace</>")
                        else
                            actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your mace</>")
                        end
                    end
                    if not job2 then
                        actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%maceitem2%]%</>")
                    end
                    if not job3 then
                        actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%maceitem3%]%</>")
                    end
                    if not job4 then
                        actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%maceitem4%]%</>")
                    end
                    if not job5 then
                        actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%maceitem5%]%</>")
                    end
                    if stage == 2 then
                        if not job6 then
                            actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%maceitem6%]%</>")
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, '819a2d9ca9cec57e54548dc17b6d58c3'),
  -- data/triggers/004/004_56_assassin_mask_progress_journal.lua
  (4, 56, $trig$-- Converted from DG Script #456: Assassin Mask progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "deadly") or string.find(arg, "promotion") or string.find(arg, "deadly_promotion or arg ~=assassin_mask") then
    if string.find(actor.class, "assassin") then
        _return_value = true
        local bountystage = actor:get_quest_stage("bounty_hunt")
        local maskstage = actor:get_quest_stage("assassin_mask")
        local master = mobiles.template(60, 51).name
        local job1 = actor:get_quest_var("assassin_mask:masktask1")
        local job2 = actor:get_quest_var("assassin_mask:masktask2")
        local job3 = actor:get_quest_var("assassin_mask:masktask3")
        local job4 = actor:get_quest_var("assassin_mask:masktask4")
        actor:send("<b:green>&uDeadly Promotion</>")
        local level
        if not stage then
            level = 10
        else
            level = maskstage * 10
        end
        if not actor:get_has_completed("assassin_mask") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        local status
        if actor:get_has_completed("assassin_mask") then
            status = "Completed!"
        elseif maskstage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level then
            if maskstage == 0 then
                actor:send("You have to do a <b:cyan>[job]</> for " .. tostring(master) .. " first though.")
                return _return_value
            elseif (maskstage >= bountystage) and not actor:get_has_completed("bounty_hunt") then
                actor:send("You need to complete some more Contract Killer jobs before you can receive another promotion.")
                return _return_value
            end
            -- switch on maskstage
            local mask
            local gem
            local place
            local hint
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
            actor:send("Quest Master: " .. tostring(master))
            if job1 or job2 or job3 or job4 then
                actor:send("</>")
                actor:send("You've done the following:")
                if job1 then
                    actor:send("- attacked " .. tostring(attack) .. " times")
                end
                if job2 then
                    actor:send("- found " .. "%get.obj_shortdesc[%mask%]%")
                end
                if job3 then
                    actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
                end
                if job4 then
                    actor:send("- hidden in " .. tostring(place))
                end
            end
            actor:send("</>")
            actor:send("You need to:")
            if job1 and job2 and job3 and job4 then
                actor:send("Give " .. tostring(master) .. " your old mask.")
                return _return_value
            end
            if not job1 then
                local remaining = attack - actor:get_quest_var("assassin_mask:attack_counter")
                actor:send("- attack &9<blue>" .. tostring(remaining) .. "</> more times while wearing your mask.")
            end
            if not job2 then
                actor:send("- find &9<blue>" .. "%get.obj_shortdesc[%mask%]%</>")
            end
            if not job3 then
                actor:send("- find &9<blue>" .. "%get.obj_shortdesc[%gem%]%</>")
            end
            if not job4 then
                actor:send("- &9<blue>hide in a place called \"&9<blue>" .. tostring(place) .. "</>\".")
                actor:send("</>   It's &9<blue>" .. tostring(hint) .. "</>")
            end
        end
    end
end
return _return_value$trig$, '445417afba923ff796b531eef0cc4001'),
  -- data/triggers/004/004_58_divine_devotion_progress_journal.lua
  (4, 58, $trig$-- Converted from DG Script #458: Divine Devotion progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "divine") or string.find(arg, "devotion") or string.find(arg, "divine_devotion") or string.find(arg, "paladin_pendant") or string.find(arg, "paladin pendant") then
    local anti = "Anti-Paladin"
    if string.find(actor.class, "paladin") or actor.class == "anti-paladin" then
        _return_value = true
        local huntstage = actor:get_quest_stage("dragon_slayer")
        local pendantstage = actor:get_quest_stage("paladin_pendant")
        local master = mobiles.template(30, 80).name
        local job1 = actor:get_quest_var("paladin_pendant:necklacetask1")
        local job2 = actor:get_quest_var("paladin_pendant:necklacetask2")
        local job3 = actor:get_quest_var("paladin_pendant:necklacetask3")
        local job4 = actor:get_quest_var("paladin_pendant:necklacetask4")
        actor:send("<b:green>&uDivine Devotion</>")
        local level
        if not pendantstage then
            level = 10
        else
            level = pendantstage * 10
        end
        if not actor:get_has_completed("paladin_pendant") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        local status
        if actor:get_has_completed("paladin_pendant") then
            status = "Completed!"
        elseif pendantstage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level then
            if pendantstage == 0 then
                actor:send("Your first act of devotion should be to <b:cyan>[hunt]</> a dragon.")
                return _return_value
            elseif (pendantstage >= huntstage) and not actor:get_has_completed("dragon_slayer") then
                actor:send("Slay a few more dragons before you can receive another promotion.")
                return _return_value
            end
            -- switch on pendantstage
            local necklace
            local gem
            local place
            local hint
            if pendantstage == 1 then
                necklace = 12003
                gem = 55582
                place = "The Mist Temple Altar"
                hint = "in the Misty Caverns."
            elseif pendantstage == 2 then
                necklace = 23708
                gem = 55590
                place = "Chamber of Chaos"
                hint = "in the Temple of Chaos."
            elseif pendantstage == 3 then
                necklace = 58005
                gem = 55622
                place = "Altar of Borgan"
                hint = "in the lost city of Nymrill."
            elseif pendantstage == 4 then
                necklace = 48123
                gem = 55654
                place = "A Hidden Altar Room"
                hint = "in a cave in South Caelia's Wailing Mountains."
            elseif pendantstage == 5 then
                necklace = 12336
                gem = 55662
                place = "The Altar of the Snow Leopard Order"
                hint = "buried deep in Mt. Frostbite"
            elseif pendantstage == 6 then
                necklace = 43019
                gem = 55677
                place = "Chapel Altar"
                hint = "deep underground in a lost castle."
            elseif pendantstage == 7 then
                necklace = 37015
                gem = 55709
                place = "A Cliffside Altar"
                hint = "tucked away in the land of Dreams."
            elseif pendantstage == 8 then
                necklace = 58429
                gem = 55738
                place = "Dark Altar"
                hint = "entombed with an ancient evil king."
            elseif pendantstage == 9 then
                necklace = 52010
                gem = 55739
                place = "An Altar"
                hint = "far away in the Plane of Air."
            end
            local attack = pendantstage * 100
            actor:send("Quest Master: " .. tostring(master))
            if job1 or job2 or job3 or job4 then
                actor:send("</>")
                actor:send("You've done the following:")
                if job1 then
                    actor:send("- attacked " .. tostring(attack) .. " times")
                end
                if job2 then
                    actor:send("- found " .. "%get.obj_shortdesc[%necklace%]%")
                end
                if job3 then
                    actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
                end
                if job4 then
                    actor:send("- prayed in " .. tostring(place))
                end
            end
            actor:send("</>")
            actor:send("You need to:")
            if job1 and job2 and job3 and job4 then
                actor:send("Give " .. tostring(master) .. " your old necklace.")
                return _return_value
            end
            if not job1 then
                local remaining = attack - actor:get_quest_var("paladin_pendant:attack_counter")
                actor:send("- attack <b:yellow>" .. tostring(remaining) .. "</> more times while wearing your necklace.")
            end
            if not job2 then
                actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%necklace%]%</>")
            end
            if not job3 then
                actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</>")
            end
            if not job4 then
                actor:send("- <b:yellow>pray</> in a place called \"<b:yellow>" .. tostring(place) .. "</>\".")
                actor:send("</>   It's <b:yellow>" .. tostring(hint) .. "</>")
            end
        end
    end
end
return _return_value$trig$, 'df5af5db5c0807178443356c6f6b27d1'),
  -- data/triggers/004/004_60_eye_of_the_tiger_progress_journal.lua
  (4, 60, $trig$-- Converted from DG Script #460: Eye of the Tiger progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "eye of the tiger") or string.find(arg, "tiger") then
    local hunterclasses = "Warrior Ranger Berserker Mercenary"
    if string.find(string.lower(hunterclasses), actor.class, 1, true) then
        _return_value = true
        local huntstage = actor:get_quest_stage("beast_master")
        local trophystage = actor:get_quest_stage("ranger_trophy")
        local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
        local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
        local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
        local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
        actor:send("<b:green>&uEye of the Tiger</>")
        local level
        if not trophystage then
            level = 10
        else
            level = trophystage * 10
        end
        if not actor:get_has_completed("ranger_trophy") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        local status
        if actor:get_has_completed("ranger_trophy") then
            status = "Completed!"
        elseif trophystage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level then
            if trophystage == 0 then
                actor:send("You must <b:cyan>[hunt]</> a great beast to demonstrate your skills first.")
                return _return_value
            elseif (trophystage >= huntstage) and not actor:get_has_completed("beast_master") then
                actor:send("Prove your dominion over some more great beasts before you can demonstrate your skills.")
                return _return_value
            end
            -- switch on trophystage
            local trophy
            local gem
            local place
            local hint
            if trophystage == 1 then
                trophy = 1607
                gem = 55579
                place = "A Coyote's Den"
                hint = "near the Kingdom of the Meer Cats."
            elseif trophystage == 2 then
                trophy = 17806
                gem = 55591
                place = "In the Lions' Den"
                hint = "in the western reaches of Gothra."
            elseif trophystage == 3 then
                trophy = 1805
                gem = 55628
                place = "either of the two Gigantic Roc Nests"
                hint = "in the Wailing Mountains."
            elseif trophystage == 4 then
                trophy = 62513
                gem = 55652
                place = "Chieftain's Lair"
                hint = "in Nukreth Spire in South Caelia."
            elseif trophystage == 5 then
                trophy = 23803
                gem = 55664
                place = "The Heart of the Den"
                hint = "where the oldest unicorn in South Caelia makes its home."
            elseif trophystage == 6 then
                trophy = 43009
                gem = 55685
                place = "Giant Lynx's Lair"
                hint = "far to the north beyond Mt. Frostbite."
            elseif trophystage == 7 then
                trophy = 47008
                gem = 55705
                place = "Giant Griffin's Nest"
                hint = "tucked away in a secluded and well guarded corner of Griffin Island."
            elseif trophystage == 8 then
                trophy = 53323
                gem = 55729
                place = "Witch's Den"
                hint = "entombed with an ancient evil king."
            elseif trophystage == 9 then
                trophy = 52014
                gem = 55741
                place = "Dargentan's Lair"
                hint = "at the pinnacle of his flying fortress."
            end
            local attack = trophystage * 100
            if job1 or job2 or job3 or job4 then
                actor:send("You've done the following:")
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
            actor:send("</>")
            actor:send("You need to:")
            if job1 and job2 and job3 and job4 then
                actor:send("Give " .. tostring(master) .. " your old trophy.")
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
        end
    end
end
return _return_value$trig$, 'b124c46824178c2fc0abfa5c9bdaca6b'),
  -- data/triggers/004/004_62_anti-paladin_diabolist_necromancer_subclass_progre.lua
  (4, 62, $trig$-- Converted from DG Script #462: Anti-Paladin Diabolist Necromancer Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local anti = "Anti-Paladin"
    local antipaladinraces = "faerie_seelie elf"
    local diabolistraces = "faerie_seelie elf"
    local necromancerraces = "faerie_seelie elf"
    local check
    if string.find(arg, "anti") and string.find(actor.class, "warrior") and actor.level <= 25 and not (string.find(antipaladinraces, actor.race)) then
        actor:send("<b:red>Anti-Paladin</>")
        check = "yes"
    elseif string.find(arg, "Diabolist") and string.find(actor.class, "cleric") and actor.level <= 35 and not (string.find(diabolistraces, actor.race)) then
        actor:send("<magenta>Diabolist</>")
        check = "yes"
    elseif string.find(arg, "Necromancer") and string.find(actor.class, "sorcerer") and actor.level <= 45 and not (string.find(necromancerraces, actor.race)) then
        actor:send("&9<blue>Necromancer</>")
        check = "yes"
    end
    if check == "yes" then
        _return_value = true
        actor:send("Quest Master: " .. tostring(mobiles.template(85, 1).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        actor:send("This class is for evil characters only.")
        if actor:get_quest_stage("nec_anti_dia_subclass") then
            actor:send(tostring(mobiles.template(85, 1).name) .. " said to you:")
            -- switch on actor:get_quest_stage("nec_anti_dia_subclass")
            if actor:get_quest_stage("nec_anti_dia_subclass") == 1 then
                actor:send("Only the most cunning and strong will complete the <magenta>quest</> I set before you.")
                actor:send("I shall take great pleasure in your demise, but I will offer great rewards for your success.")
            elseif actor:get_quest_stage("nec_anti_dia_subclass") == 2 then
                actor:send("Many years ago, my pact with the demon realm allowed me to be master of this domain.")
                actor:send("All were subjugated, man, woman, and beast._")
                actor:send("One man would not bow though!")
                actor:send("My pitiful waste of a brother escaped my minions._")
                actor:send("Perhaps you will remedy that.")
            elseif actor:get_quest_stage("nec_anti_dia_subclass") == 3 or actor:get_quest_stage("nec_anti_dia_subclass") == 4 then
                actor:send("My wretched sibling, Ber...  I shall not utter his name!_")
                actor:send("I despise him and his reverent little life._")
                actor:send("He thinks he is safe now, beyond my grasp.  That FOOL!_")
            end
        end
    end
end
return _return_value$trig$, '1b3f33e56f7a8c51d3d30e770b87bc28'),
  -- data/triggers/004/004_63_monk_subclass_progress_journal.lua
  (4, 63, $trig$-- Converted from DG Script #463: Monk Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local monkraces = "none"
    if string.find(arg, "Monk") and string.find(actor.class, "warrior") and actor.level <= 25 and not (string.find(monkraces, actor.race)) then
        _return_value = true
        actor:send("<yellow>Monk</>")
        actor:send("Quest Master: " .. tostring(mobiles.template(51, 30).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        if actor:get_quest_stage("monk_subclass") then
            actor:send(tostring(mobiles.template(51, 30).name) .. " said to you:")
            -- switch on actor:get_quest_stage("monk_subclass")
            if actor:get_quest_stage("monk_subclass") == 1 then
                actor:send("It is wonderful to hear of others wanting to join the Brotherhood of the Monks._")
                actor:send("You will be rewarded for your success with wonderful training, but only those pure of mind will complete the quest.")
            elseif actor:get_quest_stage("monk_subclass") == 2 then
                actor:send("Usually people come in here promising me the return of something long lost of mine.")
                actor:send("The thing is, I have not always lead this life.  When I was young I was quite the rabble-rouser._")
                actor:send("Well, it is rather embarrassing, but...  I miss my old sash, and I want it back._")
                actor:send("I was told it looked wonderful on me._")
                actor:send(tostring(actor.name) .. ", can you recover it?_")
                actor:send("Please?_")
                actor:send("Long ago some ruthless fiends made off with it.")
            elseif actor:get_quest_stage("monk_subclass") == 3 or actor:get_quest_stage("monk_subclass") == 4 then
                actor:send("Have you recovered my sash from those thieves out west?_")
                actor:send("If you return my sash, I will complete your initiation as a monk.")
            end
        end
    end
end
return _return_value$trig$, '149d91edb5067f52ccdd9e4253f59dc0'),
  -- data/triggers/004/004_64_pyromancer_subclass_progress_journal.lua
  (4, 64, $trig$-- Converted from DG Script #464: Pyromancer Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local pyroraces = "arborean dragonborn_frost"
    if string.find(arg, "Pyromancer") and string.find(actor.class, "sorcerer") and actor.level <= 45 and not (string.find(pyroraces, actor.race)) then
        _return_value = true
        actor:send("<b:red>Pyromancer</>")
        actor:send("Quest Master: " .. tostring(mobiles.template(52, 30).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        if actor:get_quest_stage("pyromancer_subclass") then
            actor:send(tostring(mobiles.template(52, 30).name) .. " said to you:")
            -- switch on actor:get_quest_stage("pyromancer_subclass")
            if actor:get_quest_stage("pyromancer_subclass") == 1 then
                actor:send("Only the best and most motivated of mages will complete the quest I lay before you._")
                actor:send("However, I am sure it is in you, if it is truly your desire, to complete this quest and become a pyromancer.")
            elseif actor:get_quest_stage("pyromancer_subclass") == 2 then
                actor:send("Part of the essence of fire is no longer under my power.")
                actor:send("I once controlled all three parts of the flame: <b:white>White</>, <blue>Gray</>, and &9<blue>Black</>._")
                actor:send("But one of them was taken from my control.")
            elseif actor:get_quest_stage("pyromancer_subclass") == 3 or actor:get_quest_stage("pyromancer_subclass") == 4 then
                actor:send("The " .. tostring(actor:get_quest_var("pyromancer_subclass:part")) .. " flame was taken from me._")
                actor:send("To truly help, I suggest you stop loitering and go recover it.'")
                -- switch on actor:get_quest_var("pyromancer_subclass:part")
                local place
                if actor:get_quest_var("pyromancer_subclass:part") == "white" then
                    place = "&bin some kind of mine&0"
                elseif actor:get_quest_var("pyromancer_subclass:part") == "black" then
                    place = "&bin some kind of temple&0"
                elseif actor:get_quest_var("pyromancer_subclass:part") == "gray" then
                else
                    place = "&bnear some kind of hill&0"
                end
                actor:send("Last I heard, it was " .. tostring(place) .. ", or something of the like.")
            end
        end
    end
end  -- auto-close block
return _return_value$trig$, '6fd273f63a25855aa0e3ab4178e0593d'),
  -- data/triggers/004/004_65_mercenary_assassin_thief_subclass_progress_journal.lua
  (4, 65, $trig$-- Converted from DG Script #465: Mercenary Assassin Thief Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local assassinraces = "none"
    local mercenaryraces = "none"
    local thiefraces = "none"
    local check
    local questname
    if string.find(actor.class, "rogue") and actor.level <= 25 then
        if string.find(arg, "Mercenary") and not (string.find(mercenaryraces, actor.race)) then
            actor:send("&9<blue>Mercenary</>")
            questname = "mercenary"
            check = "yes"
        elseif string.find(arg, "Assassin") and not (string.find(assassinraces, actor.race)) then
            actor:send("<red>Assassin</>")
            questname = "assassin"
            check = "yes"
        elseif string.find(arg, "Thief") and not (string.find(thiefraces, actor.race)) then
            actor:send("<b:red>Thief</>")
            questname = "thief"
            check = "yes"
        end
    end
    if check == "yes" then
        _return_value = true
        actor:send("Quest Master: " .. tostring(mobiles.template(60, 50).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        if questname == "assassin" then
            actor:send("This class is for evil characters only.")
        end
        if actor:get_quest_stage("merc_ass_thi_subclass") then
            actor:send(tostring(mobiles.template(60, 50).name) .. " said to you:")
            -- switch on actor:get_quest_stage("merc_ass_thi_subclass")
            if questname == "mercenary" then
                if actor:get_quest_stage("merc_ass_thi_subclass") == 1 then
                    actor:send("He would pay well.  Yes, that Lord would pay well indeed.")
                elseif quest_name == "assassin" then
                    actor:send("Yes, that would bring a good price.")
                elseif quest_name == "thief" then
                    actor:send("There is a package that someone could get back.")
                end
                if questname == "mercenary" then
                elseif actor:get_quest_stage("merc_ass_thi_subclass") == 2 then
                    actor:send("Well, a great Lord, who shall remain unnamed, has lost a cloak.")
                    actor:send("He has come to me for its return.")
                    actor:send("If you went and procured it, he would be grateful.")
                    actor:send("And if he is grateful, I would be as well, and your training would be finished._")
                    actor:send("It would be quite a payday for a cloak.")
                elseif quest_name == "thief" then
                    actor:send("Some time ago it was sent and picked up by someone who should not have it._")
                    actor:send("Bloody farmers.")
                elseif questname == "assassin" then
                    actor:send("I have some rich men unhappy with the politics of the region in question.")
                    actor:send("You could help with those politics if you wish.")
                end
                if questname == "mercenary" then
                elseif actor:get_quest_stage("merc_ass_thi_subclass") == 3 or actor:get_quest_stage("merc_ass_thi_subclass") == 4 then
                    actor:send("It was made off with in a raid on his castle by some bothersome insect warriors.")
                    actor:send("All the Lord was able to tell me is they said something about wanting it for their queen._")
                    actor:send("I think you should go find it now._")
                    actor:send("Come back when you ave the cloak, do not come back at all.")
                elseif questname == "assassin" then
                    actor:send("Ah yes, the politics of it all.")
                    actor:send("Personally I am not one for them, but some people get all mixed up in those._")
                    actor:send("Go kill the Mayor of Mielikki._")
                    actor:send("He's probably holed up in his office in City Hall.")
                    actor:send("You'll have to break in, sneak past the guards, and kill him._")
                    actor:send("Get his cane as proof and come back and give it to me.")
                elseif questname == "thief" then
                    actor:send("That is right, a package was taken by a farmer who hould not have it._")
                    actor:send("I know this: he got it from the post office in Mielikki and he lives near there.")
                    actor:send("Go get it back and I will make it worth it to you._")
                    actor:send("Do not let anyone see you do not leave a trail of bodies behind you.")
                    actor:send("And be careful!  If you jostle the package too much it just might explode.")
                end
            end
        end
    end
end
return _return_value$trig$, '83d01610a44ec59c843d41e311c5634a'),
  -- data/triggers/004/004_66_illusionist_subclass_progress_journal.lua
  (4, 66, $trig$-- Converted from DG Script #466: Illusionist Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local illusionraces = "none"
    if string.find(arg, "Illusionist") and string.find(actor.class, "sorcerer") and actor.level <= 45 and not (string.find(illusionraces, actor.race)) then
        _return_value = true
        actor:send("<b:magenta>Illusionist</>")
        actor:send("Quest Master: " .. tostring(mobiles.template(172, 0).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        if actor:get_quest_stage("illusionist_subclass") then
            actor:send(tostring(mobiles.template(172, 0).name) .. " said to you:")
            -- switch on actor:get_quest_stage("illusionist_subclass")
            if actor:get_quest_stage("illusionist_subclass") == 1 then
                actor:send("This is what I need you to do...")
                actor:send("That ruffian in the smuggler's hideout once stole a woman from me, on the very eve of our betrothal announcement.")
                actor:send("Or my pride, perhaps.")
                actor:send("It appears that she was his from the very beginning._")
                actor:send("She has departed, she is lost, my dear Cestia...")
                actor:send("She boarded a ship for the southern seas and never returned.")
                actor:send("I fear she is dead.")
                actor:send("But she may have survived, and on that fact this plan hinges._")
                actor:send("I gave her a valuable onyx choker as a betrothal gift.")
                actor:send("She took it in her deceit._")
                actor:send("The smuggler leader took the choker, and keeps it as a prize.")
                actor:send("To humiliate me, perhaps.")
                actor:send("And now he has raised defenses that even I cannot penetrate._")
                actor:send("He knows my fatal weakness: hay fever._")
                actor:send("So he has placed flowers, to reveal me should I enter his home in disguise._")
                actor:send("This is where you come in._")
                actor:send("I would like you to enter the hideout in disguise and take back the choker.")
                actor:send("But beware: it is well hidden._")
                actor:send("Somehow that brutish fool has engaged the services of an illusionist...")
                actor:send("I would like to know who helped him... but no matter._")
                actor:send("'I will enchant you to resemble dear Cestia when the smugglers look upon you.")
                actor:send("Their leader will no doubt welcome you with open arms._")
                actor:send("'But we must ensure that he will reveal its hiding place to you.")
                actor:send("For that, we will make it appear as if the guards of Mielikki have discovered their hideout._")
                actor:send("It is my hope that the leader will hide you - Cestia - for safekeeping, in his most secure location._")
                actor:send("There, perhaps, you will find the choker._")
                actor:send("'I will give you a vial of disturbance.")
                actor:send("Drop it and once you find their leader Gannigan sounds of shouting and fighting will resonate throughout the area.")
                actor:send("It will convince the smugglers that they are under attack._")
                actor:send("You must take care to drop it out of sight of any smugglers, or they may become suspicious.")
                actor:send("Then go immediately to the leader, and stall him until you hear the sounds of invasion._")
                actor:send("Come back and ask for <b:cyan>help</> if you get stuck!")
            elseif actor:get_quest_stage("illusionist_subclass") == 2 then
                actor:send("Did you meet with the leader?")
                actor:send("I hope the disguise was sufficient._")
                actor:send("Perhaps it would be worthwhile to try again.")
                actor:send("The smuggler leader should be searching high and low for Cestia, now._")
                actor:send("If you are willing, I will refresh your disguise for another attempt.")
                actor:send("Say <b:white>'begin'</> when you are ready.")
            else
                actor:send("Do you have the choker?  Did you lose it?_")
                actor:send("If you want to try again, say <b:white>'restart'</> and I will refresh your magical disguise.")
            end
        end
    end
end
return _return_value$trig$, '4ad07d3c9241c350d192dbb1d21915d8'),
  -- data/triggers/004/004_67_paladin_priest_subclass_progress_journal.lua
  (4, 67, $trig$-- Converted from DG Script #467: Paladin Priest Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local priestraces = "drow faerie_unseelie"
    local paladinraces = "drow faerie_unseelie"
    local check
    if string.find(arg, "Paladin") and string.find(actor.class, "warrior") and actor.level <= 25 and not (string.find(paladinraces, actor.race)) then
        actor:send("<b:white>Paladin</>")
        check = "yes"
    elseif string.find(arg, "Priest") and string.find(actor.class, "cleric") and actor.level <= 35 and not (string.find(priestraces, actor.race)) then
        actor:send("<b:cyan>Priest</>")
        check = "yes"
    end
    if check == "yes" then
        _return_value = true
        actor:send("Quest Master: " .. tostring(mobiles.template(185, 81).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        actor:send("This class is for good characters only.")
        if actor:get_quest_stage("pri_pal_subclass") then
            actor:send(tostring(mobiles.template(185, 81).name) .. " said to you:")
            -- switch on actor:get_quest_stage("pri_pal_subclass")
            if actor:get_quest_stage("pri_pal_subclass") == 1 then
                actor:send("It is necessary to make a quest such as this quite tough to ensure you really want to do this._")
                actor:send("I am sure you will complete the quest though.")
            elseif actor:get_quest_stage("pri_pal_subclass") == 2 then
                actor:send("One of our guests made off with our most sacred bronze chalice._")
                actor:send("We have reason to believe it was a ruse by the filthy diabolists to try and weaken us.")
                actor:send("</>Our Prior has offered to try and retrieve it for us, but..._")
                actor:send("I think perhaps that would be a bad idea and that you should find it instead.")
            elseif actor:get_quest_stage("pri_pal_subclass") == 3 then
                actor:send("Have you found the bronze chalice the diabolists stole?")
            end
        end
    end
end
return _return_value$trig$, '1915cc405e3c2829fb9fc4712eac895a'),
  -- data/triggers/004/004_68_ranger_druid_subclass_progress_journal.lua
  (4, 68, $trig$-- Converted from DG Script #468: Ranger Druid Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local druidraces = "none"
    local rangerraces = "none"
    local check
    if string.find(arg, "Ranger") and string.find(actor.class, "warrior") and actor.level <= 25 and not (string.find(rangerraces, actor.race)) then
        actor:send("<b:green>Ranger</>")
        check = "yes"
    elseif string.find(arg, "Druid") and string.find(actor.class, "cleric") and actor.level <= 35 and not (string.find(druidraces, actor.race)) then
        actor:send("<green>Druid</>")
        check = "yes"
    end
    if check == "yes" then
        _return_value = true
        actor:send("Quest Master: " .. tostring(mobiles.template(163, 15).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        if string.find(arg, "Ranger") then
            actor:send("This class is for good characters only.")
        else
            actor:send("This class is for neutral characters only.")
        end
        if actor:get_quest_stage("ran_dru_subclass") then
            actor:send(tostring(mobiles.template(163, 15).name) .. " said to you:")
            -- switch on actor:get_quest_stage("ran_dru_subclass")
            if actor:get_quest_stage("ran_dru_subclass") == 1 then
                actor:send("Only the most dedicated to the forests shall complete the quest I set upon you.")
            elseif actor:get_quest_stage("ran_dru_subclass") == 2 then
                actor:send("Yes, quest. I do suppose it would help if I told you about it._")
                actor:send("Long ago I lost something.")
                actor:send("It is a shame, but it has never been recovered._")
                actor:send("If you were to help me with that, then we could arrange something.")
            elseif actor:get_quest_stage("ran_dru_subclass") == 3 or actor:get_quest_stage("ran_dru_subclass") == 4 then
                actor:send("It seems I am becoming forgetful in my age._")
                actor:send("Well, you see now, I lost the jewel of my heart.")
                actor:send("If you are up to it, finding and returning it to me will get you your reward._")
                actor:send("But for now, it is time for you to depart I think._")
                actor:send("You have brought up painful memories for me to relive.")
            end
        end
    end
end
return _return_value$trig$, '556cf5635dbadac21a295879c750b62f'),
  -- data/triggers/004/004_69_cryomancer_subclass_progress_journal.lua
  (4, 69, $trig$-- Converted from DG Script #469: Cryomancer Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local cryoraces = "arborean dragonborn_fire"
    if string.find(arg, "Cryomancer") and string.find(actor.class, "sorcerer") and actor.level <= 45 and not (string.find(cryoraces, actor.race)) then
        _return_value = true
        actor:send("<b:blue>Cryomancer</>")
        actor:send("Quest Master: " .. tostring(mobiles.template(550, 20).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        if actor:get_quest_stage("cryomancer_subclass") then
            actor:send(tostring(mobiles.template(550, 20).name) .. " said to you:")
            -- switch on actor:get_quest_stage("cryomancer_subclass")
            if actor:get_quest_stage("cryomancer_subclass") == 1 then
                actor:send("It will take a great mage with a dedication to the cold arts to complete the quest I lay before you.")
                actor:send("Your reward is simple if you succeed, and I am sure you will enjoy a life of the cold.")
            elseif actor:get_quest_stage("cryomancer_subclass") == 2 then
                actor:send("My counterpart, the great Emmath Firehand, long ago battled with me once._")
                actor:send("It was not serious by any means, but it did end in a stalemate.")
                actor:send("The catch however..._")
                actor:send("Is that what we battled over may still be suffering.")
            elseif actor:get_quest_stage("cryomancer_subclass") == 3 then
                actor:send("It is a shame really, that poor shrub, it really was an innocent in all of that._")
                actor:send("I do feel bad about it.")
                actor:send("The poor thing tried to flee us and sought the shaman who created him._")
                actor:send("I do not know if that will help you end his suffering or not, but I hope it does._")
                actor:send("And the reward will be great if you do._")
                actor:send("The shrub muttered something about a place with rushing water and some odd warriors being his safety._")
                actor:send("Oh!  One last thing.")
                actor:send("When you return to claim your reward, be sure to say to me <b:white>\"The shrub suffers no longer\"</>, and the prize will be yours.")
            elseif actor:get_quest_stage("cryomancer_subclass") == 4 then
                actor:send("Say <b:white>\"The shrub suffers no longer\"</>, and the prize will be yours.")
            end
        end
    end
end
return _return_value$trig$, '98341385951c63b67e6a7763694f6fa4'),
  -- data/triggers/004/004_70_berserker_subclass_progress_journal.lua
  (4, 70, $trig$-- Converted from DG Script #470: Berserker Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local berserkerraces = "none"
    if string.find(arg, "Berserker") and string.find(actor.class, "warrior") and actor.level <= 25 and not (string.find(berserkerraces, actor.race)) then
        _return_value = true
        actor:send("&9<blue>Berserker</>")
        actor:send("Quest Master: " .. tostring(mobiles.template(364, 30).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        if actor:get_quest_stage("berserker_subclass") then
            actor:send(tostring(mobiles.template(364, 30).name) .. " said to you:")
            -- switch on actor:get_quest_stage("berserker_subclass")
            if actor:get_quest_stage("berserker_subclass") == 1 then
                actor:send("There are a few shared rites that bind us together.")
                actor:send("None is more revered than the Wild Hunt.")
            elseif actor:get_quest_stage("berserker_subclass") == 2 then
                actor:send("Let us challenge the Spirits for the right to prove ourselves!")
                actor:send("If they deem you worthy, the Spirits send you a vision of a mighty beast.")
            elseif actor:get_quest_stage("berserker_subclass") == 3 then
                actor:send("Howl to the spirits before " .. tostring(mobiles.template(364, 30).name) .. " and make your song known!")
                -- switch on actor:get_quest_var("berserker_subclass:target")
                local target
                local place
                if actor:get_quest_var("berserker_subclass:target") == 16105 then
                    target = 16105
                    place = "a desert cave"
                elseif actor:get_quest_var("berserker_subclass:target") == 16310 then
                    target = 16310
                    place = "some forested highlands"
                elseif actor:get_quest_var("berserker_subclass:target") == 20311 then
                    target = 20311
                    place = "a vast plain"
                elseif actor:get_quest_var("berserker_subclass:target") == 55220 then
                    target = 55220
                    place = "the frozen tundra"
                end
                actor:send("The Spirits revealed to you a vision of " .. "%get.mob_shortdesc[%target%]%!")
                actor:send("You saw it iss in " .. tostring(place) .. "!")
            end
        end
    end
end  -- auto-close block
return _return_value$trig$, '29cb5d114f13a82900d6f38977f6611b'),
  -- data/triggers/004/004_71_bard_subclass_progress_journal.lua
  (4, 71, $trig$-- Converted from DG Script #471: Bard Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local bardraces = "none"
    if string.find(arg, "Bard") and string.find(actor.class, "rogue") and actor.level <= 25 and not (string.find(bardraces, actor.race)) then
        _return_value = true
        actor:send("<b:magenta>Bard</>")
        actor:send("Quest Master: " .. tostring(mobiles.template(43, 98).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        if actor:get_quest_stage("bard_subclass") then
            -- switch on actor:get_quest_stage("bard_subclass")
            if actor:get_quest_stage("bard_subclass") == 1 then
                actor:send("Go to the audition room and sing for " .. tostring(mobiles.template(43, 98).name) .. ".")
            elseif actor:get_quest_stage("bard_subclass") == 2 then
                actor:send("Go to the audition room and dance for " .. tostring(mobiles.template(43, 98).name) .. ".")
            elseif actor:get_quest_stage("bard_subclass") == 3 or actor:get_quest_stage("bard_subclass") == 4 then
                actor:send("You were looking for an old script in Morgan Hill.")
                actor:send("Give it to " .. tostring(mobiles.template(43, 98).name) .. " when you find it.")
            elseif actor:get_quest_stage("bard_subclass") == 5 then
                actor:send(tostring(mobiles.template(43, 98).name) .. " said to you:")
                actor:send("Time to gimme some dialogue work.")
                actor:send("I sure hope you're off book!_")
                actor:send("That means \"memorized\" in the business.")
            end
        end
    end
end
return _return_value$trig$, 'fba91d3236cbc8579226a82f5dbacca6'),
  -- data/triggers/004/004_72_armor_clarification.lua
  (4, 72, $trig$-- Converted from DG Script #472: Armor clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "armor" then
    _return_value = true
    actor:send("Please specify:")
    actor:send("Guild Armor Phase One")
    actor:send("Guild Armor Phase Two")
    actor:send("Guild Armor Phase Three")
    if (string.find(actor.class, "priest") and actor.level >= 50) or (string.find(actor.class, "cleric") and actor.level >= 65) then
        actor:send("Group Armor")
    end
end
return _return_value$trig$, '12608d2a0aced649d229ba235871ff4b'),
  -- data/triggers/004/004_73_wand_clarification.lua
  (4, 73, $trig$-- Converted from DG Script #473: Wand clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "wand" then
    local sorcererclasses = "Sorcerer Cryomancer Pyromancer Illusionist Necromancer"
    if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
        _return_value = true
        actor:send("Please specify:")
        actor:send("Acid Wand")
        actor:send("Air Wand")
        actor:send("Fire Wand")
        actor:send("Ice Wand")
    end
end
return _return_value$trig$, 'b71c6930f68de17514d8e7ea04ae536e'),
  -- data/triggers/004/004_74_ice_clarification.lua
  (4, 74, $trig$-- Converted from DG Script #474: Ice clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "ice" then
    local sorcererclasses = "Sorcerer Cryomancer Pyromancer Illusionist Necromancer"
    if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
        _return_value = true
        actor:send("Please specify:")
        actor:send("Ice Wand")
        if string.find(actor.class, "cryomancer") then
            if actor.level >= 50 then
                actor:send("Wall of Ice")
            end
            if actor.level >= 85 then
                actor:send("Ice Shards")
            end
        end
    end
end
return _return_value$trig$, 'ea683d90ee2512c8c20b63b59cb80cb4'),
  -- data/triggers/004/004_75_group_clarification.lua
  (4, 75, $trig$-- Converted from DG Script #475: Group clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "group" then
    if actor.level >= 50 and (string.find(actor.class, "priest") or string.find(actor.class, "cleric") or string.find(actor.class, "diabolist")) then
        _return_value = true
        actor:send("Please specify:")
        actor:send("Group Heal")
        if string.find(actor.class, "priest") or (actor.level >= 65 and string.find(actor.class, "cleric")) then
            actor:send("Group Armor")
        end
        if actor.level >= 65 and string.find(actor.class, "cleric") then
            actor:send("Group Recall")
        end
    end
end
return _return_value$trig$, '395fec189141bc8fac1ede41941a21cc'),
  -- data/triggers/004/004_76_major_clarification.lua
  (4, 76, $trig$-- Converted from DG Script #476: Major clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "major" then
    local relocateclasses = "Sorcerer Cryomancer Pyromancer"
    if (actor.level >= 50 and string.find(string.lower(relocateclasses), actor.class, 1, true)) or (actor.level >= 65 and string.find(actor.class, "bard")) then
        _return_value = true
        actor:send("Please specify:")
        if actor.level >= 50 and string.find(string.lower(relocateclasses), actor.class, 1, true) then
            actor:send("Major Globe")
        end
        if actor.level >= 65 and string.find(actor.class, "bard") then
            actor:send("Major Paralysis")
        end
    end
end
return _return_value$trig$, 'af28b887158e44fbcc155a224282773f'),
  -- data/triggers/004/004_78_doom_clarification.lua
  (4, 78, $trig$-- Converted from DG Script #478: Doom clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "doom" then
    if (actor.level >= 75 and string.find(actor.class, "druid")) or actor.level >= 85 then
        _return_value = true
        actor:send("Please Specify:")
        if actor.level >= 75 and string.find(actor.class, "druid") then
            actor:send("Creeping Doom")
        end
        if actor.level >= 85 then
            actor:send("The Planes of Doom")
        end
    end
end
return _return_value$trig$, '7c8a9b20d82a0e9b7e591d34952640e4'),
  -- data/triggers/004/004_79_wall_clarification.lua
  (4, 79, $trig$-- Converted from DG Script #479: Wall clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "wall" then
    if actor.level >= 50 and (string.find(actor.class, "cryomancer") or string.find(actor.class, "illusionist") or string.find(actor.class, "bard")) then
        _return_value = true
        actor:send("Please specify:")
        if string.find(actor.class, "cryomancer") then
            actor:send("Wall of Ice")
        end
        if string.find(actor.class, "illusionist") or string.find(actor.class, "bard") then
            actor:send("Illusory Wall")
        end
    end
end
return _return_value$trig$, '5db5228a6051c74eef209b2842f40921'),
  -- data/triggers/004/004_80_eye_clarification.lua
  (4, 80, $trig$-- Converted from DG Script #480: Eye clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "eye" then
    local hunterclasses = "Warrior Ranger Berserker Mercenary"
    if (actor.level >= 75 and string.find(actor.class, "sorcerer")) or (actor.level >= 10 and string.find(string.lower(hunterclasses), actor.class, 1, true)) then
        _return_value = true
        actor:send("Please specify:")
        if actor.level >= 75 and string.find(actor.class, "sorcerer") then
            actor:send("Wizard Eye")
        end
        if actor.level >= 10 and string.find(string.lower(hunterclasses), actor.class, 1, true) then
            actor:send("Eye of the tiger")
        end
    end
end
return _return_value$trig$, '6e1c94e94f24ff0be5d18a1ac73b2a0c'),
  -- data/triggers/004/004_81_gate_clarification.lua
  (4, 81, $trig$-- Converted from DG Script #481: Gate clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "gate" then
    if actor.level >= 75 and (string.find(actor.class, "priest") or string.find(actor.class, "diabolist")) then
        _return_value = true
        actor:send("Please specify:")
        if string.find(actor.class, "priest") then
            actor:send("Heavens Gate")
        end
        if string.find(actor.class, "diabolist") then
            actor:send("Hell Gate")
        end
    end
end
return _return_value$trig$, 'bfce662916a6cd6e8893bd9eb0d5db7b'),
  -- data/triggers/004/004_85_monk_chants_progress_journal.lua
  (4, 85, $trig$-- Converted from DG Script #485: Monk Chants progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(actor.class, "monk") then
    local read
    local title
    local level
    local minstage
    local clue1
    local clue2
    if string.find(arg, "tremors") or string.find(arg, "tremors of saint augustine") or string.find(arg, "tremors_of_saint_augustine") then
        read = "yes"
        title = "Tremors of Saint Augustine"
        level = 30
        minstage = 1
        clue1 = "a book surrounded by trees and shadows."
        clue2 = "in a place that is both natural and urban, serenely peaceful and profoundly sorrowful."
    elseif string.find(arg, "tempest") or string.find(arg, "tempest of saint augustine") or string.find(arg, "tempest_of_saint_augustine") then
        read = "yes"
        title = "Tempest of Saint Augustine"
        level = 40
        minstage = 2
        clue1 = "a scroll, dedicated to this particular chant, guarded by a creature of the same elemental affinity."
        clue2 = "on the peak of Urchet Pass."
    elseif string.find(arg, "blizzards") or string.find(arg, "blizzards of saint augustine") or string.find(arg, "blizzards_of_saint_augustine") then
        read = "yes"
        title = "Blizzards of Saint Augustine"
        level = 50
        minstage = 3
        clue1 = "a book held by a master who in turn is a servant of a beast of winter."
        clue2 = "in a temple shrouded in mists."
    elseif string.find(arg, "aria") or string.find(arg, "dissonance") or string.find(arg, "aria of dissonance") then
        read = "yes"
        title = "Aria of Dissonance"
        level = 60
        minstage = 4
        clue1 = "a book on war, held by a banished war god."
        clue2 = "in a dark cave before a blasphemous book, near an unholy fire."
    elseif string.find(arg, "apocalyptic") or string.find(arg, "Anthem") then
        read = "yes"
        title = "Apocalyptic Anthem"
        level = 75
        minstage = 5
        clue1 = "a scroll where illusion is inscribed over and over held by a brother who thirsts for escape."
        clue2 = "in a chapel of the walking dead."
    elseif string.find(arg, "fires") or string.find(arg, "fires of saint augustine") or string.find(arg, "fires_of_saint_augustine") then
        read = "yes"
        title = "Fires of Saint Augustine"
        level = 80
        minstage = 6
        clue1 = "a scroll of curses, carried by children of air in a floating fortress."
        clue2 = "at an altar dedicated to fire's destructive forces."
    elseif string.find(arg, "seed") or string.find(arg, "destruction") or string.find(arg, "seed of destruction") then
        read = "yes"
        title = "Seed of Destruction"
        level = 99
        minstage = 7
        clue1 = "the eye of one caught in an eternal feud."
        clue2 = "at an altar deep in the outer realms surrounded by those who's vengeance was never satisfied."
    end
    if read == "yes" then
        _return_value = true
        local chantstage = actor:get_quest_stage("monk_chants")
        local visionstage = actor:get_quest_stage("monk_vision")
        local master = mobiles.template(53, 8).name
        actor:send("<b:green>&u" .. tostring(title) .. "</>")
        actor:send("Minimum Level: " .. tostring(level))
        local status
        if chantstage > minstage then
            status = "Completed!"
        elseif chantstage == "minstage" and (chantstage < (visionstage - 2)) then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level and chantstage == "minstage" then
            if chantstage >= (visionstage - 2) then
                actor:send("You must walk further along the Way in service of Balance first.")
                return _return_value
            end
            actor:send("You are looking for " .. tostring(clue1))
            actor:send("Take it and <b:cyan>[meditate]</> " .. tostring(clue2))
        elseif actor.level >= level and not chantstage then
            actor:send("Ask " .. tostring(master) .. " about <b:cyan>[chants]" .. "%0 to get started.")
        end
    end
end
return _return_value$trig$, '293f71a523aa4c07239a809c90f79946'),
  -- data/triggers/004/004_86_infernal_weaponry_progress_journal.lua
  (4, 86, $trig$-- Converted from DG Script #486: Infernal Weaponry progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "trident") or string.find(arg, "hell trident") or string.find(arg, "hell_trident") or string.find(arg, "Infernal Weaponry") or string.find(arg, "infernal") or string.find(arg, "weaponry") or string.find(arg, "infernal_weaponry") then
    if string.find(actor.class, "diabolist") then
        _return_value = true
        actor:send("<b:green>&uInfernal Weaponry</>")
        actor:send("Weapons of the lower realms await a diabolist dedicated enough to claim them.")
        local hellstage = actor:get_quest_stage("hell_trident")
        local minlevel
        if not hellstage then
            minlevel = 35
        elseif hellstage == 1 then
            minlevel = 65
        elseif hellstage == 2 then
            minlevel = 90
        end
        if not actor:get_has_completed("hell_trident") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        local status
        if actor:get_has_completed("hell_trident") then
            status = "Completed!"
        elseif hellstage then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor:get_quest_stage("hell_trident") then
            local job1 = actor:get_quest_var("hell_trident:helltask1")
            local job2 = actor:get_quest_var("hell_trident:helltask2")
            local job3 = actor:get_quest_var("hell_trident:helltask3")
            local job4 = actor:get_quest_var("hell_trident:helltask4")
            local job5 = actor:get_quest_var("hell_trident:helltask5")
            local job6 = actor:get_quest_var("hell_trident:helltask6")
            -- switch on hellstage
            local master, pl_word, word, spell2, spell1, task6, task6do
            if hellstage == 1 then
                master = mobiles.template(60, 32).name
                local gem = 55662
                pl_word = "angels"
                word = "angel"
                spell2 = "Banish"
                spell1 = "Hellfire and Brimstone"
                task6 = "assisted Vilekka Kar'Shezden"
                task6do = "&3&bAssist the High Priestess of Lolth in hunting down and destroying the heretics of her Goddess.&0"
            elseif hellstage == 2 then
                master = mobiles.template(125, 26).name
                local gem = 55739
                pl_word = "ghaeles, solars, or seraphs"
                word = "ghaele, solar, or seraph"
                spell1 = "Resurrect"
                spell2 = "Hell Gate"
                task6 = "Defeated the Undead Prince"
                task6do = "find one long-buried and branded an infidel.  &3&bFinish his undying duel for him&0 as a sacrifice of honor."
            else
                if not actor:get_has_completed("hell_trident") then
                    actor:send("Only someone mighty enough to claim the ancient truthstone and present it unto the leader of chaos may be given the dark powers of hell.  These diabolists will be rewarded for their unquenchable devotion by the dark gods themselves!")
                    return _return_value
                end
            end
            if actor.level >= minlevel then
                actor:send("Quest Master: " .. tostring(master))
                if not actor:get_quest_var("hell_trident:greet") then
                    actor:send("Speak with " .. tostring(master) .. ".")
                    return _return_value
                else
                    if job1 or job2 or job3 or job4 or job5 or job6 then
                        actor:send("You have done the following:")
                        if job1 then
                            actor:send("- attacked 666 times")
                        end
                        if job2 then
                            actor:send("- slayed 6 " .. tostring(pl_word))
                        end
                        if job3 then
                            actor:send("- found 6 " .. "%get.obj_shortdesc[%gem%]%")
                        end
                        if job5 then
                            actor:send("- learned " .. tostring(spell2))
                        end
                        if job4 then
                            actor:send("- learned " .. tostring(spell1))
                        end
                        if job6 then
                            actor:send("- " .. tostring(task6))
                        end
                        actor:send("</>")
                    end
                    if job1 and job2 and job3 and job4 and job5 and job6 then
                        actor:send("Give " .. tostring(master) .. " your trident to finalize the pact.")
                    else
                        actor:send("You must still:")
                        if not job1 then
                            local remaining = 666 - actor:get_quest_var("hell_trident:attack_counter")
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your trident</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your trident</>")
                            end
                        end
                        if not job2 then
                            local kills = 6 - actor:get_quest_var("hell_trident:celestials")
                            if kills > 1 then
                                actor:send("- <b:yellow>slay " .. tostring(kills) .. " more " .. tostring(pl_word) .. "</>")
                            else
                                actor:send("- <b:yellow>slay " .. tostring(kills) .. " more " .. tostring(word) .. "</>")
                            end
                        end
                        if not job3 then
                            local gems = 6 - actor:get_quest_var("hell_trident:gems")
                            if gems > 1 then
                                actor:send("- <b:yellow>find " .. tostring(gems) .. " more " .. "%get.obj_pldesc[%gem%]%</>")
                            else
                                actor:send("- <b:yellow>find " .. tostring(gems) .. " more " .. "%get.obj_noadesc[%gem%]%</>")
                            end
                        end
                        if not job5 then
                            actor:send("- <b:yellow>learn " .. tostring(spell2) .. "</>")
                        end
                        if not job4 then
                            actor:send("- <b:yellow>learn " .. tostring(spell1) .. "</>")
                        end
                        if not job6 then
                            actor:send("- " .. tostring(task6do))
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, 'c47cf841b7e1d495f241c2e4c805d243'),
  -- data/triggers/004/004_87_hell_clarification.lua
  (4, 87, $trig$-- Converted from DG Script #487: Hell clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "hell" then
    if string.find(actor.class, "diabolist") then
        _return_value = true
        actor:send("Please specify:")
        actor:send("Hellfire and Brimstone")
        actor:send("Infernal Weaponry")
        actor:send("Hell Gate")
    end
end
return _return_value$trig$, '1ac327f1c77d4e26d0569bbe80f62452'),
  -- data/triggers/004/004_95_sanctuary_clarification.lua
  (4, 95, $trig$-- Converted from DG Script #495: sanctuary clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "sanctuary" or arg == "sanc" then
    local majorsancclasses = "Cleric Priest Diabolist Paladin Anti-Paladin"
    local greatersancclasses = "Cleric Priest Diabolist"
    if string.find(string.lower(majorsancclasses), actor.class, 1, true) then
        _return_value = true
        actor:send("Please specify:")
        if actor.level >= 75 then
            actor:send("Major Sanctuary")
        end
        if actor.level >= 85 and string.find(string.lower(greatersancclasses), actor.class, 1, true) then
            actor:send("Greater Sanctuary")
        end
    end
end
return _return_value$trig$, 'd930722d490cee3fb376bb07f51876d4'),
  -- data/triggers/004/004_97_rogue_cloak_progress_journal.lua
  (4, 97, $trig$-- Converted from DG Script #497: Rogue Cloak progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "cloak") or string.find(arg, "dagger") or string.find(arg, "cloak and dagger") or string.find(arg, "rogue_cloak") then
    if string.find(actor.class, "rogue") or string.find(actor.class, "bard") or actor.class ~= "thief" then
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
return _return_value$trig$, '68d097740836af0f4482a907fb9705c2'),
  -- data/triggers/004/004_98_group_recall_progress_journal.lua
  (4, 98, $trig$-- Converted from DG Script #498: Group Recall progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "group recall") then
    if actor.level >= 65 and string.find(actor.class, "cleric") then
        _return_value = true
        actor:send("This quest is not yet available in game.")
        actor:send("Petition the gods for a quest.")
    end
end
return _return_value$trig$, '5a7fba4c124d556194503e2b9e1a0ad9'),
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
elseif string.find(actor.class, "anti") then
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
end$trig$, '669a2efd2aa8c5cee721490d16d0907e'),
  -- data/triggers/018/018_24_blur_ranger_greet.lua
  (18, 24, $trig$-- Converted from DG Script #1824: blur_ranger_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if string.find(actor.class, "ranger") then
    self:command("bow " .. tostring(actor))
    self:say("Welcome fellow warden.")
    wait(1)
else
    self.room:send(tostring(self.name) .. " says, 'Greetings traveler.  Be careful, this forest can")
    self.room:send("</>be... unpredictable.'")
end
if actor:get_quest_stage("blur") == 1 then
    self.room:send(tostring(self.name) .. " says, 'I see you have brought peace to the forest.  I am")
    self.room:send("</>impressed.  Perhaps you are ready to learn the deeper ways of nature?'")
elseif actor:get_quest_stage("blur") == 2 then
    self.room:send(tostring(self.name) .. " says, 'The Syric Warder still lives.  Relieve him of his")
    self.room:send("</>endless vigil.'")
elseif actor:get_quest_stage("blur") == 3 then
    self:say("Let me have the Warder's sword.")
elseif actor:get_quest_stage("blur") == 4 then
    self:say("Are you ready to race the four winds?")
elseif actor:get_has_failed("blur") then
    self:say("Back again I see.  Ready to try again?")
end$trig$, '00903ff20274a15d27f6bdc8a4635c02'),
  -- data/triggers/018/018_50_no_monk.lua
  (18, 50, $trig$-- Converted from DG Script #1850: no_monk
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
if string.find(actor.class, "monk") then
    actor:send("You cannot use " .. tostring(self.shortdesc) .. ".")
    return false  -- Block the WEAR
end
return true$trig$, 'a69fd619fec6b22301a493223f6efc57'),
  -- data/triggers/022/022_19_archon_sceptre_wield.lua
  (22, 19, $trig$-- Converted from DG Script #2219: archon_sceptre_wield
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
if actor.is_player then
    wait(1)
    if string.find(actor.class, "anti") then
        actor:send("You feel a great surge of power rush through your body.")
        self.room:send_except(actor, "The eyes of " .. tostring(actor.name) .. " begin to burn brightly.")
        wait(1)
        self.room:send_except(actor, "Blackened horns protrude from atop the head of " .. tostring(actor.name) .. ".")
    else
        local dmg = random(1, 100)
        -- TODO(parity): original DG message likely "Your mind is assaulted by horrific images..."; converter replaced verb with actor.class
        actor:send("Your mind is " .. tostring(actor.class) .. " by horrific images and a sense of extreme pain.")
        dmg = dmg + 150
        local damage_dealt = actor:damage(dmg)  -- type: physical
        actor:command("remove sceptre")
        actor:command("drop sceptre")
    end
else
    wait(1)
    actor:send("You can't have the Sceptre of the Archon.  You're not worthy!")
    actor:command("remove sceptre")
    actor:command("drop sceptre")
end$trig$, '1627b75405a0b8eb7eb3a423d89dda38'),
  -- data/triggers/022/022_22_nezer_head_rip_1.lua
  (22, 22, $trig$-- Converted from DG Script #2222: Nezer_head_rip_1
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(5)
-- Let's see how many casters we have in the room.
local casters = 0
for _, victim in ipairs(self:get_people()) do
    if (victim.is_player) and (victim.level < 100) then
        if string.find(victim.class, "cleric") or string.find(victim.class, "priest") or string.find(victim.class, "druid") or string.find(victim.class, "diabolist") or string.find(victim.class, "sorcerer") or string.find(victim.class, "cryomancer") or string.find(victim.class, "pyromancer") or string.find(victim.class, "necromancer") then
            casters = casters + 1
        end
    end
end
-- So if we have casters, pick one, we don't want the same
-- one or to have a set order, so lets pick a random caster.
if casters > 0 then
    local gotyou = 0
    local target = nil
    while gotyou == 0 do
        target = self.room.actors[random(1, #self.room.actors)]
        if string.find(target.class, "cleric") or string.find(target.class, "priest") or string.find(target.class, "druid") or string.find(target.class, "diabolist") or string.find(target.class, "sorcerer") or string.find(target.class, "cryomancer") or string.find(target.class, "pyromancer") or string.find(target.class, "necromancer") then
            gotyou = gotyou + 1
        end
    end
    victim = target
    -- Hello target, now you must die!
    local message = 1
    local keepgoing = 1
    while keepgoing == 1 do
        -- TODO(parity): legacy check `victim.room == 2216` (vnum) — verify victim is in arena room (22, 16)
        if victim.room and victim.room.zone_id == 22 and victim.room.local_id == 16 then
            -- switch on message
            if message == 1 then
                self.room:send_except(victim, tostring(victim.name) .. "'s magic catches the attention of one of Nezer's heads.")
                victim:send("One of Nezer's heads suddenly takes notice of you.'")
            elseif message == 2 then
                self.room:send_except(victim, "Nezer's head darts at " .. tostring(victim.name) .. ", who only barely side steps the attack.")
                victim:send("You just barely side step a bite by Nezer's head. Lucky you.")
            elseif message == 3 then
                local damage = random(1, 20)
                damage = damage + 105
                self.room:send_except(victim, "Nezer's head darts at " .. tostring(victim.name) .. " again, this time grabbing " .. tostring(victim.possessive) .. " in his razor sharp teeth! (<blue>" .. tostring(damage) .. "</>)")
                victim:send("Nezer's head darts at you again, this time grabbing at you with it's shapr teeth, OUCH! (<b:red>" .. tostring(damage) .. "</>)")
                local damage_dealt = victim:damage(damage)  -- type: physical
            elseif message == 4 then
                local damage = random(1, 20)
                damage = damage + 150
                self.room:send_except(victim, "Nezer's second head notices the first chewing on something. (<blue>" .. tostring(damage) .. "</>)")
                victim:send("Nezer's second head notices you as the first chomps down on you hard, OUCH! (<b:red>" .. tostring(damage) .. "</>)")
                local damage_dealt = victim:damage(damage)  -- type: physical
            elseif message == 5 then
                self.room:send_except(victim, "Nezer's second head bites onto the half of " .. tostring(victim.name) .. " that was sticking out before RIPPING " .. tostring(victim.possessive) .. " in half! (<blue>DEAD</>)")
                victim:send("Nezer's second head bites onto the half of you that wasn't already being consumed before RIPPING you in half! You are DEAD! (<b:red>DEAD</>)")
                victim:damage(10000)  -- type: physical
                keepgoing = keepgoing + 1
            else
            end
        else
            self.room:send("Nezer looks around for something that is no longer there.")
            keepgoing = keepgoing + 1
        end
        wait(8)
        message = message + 1
    end
end$trig$, 'f748d3c1e935e5d096f6015313e65964'),
  -- data/triggers/023/023_06_high-druid-blessings.lua
  (23, 6, $trig$-- Converted from DG Script #2306: high-druid-blessings
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
if actor.is_player then
    if string.find(actor.class, "druid") then
        wait(1)
        self:command("nod")
        wait(1)
        self:say("Long ago, the founders of the Vale left gret stone monoliths in each of the four power points of nature.")
        self:say("There was one in each direction, and they were used to commune with the powers of nature.")
        wait(2)
        self:say("But the blessings of nature were lost, and we were forced to abandon the stones in order to protect our order.")
        wait(2)
        self:say("If you could prove yourself by bringing me the blessing of the south, perhaps you could be sent after the others as well.")
        self:command("bow " .. tostring(actor.name))
    else
        self.room:send(tostring(self.name) .. " smiles sadly at " .. tostring(actor.name) .. ".")
        self:say("I am afraid you cannot help me, my child.")
        self:say("This is a concern for the druids.")
    end
end$trig$, '78e41a84ab1dfbf903f77ce8b2e42eb1'),
  -- data/triggers/023/023_07_high-druid-receive.lua
  (23, 7, $trig$local _return_value = true  -- Default: allow action
if actor.is_player then
    if string.find(actor.class, "druid") then
        if (object.zone_id == 23 and object.id == 31) then
            self:command("smile " .. tostring(actor.name))
            globals.blessings = 1
            wait(2)
            self:destroy_item("blessing")
            self:say("I am grateful the monoliths are still serving their purpose.")
            self:say("Perhaps the one to the west still retains its blessing as well?")
            wait(2)
            self:say("Please bring that to me as well!")
            self:command("sigh")
            self:say("I would go myself, but I cannot leave the Vale.")
        elseif (object.zone_id == 23 and object.id == 33) then
            if globals.blessings == 1 then
                globals.blessings = 2
                self.room:send(tostring(self.name) .. " closes his eyes and smiles.")
                wait(2)
                self:destroy_item("blessing")
                self:say("This is heartening!  I do hope the sprites were not too much trouble.")
                self:say("They tricked us long ago and kept the powers of nature for themselves.")
                wait(2)
                self:say("Another power point is to the north.  Bring me that blessing and we shall be one step closer to restoring the stones.")
                self:command("bow " .. tostring(actor.name))
            else
                self:say("Why thank you.  But how did you know I wanted this?")
                wait(2)
                self:destroy_item("blessing")
            end
        elseif (object.zone_id == 23 and object.id == 32) then
            if globals.blessings == 2 then
                self.room:send("The ancient druid's eyes light up as he receives the blessing.")
                globals.blessings = 3
                wait(2)
                self:destroy_item("blessing")
                self:say("At last, the restoration is almost complete!")
                self:say("The only one remaining is the blessing of the east.")
                wait(2)
                self:say("But be careful - it was placed far from the others.")
                self:say("Since many of the ancient roads are no more, you may have some difficulty finding it.")
            else
                self:say("Why thank you.  But this does me little good right now.")
                wait(2)
                self:destroy_item("blessing")
            end
        elseif (object.zone_id == 23 and object.id == 30) then
            if globals.blessings == 3 then
                self.room:send(tostring(self.name) .. " heaves a great sigh of relief as he places the blessings on the stone slab.")
                globals.blessings = 0
                wait(1)
                self.room:send("The &9<blue>stone slab</> begins to <b:white>glow brightly!</>")
                wait(2)
                self.room:send("<b:green>Tendrils of power shoot out from the stone slab, lighting the vale!</>")
                self.room:send(tostring(self.name) .. " smiles hapily as he watches Nature's power at work.")
                wait(4)
                self.room:send("The <b:green>glow</> begins to fade.")
                wait(1)
                actor:send(tostring(self.name) .. " turns to you and bows.")
                self.room:send_except(actor, tostring(self.name) .. " bows to " .. tostring(actor.name) .. ".")
                self:say("Truly, you have performed a great service to the Druids of Anlun Vale.")
                self:say("Please, it is not much, but accept this s a token of my gratitude.")
                wait(1)
                self.room:send(tostring(self.name) .. " pulls something out of his robes.")
                self.room:spawn_object(23, 35)
                self:command("give gaia-cloak " .. tostring(actor.name))
                wait(1)
                self:say("Truly, you have the makings of a great druid within you.")
                self:say("Never lose sight of that, and you shall prosper.")
            else
                self:say("Very interesting - but I cannot use that just now.")
                wait(2)
                self:destroy_item("blessing")
                self:command("eye " .. tostring(actor.name))
                self:say("And why should I need this?")
                _return_value = true
            end
        else
            _return_value = true
            self:say("Thank you, but I do not need this.")
            actor:send(tostring(self.name) .. " returns the item to you.")
        end
    else
        self:say("I am sorry, but I am only looking for help from a fellow druid.")
        actor:send(tostring(self.name) .. " gives " .. tostring(object.shortdesc) .. " back to you.")
    end
end
return _return_value$trig$, 'd03f74751fb629ac89f5c8bd99cfa80a'),
  -- data/triggers/023/023_08_hellfire_brimstone_patriarch_speech.lua
  (23, 8, $trig$-- Converted from DG Script #2308: hellfire_brimstone_patriarch_speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "diabolist") and actor.level > 56 and actor:get_quest_stage("hellfire_brimstone") == 0 then
    actor:start_quest("hellfire_brimstone")
    wait(2)
    self:command("grin")
    self.room:send(tostring(self.name) .. " says, 'Then first, you must prove your dedication to the dark")
    self.room:send("</>gods.'")
    wait(2)
    self:say("I need more meat to stoke the sacrificial bonfire!")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Slaughter paladins at the Sacred Haven, bring back")
    self.room:send("</>their flesh, and <b:red>[drop]</> it on the fire.'")
    wait(4)
    self:say("Six pounds should keep the fire burning long enough.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'If you need guidance, ask me about your <b:white>[spell progress]</>.'")
end$trig$, '29bf9a1b4b69e5f6b0e67e6696f18939'),
  -- data/triggers/023/023_13_hellfire_brimstone_patriarch_greet.lua
  (23, 13, $trig$-- Converted from DG Script #2313: hellfire_brimstone_patriarch_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
local stage = actor:get_quest_stage("hellfire_brimstone")
-- switch on stage
if stage == 1 then
    self.room:send(tostring(self.name) .. " says, 'Have you brought me more meat?  <b:cyan>[Drop]</> it here if you have.'")
elseif stage == 2 then
    self.room:send(tostring(self.name) .. " says, 'Have you found brimstone?  <b:cyan>[Drop]</> it here if you have.'")
elseif stage == 3 then
    self:say("Give me any appropriate tributes you have found.")
else
    if actor.level > 57 and string.find(actor.class, "diabolist") then
        self:say("You seem to be quite powerful...  Powerful enough in fact to handle the Fire of the Dark One.")
        wait(2)
        self:say("Would you like to learn to rain fire and brimstone down on your enemies?")
    end
end$trig$, '09b75123d63a19072162b66212527fd3'),
  -- data/triggers/028/028_00_waterform_wave_greet.lua
  (28, 0, $trig$wait(2)
if not actor.is_player then
    return true
end
local stage = actor:get_quest_stage("waterform")
if stage == 0 then
    if actor.class and string.find(actor.class, "cryomancer") then
        self:say("How nice to see someone other than those dreadful pirates.")
        if actor.level > 72 then
            wait(2)
            self.room:send(tostring(self.name) .. " says, 'Oh, and such a capable water master too.  I could offer")
            self.room:send("</>you a modicum of protection against those pirates if you like.  Would you be")
            self.room:send("</>interested?'")
        end
    end
elseif stage == 1 then
    self:say("Did you find a piece of armor made of water?")
elseif stage == 2 then
    self:say("You should be out killing Tri-Aszp.")
elseif stage == 3 then
    self:say("Have you found a suitably large white dragon bone?")
elseif stage == 4 or stage == 5 then
    self:say("Ah, how are your water creature sample studies going?")
elseif stage == 6 then
    self:say("Do you need to confer about your notes on water sources?")
elseif stage == 7 then
    self:command("peer " .. tostring(actor))
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Ah I can see you have gleaned secrets from the waters!")
    self.room:send("</>Give me the dragon bone cup when you're ready.'")
end$trig$, 'c24a19179d5f216349a2724dbaafea61'),
  -- data/triggers/028/028_01_waterform_wave_speech1.lua
  (28, 1, $trig$-- Speech keywords: yes / protection / how / okay
-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "protection?", "how?", "okay"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local speech_lower = string.lower(speech)
local speech_lower = string.lower(speech or "")
if not (string.find(speech_lower, "yes") or string.find(speech_lower, "protection")
        or string.find(speech_lower, "how") or string.find(speech_lower, "okay")) then
    return true
end
wait(2)
local stage = actor:get_quest_stage("waterform")
if stage == 0 and actor.is_player and actor.class
        and string.find(actor.class, "cryomancer") and actor.level > 72 then
    actor:start_quest("waterform")
    self.room:send(tostring(self.name) .. " says, 'I can teach you to transform you into a raging torrent,")
    self.room:send("</>giving you the strength of the water itself!  All you need is a single piece of")
    self.room:send("</>armor made from water to wrap about you.'")
    -- 
    -- THIS. IS. A. LIE.  Yes, the quest master, a talking wave, gets the material components of its own spell wrong.
    -- 
    wait(4)
    self:say("Bring it to me and I will teach you the transformation!")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'If you forget, you can ask me for a reminder of your")
    self.room:send("</><b:white>[progress]</>.'")
elseif stage == 1 then
    self:say("Then please give it to me.")
elseif stage == 2 or stage == 3 then
    self:say("Then please give it to me.")
elseif stage == 4 then
    self:say("Splendid!  Please, keep at it!")
elseif stage == 5 then
    self:say("Splendid!  Give me the bone cup if you're done.")
elseif stage == 6 then
    self.room:send(tostring(self.name) .. " says, 'If you need, you may ask for a reminder of your")
    self.room:send("</><b:white>[progress]</>.'")
end$trig$, 'f8313e6625b6d3289cab88220ad36a27'),
  -- data/triggers/030/030_05_illusionists_sense_illusion.lua
  (30, 5, $trig$-- Converted from DG Script #3005: Illusionists sense illusion
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
wait(1)
if string.find(actor.class, "illusionist") then
    actor:send("<magenta>You sense the magic of illusion at work upon your senses.</>")
end$trig$, '51cea9f3ee071ada8c2d04673559cb3a'),
  -- data/triggers/030/030_06_archmage_responds_to_guild.lua
  (30, 6, $trig$-- Converted from DG Script #3006: Archmage responds to 'guild'
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
wait(1)
if string.find(actor.class, "sorcerer") then
    self:command("smirk")
    wait(3)
    self:command("ruffle " .. tostring(actor.name))
elseif string.find(actor.class, "cryomancer") or string.find(actor.class, "pyromancer") then
    self:say("Silly bun!  It's right outside!")
    wait(3)
    self:command("pat " .. tostring(actor.name))
elseif string.find(actor.class, "necromancer") then
    self:say("Why, you're looking for creepy old Asiri!")
    wait(2)
    self:command("nod")
    wait(3)
    self:say("I suppose he's around here somewhere.  Somewhere creepy!  I don't really know.")
elseif string.find(actor.class, "illusionist") then
    self:say("Oh dear.  You're asking the wrong spellcaster.  You illusionists, so good at hiding.")
    wait(4)
    self:say("But there is one thing.  Old Eamus - Ermie?  What was his name?")
    wait(3)
    self:command("ponder")
    wait(3)
    self:say("Well anyway, he'd always head to the bank after tea.  But he didn't go into the bank.")
    wait(4)
    self:say("Come to think of it, you illusionists are always sneaking off to the bank.   Or not.")
    self:say("Oh, I'm so confused!")
else
    self:command("sigh")
    wait(3)
    self:say("I'm so sorry, dearie, I've no earthly idea where your guild is.")
end$trig$, '234f70dca4f9594955f128d41df63cd2'),
  -- data/triggers/030/030_07_archmage_responds_to_necromancer.lua
  (30, 7, $trig$-- Converted from DG Script #3007: Archmage responds to 'necromancer'
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
wait(1)
if string.find(actor.class, "sorcerer") and actor.level > 9 and actor.level < 46 then
    self:say("So you want to take on the dark arts, eh?  The foul arts?  The stinky death arts?")
    wait(3)
    self:command("sniff")
    wait(3)
    self:say("I suppose there's no accounting for taste.  You might want to find a pungent necromancer to help with this endeavour.  If you absolutely must.")
    wait(4)
    self:say("Or a diabolist, even.  Seriously.  They're all the same, painted dark purple and wearing old umbrellas.")
    wait(4)
    self:say("Yes, there IS a necromancer nearby.  I should think the odor would have given him away to you long ago.")
    wait(4)
    self:say("Go look around the creepy nasty parts of town.  No, NOT underground!  This is Asiri we're talking about here!")
    self:say("He's vain and no doubt sips blood in a musty parlour, but he won't stand for mold.")
    wait(4)
    self:say("I suppose a run-down shack of some kind would suit him.  I've never been to visit.  Never will.")
elseif string.find(actor.class, "sorcerer") and actor.level < 10 then
    self:say("You want to know about evil, scheming death mages?  A fine young sorcerer like yourself?")
    wait(4)
    self:say("I canNOT imagine why.  They lead frightful lives.  Entertained and served by corpses.")
    wait(3)
    self:command("shudder")
    wait(3)
    self:say("At any rate, Asiri won't do a thing for you at your age.  So you can just put the idea out of your mind.")
    wait(4)
    self:say("Preferably forever.")
elseif string.find(actor.class, "necromancer") then
    actor:send(tostring(self.name) .. " looks you over.")
    self.room:send_except(actor, tostring(self.name) .. " looks " .. tostring(actor.name) .. " over.")
    wait(4)
    self:say("Indeed.  I suppose you are.  Well.")
    wait(4)
    self:say("It can't be helped, can it?  You're... well, you're what you are, aren't you.")
    wait(4)
    self:say("If you're looking for your guild, I can only assure you that it's nowhere nearby.")
    wait(4)
    self:say("Well, it can't be TOO far away, as I can smell the rot of old Asiri.  It drifts over half the town.")
    wait(3)
    self:command("gag")
    wait(3)
    self:say("Why don't you look for a few undead folks?  Asiri seems to discard as many corpses as he employs.")
else
    self:say("You smell it, too?")
    wait(4)
    self:say("I'm going to start a petition to have Asiri evicted from our fine town.")
    wait(4)
    self:say("I hope I can count on you to sign promptly.")
    wait(4)
    self:command("eyebrow " .. tostring(actor.name))
end$trig$, '2140747051eca1c4772d10aec6cae049'),
  -- data/triggers/030/030_08_archmage_responds_to_illusionist.lua
  (30, 8, $trig$-- Converted from DG Script #3008: Archmage responds to 'illusionist'
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
wait(1)
if string.find(actor.class, "sorcerer") and actor.level > 9 and actor.level < 46 then
    self:say("If you want to become an illusionist, you might want to talk to the Grand Master in the citadel.")
    wait(3)
    self:say("Unfortunately, he has been in a foul mood of late.  He may not agree to help you.  But I know of no one else.")
elseif string.find(actor.class, "sorcerer") and actor.level < 10 then
    self:say("Illusionists?  Crafty folk, you can never be quite sure what's going on around them.")
    wait(3)
    self:say("You could become one if you wanted, but you'll have to wait until you have achieved level 10.")
elseif string.find(actor.class, "illusionist") then
    self:say("Are you looking for the guild?  I hear that they place crafty illusions over the entrances.  But only visual ones...")
    wait(3)
    self:say("They always seem to be near banks, as well.  Sorry, I don't know anything more about them.")
else
    self:say("I always used to take along an illusionist when adventuring.  You never know when they'll come in handy!")
end$trig$, '28dbfa27f9c9a3d90b9d15d8ac3f5847'),
  -- data/triggers/030/030_09_erasmus_responds_to_charm_person.lua
  (30, 9, $trig$-- Converted from DG Script #3009: Erasmus responds to "charm person"
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
wait(2)
if string.find(actor.class, "illusionist") then
    if actor:has_skill("charm person") == 100 then
        self:say("A nice spell, isn't it?  I hope you're enjoying it.")
    elseif actor.level < 17 then
        self:say("Ah, charm person.  A powerful spell, capable of great evil - or good.")
        wait(2)
        self:say("Come back when you have a bit more experience, and I'll teach it to you.")
    else
        self:say("Oh, the charm person spell.  You're ready to learn that one!")
        wait(2)
        self:say("Stand still there while I teach you.")
        wait(2)
        self:emote("launches into a marathon of lectures and speeches about diverse arcana.")
        wait(5)
        self:emote("is still spewing forth obscure knowledge at a furious rate!")
        wait(5)
        self:emote("seems to be winding down, as if the lesson were almost over.")
        wait(5)
        if actor.room == self.room then
            self:say("I'm impressed with your attentiveness, " .. tostring(actor.name) .. ".")
            wait(3)
            self:say("I can see that you've learned charm person rather well.")
            skills.set_level(actor, "charm person", 1000)
        else
            self:say("Eh?  Where did " .. tostring(actor.name) .. " go?  Must not have a thirst for knowledge!")
        end
    end
elseif string.find(actor.class, "sorcerer") then
    if actor:has_skill("charm person") == 100 then
        self:command("gasp")
        wait(3)
        self:say("What's this?  An ordinary sorcerer with charm person?!")
        wait(5)
        self:say("Will wonders never cease!")
        wait(5)
        self:command("shake")
    else
        self:say("Don't look at me!  I'm a legendary teacher, but some things are just beyond me!")
        wait(5)
        self:say("You sorcerers require extra help learning this... rather simple spell.")
        wait(5)
        self:say("And you'll get none of it for me, because I have better things to do.")
    end
else
    self:command("sigh")
    wait(3)
    self:say("Yes, yes, a wonderful spell, how incredible we illusionists are, certainly.")
    wait(3)
    self:command("roll")
    wait(3)
    self:say("Why don't you go bash some poor rodents' heads in.  Or whatever it is you do.")
end$trig$, '4f318a945d565307fc841f5628632619'),
  -- data/triggers/030/030_156_trainers_not_level_gain.lua
  (30, 156, $trig$-- Converted from DG Script #3156: trainers not level gain
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: level
if not (cmd == "level") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
if cmd == "l" or cmd == "le" then
    _return_value = true
    return _return_value
end
actor:send(tostring(self.name) .. " says, 'Sorry, I'm not a guild master.'")
wait(2)
local warriors = "warrior paladin ranger monk berserker anti-paladin"
local clerics = "cleric druid priest diabolist"
local rogues = "rogue bard mercenary assassin thief"
local sorcerers = "sorcerer cryomancer pyromancer illusionist necromancer"
if (self.zone_id == 30 and self.id == 165) then
    -- Calken
    if string.find(string.lower(warriors), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'Your guild master is right around the corner!  Go west and north.'")
    elseif string.find(string.lower(clerics), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'The Cleric Guild Masters are north of Town Center by the Temple to Mielikki.'")
    elseif string.find(string.lower(rogues), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'The Rogue Guild is known to be somewhere near the jewelry shop in the south-west corner of Town Center.  But don't go to Julk's training grounds!'")
    elseif string.find(string.lower(sorcerers), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'The Sorcerer Guild Masters are located near Bigby's Magic Shope just west and south of Town Center.  But don't go to Fecil's study hall!'")
    end
elseif (self.zone_id == 30 and self.id == 170) then
    -- Fecil
    if string.find(string.lower(warriors), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'The Warrior Guild is located behind Santiago's Weapon Shop just east of Town Center.  But don't go to Calken in the training grounds!'")
    elseif string.find(string.lower(clerics), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'The Cleric Guild Masters are north of Town Center by the Temple to Mielikki.'")
    elseif string.find(string.lower(rogues), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'The Rogue Guild is known to be somewhere near the jewelry shop in the south-west corner of Town Center.'")
    elseif string.find(string.lower(sorcerers), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'You guild master is just around the corner!  Go north and east.'")
    end
elseif (self.zone_id == 30 and self.id == 160) then
    -- Julk
    if string.find(string.lower(warriors), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'The Warrior Guild is located behind Santiago's Weapon Shop just east of Town Center.  But don't go to Calken in the training grounds!'")
    elseif string.find(string.lower(clerics), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'The Cleric Guild Masters are north of Town Center by the Temple to Mielikki.'")
    elseif string.find(string.lower(rogues), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'Your guild master is right around the corner!  Go north down.'")
    elseif string.find(string.lower(sorcerers), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'The Sorcerer Guild Masters are located near Bigby's Magic Shope just west and south of Town Center.  But don't go to Fecil's study hall!'")
    end
end
return _return_value$trig$, 'afb41d2ce6eea37114952888e80bf803'),
  -- data/triggers/030/030_80_dragon_slayer_isilynor_greet.lua
  (30, 80, $trig$-- Converted from DG Script #3080: Dragon Slayer Isilynor Greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
local anti = "Anti-Paladin"
if not actor:get_has_completed("dragon_slayer") then
    if not actor:get_quest_stage("dragon_slayer") then
        if actor.level > 4 then
            actor:send(tostring(self.name) .. " says, 'Hail!  I am Isilynor, Grand Master of the Knights of Dragonfire, a guild of professional dragon slayers.  We're always seeking bold recruits to <b:cyan>[hunt]</> the great dragons of the world.  I reward those who put their mettle to the test.'")
        end
    elseif actor:get_quest_var("dragon_slayer:hunt") == "running" then
        actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  What are you doing here?  If you lost your notice say <b:cyan>\"I need a new notice\"</>.'")
    elseif actor:get_quest_var("dragon_slayer:hunt") == "dead" then
        actor:send(tostring(self.name) .. " says, 'Welcome back!  If your hunt was successful give me your notice.  If you lost your notice say <b:cyan>\"I need a new notice\"</>.'")
    elseif actor:get_quest_stage("dragon_slayer") >= 1 and not actor:get_has_completed("dragon_slayer") then
        actor:send(tostring(self.name) .. " says, 'Ah, back for another dragon to <b:cyan>[hunt]</> I see.'")
    end
    if not actor:get_has_completed("paladin_pendant") and actor.level > 9 and (string.find(actor.class, "paladin") or string.find(actor.class, "anti")) then
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Or maybe you're here to discuss your <b:cyan>[devotion]</> to the cause.'")
    end
else
    if (string.find(actor.class, "paladin") or actor.class == "anti-paladin") and not actor:get_quest_stage("paladin_pendant") and actor.level > 9 then
        actor:send(tostring(self.name) .. " says, 'A new recruit looking to prove your <b:cyan>[devotion]</> to the cause.'")
    elseif actor:get_quest_stage("paladin_pendant") and not actor:get_has_completed("paladin_pendant") then
        actor:send(tostring(self.name) .. " says, 'Ah, you must be looking to prove your <b:cyan>[devotion]</> again.'")
    end
end$trig$, '3077c176823b9c037b6831b9e13ad9e2'),
  -- data/triggers/043/043_48_lp_join_us.lua
  (43, 48, $trig$-- Converted from DG Script #4348: LP_join_us
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if random(1, 3) == 1 then
    self:emote("croons gently, 'Join us, leave your fields to flower...'")
end
-- switch on actor:get_quest_stage("bard_subclass")
if actor:get_quest_stage("bard_subclass") == 1 or actor:get_quest_stage("bard_subclass") == 2 or actor:get_quest_stage("bard_subclass") == 3 or actor:get_quest_stage("bard_subclass") == 4 then
    actor:send(tostring(self.name) .. " says, 'Ready to continue your audition?'")
else
    if string.find(actor.class, "rogue") then
        -- switch on actor.race
        -- case ADD RESTRICTED RACES HERE
        -- break
        wait(1)
        if actor.level >= 10 and actor.level <= 25 then
            actor:send(tostring(self.name) .. " says, 'The guardians of splendor are calling out your name, " .. tostring(actor.name) .. ".  Do you want to know what they're saying?'")
        end
    end  -- auto-close block
end  -- auto-close block$trig$, '7b39de78dc7e305215aba9a02c5aa2c9'),
  -- data/triggers/043/043_54_lp_bard_subclass_speech1.lua
  (43, 54, $trig$-- Converted from DG Script #4354: LP_bard_subclass_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "rogue") and (actor.level >= 10 and actor.level <= 25) then
    -- switch on actor.race
    -- case ADD RESTRICTED RACES HERE
    -- msend %actor% &1Your race cannot subclass to bard.&0
    -- halt
    -- break
    wait(2)
    if speech == "yes" then
        actor:send(tostring(self.name) .. " says, 'Right this way then!'")
        local next_line
        -- switch on actor:get_quest_stage("bard_subclass")
        if actor:get_quest_stage("bard_subclass") == 1 then
            next_line = "Let's hear you &5&bsing&0!"
        elseif actor:get_quest_stage("bard_subclass") == 2 then
            next_line = "Let's see you &5&bdance&0!"
        elseif actor:get_quest_stage("bard_subclass") == 3 or actor:get_quest_stage("bard_subclass") == 4 then
            next_line = "Do you have the &3&bscript&0?"
        elseif actor:get_quest_stage("bard_subclass") == 5 then
            next_line = "Let's hear some &6&bdialogue&0!"
        else
            next_line = "So, let's discuss your &6&baudition&0."
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Seems like you got real star potential kid.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Follow me to the rehearsal studio.  We want you to audition for us.'")
        end
        wait(2)
        actor:send(tostring(self.name) .. " escorts you backstage to a smaller dance studio.")
        self.room:send_except(actor, tostring(self.name) .. " escorts " .. tostring(actor.name) .. " backstage.")
        wait(2)
        actor:teleport(get_room(43, 69))
        -- actor looks around
        wait(2)
        actor:send(tostring(self.name) .. " settles in.")
        wait(1)
        get_room(43, 69):at(function()
            actor:send(tostring(self.name) .. " says, '" .. tostring(next_line) .. "'")
        end)
    else
        actor:send(tostring(self.name) .. " says, 'Too bad.  You have real start potential kid.  You could be big.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Huge!'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Lemme know if you change your mind.  It's not too late for you.'")
    end
end$trig$, 'c94d214c5bb25b56d56d41bc05e7a3af'),
  -- data/triggers/043/043_55_lp_bard_subclass_speech2.lua
  (43, 55, $trig$-- Converted from DG Script #4355: LP_bard_subclass_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: audition audition? process process?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "audition") or string.find(string.lower(speech), "audition?") or string.find(string.lower(speech), "process") or string.find(string.lower(speech), "process?")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "rogue") and (actor.level >= 10 and actor.level <= 25) then
    -- switch on actor.race
    -- case ADD RESTRICTED RACES HERE
    -- msend %actor% &1Your race cannot subclass to bard.&0
    -- halt
    -- break
    if not actor:get_quest_stage("bard_subclass") then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'We're looking for someone who can sing and dance and act - a real triple threat.  It'll earn you a place in the spotlight and the Bard Guild.  You'll be a real professional!'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Whadda ya say kid?  You wanna give it a shot?'")
    end
end$trig$, '0f679c63cff9f07801fde859f8e8ee09'),
  -- data/triggers/043/043_56_lp2_bard_subclass_speech1.lua
  (43, 56, $trig$-- Converted from DG Script #4356: LP2_bard_subclass_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "rogue") and (actor.level >= 10 and actor.level <= 25) then
    -- switch on actor.race
    -- case ADD RESTRICTED RACES HERE
    -- msend %actor% &1Your race cannot subclass to bard.&0
    -- halt
    -- break
    if not actor:get_quest_stage("bard_subclass") then
        wait(2)
        if string.find(speech, "yes") then
            actor:start_quest("bard_subclass", "bar")
            actor:send(tostring(self.name) .. " says, 'Great!  From now on, you can check your <b:cyan>[subclass progress]</> with me.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'First, let's hear you <b:magenta>sing</>.'")
        else
            self:command("nod")
            actor:send(tostring(self.name) .. " says, 'Come back if you want to go through with it.  My door is always open.'")
        end
    end
end$trig$, '3df5d846cd9473161047e825aa5bf164'),
  -- data/triggers/043/043_66_lp2_bard_subclass_status_checker.lua
  (43, 66, $trig$-- Converted from DG Script #4366: LP2_bard_subclass_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: status status? progress progress?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "status") or string.find(string.lower(speech), "status?") or string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?")) then
    return true  -- No matching keywords
end
wait(2)
-- switch on actor:get_quest_stage("bard_subclass")
if actor:get_quest_stage("bard_subclass") == 1 then
    actor:send(tostring(self.name) .. " says, 'You're at the <b:magenta>singing</> portion of your audition.'")
elseif actor:get_quest_stage("bard_subclass") == 2 then
    actor:send(tostring(self.name) .. " says, 'You're at the <b:magenta>dancing</> portion of your audition.'")
elseif actor:get_quest_stage("bard_subclass") == 3 or actor:get_quest_stage("bard_subclass") == 4 then
    actor:send(tostring(self.name) .. " says, 'You were looking for an old <b:yellow>script</> in Morgan Hill.'")
    if (self.zone_id == 43 and self.id == 98) then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Give it to me when you find it.'")
    end
elseif actor:get_quest_stage("bard_subclass") == 5 then
    actor:send(tostring(self.name) .. " says, 'Time to gimme some <b:cyan>dialogue</> work.  I sure hope you're off book!'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'That means \"memorized\" in the business.'")
    self:command("wink " .. tostring(actor))
else
    local classquest
    if string.find(actor.class, "rogue") then
        -- switch on actor.race
        -- case ADD RESTRICTED RACES HERE
        -- set classquest no
        if actor.level > 10 then
            actor:send(tostring(self.name) .. " says, 'You're a bit too green now, but come back soon!'")
        elseif actor.level >= 10 and actor.level <= 25 then
            actor:send(tostring(self.name) .. " says, 'You haven't even started your audition yet!'")
            if (self.zone_id == 43 and self.id == 99) then
                wait(2)
                actor:send(tostring(self.name) .. " says, 'Say <b:cyan>'yes'</> if you're ready to continue.'")
            end
        else
            actor:send(tostring(self.name) .. " says, 'It's too late to start your career now buddy, sorry.'")
        end
    else
        classquest = "no"
    end
    if classquest == "no" then
        actor:send(tostring(self.name) .. " says, 'You aren't cut out for a life on stage.'")
    end
end  -- auto-close block$trig$, '76c363df07e368bfb1beb54213dcdab7'),
  -- data/triggers/051/051_06_monk_subclass_quest_arre_speech1.lua
  (51, 6, $trig$-- Converted from DG Script #5106: monk_subclass_quest_arre_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%
--
-- Initial "where am I" hint -- nudges Warriors toward asking about her
-- "reason". Non-warriors are dismissed.
--
-- TODO(parity): legacy DG had a placeholder for restricted races
-- ("ADD RESTRICTED RACES HERE") which was never filled in.

-- Speech keywords: here, where
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "here") or string.find(speech_lower, "where")) then
    return true  -- No matching keywords
end
if not string.find(actor.class, "warrior") then
    wait(2)
    actor:send(self.name .. " says, 'Ah, you are not well suited to my teaching.  So I shall not waste my time with you.'")
    return
end
wait(2)
if actor.level < 10 then
    self:command("eye " .. actor.name)
    actor:send(self.name .. " says, 'Perhaps in time, after you've gained a little more experience, we can talk more.'")
elseif actor.level <= 25 then
    wait(2)
    self:command("chuckle")
    actor:send(self.name .. " says, 'Do you not know where you are?  Silly youth.'")
    wait(1)
    actor:send(self.name .. " says, 'Why did you come to my chambers if you do not have a reason?'")
    wait(1)
    self:command("frown")
    wait(1)
    actor:send(self.name .. " says, 'I suppose you are here for the same <b:cyan>reason</> as everyone else that ever visits me.'")
    self:command("sigh")
else
    actor:send(self.name .. " says, 'Ah, you are no longer suited for my teachings.  So I shall not waste my time with you.'")
end$trig$, 'c03884247a952dd3377dc442ed6bf915'),
  -- data/triggers/051/051_07_monk_subclass_quest_arre_speech2.lua
  (51, 7, $trig$-- Converted from DG Script #5107: monk_subclass_quest_arre_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%
--
-- Follow-up to speech1: when the player asks Arre about her "reason",
-- prompt them to commit (yes/no) to the subclass quest.
--
-- TODO(parity): legacy DG had a placeholder for restricted races
-- ("ADD RESTRICTED RACES HERE") which was never filled in.

-- Speech keyword: reason
if not string.find(string.lower(speech), "reason") then
    return true  -- No matching keywords
end
if not string.find(actor.class, "warrior") then
    wait(2)
    actor:send(self.name .. " says, 'Ah, you are not well suited to my teaching.  So I shall not waste my time with you.'")
    return
end
-- Only react before the quest has started (stage nil/0).
local stage = actor:get_quest_stage("monk_subclass")
if stage and stage ~= 0 then
    return
end
wait(2)
if actor.level < 10 then
    self:command("eye " .. actor.name)
    actor:send(self.name .. " says, 'Perhaps in time, after you've gained a little more experience, we can talk more.'")
elseif actor.level <= 25 then
    self:command("grumble")
    actor:send(self.name .. " says, 'Yes a reason...'")
    wait(1)
    actor:send(self.name .. " says, 'You do not know much do you?'")
    self:command("roll")
    self:command("mutter")
    wait(3)
    self:command("eye " .. actor.name)
    actor:send(self.name .. " says, 'Are you certain you wish to study as a monk and have strength over mind and body alike?'")
else
    actor:send(self.name .. " says, 'Ah, you are no longer suited for my teachings.  So I shall not waste my time with you.'")
end$trig$, '46e59ab0db832f0b07928614079a6eae'),
  -- data/triggers/051/051_08_monk_subclass_quest_arre_speech3.lua
  (51, 8, $trig$-- Speech keywords: yes, no
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "yes") or string.find(speech_lower, "no")) then
    return true  -- No matching keywords
end
if not string.find(actor.class, "warrior") then
    return  -- Non-warriors silently ignored, matching legacy DG
end
local stage = actor:get_quest_stage("monk_subclass")
if string.find(speech_lower, "yes") then
    wait(2)
    if actor.level < 10 then
        self:command("eye " .. actor.name)
        actor:send(self.name .. " says, 'Perhaps in time, after you've gained a little more experience, we can talk more.'")
    elseif actor.level <= 25 then
        if stage == nil or stage == 0 then
            actor:start_quest("monk_subclass")
            self:command("bow")
            actor:send(self.name .. " says, 'It is wonderful to hear of others wanting to join the Brotherhood of the Monks.  You will be rewarded for your success with wonderful training, but only those pure of mind will complete the <b:cyan>quest</>.'")
            self.room:send("</>")
            actor:send(self.name .. " says, 'You may ask about your <b:cyan>[subclass progress]</> or at any time.'")
        elseif stage == 2 then
            actor:send(self.name .. " says, 'Thank you.  I'm certain those <b:cyan>fiends</> still have it.'")
        end
    else
        actor:send(self.name .. " says, 'Ah, you are no longer suited for my teachings.  So I shall not waste my time with you.'")
    end
else
    wait(2)
    if stage == nil or stage == 0 then
        actor:send(self.name .. " says, 'It is too bad then, we could use more in our ranks, but only if they truly wish to belong.'")
        self:command("smile")
    elseif stage == 2 then
        actor:send(self.name .. " says, 'Then I am unwilling to continue your training.'")
    end
    wait(1)
    actor:send(self.name .. " says, 'Begone then.")
    actor:send("Your eyes blink repeatedly and you find yourself elsewhere.")
    self.room:send_except(actor, "There is a brief sparkle, and " .. actor.name .. " is sent elsewhere.")
    actor:teleport(get_room(580, 1))
end$trig$, 'a014818a9df860a34229b41eb7759407'),
  -- data/triggers/051/051_17_monk_subclass_quest_arre_status.lua
  (51, 17, $trig$-- Speech keywords: subclass, progress
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "subclass") or string.find(speech_lower, "progress")) then
    return true  -- No matching keywords
end
local stage = actor:get_quest_stage("monk_subclass")
if stage == 1 then
    wait(2)
    actor:send(self.name .. " says, 'It is wonderful to hear of others wanting to join the Brotherhood of the Monks.  You will be rewarded for your success with wonderful training, but only those pure of mind will complete the <b:cyan>quest</>.'")
elseif stage == 2 then
    wait(2)
    actor:send(self.name .. " says, 'Alright, well sit back.'")
    wait(2)
    actor:send(self.name .. " says, 'Usually people come in here promising me the return of something long lost of mine.'")
    self:command("scratch")
    wait(3)
    actor:send(self.name .. " says, 'The thing is, I have not always lead this life.  When I was young I was quite the rabble-rouser.'")
    self:emote("looks wistfully for a moment.")
    wait(4)
    actor:send(self.name .. " says, 'Well, it is rather embarrassing, but...  I miss my old sash, and I want it back.'")
    wait(2)
    self:emote("shakes her head.")
    actor:send(self.name .. " says, 'I was told it looked wonderful on me.'")
    wait(3)
    actor:send(self.name .. " says, '" .. actor.name .. ", can you recover it?'")
    wait(1)
    actor:send(self.name .. " whispers to you, 'Please?'")
    wait(3)
    actor:send(self.name .. " says, 'Long ago some ruthless <b:cyan>fiends</> made off with it.'")
elseif stage == 3 or stage == 4 then
    wait(2)
    actor:send(self.name .. " says, 'Have you recovered my sash from those thieves out west?  If you return my sash, I will complete your initiation as a monk.'")
elseif not string.find(actor.class, "warrior") then
    actor:send(self.name .. " says, 'Ah, you are not well suited to my teaching.  So I shall not waste my time with you.'")
else
    wait(2)
    if actor.level < 10 then
        self:command("eye " .. actor.name)
        actor:send(self.name .. " says, 'Perhaps in time, after you've gained a little more experience, we can talk more.'")
    elseif actor.level <= 25 then
        actor:send(self.name .. " says, 'You are not trying to join the Brotherhood.'")
    else
        actor:send(self.name .. " says, 'Ah, you are no longer suited for my teachings.  So I shall not waste my time with you.'")
    end
end$trig$, '98570534afe9a2863521196cf93672d8'),
  -- data/triggers/052/052_02_pyromancer_subclass_quest_emmath_greet.lua
  (52, 2, $trig$wait(2)
-- TODO: type_wand greet branch removed pending quest schema rework.
local stage = actor:get_quest_stage("pyromancer_subclass")
-- switch on stage
if stage == 1 then
    actor:send(tostring(self.name) .. " says, 'Come back to try again have you?  Only the best and most motivated of mages will complete the quest I lay before you.'")
    self:command("smile")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'However, I am sure it is in you, if it is truly your desire, to complete this <b:red>quest</> and become a pyromancer.'")
elseif stage == 2 then
    actor:send(tostring(self.name) .. " says, 'Are you ready to finish listening now?  I once controlled all three parts of the flame: <b:white>White</>, <blue>Gray</>, and &9<blue>Black</>.'")
    wait(2)
    self:command("frown")
    actor:send(tostring(self.name) .. " says, 'But one of them was taken from my <b:red>control</>.'")
    wait(1)
    self:command("sigh")
elseif stage == 3 or stage == 4 then
    actor:send(tostring(self.name) .. " says, 'Do you have the " .. tostring(actor:get_quest_var("pyromancer_subclass:part")) .. " flame?  Give it here!'")
else
    if string.find(actor.class, "sorcerer") then
        if actor.race == "dragonborn_frost" or actor.race == "arborean" then
            return true
        else
            if actor.level >= 10 and actor.level <= 45 then
                self.room:send("Emmath Firehand's glowing eyes flash brightly for a moment.")
                actor:send(tostring(self.name) .. " says, 'Some love the life of <b:red>flame</>.  Do you?'")
                self:emote("flicks a grin around the room.")
            elseif string.find(actor.class, "sorcerer") and actor.level < 10 then
                self:emote("stares in amazement at " .. tostring(actor.name) .. ".")
                actor:send(tostring(self.name) .. " says, 'I have no idea how you found me but you are far too inexperienced to be in these tunnels in the first place, and even less to ask for my guidance.'")
            end
        end
    end
end$trig$, '4d8a385f893e12e74d64481bbc511d1b'),
  -- data/triggers/052/052_03_pyromancer_subclass_quest_emmath_speech1.lua
  (52, 3, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"flame?", "flames?", "life?", "flame", "flames", "life"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

if string.find(actor.class, "pyromancer") then
    wait(2)
    self:command("chuckle")
    actor:send(tostring(self.name) .. " says, 'I have nothing more to teach you, young one.'")
elseif not actor:get_quest_stage("pyromancer_subclass") then
    if string.find(actor.class, "sorcerer") then
        if actor.race == "dragonborn_frost" or actor.race == "arborean" then
            actor:send("<red>Your race may not subclass to pyromancer.</>")
            return true
        end
        wait(2)
        if actor.level >= 10 and actor.level <= 45 then
            self:command("nod " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'Do you wish to become one with the flame, becoming a mage of fire?'")
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'Not yet, for you are still an initiate.  Come back when you have gained more experience.'")
        else
            actor:send(tostring(self.name) .. " says, 'Unfortunately you are too dedicated to your universalist ways for me to teach you now.'")
        end
    else
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Sorry, I cannot help you learn the ways of the flame.'")
    end
end$trig$, '705a39f3c15d9b676bf880a48aa40d35'),
  -- data/triggers/052/052_04_pyromancer_subclass_quest_emmath_speech2.lua
  (52, 4, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
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
local speech_lower = string.lower(speech)

if not actor:get_quest_stage("pyromancer_subclass") and string.find(actor.class, "sorcerer") then
    if string.find(speech_lower, "yes") then
        if actor.level >= 10 and actor.level <= 45 then
            if actor.race == "dragonborn_frost" or actor.race == "arborean" then
                actor:send("<red>Your race may not subclass to Pyromancer.</>")
                return true
            else
                wait(2)
                actor:start_quest("pyromancer_subclass", "Pyr")
                self:command("nod")
                actor:send(tostring(self.name) .. " says, 'Only the best and most motivated of mages will complete the <b:red>quest</> I lay before you.'")
                self:command("smile")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'However, I am sure it is in you, if it is truly your desire, to complete this quest and become a pyromancer.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'You may ask about your quest <b:red>[subclass progress]</> at any time.'")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'Don't ask me to repeat myself though.'")
                wait(1)
                actor:send(tostring(self.name) .. " says, 'I hate that.'")
            end
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'Come back to me once you've gained more experience.'")
        elseif actor.level > 45 then
            actor:send(tostring(self.name) .. " says, 'Unfortunately you are too dedicated to your universalist ways for me to teach you now.'")
        end
    else
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Very well, then begone from here.  I suppose you do not have it in you to be a mage of fire anyway.'")
        actor:send("Emmath places his fiery palm in the air, making the room glow brightly.")
        self.room:send_except(actor, "Emmath raises his palm into the air, making the room very bright.")
        actor:send("The air around you wavers.")
        self.room:send_except(actor, tostring(actor.name) .. " suddenly disappears at Emmath's command.")
        actor:teleport(get_room(51, 91))
        actor:command("look")
    end
end$trig$, '3b18ae3403504132956595728605b65a'),
  -- data/triggers/053/053_10_beast_master_pumahl_greet.lua
  (53, 10, $trig$-- Converted from DG Script #5310: Beast Master Pumahl greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
if not actor:get_has_completed("beast_master") then
    if not actor:get_quest_stage("beast_master") then
        actor:send(tostring(self.name) .. " says, 'Welcome to the Hall of the Hunt, home of the Beast Masters.  We give out assignments to <b:cyan>[hunt]</> and defeat legendary creatures.  Great rewards wait those who prove their mettle.'")
    elseif actor:get_quest_var("beast_master:hunt") == "running" then
        actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  What are you doing here?  If you lost your assignment say, <b:cyan>\"I need a new assignment\"</>.'")
    elseif actor:get_quest_var("beast_master:hunt") == "dead" then
        actor:send(tostring(self.name) .. " says, 'Welcome back!  If your hunt was successful give me your assignment.  If you lost your assignment say, <b:cyan>\"I need a new assignment\"</>.'")
    elseif actor:get_quest_stage("beast_master") >= 1 and not actor:get_has_completed("beast_master") then
        actor:send(tostring(self.name) .. " says, 'Ah, back for another creature to <b:cyan>[hunt]</> I see.'")
    end
    if not actor:get_has_completed("ranger_trophy") and actor.level > 9 and (string.find(actor.class, "warrior") or string.find(actor.class, "berserker") or string.find(actor.class, "ranger") or string.find(actor.class, "mercenary")) then
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Or maybe you're here to prove your <b:cyan>[skill]</> as a hunter.'")
    end
else
    if (string.find(actor.class, "ranger") or string.find(actor.class, "warrior") or string.find(actor.class, "berserker") or string.find(actor.class, "mercenary")) and not actor:get_quest_stage("ranger_trophy") and actor.level > 9 then
        actor:send(tostring(self.name) .. " says, 'A new hunter looking to prove your <b:cyan>[skill]</> I see.'")
    elseif actor:get_quest_stage("ranger_trophy") and not actor:get_has_completed("ranger_trophy") then
        actor:send(tostring(self.name) .. " says, 'Ah, you must be looking to prove your <b:cyan>[skill]</> again.'")
    end
end$trig$, '94aa6e0aafc6f5f3840618358e2f3a86'),
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
        if (string.find(actor.class, "ranger") or string.find(actor.class, "warrior") or string.find(actor.class, "berserker") or string.find(actor.class, "mercenary")) and actor:get_quest_stage("ranger_trophy") == 0 then
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
return _return_value$trig$, '64389c58aa501522ff842f30c41da2a7'),
  -- data/triggers/053/053_20_honus_treasure_hunter_greet.lua
  (53, 20, $trig$-- Converted from DG Script #5320: Honus Treasure Hunter greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
if not actor:get_has_completed("treasure_hunter") then
    if not actor:get_quest_stage("treasure_hunter") then
        actor:send(tostring(self.name) .. " says, 'Well hello and welcome!  I'm Honus, global representative of the Guild of Treasure Hunters.  We're always seeking bold explorers to <b:cyan>[hunt]</> down and recover exquisite rarities.'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'We pay well, of course.'")
    elseif actor:get_quest_var("treasure_hunter:hunt") == "running" then
        actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  What are you doing here?  If you lost your order say, <b:cyan>\"I need a new order\".</>'")
    elseif actor:get_quest_var("treasure_hunter:hunt") == "found" then
        actor:send(tostring(self.name) .. " says, 'Welcome back!  If your hunt was successful give me your order.  If you lost your order say, <b:cyan>\"I need a new order\".</>'")
    elseif actor:get_quest_stage("treasure_hunter") >= 1 and not actor:get_has_completed("treasure_hunter") then
        actor:send(tostring(self.name) .. " says, 'Ah, back to <b:cyan>[hunt]</> for more treasure!'")
    end
    if not actor:get_has_completed("rogue_cloak") and actor.level > 9 and (string.find(actor.class, "rogue") or string.find(actor.class, "thief") or string.find(actor.class, "bard")) then
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Or maybe you're here to seek a <b:cyan>[promotion]</>.'")
    end
else
    if (string.find(actor.class, "rogue") or string.find(actor.class, "thief") or string.find(actor.class, "bard")) and not actor:get_quest_stage("rogue_cloak") and actor.level > 9 then
        actor:send(tostring(self.name) .. " says, 'Oh look, a new recruit gunning for a <b:cyan>[promotion]</>.'")
    elseif actor:get_quest_stage("rogue_cloak") and not actor:get_has_completed("rogue_cloak") then
        actor:send(tostring(self.name) .. " says, 'Ah, you must be looking for another <b:cyan>[promotion]</>.'")
    end
end$trig$, '6df71098172927c9b1539876db5ec7df'),
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
    if (string.find(actor.class, "rogue") or string.find(actor.class, "thief") or string.find(actor.class, "bard")) and actor:get_quest_stage("rogue_cloak") == 0 then
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
return _return_value$trig$, 'f23296fcbcca5ed976f05e674d2cb4c9'),
  -- data/triggers/053/053_35_elemental_chaos_hakujo_greet.lua
  (53, 35, $trig$-- Converted from DG Script #5335: Elemental Chaos Hakujo greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if not actor:get_has_completed("elemental_chaos") then
    if not actor:get_quest_stage("elemental_chaos") then
        self:command("bow")
        actor:send(tostring(self.name) .. " says, 'Welcome wanderer.  I have not seen the likes of you before.'")
        wait(2)
        self:command("eye " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'Though now that I get a look at you, perhaps you can assist in our <b:cyan>[mission]</>.'")
    elseif actor:get_quest_var("elemental_chaos:bounty") == "running" then
        actor:send(tostring(self.name) .. " says, 'What are you doing here so soon?  You still have a mission to accomplish.  If you misplaced it, say, <b:cyan>\"I need a new note\"</>.'")
    elseif actor:get_quest_var("elemental_chaos:bounty") == "dead" then
        actor:send(tostring(self.name) .. " says, 'If you completed the deed, give me your mission.  If you misplaced it, say, <b:cyan>\"I need a new note\"</>.'")
    elseif actor:get_quest_stage("elemental_chaos") >= 1 and not actor:get_has_completed("elemental_chaos") then
        actor:send(tostring(self.name) .. " says, 'Ah, I have <b:cyan>[news]</> for you.'")
    end
    wait(1)
    if not actor:get_quest_stage("monk_vision") and actor.level > 9 and string.find(actor.class, "monk") then
        actor:send(tostring(self.name) .. " says, 'Or maybe you're here to discuss <b:cyan>[enlightenment]</>.'")
    elseif actor.level > 9 and string.find(actor.class, "monk") then
        actor:send(tostring(self.name) .. " says, 'Or have you come to seek further <b:cyan>[enlightenment]</>.'")
    end
else
    if string.find(actor.class, "monk") and not actor:get_quest_stage("monk_vision") and actor.level > 9 then
        actor:send(tostring(self.name) .. " says, 'Oh look, someone else in line for a <b:cyan>[enlightenment]</>.'")
    elseif actor:get_quest_stage("monk_vision") and not actor:get_has_completed("monk_vision") then
        actor:send(tostring(self.name) .. " says, 'Ah, you must be seeking further <b:cyan>[enlightenment]</>.'")
    end
end$trig$, '4d14293deaa5967b2411057a0df25329'),
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
    if string.find(actor.class, "monk") and actor:get_quest_stage("monk_vision") == 0 then
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
return _return_value$trig$, '05cf33eebb6a9881cd7c1680bcf5697e'),
  -- data/triggers/053/053_43_elemental_chaos_hakujo_progress_checker.lua
  (53, 43, $trig$-- Converted from DG Script #5343: Elemental Chaos Hakujo progress checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: progress
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "progress")) then
    return true  -- No matching keywords
end
wait(2)
actor:send("<b:green>Elemental Chaos</>")
if actor:get_has_completed("elemental_chaos") then
    actor:send(tostring(self.name) .. " says, 'Chaos can never be truly destroyed, but you have helped restore Balance.'")
elseif not actor:get_quest_stage("elemental_chaos") then
    actor:send(tostring(self.name) .. " says, 'You aren't walking the Way with me.'")
elseif actor:get_quest_var("elemental_chaos:bounty") == "dead" then
    actor:send(tostring(self.name) .. " says, 'Give me your current mission first.'")
elseif actor.level >= (actor:get_quest_stage("elemental_chaos") - 1) * 10 then
    if actor:get_quest_var("elemental_chaos:bounty") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't doing anything for me right now.'")
    else
        -- switch on actor:get_quest_stage("elemental_chaos")
        if actor:get_quest_stage("elemental_chaos") == 1 then
            actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Investigate the news of an imp and dispatch it if you find one.'")
        elseif actor:get_quest_stage("elemental_chaos") == 2 then
            actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Silence the seductive song of the Leading Player.'")
        elseif actor:get_quest_stage("elemental_chaos") == 3 then
            actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Destroy the Chaos and the cult worshiping it!'")
        elseif actor:get_quest_stage("elemental_chaos") == 4 then
            actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Undertake the vision quest from the shaman in Three-Falls Canyon and defeat whatever awaits at the end.'")
        elseif actor:get_quest_stage("elemental_chaos") == 5 then
            actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Dispatch the Fangs of Yeenoghu.  Be sure to destroy all of them.'")
        elseif actor:get_quest_stage("elemental_chaos") == 6 then
            actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Extinguish the fire elemental lord who serves Krisenna.'")
        elseif actor:get_quest_stage("elemental_chaos") == 7 then
            actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Stop the acolytes in the Cathedral of Betrayal.'")
        elseif actor:get_quest_stage("elemental_chaos") == 8 then
            actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Destroy Cyprianum the Reaper in the heart of his maze.'")
        elseif actor:get_quest_stage("elemental_chaos") == 9 then
            actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Banish the Chaos Demon in Frost Valley.'")
        elseif actor:get_quest_stage("elemental_chaos") == 10 then
            actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Slay one of the Norhamen.'")
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'Give me more time to strategize how to bring Balance to Chaos.  Come back after you've gained some more experience.'")
end
if string.find(actor.class, "monk") then
    actor:send("</>")
    actor:send("</>")
    actor:send("<b:green>Enlightenment</>")
    local missionstage = actor:get_quest_stage("elemental_chaos")
    local visionstage = actor:get_quest_stage("monk_vision")
    local job1 = actor:get_quest_var("monk_vision:visiontask1")
    local job2 = actor:get_quest_var("monk_vision:visiontask2")
    local job3 = actor:get_quest_var("monk_vision:visiontask3")
    local job4 = actor:get_quest_var("monk_vision:visiontask4")
    local place
    if actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for a vision yet.  Come back when you've grown a bit.'")
    elseif actor:get_has_completed("monk_vision") then
        actor:send(tostring(self.name) .. " says, 'You are already awakened to the Illusion of Reality!'")
    elseif actor.level < (visionstage * 10) then
        actor:send(tostring(self.name) .. " says, 'You aren't ready to start a journey to Enlightenment yet.  Come back when you've grown a bit.'")
    elseif visionstage == 0 then
        actor:send(tostring(self.name) .. " says, 'You must undertake a <b:cyan>[mission]</> in service of Balance first.'")
    elseif (visionstage >= missionstage) and not actor:get_has_completed("elemental_chaos") then
        actor:send(tostring(self.name) .. " says, 'You must walk further along the Way in service of Balance first.'")
    else
        -- switch on visionstage
        local hint
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
        local attack = visionstage * 100
        if job1 or job2 or job3 or job4 then
            actor:send("You've done the following:")
            if job1 then
                actor:send("- attacked " .. tostring(attack) .. " times")
            end
            if job2 then
                actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
            end
            if job3 then
                actor:send("- found " .. "%get.obj_shortdesc[%book%]%")
            end
            if job4 then
                actor:send("- read in " .. tostring(place))
            end
            actor:send("</>")
        end
        actor:send("You need to:")
        if job1 and job2 and job3 and job4 then
            actor:send("Just give me your current vision mark.")
        else
            if not job1 then
                local remaining = attack - actor:get_quest_var("monk_vision:attack_counter")
                actor:send("- attack &9<blue>" .. tostring(remaining) .. "</> more times while wearing your vision mark.")
            end
            if not job4 then
                actor:send("- take <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</> and <b:yellow>%get.obj_shortdesc[%book%]%</> and <b:yellow>read</> in a place called \"<b:yellow>%place%</>\".")
                actor:send("</>   It's <b:green>" .. tostring(hint) .. "</>")
            else
                if not job2 then
                    actor:send("- give me <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</>")
                end
                if not job3 then
                    actor:send("- give me <b:yellow>" .. "%get.obj_shortdesc[%book%]%</>")
                end
            end
        end
    end
    if actor:get_quest_stage("monk_chants") then
        local chantstage = actor:get_quest_stage("monk_chants")
        -- switch on chantstage
        local chant, level, item, place
        if chantstage == 1 then
            chant = "Tremors of Saint Augustine"
            level = 30
            item = "a book surrounded by trees and shadows"
            place = "in a place that is both natural and urban, serenely peaceful and profoundly sorrowful"
        elseif chantstage == 2 then
            chant = "Tempest of Saint Augustine"
            level = 40
            item = "a scroll, dedicated to this particular chant, guarded by a creature of the same elemental affinity"
            place = "at the marker on a southern mountain range."
        elseif chantstage == 3 then
            chant = "Blizzards of Saint Augustine"
            level = 50
            item = "a book held by a master who in turn is a servant of a beast of winter"
            place = "in a temple shrouded in mists"
        elseif chantstage == 4 then
            chant = "Aria of Dissonance"
            level = 60
            item = "a book on war, held by a banished war god"
            place = "in a dark cave before a blasphemous book, near an unholy fire"
        elseif chantstage == 5 then
            chant = "Apocalyptic Anthem"
            level = 75
            item = "a scroll where illusion is inscribed over and over held by a brother who thirsts for escape"
            place = "in a chapel of the walking dead"
        elseif chantstage == 6 then
            chant = "Fires of Saint Augustine"
            level = 80
            item = "a scroll of curses, carried by children of air in a floating fortress"
            place = "at an altar dedicated to fire's destructive forces"
        elseif chantstage == 7 then
            chant = "Seed of Destruction"
            level = 99
            item = "the eye of one caught in an eternal feud"
            place = "at an altar deep in the outer realms surrounded by those who's vengeance was never satisfied"
        end
        actor:send("</>")
        actor:send("</>")
        actor:send("<b:green>Esoteric Chants</>")
        if actor.level >= level then
            if chantstage < (visionstage - 2) then
                actor:send(tostring(self.name) .. " says, 'You are seeking the chant " .. tostring(chant) .. ".'")
                actor:send("</>")
                actor:send(tostring(self.name) .. " says, 'You are looking for " .. tostring(item) .. ".")
                actor:send("Take it and <b:cyan>[meditate]</> " .. tostring(place) .. ".'")
            else
                actor:send(tostring(self.name) .. " says, 'You must first take another step towards <b:cyan>[enlightenment]</> before you can grasp more esoteric knowledge.'")
            end
        else
            actor:send(tostring(self.name) .. " says, 'You aren't ready to learn the next chant yet.'")
        end
    end
end$trig$, 'fe71113435cdc99296d809489a74c0b2'),
  -- data/triggers/053/053_57_hell_trident_progress_tracker.lua
  (53, 57, $trig$-- Converted from DG Script #5357: Hell Trident progress tracker
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: weapon progress (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "weapon progress", 1, true) then
    return true  -- Not the phrase
end
wait(2)
if string.find(actor.class, "diabolist") then
    local level, response
    if actor:get_quest_stage("hell_trident") then
        local hellstage = actor:get_quest_stage("hell_trident")
        if hellstage == 1 then
            level = 65
        elseif hellstage == 2 then
            level = 90
        end
        -- switch on self.id
        -- switch on hellstage
        if hellstage == 1 then
            response = "stage2"
        elseif hellstage == 2 then
            response = "stage3"
        else
            if actor:get_has_completed("hell_trident") then
                response = "complete"
            end
        end
        local step = 1
        local gem = 55662
        local pl_word = "angels"
        local word = "angel"
        local spell1 = "Hellfire and Brimstone"
        local quest1 = actor:get_has_completed("hellfire_brimstone")
        local spell2 = "Banish"
        local quest2 = actor:get_has_completed("banish")
        if not actor:get_quest_var("hell_trident:helltask6") and actor.level >= level and hellstage == 1 then
            if actor:get_quest_stage("vilekka_stew") > 3 then
                actor:set_quest_var("hell_trident", "helltask6", 1)
            end
        end
        local task6 = "assisted Vilekka Kar'Shezden"
        local task6do = "&3&bAssist the High Priestess of Lolth in hunting down and destroying the heretics of her Goddess.&0"
        local step = 2
        local gem = 55739
        local pl_word = "ghaeles, solars, or seraphs"
        local word = "ghaele, solar, or seraph"
        local spell1 = "Resurrect"
        local quest1 = actor:get_has_completed("resurrection_quest")
        local spell2 = "Hell Gate"
        local quest2 = actor:get_has_completed("hell_gate")
        local task6 = "Defeated the Undead Prince"
        local task6do = "find one long-buried and branded an infidel.  &3&bFinish his undying duel for him&0 as a sacrifice of honor."
        if hellstage == "step" then
            if actor.level >= level then
                if not actor:get_quest_var("hell_trident:helltask4") then
                    if quest1 then
                        actor:set_quest_var("hell_trident", "helltask4", 1)
                    end
                end
                if not actor:get_quest_var("hell_trident:helltask5") then
                    if quest2 then
                        actor:set_quest_var("hell_trident", "helltask5", 1)
                    end
                end
                if not actor:get_quest_var("hell_trident:greet") then
                    actor:send(tostring(self.name) .. " says, 'Tell me why you have come.'")
                else
                    local job1 = actor:get_quest_var("hell_trident:helltask1")
                    local job2 = actor:get_quest_var("hell_trident:helltask2")
                    local job3 = actor:get_quest_var("hell_trident:helltask3")
                    local job4 = actor:get_quest_var("hell_trident:helltask4")
                    local job5 = actor:get_quest_var("hell_trident:helltask5")
                    local job6 = actor:get_quest_var("hell_trident:helltask6")
                    if job1 or job2 or job3 or job4 or job5 or job6 then
                        actor:send(tostring(self.name) .. " says, 'You have done the following:'")
                        if job1 then
                            actor:send("- attacked 666 times")
                        end
                        if job2 then
                            actor:send("- slayed 6 " .. tostring(pl_word))
                        end
                        if job3 then
                            actor:send("- found 6 " .. "%get.obj_shortdesc[%gem%]%")
                        end
                        if job4 then
                            actor:send("- learned " .. tostring(spell1))
                        end
                        if job5 then
                            actor:send("- learned " .. tostring(spell2))
                        end
                        if job6 then
                            actor:send("- " .. tostring(task6))
                        end
                        actor:send("</>")
                    end
                    if job1 and job2 and job3 and job4 and job5 and job6 then
                        actor:send(tostring(self.name) .. " says, 'Give me your trident to finalize the pact.'")
                    else
                        actor:send("You must still:")
                        if not job1 then
                            local remaining = 666 - actor:get_quest_var("hell_trident:attack_counter")
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your trident</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your trident</>")
                            end
                        end
                        if not job2 then
                            local kills = 6 - actor:get_quest_var("hell_trident:celestials")
                            if kills > 1 then
                                actor:send("- <b:yellow>slay " .. tostring(kills) .. " more " .. tostring(pl_word) .. "</>")
                            else
                                actor:send("- <b:yellow>slay " .. tostring(kills) .. " more " .. tostring(word) .. "</>")
                            end
                        end
                        if not job3 then
                            local gems = 6 - actor:get_quest_var("hell_trident:gems")
                            if gems > 1 then
                                actor:send("- <b:yellow>find " .. tostring(gems) .. " more " .. "%get.obj_pldesc[%gem%]%</>")
                            else
                                actor:send("- <b:yellow>find " .. tostring(gems) .. " more " .. "%get.obj_noadesc[%gem%]%</>")
                            end
                        end
                        if not job4 then
                            actor:send("- <b:yellow>learn " .. tostring(spell1) .. "</>")
                        end
                        if not job5 then
                            actor:send("- <b:yellow>learn " .. tostring(spell2) .. "</>")
                        end
                        if not job6 then
                            actor:send("- " .. tostring(task6do))
                        end
                    end
                end
            else
                response = "level"
            end
        else
            if actor:get_has_completed("hell_trident") then
                response = "complete"
            elseif actor:get_quest_stage("hell_trident") < step then
                response = "stage1"
            else
                response = "stage3"
            end
        end
    end
    if response == "stage1" then
        actor:send(tostring(self.name) .. " says, 'You must make the initial offerings with another dark priest.'")
    elseif response == "stage2" then
        if actor.level >= level then
            actor:send(tostring(self.name) .. " says, 'Hell hungers for more and will reward you greatly if you feed it.  Attack with that trident 666 times then seek out the Black Priestess, the left hand of Ruin Wormheart.  She will guide your offerings.'")
        else
            actor:send(tostring(self.name) .. " says, 'Other forces of Hell will eventually take notice of you too now.  Seek out the left hand of Ruin Wormheart, the Black Priestess, after you have grown more.  She will be your emissary.'")
            actor:send("<red>You must be level " .. tostring(level) .. " or greater to continue this quest.</>")
        end
    elseif response == "stage3" then
        if actor.level >= level then
            actor:send(tostring(self.name) .. " says, 'The Demon Lord Krisenna is known to traffic with mortals from time to time.  Impress him and perhaps he will grant you a boon.'")
        else
            actor:send(tostring(self.name) .. " says, 'Continue to prove your value to Hell and perhaps a Demon Lord might be willing to grant your their patronage.'")
            actor:send("<red>You must be level " .. tostring(level) .. " or greater to continue this quest.</>")
        end
    elseif response == "complete" then
        actor:send(tostring(self.name) .. " says, 'You've already marshalled the forces of Hell and Damnation to your side!'")
    elseif response == "level" then
        actor:send(tostring(self.name) .. " say, 'Stand before me again when you have achieved a larger measure of greatness.'")
        actor:send("<red>You must be level " .. tostring(level) .. " or greater to continue this quest.</>")
    end
end$trig$, 'df60046d4ddfb86c4a8ac0811863d430'),
  -- data/triggers/055/055_18_degeneration_cat_greet.lua
  (55, 18, $trig$-- Converted from DG Script #5518: degeneration_cat_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
local stage = actor:get_quest_stage("degeneration")
if string.find(actor.class, "necromancer") then
    if actor.level > 80 then
        if stage == 0 then
            self.room:send(tostring(self.name) .. " says, 'Ah, finally a visitor worth my attention.  Have you come to")
            self.room:send("</>advance your knowledge of the deathly arts?'")
        elseif stage == 1 then
            self:say("Do you have Yajiro's book?")
        elseif stage == 2 then
            self:say("Do you have Mesmeriz's necklace?")
        elseif stage == 3 then
            self:say("Do you have Luchiaans' mask?")
        elseif stage == 4 then
            self:say("Do you have Voliangloch's rod?")
        elseif stage == 5 then
            self:say("Do you have Kryzanthor's robe?")
        elseif stage == 6 then
            self:say("Do you have Ureal's statuette?")
        elseif stage == 7 or stage == 8 then
            self:say("Do you have Norisent's book?")
        elseif stage == 9 then
            self:say("Do you have the ruby?")
        end
    end
end$trig$, 'a1fd3639580e91ddca5eeee46fd8cf3b'),
  -- data/triggers/055/055_19_degeneration_cat_speech1.lua
  (55, 19, $trig$-- Converted from DG Script #5519: degeneration_cat_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes arts?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "arts?")) then
    return true  -- No matching keywords
end
wait(2)
if string.find(actor.class, "necromancer") and actor.level > 80 and actor:get_quest_stage("degeneration") == 0 then
    self.room:send(tostring(self.name) .. " says, 'I've been working for many years on a new spell to suffuse")
    self.room:send("</>beings with the energy of the dead.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'There are seven dark wizards whose work I believe will help")
    self.room:send("</>me complete the spell.  Each one carries a focus I need you to bring back so I")
    self.room:send("</>can better understand their spellcraft techniques.'")
    wait(6)
    self:say("I'll start you off with the weakest of the targets.")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'On the Emerald Isle is a man named Yajiro.  Although his")
    self.room:send("</>magic is underdeveloped, he has somehow managed to summon an impressive demon")
    self.room:send("</>and imprison a goddess.'")
    wait(6)
    self.room:send(tostring(self.name) .. " says, 'Bring me his book so I may glean what information I can")
    self.room:send("</>about his techniques.'")
    actor:start_quest("degeneration")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'If you need, I can remind you of your <b:white>[spell progress]</>.'")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Say <b:white>[faction status]</> if you wish to speak with the Third")
    self.room:send("</>Black Legion Quartermaster over there.'")
elseif actor:get_quest_stage("degeneration") > 0 then
    self:say("Give it to me then!")
end$trig$, '59206c52dc850a98316deb19baac47f6'),
  -- data/triggers/060/060_05_quest_timulos_greet.lua
  (60, 5, $trig$-- Converted from DG Script #6005: quest_timulos_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
local quest_name = actor:get_quest_var("merc_ass_thi_subclass:subclass_name")
local quest_stage = actor:get_quest_stage("merc_ass_thi_subclass")
-- Restructured: the converter mangled the nested switch. The original DG
-- was switch(quest_stage) { case 1/2/3-4 { switch(subclass_name) }}.
if quest_name then
    if quest_stage == 1 then
        if quest_name == "thief" then
            actor:send(tostring(self.name) .. " says, 'Back to try your hand at being a thief?  There is a <b:cyan>package</> that someone could get back.'")
        elseif quest_name == "mercenary" then
            actor:send(tostring(self.name) .. " says, 'If you want to continue training as a mercenary, listen up.  A <b:cyan>lord</> needs our services.'")
        elseif quest_name == "assassin" then
            actor:send(tostring(self.name) .. " says, 'Ah, you are back!  I believe I have a job for a trainee assassin.  One that would bring a good <b:cyan>price</>.'")
        end
    elseif quest_stage == 2 then
        if quest_name == "thief" then
            actor:send(tostring(self.name) .. " says, 'You getting cold feet about being a thief?  It's just stealing a package from some farmers.'")
            self:command("grumble")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Bloody <b:cyan>farmers</>.'")
        elseif quest_name == "mercenary" then
            actor:send(tostring(self.name) .. " says, 'Back to continue your mercenary training?  You're probably wondering about the <b:cyan>cloak</>.'")
        elseif quest_name == "assassin" then
            actor:send(tostring(self.name) .. " says, 'Stop wasting my time and finish your assassin training. I have some rich men unhappy with the politics of the region in question.  You could help with those <b:cyan>politics</> if you wish.'")
        end
    elseif quest_stage == 3 or quest_stage == 4 then
        if quest_name == "thief" then
            actor:send(tostring(self.name) .. " says, 'Hurry up and finish your thief training.  Deliver the <b:yellow>package</> those Mielikki farmers walked off with!'")
        elseif quest_name == "mercenary" then
            actor:send(tostring(self.name) .. " says, 'Have you put your mercenary potential to good use?  Give me the <b:yellow>cloak</> the insect warriors stole.'")
        elseif quest_name == "assassin" then
            actor:send(tostring(self.name) .. " says, 'Is the job done?'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Shhhh, don't say anything!  Assassins keep their secrets.'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'But do give me the target's <b:yellow>cane</> if you have it.'")
        end
    end
else
    if actor:get_has_failed("merc_ass_thi_subclass") then
        actor:send(tostring(self.name) .. " says, 'That could have gone better.  I see you failed your mission.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'I suppose you want to try again.'")
    elseif string.find(actor.class, "rogue") and (actor.level >= 10 and actor.level <= 25) then
        actor:send(tostring(self.name) .. " says, '" .. tostring(actor.name) .. ", have you come to me for training?'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Well?  Do you want <b:cyan>training</> " .. tostring(actor.name) .. " or are you just going to stand there?'")
        self:command("tap")
    elseif string.find(actor.class, "rogue") and actor.level < 10 then
        actor:send(tostring(self.name) .. " says, '" .. tostring(actor.name) .. ", have you come to me for trai- '")
        wait(2)
        self:emote("stops cold.")
        wait(1)
        self:command("eye " .. tostring(actor))
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You might be a bit green for my training, kid.'")
    end
end$trig$, 'b309868a31c60144bdb495237c9c8267'),
  -- data/triggers/060/060_06_quest_timulos_training.lua
  (60, 6, $trig$-- Converted from DG Script #6006: quest_timulos_training
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: training
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "training")) then
    return true  -- No matching keywords
end
wait(2)
if string.find(actor.class, "rogue") then
    if actor.level >= 10 and actor.level <= 25 then
        if not use_subclass then
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
    wait(2)
    -- this may need to be changed in the future if new classes are invented that aren't just <name>s for pluralizing.
    actor:send(tostring(self.name) .. " says, 'I don't work with " .. tostring(actor.class) .. "s.'")
end$trig$, 'c9e84be3752887c9e5d029fadfd51327'),
  -- data/triggers/060/060_07_quest_timulos_merc.lua
  (60, 7, $trig$-- Converted from DG Script #6007: quest_timulos_merc
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: mercenary
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "mercenary")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "rogue") then
    -- switch on actor.race
    -- case ADD NEW RESTRICTED RACES HERE
    -- if actor.level% >= 10 && %actor.level% <= 25
    -- msend %actor% &1Your race may not subclass to mercenary.&0
    -- halt
    -- endif
    wait(2)
    if actor.level >= 10 and actor.level <= 25 then
        if use_subclass then
            actor:send(tostring(self.name) .. " says, 'One moment, I'm getting someone else set up.'")
            actor:send(tostring(self.name) .. " ushers you into the corner.")
            self.room:send_except(actor, tostring(self.name) .. " ushers " .. tostring(actor.name) .. " into the corner.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Wait there.'")
        else
            actor:send(tostring(self.name) .. " says, 'So, you wish to become a mercenary do you?'")
            local use_subclass = "Mer"
            globals.use_subclass = globals.use_subclass or true
        end
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'I like your zeal, but it's a little too soon for you to subclass kid.'")
    else
        actor:send(tostring(self.name) .. " says, 'It's waaaaaaay too late to train you.  That ship has sailed!'")
    end
else
    actor:send(tostring(self.name) .. " says, 'I do not know how to train you to be one, sorry, go away.'")
end$trig$, '2530b24bea576734f07672c35136439a'),
  -- data/triggers/060/060_08_quest_timulos_assassin.lua
  (60, 8, $trig$-- Converted from DG Script #6008: quest_timulos_assassin
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: assassin
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "assassin")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "rogue") then
    -- switch on actor.race
    -- case ADD NEW RESTRICTED RACES HERE
    -- if actor.level% <= 25
    -- msend %actor% &1Your race may not subclass to assassin.&0
    -- halt
    -- endif
    wait(2)
    if actor.level >= 10 and actor.level <= 25 then
        if actor.alignment <= -350 then
            if use_subclass then
                actor:send(tostring(self.name) .. " says, 'One moment, I'm getting someone else set up.'")
                actor:send(tostring(self.name) .. " ushers you into the corner.")
                self.room:send_except(actor, tostring(self.name) .. " ushers " .. tostring(actor.name) .. " into the corner.")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'Wait there.'")
            else
                actor:send(tostring(self.name) .. " says, 'So, you wish to become an assassin do you?'")
                local use_subclass = "Ass"
                globals.use_subclass = globals.use_subclass or true
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
end$trig$, '4cd6020025c8c82401c53b8fd9fac604'),
  -- data/triggers/060/060_09_quest_timulos_thief.lua
  (60, 9, $trig$-- Converted from DG Script #6009: quest_timulos_thief
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: thief
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "thief")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "rogue") then
    -- switch on actor.race
    -- case ADD NEW RESTRICTED RACES HERE
    -- if actor.level% <= 25
    -- msend %actor% &1Your race may not subclass to thief.&0
    -- halt
    -- endif
    wait(2)
    if actor.level >= 10 and actor.level <= 25 then
        if use_subclass then
            actor:send(tostring(self.name) .. " says, 'One moment, I'm getting someone else set up.'")
            actor:send(tostring(self.name) .. " ushers you into the corner.")
            self.room:send_except(actor, tostring(self.name) .. " ushers " .. tostring(actor.name) .. " into the corner.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Wait there.'")
        else
            actor:send(tostring(self.name) .. " says, 'So, you wish to become a thief do you?'")
            local use_subclass = "Thi"
            globals.use_subclass = globals.use_subclass or true
        end
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'I like your zeal, but it's a little too soon for you too subclass kid.'")
    else
        actor:send(tostring(self.name) .. " says, 'It's waaaaaaay too late to train you.  That ship has sailed!'")
    end
else
    actor:send(tostring(self.name) .. " says, 'I do not know how to train you to be one, sorry, go away.'")
end$trig$, '7e1bbb3c0f9a01e2778668aa881c9d6b'),
  -- data/triggers/060/060_10_quest_timulous_yesno.lua
  (60, 10, $trig$-- Converted from DG Script #6010: quest_timulous_yesno
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
end
wait(2)
if string.find(actor.class, "rogue") and (actor.level >= 10 and actor.level <= 25) then
    if string.find(speech, "yes") then
        if actor:get_has_failed("merc_ass_thi_subclass") then
            actor:restart_quest("merc_ass_thi_subclass")
            actor:advance_quest("merc_ass_thi_subclass")
            actor:advance_quest("merc_ass_thi_subclass")
            self:command("nod")
            actor:send(tostring(self.name) .. " says, 'Then try again.'")
            wait(2)
            if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "thief" then
                actor:send(tostring(self.name) .. " says, 'Be careful this time!  Stay hidden getting in and out.'")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'And no murdering anyone!'")
            elseif actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "assassin" then
                actor:send(tostring(self.name) .. " says, 'And be quick about it!'")
            end
            return _return_value
        end
        if use_subclass then
            actor:start_quest("merc_ass_thi_subclass", use_subclass)
            self:command("nod")
            actor:send(tostring(self.name) .. " says, 'So, you truly wish to continue.'")
            wait(1)
            if string.find(use_subclass, "Mer") then
                actor:send(tostring(self.name) .. " says, 'Yes, a mercenary would serve well for that...'")
                self:emote("thinks back for a moment.")
                wait(1)
                actor:send(tostring(self.name) .. " says, 'He would pay well.  Yes, that <b:cyan>Lord</> would pay well indeed.'")
            elseif string.find(use_subclass, "Ass") then
                actor:send(tostring(self.name) .. " says, 'An assassin would be perfect, but to show your true desire...'")
                self:emote("grins deeply, curling his lip up.")
                wait(1)
                actor:send(tostring(self.name) .. " says, 'Yes, that would bring a good <b:cyan>price</>.'")
            elseif string.find(use_subclass, "Thi") then
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
use_subclass = nil$trig$, 'c1bb86c87b40e8c58120964684269a3c'),
  -- data/triggers/060/060_25_quest_timulos_status.lua
  (60, 25, $trig$-- Converted from DG Script #6025: quest_timulos_status
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: subclass progress
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "subclass") or string.find(string.lower(speech), "progress")) then
    return true  -- No matching keywords
end
wait(2)
local quest_name = actor:get_quest_var("merc_ass_thi_subclass:subclass_name")
local quest_stage = actor:get_quest_stage("merc_ass_thi_subclass")
-- Restructured: the converter mangled the nested switch. The original DG
-- was switch(quest_stage) { case 1/2/3-4 { switch(subclass_name) }}.
if quest_name then
    if quest_stage == 1 then
        if quest_name == "mercenary" then
            actor:send(tostring(self.name) .. " says, 'Yes, a mercenary would serve well for that...'")
            self:emote("thinks back for a moment.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'He would pay well.  Yes, that <b:cyan>Lord</> would pay well indeed.'")
        elseif quest_name == "assassin" then
            actor:send(tostring(self.name) .. " says, 'An assassin would be perfect, but to show your true desire...'")
            self:emote("grins deeply, curling his lip up.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Yes, that would bring a good <b:cyan>price</>.'")
        elseif quest_name == "thief" then
            actor:send(tostring(self.name) .. " says, 'Hmmm, a true thief would have to get something I think.'")
            self:emote("smiles cruelly.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'There is a <b:cyan>package</> that someone could get back.'")
        end
    elseif quest_stage == 2 then
        if quest_name == "mercenary" then
            actor:send(tostring(self.name) .. " says, 'Well, a great Lord, who shall remain unnamed, has lost a cloak.'")
            self:command("smirk")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'He has come to me for its return.  If you went and procured it, he would be grateful.'")
            self:command("grin")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'And if he is grateful, I would be as well, and your training would be finished.  It would be quite a payday for a <b:cyan>cloak</>.'")
        elseif quest_name == "thief" then
            actor:send(tostring(self.name) .. " says, 'Yes a package.'")
            self:command("fume")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Some time ago it was sent and picked up by someone who should not have it.'")
            self:command("grumble")
            wait(3)
            actor:send(tostring(self.name) .. " says, 'Bloody <b:cyan>farmers</>.'")
        elseif quest_name == "assassin" then
            actor:send(tostring(self.name) .. " says, 'Yes, a great price.'")
            self:command("grin")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'I have some rich men unhappy with the politics of the region in question.  You could help with those <b:cyan>politics</> if you wish.'")
        end
    elseif quest_stage == 3 or quest_stage == 4 then
        if quest_name == "mercenary" then
            actor:send(tostring(self.name) .. " says, 'Well yes, this cloak is worth much to him.'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'It was made off with in a raid on his castle by some bothersome insect warriors.'")
            self:command("mutter")
            wait(3)
            actor:send(tostring(self.name) .. " says, 'All the Lord was able to tell me is they said something about wanting it for their queen.'")
            self:command("shrug")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I think you should go find it now.  Come back when you have the <b:yellow>cloak</>, do not come back at all.'")
            self:command("open fence")
            self:emote("pushes " .. tostring(actor.name) .. " away.")
            actor:move("north")
            self:command("close fence")
        elseif quest_name == "assassin" then
            actor:send(tostring(self.name) .. " says, 'Ah yes, the politics of it all.  Personally I am not one for them, but some people get all mixed up in those.'")
            wait(2)
            self:command("consider " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'Well, you seem fit, I guess.'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Go kill the Mayor of Mielikki.  He's probably holed up in his office in City Hall.'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'You'll have to break in, sneak past the guards, and <red>kill</> him.  Get his <b:yellow>cane</> as proof and come back and give it to me.'")
            wait(4)
            actor:send(tostring(self.name) .. " says, 'It is worth much to me if he dies, so get to it.  It will be worth it for you as well.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Well, go on.'")
            self:command("open fence")
            self:emote("pushes " .. tostring(actor.name) .. " away.")
            actor:move("north")
            self:command("close fence")
        elseif quest_name == "thief" then
            actor:send(tostring(self.name) .. " says, 'That is right, a <b:yellow>package</> was taken by a farmer who should not have it.'")
            self:command("grumble")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I know this: he got it from the post office in Mielikki and he lives near there.  Go get it back and I will make it worth it to you.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Do not let anyone see you do not leave a trail of bodies behind you.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'And be careful!  If you jostle the package too much it just might explode.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'For now though, we are done, begone.'")
            wait(2)
            self:command("open fence")
            actor:send(tostring(self.name) .. " says, 'Well, go on.'")
            self:emote("pushes " .. tostring(actor.name) .. " harshly away.")
            actor:move("north")
            self:command("close fence")
        end
    end
else
    if string.find(actor.class, "rogue") then
        if actor.level >= 10 and actor.level <= 25 then
            actor:send(tostring(self.name) .. " says, 'You are not on any quests from me.'")
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'I like your zeal, but it's a little too soon for you to subclass kid.'")
        else
            actor:send(tostring(self.name) .. " says, 'It's waaaaaaay too late to train you.  That ship has sailed!'")
        end
    else
        actor:send(tostring(self.name) .. " says, 'I don't train \"your type.\"  Now get lost.'")
    end
end$trig$, 'e28825a448600326da9c598e183473ca'),
  -- data/triggers/060/060_50_berix_bounty_hunt_greet.lua
  (60, 50, $trig$-- Converted from DG Script #6050: Berix bounty hunt greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
if not actor:get_has_completed("bounty_hunt") then
    if not actor:get_quest_stage("bounty_hunt") then
        if actor.alignment <= -350 or string.find(actor.class, "assassin") or string.find(actor.class, "mercenary") then
            actor:send(tostring(self.name) .. " says, 'Well hello there.  You look like quite a piece of work.  I think I have a <b:cyan>[job]</> for you.'")
        else
            actor:send(tostring(self.name) .. " says, 'What do you want?'")
        end
    elseif actor:get_quest_var("bounty_hunt:bounty") == "running" then
        actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  What are you doing here?  If you lost your contract like a moron, say, <b:cyan>\"I need a new contract\"</>.'")
    elseif actor:get_quest_var("bounty_hunt:bounty") == "dead" then
        actor:send(tostring(self.name) .. " says, 'If you got the job done, give me your contract.  If you lost your contract like a moron, say, <b:cyan>\"I need a new contract\"</>.'")
    elseif actor:get_quest_stage("bounty_hunt") >= 1 and not actor:get_has_completed("bounty_hunt") then
        actor:send(tostring(self.name) .. " says, 'Ah, back for another <b:cyan>[job]</> I see.'")
    end
    if not actor:get_has_completed("assassin_mask") and actor.level > 9 and string.find(actor.class, "assassin") then
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Or maybe you're here to discuss a <b:cyan>[promotion]</>.'")
    end
else
    if string.find(actor.class, "assassin") and not actor:get_quest_stage("assassin_mask") and actor.level > 9 then
        actor:send(tostring(self.name) .. " says, 'Oh look, someone else in line for a <b:cyan>[promotion]</>.'")
    elseif actor:get_quest_stage("assassin_mask") and not actor:get_has_completed("assassin_mask") then
        actor:send(tostring(self.name) .. " says, 'Ah, you must be looking for another <b:cyan>[promotion]</>.'")
    end
end$trig$, '1d59a3781e46896c40709826eee01ed2'),
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
        if string.find(actor.class, "assassin") and actor:get_quest_stage("assassin_mask") == 0 then
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
return _return_value$trig$, 'ad09aeedf445aca89e92486f883d7756'),
  -- data/triggers/062/062_01_necromancer_quest_spell_hints_and_shift_corpse_sta.lua
  (62, 1, $trig$-- TODO(parity): The original DG script's structure for the "degeneration"
-- branch is ambiguous after conversion (empty inner if + dangling elseif).
-- Current behavior: Necromancer guildmaster handles shift/corpse for
-- Necromancer askers; "degeneration" / fallback hint live below in a
-- separate top-level branch. Verify against DG #6201 source if available.

-- Speech keywords: shift corpse degeneration
if not (string.find(string.lower(speech), "shift")
        or string.find(string.lower(speech), "corpse")
        or string.find(string.lower(speech), "degeneration")) then
    return true
end
wait(2)
if string.find(self.class, "necromancer") then
    if speech == "degeneration" or speech == "degeneration?" then
        self.room:send(tostring(self.name) .. " says, 'Controlling negative energy to bolster the dead or")
        self.room:send("</>degenerate the living is theoretically possible.  Someone is working to")
        self.room:send("</>develop a &9<blue>Degeneration</> spell for use in the ongoing battle against")
        self.room:send("</>the Eldorian Guard.'")
    elseif string.find(actor.class, "necromancer") and actor:get_quest_stage("shift_corpse") == 0 then
        if speech == "shift" or speech == "shift?" or speech == "corpse" or speech == "corpse?" or speech == "shift corpse" or speech == "shift corpse?" then
            self:say("So you want to learn our most powerful secrets, eh?")
            self:command("peer " .. tostring(actor))
            wait(1)
            if actor.level < 97 then
                self.room:send(tostring(self.name) .. " says, 'Unfortunately you are not prepared to handle such magic.")
                self.room:send("</>There are easier ways to kill yourself.'")
            else
                self:command("nod")
                self.room:send(tostring(self.name) .. " says, 'I will teach you the words to the spell.  But the words")
                self.room:send("</>alone are meaningless.  The true power to fuel Shift Corpse cannot be")
                self.room:send("</>taught - it must be taken.'")
                wait(2)
                self:say("You must steal the power of a god.")
                actor:start_quest("shift_corpse")
            end
        else
            self.room:send_except(actor, tostring(self.name) .. " sneers at " .. tostring(actor.name) .. ".")
            actor:send(tostring(self.name) .. " sneers at you.")
            self:say("This magic is not for you!")
        end
    else
        self:say("That spell is far outside the realm of our Guild.")
    end
else
    self.room:send(tostring(self.name) .. " says, 'Only a powerful member of the Necromancer Guild")
    self.room:send("</>might know how to cast such a spell.'")
end$trig$, '63d7ebdf4785c42c92e1dec160511b71'),
  -- data/triggers/062/062_04_pyromancer_quest_spell_hints_and_supernova_start.lua
  (62, 4, $trig$-- TODO(parity): Original DG branching for non-supernova hints (meteorswarm,
-- diabolist response, fallback) is ambiguous after conversion (empty inner if
-- + dangling elseif). Pyromancers fall through to spell-specific hints below;
-- verify against DG #6204 source if this is wrong.

if not (string.find(string.lower(speech), "supernova")
        or string.find(string.lower(speech), "super")
        or string.find(string.lower(speech), "nova")
        or string.find(string.lower(speech), "meteor")
        or string.find(string.lower(speech), "swarm")) then
    return true
end
wait(2)
if string.find(self.class, "pyromancer") then
    -- Supernova quest entrypoint, Pyromancer asker only
    if speech == "super" or speech == "super?" or speech == "nova" or speech == "nova?" or speech == "supernova" or speech == "supernova?" then
        if string.find(actor.class, "pyromancer") then
            if actor.level > 88 then
                if actor:get_quest_stage("supernova") == 0 then
                    actor:start_quest("supernova")
                    self.room:send(tostring(self.name) .. " says, 'Supernova is really only taught by one person:")
                    self.room:send("</>Phayla, daughter of the Sun.'")
                    wait(1)
                    self.room:send(tostring(self.name) .. " says, 'Phayla is one of the most powerful sorceresses in")
                    self.room:send("</>existence.  Beings from all across the universe have sought her out for just a")
                    self.room:send("</>chance to study under her.  Most fail to find her.  She has agreed to teach")
                    self.room:send("</>even fewer.'")
                    wait(5)
                    self.room:send(tostring(self.name) .. " says, 'She resides in a demiplane of her own creation.")
                    self.room:send("</>It's constantly shifting and changing, so it's impossible for anyone but Phayla")
                    self.room:send("</>to know where it is or how to access it without help.'")
                    wait(2)
                    self.room:send(tostring(self.name) .. " says, 'However, she likes to leave clues to accessing it")
                    self.room:send("</>scattered throughout the world.'")
                    wait(4)
                    self.room:send(tostring(self.name) .. " says, 'On their own, the clues are illegible and")
                    self.room:send("</>unintelligible.  The keys to reading them are lamps Phayla gives to her most")
                    self.room:send("</>ardent and formidable followers.'")
                    wait(4)
                    self:say("If you find one I may be able to help you more.")
                    wait(2)
                    self.room:send(tostring(self.name) .. " says, 'You can check in with me about your <b:white>[progress]</>")
                    self.room:send("</>toward learning Supernova at any time.'")
                    self.room:send(tostring(self.name) .. " says, 'If you want to know about your armor quests, ask")
                    self.room:send("</>me about your <white></>[status]</> instead.'")
                else
                    self.room:send(tostring(self.name) .. " says, 'You're not ready to be asking about such an")
                    self.room:send("</>awesome spell.  We can do a follow-up visit after you gain some more")
                    self.room:send("</>experience.'")
                end
            else
                self:say("Supernova is beyond your discipline.")
            end
        else
            self:say("Supernova is far outside our discipline.")
        end
    elseif speech == "meteor" or speech == "meteor?" or speech == "swarm" or speech == "swarm?" or speech == "meteorswarm" or speech == "meteorswarm?" then
        self.room:send(tostring(self.name) .. " says, 'Crazy old McCabe the Elementalist has developed")
        self.room:send("</>such a spell. If you can find him, you might be able to persuade him to teach")
        self.room:send("</>you <b:red>Meteorswarm</>.'")
        self.room:send("</>He likes the devastating effects of volcanoes.'")
    else
        self.room:send(tostring(self.name) .. " says, 'I'm afraid I can't help you with that particular")
        self.room:send("</>spell.'")
    end
end
return true$trig$, 'bda2a13bf49b3e01b0aa05ebeee58741'),
  -- data/triggers/085/085_00_ziijhan_welcome.lua
  (85, 0, $trig$-- Converted from DG Script #8500: ziijhan_welcome
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
-- switch on actor:get_quest_stage("nec_dia_ant_subclass")
if actor:get_quest_stage("nec_dia_ant_subclass") == 1 then
    actor:send(tostring(self.name) .. " says, 'So you come crawling back.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Only the most cunning and strong will complete the <magenta>quest</> I set before you.  I shall take great pleasure in your demise, but I will offer great rewards for your success.'")
elseif actor:get_quest_stage("nec_dia_ant_subclass") == 2 then
    actor:send(tostring(self.name) .. " says, 'It is time to hunt!'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'My pitiful waste of a <magenta>brother</> escaped my minions.'")
elseif actor:get_quest_stage("nec_dia_ant_subclass") == 3 or actor:get_quest_stage("nec_dia_ant_subclass") == 4 then
    actor:send(tostring(self.name) .. " says, 'Have you brought proof that my brother is not beyond my reach?'")
else
    local classgreet = "no"
    local maxlevel = 0
    if string.find(actor.class, "warrior") then
        if actor.race ~= "elf" and actor.race ~= "faerie_seelie" then
            classgreet = "yes"
            maxlevel = 25
        end
    elseif string.find(actor.class, "cleric") then
        if actor.race ~= "elf" and actor.race ~= "faerie_seelie" then
            classgreet = "yes"
            maxlevel = 35
        end
    elseif string.find(actor.class, "sorcerer") then
        if actor.race ~= "elf" and actor.race ~= "faerie_seelie" then
            classgreet = "yes"
            maxlevel = 45
        end
    end
    if classgreet == "yes" then
        if actor.level >= 10 and actor.level <= maxlevel then
            self:command("peer " .. tostring(actor.name))
            self:emote("places a most vile half-smile on his face.")
            actor:send(tostring(self.name) .. " says, 'Some know not of their <magenta>destinies</>, while others simply choose to ignore them.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Which of the two are you?'")
            self:command("glare " .. tostring(actor.name))
        end
    end
    -- TODO(parity): legacy phase_mace upgrade hook compared a quest stage
    -- against the literal string "macestep" and then multiplied that string
    -- by 10. The original DG used %macestep% as a numeric quest var; the
    -- conversion is corrupt. Reconstruct once phase_mace quest semantics
    -- are pinned down (likely: stage = current upgrade tier, minlevel = stage*10).
end  -- auto-close block$trig$, '94a893ddd3e60a371bd8aef23fab7320'),
  -- data/triggers/085/085_01_quest_preamble_ziijhan.lua
  (85, 1, $trig$-- Converted from DG Script #8501: quest_preamble_ziijhan
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: destiny destiny? destinies destinies? I know
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "destiny") or string.find(speech_lower, "destinies") or string.find(speech_lower, "i know")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("nec_dia_ant_subclass") then
    return true
end

local classquest = false
if string.find(actor.class, "warrior") then
    if actor.level >= 10 and actor.level <= 25 then
        if actor.race == "elf" or actor.race == "faerie_seelie" then
            actor:send("<red>Your race may not subclass to anti-paladin.</>")
            return true
        end
        classquest = true
    end
elseif string.find(actor.class, "cleric") then
    if actor.level >= 10 and actor.level <= 35 then
        if actor.race == "elf" or actor.race == "faerie_unseelie" then
            actor:send("<red>Your race may not subclass to diabolist.</>")
            return true
        end
        classquest = true
    end
elseif string.find(actor.class, "sorcerer") then
    if actor.level >= 10 and actor.level <= 45 then
        if actor.race == "elf" or actor.race == "faerie_seelie" then
            actor:send("<red>Your race may not subclass to necromancer.</>")
            return true
        end
        classquest = true
    end
else
    actor:send(tostring(self.name) .. " says, 'Sorry, I cannot help you achieve your destiny.'")
    return true
end

if not classquest then
    return true
end

wait(2)
if globals.use_subclass then
    actor:send(tostring(self.name) .. " says, 'Sorry little one.  I am already setting up one quest - come back in a moment.'")
    return true
end
if actor.alignment >= -349 then
    actor:send(tostring(self.name) .. " says, 'Begone, fool.  You are far too righteous to join our brotherhood.'")
    return true
end

self:command("nod " .. tostring(actor.name))
local subclass = nil
if string.find(actor.class, "warrior") then
    if actor.level >= 10 and actor.level <= 25 then
        actor:send(tostring(self.name) .. " says, 'Do ye wish to join the ranks of the unholy warriors?'")
        subclass = "Ant"
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'Strong thirst for slaughter for one so young.  Come back once you've gained some more experience.'")
    else
        actor:send(tostring(self.name) .. " says, 'You are already following your destiny.  I cannot help you any further.'")
    end
elseif string.find(actor.class, "cleric") then
    if actor.level >= 10 and actor.level <= 35 then
        actor:send(tostring(self.name) .. " says, 'Do ye wish to join the ranks of the diabolists and derive power from madness and darkness?'")
        subclass = "Dia"
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'Strong thirst for madness for one so young.  Come back once you've gained some more experience.'")
    else
        actor:send(tostring(self.name) .. " says, 'You are already following your destiny.  I cannot help you any further.'")
    end
elseif string.find(actor.class, "sorcerer") then
    if actor.level >= 10 and actor.level <= 45 then
        actor:send(tostring(self.name) .. " says, 'Do ye wish to join the ranks of the necromancers and have power over death?'")
        subclass = "Nec"
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'Strong thirst for death for one so young.  Come back once you've gained some more experience.'")
    else
        actor:send(tostring(self.name) .. " says, 'You are already following your destiny.  I cannot help you any further.'")
    end
end
if subclass then
    globals.use_subclass = subclass
end
return true$trig$, 'fd0beccf77045d3e9a1554eb17470eca'),
  -- data/triggers/085/085_02_start_quest_ziijhan.lua
  (85, 2, $trig$-- Converted from DG Script #8502: start_quest_ziijhan
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "yes") or string.find(speech_lower, "no")) then
    return true  -- No matching keywords
end
local classquest = false
if string.find(actor.class, "cleric") and actor.level >= 10 and actor.level <= 35 then
    if actor.race == "elf" or actor.race == "faerie_seelie" then
        actor:send("<red>Your race may not subclass to diabolist.</>")
        return true
    end
    classquest = true
elseif string.find(actor.class, "warrior") and actor.level >= 10 and actor.level <= 25 then
    if actor.race == "elf" or actor.race == "faerie_seelie" then
        actor:send("<red>Your race may not subclass to anti-paladin.</>")
        return true
    end
    classquest = true
elseif string.find(actor.class, "sorcerer") and actor.level >= 10 and actor.level <= 45 then
    if actor.race == "elf" or actor.race == "faerie_seelie" then
        actor:send("<red>Your race may not subclass to necromancer.</>")
        return true
    end
    classquest = true
end
if classquest then
    if string.find(speech_lower, "yes") then
        if actor:get_quest_stage("nec_dia_ant_subclass") == 0 then
            actor:start_quest("nec_dia_ant_subclass", globals.use_subclass)
        end
        globals.use_subclass = nil
        wait(2)
        self:command("nod")
        actor:send(tostring(self.name) .. " says, 'Only the most cunning and strong will complete the <magenta>quest</> I set before you.  I shall take great pleasure in your demise, but I will offer great rewards for your success.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'I can update you on your <magenta>[subclass progress]</> as well.'")
    elseif string.find(speech_lower, "no") then
        globals.use_subclass = nil
        actor:send(tostring(self.name) .. " says, 'Begone from my sight before I lose patience with you!'")
        self:command("whap " .. tostring(actor.name))
        actor:send("Ziijhan waves his arms in a circle and you are blinded by a flash of light!")
        self.room:send_except(actor, "Ziijhan glares at " .. tostring(actor.name) .. " and sends " .. tostring(actor.object) .. " elsewhere!")
        actor:teleport(get_room(85, 1))
    end
end$trig$, 'e938f05bd5288534975d63b7c4b14940'),
  -- data/triggers/085/085_25_anti-necro-dia_subclass_status_checker.lua
  (85, 25, $trig$-- Converted from DG Script #8525: Anti-Necro-Dia subclass status checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: subclass progress
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "subclass") or string.find(speech_lower, "progress")) then
    return true  -- No matching keywords
end
local stage = actor:get_quest_stage("nec_anti_dia_subclass")
if stage == 1 then
    actor:send(tostring(self.name) .. " says, 'So you come crawling back.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Only the most cunning and strong will complete the <magenta>quest</> I set before you.  I shall take great pleasure in your demise, but I will offer great rewards for your success.'")
elseif stage == 2 then
    actor:send(tostring(self.name) .. " says, 'Many years ago, my pact with the demon realm allowed me to be master of this domain.  All were subjugated, man, woman, and beast.'")
    self:command("smirk")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'One man would not bow though!'")
    self:emote("growls with an anger and fury with which many have never seen and lived!")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'My pitiful waste of a <magenta>brother</> escaped my minions.'")
    self:command("smi " .. tostring(actor.name))
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Perhaps you will remedy that.'")
elseif stage == 3 or stage == 4 then
    actor:send(tostring(self.name) .. " says, 'My wretched sibling, Ber...  I shall not utter his name!'")
    wait(2)
    self:command("fume")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'I despise him and his reverent little life.'")
    wait(2)
    self:command("ponder")
    actor:send(tostring(self.name) .. " says, 'He thinks he is safe now, beyond my grasp.  That FOOL!'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Bring back proof of the deed and you shall be accepted.'")
else
    local classgreet = "no"
    if actor.alignment < -349 then
        local in_window =
            (string.find(actor.class, "warrior") and actor.level <= 25)
            or (string.find(actor.class, "cleric")  and actor.level <= 35)
            or (string.find(actor.class, "sorcerer") and actor.level <= 45)
        if in_window and actor.race ~= "elf" and actor.race ~= "faerie_seelie" then
            classgreet = "yes"
        end
    end
    if classgreet == "yes" then
        if actor.level >= 10 then
            self:command("peer " .. tostring(actor.name))
            self:emote("places a most vile half-smile on his face.")
            actor:send(tostring(self.name) .. " says, 'Shame you aren't performing this quest, you seem to be a nasty piece of work.'")
        else
            actor:send(tostring(self.name) .. " says, 'Come back when you have a few more kills, you seem to be a nasty piece of work.'")
        end
    else
        actor:send(tostring(self.name) .. " says, 'You don't work for me and you probably never will.'")
    end
end$trig$, '7b86ee83896059436ee09dc3b7184865'),
  -- data/triggers/085/085_99_resurrection_quest_status_checker.lua
  (85, 99, $trig$-- Converted from DG Script #8599: resurrection_quest_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: status progress
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "status") or string.find(speech_lower, "progress")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_has_completed("resurrection_quest") then
    self:say("You have already learned the secrets of the Resurrection.")
    return true
end

local stage = actor:get_quest_stage("resurrection_quest")
local hunt, item
local mob1, mob2, mob3
local mob1_name, mob2_name, mob3_name

if stage == 3 then
    self:say("Do something to interfere with Ziijhan.")
    wait(1)
    self:say("I hear he has a bishop locked up in the dungeon.")
    return true
elseif stage == 4 then
    mob1_name = mobiles.template(40, 4).name
    mob2_name = mobiles.template(40, 3).name
    mob3_name = mobiles.template(40, 16).name
    hunt = mob1_name .. ", " .. mob2_name .. ", and " .. mob3_name
    mob1 = 4004
    mob2 = 4003
    mob3 = 4016
    item = objects.template(40, 8).name
elseif stage == 5 then
    item = objects.template(40, 8).name
elseif stage == 6 then
    mob2_name = mobiles.template(533, 8).name
    mob1_name = "the Xeg-Yi"  -- displayed as a count
    hunt = "2 Xeg-Yi and " .. mob2_name
    mob2 = 53411
    mob1 = 53308
    item = objects.template(533, 7).name
elseif stage == 7 then
    item = objects.template(533, 7).name
elseif stage == 8 then
    mob1_name = mobiles.template(510, 5).name
    mob2_name = mobiles.template(530, 1).name
    mob3_name = mobiles.template(510, 14).name
    hunt = mob1_name .. ", " .. mob2_name .. ", and " .. mob3_name
    mob1 = 51005
    mob2 = 53001
    mob3 = 51014
    if string.find(actor.class, "cleric") or string.find(actor.class, "priest") then
        item = "a large book on healing from Nordus"
    elseif string.find(actor.class, "diabolist") then
        item = objects.template(510, 28).name
    end
elseif stage == 9 then
    if string.find(actor.class, "cleric") or string.find(actor.class, "priest") then
        item = "a large book on healing from Nordus"
    elseif string.find(actor.class, "diabolist") then
        item = objects.template(510, 28).name
    end
elseif stage == 10 then
    mob1_name = mobiles.template(520, 3).name
    mob2_name = mobiles.template(520, 15).name
    hunt = mob1_name .. " and " .. mob2_name
    mob1 = 52003
    mob2 = 52015
    item = objects.template(520, 1).name
elseif stage == 11 then
    item = objects.template(520, 1).name
else
    self:say("Did you want to do a quest of some kind?  Because you're not at the moment.  Get lost.")
    return true
end

if stage == 4 or stage == 6 or stage == 8 or stage == 10 then
    local target1 = actor:get_quest_var("resurrection_quest:mob1")
    local target2 = actor:get_quest_var("resurrection_quest:mob2")
    local target3
    if stage == 6 or stage == 10 then
        target3 = 1
    else
        target3 = actor:get_quest_var("resurrection_quest:mob3")
    end
    self:say("You must eliminate:")
    self.room:send(tostring(hunt))

    local done = false
    if stage == 4 or stage == 8 then
        if target1 and target2 and target3 then done = true end
    elseif stage == 6 then
        if target1 and (target2 == 2) then done = true end
    else
        if target1 and target2 then done = true end
    end
    if done then
        self:say("You have dispatched them.  Give me the death talisman!")
        return true
    end

    if target1 or target2 or target3 then
        self.room:send("You have destroyed:")
        if target1 and mob1_name then
            self.room:send("- " .. mob1_name)
        end
        if stage == 6 then
            if target2 == 2 and mob2_name then
                self.room:send("- " .. tostring(target2) .. " " .. mob2_name)
            end
        else
            if target2 and mob2_name then
                self.room:send("- " .. mob2_name)
            end
        end
        if (stage == 4 or stage == 8) and target3 and mob3_name then
            self.room:send("- " .. mob3_name)
        end
    end
    if (stage ~= 6 and (not target1 or not target2 or not target3)) or (stage == 6 and (not target1 or (target2 or 0) < 2)) then
        self.room:send("You still need to dispatch:")
        if not target1 and mob1_name then
            self.room:send("- " .. mob1_name)
        end
        if stage == 6 then
            local t2 = target2 or 0
            if t2 < 2 and mob2_name then
                local xeg = 2 - t2
                self.room:send("- " .. tostring(xeg) .. " " .. mob2_name)
            end
        else
            if not target2 and mob2_name then
                self.room:send("- " .. mob2_name)
            end
        end
        if not target3 and mob3_name then
            self.room:send("- " .. mob3_name)
        end
        self.room:send("Return " .. tostring(item) .. " as proof.")
    end
    self.room:send("Don't forget the banishment phrase: <b:blue>Dhewsost Konre</>")
elseif stage == 5 or stage == 7 or stage == 9 or stage == 11 then
    self:say("Bring me back " .. tostring(item) .. ".")
end
if stage >= 4 then
    self.room:send(tostring(self.name) .. " says, 'If you need a new talisman, say &9<blue>\"I need a new talisman\"</>.'")
end$trig$, '2c8c4baf10c5a6398a59215c516f587d'),
  -- data/triggers/103/103_09_khysan-greet.lua
  (103, 9, $trig$local ice_stage = actor:get_quest_stage("ice_shards")
local wand_stage = actor:get_quest_stage("type_wand")

local seen_before = false
if ice_stage and ice_stage > 0 then
    seen_before = true
end
if wandstep and wand_stage > wandstep then
    seen_before = true
end
if wandstep and wand_stage == wandstep and actor:get_quest_var("type_wand:greet") == 1 then
    seen_before = true
end

wait(1)
actor:send(self.name .. " looks up at your approach.")

if seen_before then
    self:say("Welcome back my friend.")
    wait(2)
    if ice_stage and ice_stage > 0 and not actor:get_has_completed("ice_shards") then
        self:say("Did you find any more clues?")
        if wandstep and wand_stage == wandstep then
            local minlevel = (wandstep - 1) * 10
            wait(1)
            if actor.level >= minlevel then
                if actor:get_quest_var("type_wand:greet") == 0 then
                    self:say("Or is there something else that brings you back?")
                else
                    self:say("Or do you have what I need for a new staff?")
                end
            end
        end
    else
        if wandstep and wand_stage == wandstep then
            local minlevel = (wandstep - 1) * 10
            if actor.level >= minlevel then
                if actor:get_quest_var("type_wand:greet") == 0 then
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
    if wandstep and wand_stage == wandstep then
        wait(1)
        local minlevel = (wandstep - 1) * 10
        if actor.level >= minlevel and actor:get_quest_var("type_wand:greet") == 0 then
            self.room:send(self.name .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        end
    end
    if not (ice_stage and ice_stage > 0) then
        wait(3)
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
end$trig$, '2b513a849e12a7bba05767e68061aeb1'),
  -- data/triggers/103/103_10_ice_shards_khysan_speech1.lua
  (103, 10, $trig$local s = string.lower(speech)
if not (string.find(s, "spell") or string.find(s, "powerful") or string.find(s, "ever")) then
    return true
end
if not string.find(actor.class, "cryomancer") then
    return true
end

wait(2)
self.room:send(self.name .. " says, 'The spell was called Ice Shards.  Supreme cryomancers")
self.room:send("</>could conjure a multitude of glistening ice fragments to annihilate their")
self.room:send("</>foes.'")
wait(2)
self:say("But that magic is lost to us now.")$trig$, '002dabd0f6a7678018d776cc6f7c1ce6'),
  -- data/triggers/103/103_11_ice_shards_khysan_speech2.lua
  (103, 11, $trig$local s = string.lower(speech)
if not string.find(s, "lost") then
    return true
end
if not string.find(actor.class, "cryomancer") then
    return true
end

wait(2)
self:command("nod")
self.room:send(self.name .. " says, 'Even my elven family, the Sunfire clan, has lost the")
self.room:send("</>secrets to the spell.'")
wait(1)
self.room:send(self.name .. " says, 'Legend has it the last copy of Ice Shards was in the")
self.room:send("</>fabled lost library of Shiran.  But perhaps the spell survived in some ancient")
self.room:send("</>text.'")
wait(3)
self.room:send(self.name .. " says, 'I've heard of four books that could potentially hold the information:'")
self.room:send("<b:yellow>the Book of Kings</>")
self.room:send("<b:yellow>the Book of Discipline</>")
self.room:send("<b:yellow>The Xapizan Codex</>")
self.room:send("<b:yellow>the Enchiridion</>")
self.room:send(self.name .. " says, 'Maybe if I could get my hands on each of them, between")
self.room:send("</>them I could piece together fragments of the spell!'")
wait(3)
self:say("Will you track down these books and bring them to me?")$trig$, 'e168bd50f71e39e7623a04b5afac8f22'),
  -- data/triggers/103/103_12_ice_shards_khysan_speech3.lua
  (103, 12, $trig$local s = string.lower(speech)
if not (string.find(s, "yes") or string.find(s, "sure") or string.find(s, "yep") or string.find(s, "okay")) then
    return true
end

wait(2)
if string.find(actor.class, "cryomancer") then
    if actor.level > 88 and actor:get_quest_stage("ice_shards") == 0 then
        actor:start_quest("ice_shards")
        self:command("beam")
        self:say("Excellent!  I'm excited!")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'If you need, you can check your <b:cyan>[ice shards progress]</> with me.'")
    elseif actor.level > 88 and actor:get_quest_stage("ice_shards") > 0 then
        self:say("Oh please do share!")
    elseif actor.level <= 88 then
        self.room:send(tostring(self.name) .. " says, 'I appreciate your enthusiasm, but it's probably too")
        self.room:send("</>dangerous, right?'")
    end
end$trig$, '5ff8596f6ff0c81cc05b2e2106c42e0c'),
  -- data/triggers/125/125_44_flaminkey.lua
  (125, 44, $trig$-- Converted from DG Script #12544: FlaminKey
-- Original: OBJECT trigger, flags: GET, probability: 100%
local burn = 1
wait(1)
if string.find(actor.class, "cry") then
    actor:send("Your cool touch makes the fiery key's heat bearable.")
    burn = 0
end
if string.find(actor.class, "pyr") then
    burn = 0
    actor:send("Your hands are accustomed to the heat, making the key easy to handle.")
end
if burn == 1 then
    actor:damage(50)  -- type: fire
    if damage_dealt ~= 0 then
        actor:send("OUCH!  You grab the key, but it's burning your hand! (<red>" .. tostring(damage_dealt) .. "</>)")
        self.room:send_except(actor, tostring(actor.name) .. " yelps as the key burns " .. tostring(actor.possessive) .. " hand! (<red>" .. tostring(damage_dealt) .. "</>)")
    end
end$trig$, 'cf60ca9239bfb3e7a141f8d490e350f9'),
  -- data/triggers/133/133_12_tell_raph_please.lua
  (133, 12, $trig$wait(2)

if not actor.is_player then
    return true
end

if actor:get_quest_stage("get_raph_food") ~= 9 then
    actor:send(self.name .. " tells you, '" .. "What do you want, go about your business." .. "'")
    return true
end

actor:complete_quest("get_raph_food")

-- Keys are lowercase class plain names (the value of actor.class).
-- Spell rewards (full caster classes). The threshold messages warn the
-- player that their level is not yet high enough to actually cast the spell.
local spell_rewards = {
    cleric      = { spell = "group heal",       min_level = 57 },
    priest      = { spell = "group heal",       min_level = 57 },
    diabolist   = { spell = "group heal",       min_level = 57 },
    druid       = { spell = "invigorate",       min_level = 65 },
    sorcerer    = { spell = "major globe",      min_level = 57 },
    pyromancer  = { spell = "major globe",      min_level = 57 },
    cryomancer  = { spell = "major globe",      min_level = 57 },
    necromancer = { spell = "summon dracolich", min_level = 73 },
}

-- Skill rewards (martial / hybrid classes). proficiency = level * 10 + 50.
local skill_rewards = {
    warrior    = "switch",
    thief      = "pick lock",
    paladin    = "switch",
    ["anti-paladin"] = "switch",
    ranger     = "switch",
    assassin   = "pick lock",
    mercenary  = "switch",
    monk       = "switch",
    berserker  = "switch",
    rogue      = "pick lock",
    bard       = "pick lock",
}

local class = actor.class

for class_name, reward in pairs(spell_rewards) do
    if class == class_name then
        self:command("smile " .. tostring(actor.name))
        skills.set_level(actor, reward.spell, 1000)
        if actor.level < reward.min_level then
            actor:send(self.name .. " tells you, '" .. "You will not be able to use your new ability for several levels." .. "'")
        end
        actor:save()
        actor:send(self.name .. " tells you, '" .. "There you go, enjoy your new powers." .. "'")
        return true
    end
end

for class_name, skill in pairs(skill_rewards) do
    if class == class_name then
        self:command("smile " .. tostring(actor.name))
        local total = actor.level * 10 + 50
        skills.set_level(actor, skill, total)
        actor:save()
        actor:send(self.name .. " tells you, '" .. "There you go, enjoy your enhanced skills." .. "'")
        return true
    end
end

return true$trig$, 'd35ce2422e2b5c43a99f4ce4146babe5'),
  -- data/triggers/133/133_25_heavens_gate_starlight_greet.lua
  (133, 25, $trig$-- Converted from DG Script #13325: heavens_gate_starlight_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
local stage = actor:get_quest_stage("heavens_gate")
-- (empty send to actor)
actor:send("<b:white>Soft starlight glitters throughout the cavern in welcome as you enter.</>")
if string.find(actor.class, "priest") and actor.level > 80 then
    if stage == 0 then
        -- (empty send to actor)
        actor:send("<b:white>A strange light glints off a strange rock formation near the center of the cavern.</>")
        if world.count_objects(133, 50) == 0 then
            self.room:spawn_object(133, 50)
        end
    elseif stage == 1 then
        if world.count_objects(133, 50) == 0 then
            self.room:spawn_object(133, 50)
        end
        actor:send("<b:white>" .. tostring(self.name) .. " coalesces into the ephemeral shape of a bent old woman, standing before the rock formation.</>")
        actor:send("<b:white>Swirling stars form the shape of a bowl in her hands, which she puts on the rock pedestal.</>")
        -- (empty send to actor)
        actor:send("<b:white>The crone invites you to <b:cyan>[commune] <b:white>for visions of your progress.</>")
    elseif stage == 2 then
        if world.count_objects(133, 50) == 0 then
            self.room:spawn_object(133, 50)
        end
        actor:send("<b:white>The floating apparition of a valiant young knight constructed from starbeams hovers over the pedestal.</>")
        actor:send("<b:white>He seems to invite you to <b:cyan>[put] <b:white>something on the <b:white>[pedestal]<b:white>.</>")
        -- (empty send to actor)
        actor:send("<b:white>The knight invites you to <b:cyan>[commune] <b:white>for visions of your progress.</>")
    elseif stage == 3 then
        actor:send("<b:white>A starry serpent slithers through the rocky cavern.</>")
        actor:send("<b:white>It looks at you with expectant, curious eyes.</>")
        -- (empty send to actor)
        actor:send("<b:white>The serpent invites you to <b:cyan>[commune] <b:white>for visions of your progress or a new Key.</>")
    elseif stage == 4 then
        wait(1)
        actor:send("<b:white>The starlight manifests as the heavenly raven again.</>")
        wait(2)
        actor:send("This time, at last, it speaks:_")
        actor:send("<b:cyan>'I I I I am the book.  Open me prophet; read; decypher.</>")
        actor:send("<b:cyan>On you, in you, in your blood, they write, have written.</>")
        actor:send("<b:cyan>Speak it but aloud to know the path of heaven for I I I I am the final key.</>")
        actor:send("<b:cyan>I I I I have shown you visions, and through me you shall read.'</>")
        -- (empty send to actor)
        actor:send("<yellow>yamo lv soeeiy vrtvln eau okia khz lrrvzryp gvxrj bzjbie hi</>")
    end
end$trig$, 'a8f71fdfae4471f34d82812c4123193a'),
  -- data/triggers/133/133_26_heavens_gate_starlight_look.lua
  (133, 26, $trig$-- Converted from DG Script #13326: heavens_gate_starlight_look
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
if string.find(actor.class, "priest") and actor.level > 80 and actor:get_quest_stage("heavens_gate") == 0 then
    self.room:send_except(actor, tostring(actor.name) .. " stands completely still, staring intently at nothing.")
    wait(1)
    actor:send("<b:white>Your mind is suddenly overwhelmed by the vision of a swirling vortex of stars above the formation.</>")
    actor:send("<b:white>It opens a gateway through the heavens!</>")
    wait(4)
    actor:send("<b:white>Swirls of galaxies and flares of stars begin to meld within the vortex.</>")
    actor:send("<b:white>They form a cosmic raven, which soars down to greet you.</>")
    wait(4)
    actor:send("<b:white>In dance-like flight, it mimics a priest, bent over the rock pedestal in prayer.</>")
    actor:send("<b:white>The starlight glistens in the shape of a bowl on the rock.</>")
    wait(4)
    actor:send("<b:white>The raven finishes the dance and melds with the bowl.</>")
    actor:send("<b:white>You find yourself gazing into a bowl with the symbol of a raven outlined in silver.</>")
    actor:send("<b:white>Its wings outstretched with feathers and talons marked with thin lines.</>")
    wait(4)
    actor:send("<b:white>The bowl seems to promise ancient sacred knowledge if only it could be brought to this place!</>")
    wait(4)
    actor:send("<b:white>The raven invites you to <b:cyan>[commune] <b:white>to receive visions of your progress.</>")
    wait(2)
    actor:send("Returning to reality, you find yourself staring at the rock pedestal.")
    actor:start_quest("heavens_gate")
end$trig$, 'd739a5470b55e357927351f7e6ec2eba'),
  -- data/triggers/163/163_01_quest_eleweiss_ranger_druid_subclass_greet.lua
  (163, 1, $trig$wait(2)

local wandstep = actor:get_quest_stage("type_wand")
if wandstep then
    local minlevel = (wandstep - 1) * 10
    if actor.level >= minlevel then
        if actor:get_quest_var("type_wand:greet") == 0 then
            actor:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        elseif actor:get_quest_var("type_wand:wandtask1")
            and actor:get_quest_var("type_wand:wandtask2")
            and actor:get_quest_var("type_wand:wandtask3") then
            actor:send(tostring(self.name) .. " says, 'Oh good, you're all set!  Let me see the staff.'")
        else
            -- TODO(parity): `weapon` was a DG global naming the in-progress weapon.
            actor:send(tostring(self.name) .. " says, 'Do you have what I need for the staff?'")
        end
    end
end

-- TODO(parity): legacy DG had a race switch ("ADD NEW RESTRICTED RACES HERE")
-- that halted on disallowed races before the class check below.

if (string.find(actor.class, "warrior") and (actor.level >= 10 and actor.level <= 25))
    or (string.find(actor.class, "cleric") and (actor.level >= 10 and actor.level <= 35)) then
    if not actor:get_quest_stage("ran_dru_subclass") then
        self:emote("grins casually.")
        actor:send(tostring(self.name) .. " says, 'Some know the ways of the woods, others are ignorant.  Do you know the <b:cyan>ways</> or not?'")
        self:emote("puts a more serious look on his face.")
    elseif actor:get_quest_stage("ran_dru_subclass") == 4 and not actor:get_has_completed("ran_dru_subclass") then
        actor:send(tostring(self.name) .. " says, 'Have you the jewel of the heart?'")
    end
end$trig$, 'b3e483b541cb99e12df8ef797f6787d0'),
  -- data/triggers/163/163_02_quest_eleweiss_ranger_druid_subclass_speak1.lua
  (163, 2, $trig$if not (string.find(speech, "ways") or string.find(speech, "I know")) then
    return true
end

if actor:get_quest_stage("ran_dru_subclass") then
    return true
end

-- TODO(parity): legacy DG had a race switch ("ADD NEW RESTRICTED RACES HERE")
-- that halted on disallowed races before each class block.

if string.find(actor.class, "cleric") then
    wait(2)
    if actor.level >= 10 and actor.level <= 35 then
        if globals.use_subclass then
            actor:send(tostring(self.name) .. " says, 'I'm currently assisting someone else, one moment please.'")
            return true
        end
        if actor.alignment > -350 and actor.alignment < 350 then
            self:command("smile " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'Do you wish to join the ranks of the woodland healers with all the power there of?'")
            globals.use_subclass = "Dru"
        else
            actor:send(tostring(self.name) .. " says, 'You are not properly aligned to be a woodland cleric.  Come back when you fix that.'")
        end
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'Seek me again later when you have gained some more experience.'")
    else
        actor:send(tostring(self.name) .. " says, 'You have traveled too far on your current path to change your way.'")
    end
elseif string.find(actor.class, "warrior") then
    wait(2)
    if actor.level >= 10 and actor.level <= 25 then
        if globals.use_subclass then
            actor:send(tostring(self.name) .. " says, 'I'm currently assisting someone else, one moment please.'")
            return true
        end
        if actor.alignment > 349 then
            self:command("nod " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'Do you wish to become a fighter who is one with the forests?'")
            globals.use_subclass = "Ran"
        else
            actor:send(tostring(self.name) .. " says, 'Sorry, your alignment is not proper for what you wish to be.  Try again later.'")
        end
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'Seek me again later when you have gained some more experience.'")
    else
        actor:send(tostring(self.name) .. " says, 'You have traveled too far on your current path to change your way.'")
    end
else
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I can do nothing for you, I am sorry.'")
    self:emote("smiles a little bit.")
end$trig$, '9060af609fd8a029df55ebc6f09137eb'),
  -- data/triggers/163/163_03_quest_eleweiss_ranger_druid_subclass_speak2.lua
  (163, 3, $trig$if not (string.find(speech, "yes") or string.find(speech, "no")) then
    return true
end

if actor:get_quest_stage("ran_dru_subclass") ~= 0 then
    return true
end

-- TODO(parity): legacy DG had a race switch ("ADD NEW RESTRICTED RACES HERE")
-- that halted on disallowed races before each class branch.

local classquest = nil
if string.find(actor.class, "cleric") then
    if actor.level >= 10 and actor.level <= 35 then
        classquest = "yes"
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'I cannot guide you yet.  Return to me when you have more experience.'")
    else
        actor:send(tostring(self.name) .. " says, 'You have traveled too far on your current path to change your way.'")
    end
elseif string.find(actor.class, "warrior") then
    if actor.level >= 10 and actor.level <= 25 then
        classquest = "yes"
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'I cannot guide you yet.  Return to me when you have more experience.'")
    else
        actor:send(tostring(self.name) .. " says, 'You have traveled too far on your current path to change your way.'")
    end
end

wait(2)
if classquest == "yes" then
    if string.find(speech, "yes") then
        if not globals.use_subclass then
            actor:send(tostring(self.name) .. " says, 'I cannot help until we talk about the ways of the woods.'")
            return true
        end
        actor:start_quest("ran_dru_subclass", globals.use_subclass)
        actor:send(tostring(self.name) .. " says, 'Only the most dedicated to the forests shall complete the <b:cyan>quest</> I set upon you.  You may inquire about your <b:cyan>[subclass progress]</> or ask me to <b:cyan>[repeat]</> myself at any time.'")
    else
        actor:send(tostring(self.name) .. " says, 'Leave my sight, you tire me.'")
        self:command("wave " .. tostring(actor.name))
        actor:send("Eleweiss calls upon the air and moves you away.")
        self.room:send_except(actor, "Eleweiss removes " .. tostring(actor.name) .. " from his presence.")
        actor:teleport(get_room(163, 74))
    end
    globals.use_subclass = nil
end$trig$, '81bbf3b38c3ab17e1509f824ccd60942'),
  -- data/triggers/163/163_09_quest_eleweiss_ranger_druid_subclass_status.lua
  (163, 9, $trig$local sl = string.lower(speech)
if not (string.find(sl, "subclass") or string.find(sl, "progress")) then
    return true
end

wait(2)
local stage = actor:get_quest_stage("ran_dru_subclass")
if stage == 1 then
    actor:send(tostring(self.name) .. " says, 'Only the most dedicated to the forests shall complete the <b:cyan>quest</> I set upon you.'")
elseif stage == 2 then
    actor:send(tostring(self.name) .. " says, 'Yes, quest. I do suppose it would help if I told you about it.'")
    self:emote("rubs his chin thoughtfully.")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Long ago I <b:cyan>lost something</>.  It is a shame, but it has never been recovered.'")
    self:command("sigh")
    actor:send(tostring(self.name) .. " says, 'If you were to help me with that, then we could arrange something.'")
    self:emote("looks hopeful.")
elseif stage == 3 or stage == 4 then
    self:command("sigh")
    actor:send(tostring(self.name) .. " says, 'It seems I am becoming forgetful in my age.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Well, you see now, I lost the jewel of my heart. If you are up to it, finding and returning it to me will get you your reward.'")
    self:command("shrug")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'But for now, it is time for you to depart I think.'")
    self:command("sigh")
    actor:send(tostring(self.name) .. " says, 'You have brought up painful memories for me to relive.'")
else
    -- TODO(parity): legacy DG had a race switch ("ADD NEW RESTRICTED RACES HERE")
    -- that halted on disallowed races before the level checks below.
    if string.find(actor.class, "cleric") then
        if actor.level >= 10 and actor.level <= 35 then
            actor:send(tostring(self.name) .. " says, 'You are not on this quest.'")
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'Seek me again later when you have gained some more experience.'")
        else
            actor:send(tostring(self.name) .. " says, 'You have traveled too far on your current path to change your way.'")
        end
    elseif string.find(actor.class, "warrior") then
        if actor.level >= 10 and actor.level <= 25 then
            actor:send(tostring(self.name) .. " says, 'You are not on this quest.'")
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'Seek me again later when you have gained some more experience.'")
        else
            actor:send(tostring(self.name) .. " says, 'You have traveled too far on your current path to change your way.'")
        end
    end
end$trig$, '56d085a70b23d97dc171fbf8d7e15879'),
  -- data/triggers/172/172_00_grand_master_responds_to_guild.lua
  (172, 0, $trig$local speech_lower = string.lower(speech)
if not string.find(speech_lower, "guild") then
    return true  -- keyword not heard
end
wait(1)
if string.find(actor.class, "sorcerer") then
    self:command("eyebrow " .. tostring(actor.name))
    wait(3)
    actor:send(tostring(self.name) .. " says, 'I know and you know that it's right behind Bigby's shop!'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Now stop wasting my time.'")
elseif string.find(actor.class, "cryomancer") then
    actor:send(tostring(self.name) .. " says, 'Your guild?  Ickle, perhaps?'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'I'm impressed that you haven't melted into a puddle from being so far south.'")
elseif string.find(actor.class, "pyromancer") then
    actor:send(tostring(self.name) .. " says, 'Where's your guild?  Probably somewhere hot, I should say?'")
    wait(3)
    self:command("chuckle grand")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Sorry, I've been shut up in this tower far too long!'")
elseif string.find(actor.class, "illusionist") then
    actor:send(tostring(self.name) .. " says, 'Yes, you'll be wanting to visit your guild.'")
    wait(3)
    self:command("nod " .. tostring(actor.name))
    wait(3)
    actor:send(tostring(self.name) .. " says, 'I haven't visited Mielikki in ages, but there is certainly one there for you.  But as to where...'")
    wait(3)
    self:command("sigh")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'The best person to ask would be the Archmage.  She really ought to keep track of these things.'")
else
    self:command("sigh")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Look, I'm no good at these sorts of questions.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Guilds are usually found near centers of commerce.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'You're the adventurer, find it yourself!'")
end$trig$, '5398c9b56b93322f43401d2b65f291b4'),
  -- data/triggers/172/172_01_ill-subclass_grand_master_greeting.lua
  (172, 1, $trig$if string.find(actor.class, "sorcerer") and actor.level >= 10 and actor.level <= 45 then
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Hello, " .. tostring(actor.name) .. ".'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I'm looking for bright young sorcerers like yourself to become illusionists.  But I need evidence of your dedication...  And resourcefulness.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Do you have time to do a small favor for me?'")
end

if not actor:get_has_completed("illusionist_subclass") and actor:get_quest_stage("illusionist_subclass") > 0 then
    wait(1)
    self:command("smile " .. tostring(actor.name))
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Quest going well, I hope?  Say <b:cyan>'help'</> if you're having any trouble.'")
end$trig$, 'c9d348457355445545eb62952624abf8'),
  -- data/triggers/172/172_02_ill-subclass_grand_master_s_exposition_part_1.lua
  (172, 2, $trig$local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "yes") or string.find(speech_lower, "ok") or string.find(speech_lower, "okay") or string.find(speech_lower, "sure") or string.find(speech_lower, "favor") or string.find(speech_lower, "what")) then
    return true  -- keyword not heard
end

-- Only sorcerers in the right level band get the story; everyone else gets
-- a brief brushoff.
if not string.find(actor.class, "sorcerer") then
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Nope, not a sorcerer, can't help.'")
    return true
end

if actor.level < 10 then
    wait(1)
    actor:send(tostring(self.name) .. " says, 'You're not ready to have your mind blown!'")
    return true
elseif actor.level > 45 then
    wait(1)
    actor:send(tostring(self.name) .. " says, 'It's okay, you're too late to care.'")
    return true
end

wait(1)
actor:send(tostring(self.name) .. " says, 'Are you ready to hear the story?  Well, here it comes!'")
wait(4)
actor:send(tostring(self.name) .. " says, 'When you feel that you're ready, you can say <b:cyan>'begin'</>.  Then I'll outfit you for this quest.  But for now, listen carefully.'")
wait(5)
actor:send(tostring(self.name) .. " says, 'This is what I need you to do...'")
wait(3)
actor:send(tostring(self.name) .. " says, 'That ruffian in the smuggler's hideout once stole a woman from me, on the very eve of our betrothal announcement.  Or my pride, perhaps.  It appears that she was his from the very beginning.'")
wait(7)
actor:send(tostring(self.name) .. " says, 'She has departed, she is lost, my dear Cestia...  She boarded a ship for the southern seas and never returned.  I fear she is dead.  But she may have survived, and on that fact this plan hinges.'")
wait(7)
actor:send(tostring(self.name) .. " says, 'I gave her a valuable onyx choker as a betrothal gift.  She took it in her deceit.'")
wait(7)
actor:send(tostring(self.name) .. " says, 'The smuggler leader took the choker, and keeps it as a prize.  To humiliate me, perhaps.  And now he has raised defenses that even I cannot penetrate.'")
wait(7)
actor:send(tostring(self.name) .. " says, 'He knows my fatal weakness: hay fever.'")
wait(3)
actor:send(tostring(self.name) .. " says, 'So he has placed flowers, to reveal me should I enter his home in disguise.'")
wait(5)
self:emote("pauses for breath.")
wait(4)
actor:send(tostring(self.name) .. " says, 'Say <b:cyan>'continue'</> when you're ready to hear the rest.'")$trig$, '8a7a35bb371b2ca71bc2a8c076e69d97'),
  -- data/triggers/172/172_03_ill-subclass_grand_master_starts.lua
  (172, 3, $trig$local speech_lower = string.lower(speech)
if not string.find(speech_lower, "begin") then
    return true  -- keyword not heard
end

if not string.find(actor.class, "sorcerer") then
    return true
end
if actor.level < 10 or actor.level > 45 then
    return true
end
if actor:get_quest_stage("illusionist_subclass") ~= 0 then
    return true  -- already mid-quest; 'restart' is the right keyword
end

wait(1)
actor:send(tostring(self.name) .. " says, 'Good, good.  Please stand still while I enchant you so that the smugglers will see you as Cestia.'")
wait(3)
self:emote("utters the words, 'incognito'.")
wait(2)
actor:send(tostring(self.name) .. " says, 'Now... take this vial.'")
self.room:spawn_object(172, 15)
self:command("give vial " .. tostring(actor.name))
wait(2)
actor:send(tostring(self.name) .. " says, 'Now go to the hideout, <b:cyan>drop the vial</>, and quickly go to to see the leader.  Remember not to let anyone see you drop it!'")
wait(2)
actor:send(tostring(self.name) .. " says, 'Come back and ask for <b:cyan>help</> if you get stuck!'")
actor:start_quest("illusionist_subclass", "Illusionist")$trig$, '7888e6a943918e58b8eea9bb467aae39'),
  -- data/triggers/172/172_04_ill-subclass_grand_master_restarts.lua
  (172, 4, $trig$local speech_lower = string.lower(speech)
if not string.find(speech_lower, "restart") then
    return true  -- keyword not heard
end

if string.find(actor.class, "sorcerer")
    and actor.level > 9 and actor.level < 46
    and actor:get_quest_stage("illusionist_subclass") > 0 then
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Very well, if you insist.'")
    actor:restart_quest("illusionist_subclass")
    wait(1)
    self:emote("rummages about in his things.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Here is another vial.'")
    wait(1)
    self.room:spawn_object(172, 15)
    self:command("give vial " .. tostring(actor.name))
    wait(2)
    actor:send(tostring(self.name) .. " says, 'And don't muck it up this time!'")
end$trig$, '1ce6a38ed5e3d55a91142534dfaab115'),
  -- data/triggers/172/172_15_ill-subclass_grand_master_responds_to_hi.lua
  (172, 15, $trig$local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "hi")
    or string.find(speech_lower, "hello")
    or string.find(speech_lower, "howdy")) then
    return true  -- keyword not heard
end

local stage = actor:get_quest_stage("illusionist_subclass")

if string.find(actor.class, "sorcerer") and stage == 0 then
    wait(1)
    if actor.level >= 10 and actor.level <= 45 then
        actor:send(tostring(self.name) .. " says, 'Well, hello there.'")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Do you have time to do me the very tiniest of favors?'")
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'Nope, too unrefined, next!'")
    else
        actor:send(tostring(self.name) .. " says, 'Nope, too small, next!'")
    end
    return true
end

if stage > 0 and not actor:get_has_completed("illusionist_subclass") then
    actor:send(tostring(self.name) .. " says, 'Quest going well, I hope?'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Just say <b:cyan>'help'</> if you get stuck.'")
end$trig$, '4deb75121060b01566c9d42b7b7de7dc'),
  -- data/triggers/172/172_16_ill-subclass_grand_master_s_exposition_part_2.lua
  (172, 16, $trig$local speech_lower = string.lower(speech)
if not string.find(speech_lower, "continue") then
    return true  -- keyword not heard
end

local stage = actor:get_quest_stage("illusionist_subclass")

if string.find(actor.class, "sorcerer")
    and actor.level >= 10 and actor.level <= 45
    and stage == 0 then
    wait(1)
    actor:send(tostring(self.name) .. " says, 'This is where you come in.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I would like you to enter the hideout in disguise and take back the choker.  But beware: it is well hidden.'")
    wait(5)
    actor:send(tostring(self.name) .. " says, 'Somehow that brutish fool has engaged the services of an illusionist... I would like to know who helped him... but no matter.'")
    wait(5)
    actor:send(tostring(self.name) .. " says, 'I will enchant you to resemble dear Cestia when the smugglers look upon you.  Their leader will no doubt welcome you with open arms.'")
    wait(7)
    actor:send(tostring(self.name) .. " says, 'But we must ensure that he will reveal its hiding place to you.  For that, we will make it appear as if the guards of Mielikki have discovered their hideout.'")
    wait(7)
    actor:send(tostring(self.name) .. " says, 'It is my hope that the leader will hide you - Cestia - for safekeeping, in his most secure location.'")
    wait(5)
    actor:send(tostring(self.name) .. " says, 'There, perhaps, you will find the choker.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'I will give you a vial of disturbance.  Drop it and once you find their leader Gannigan sounds of shouting and fighting will resonate throughout the area.  It will convince the smugglers that they are under attack.'")
    wait(7)
    actor:send(tostring(self.name) .. " says, 'You must take care to drop it out of sight of any smugglers, or they may become suspicious.  Then go immediately to the leader, and stall him until you hear the sounds of invasion.'")
    wait(7)
    actor:send(tostring(self.name) .. " says, 'Well, what say you?  Are you up for it?  Say <b:cyan>'begin'</> if you are ready!'")
    return true
end

if stage > 0 and not actor:get_has_completed("illusionist_subclass") then
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Continue what?  Why aren't you infiltrating the hideout?'")
    wait(3)
    self:command("ponder " .. tostring(actor.name))
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Say <b:cyan>'restart'</> if you've gotten stuck.'")
end$trig$, '6e7f05fb691ec97a52602d79db5618b3'),
  -- data/triggers/172/172_18_ill-subclass_flowers_make_people_sneeze.lua
  (172, 18, $trig$if not percent_chance(5) then
    return true
end
if string.find(actor.class, "illusionist") then
    return true  -- subclass already complete; flowers no longer affect them
end

wait(2)
local num = random(1, 6)
if num == 1 then
    actor:command("sneeze")
    wait(3)
    actor:command("sneeze")
elseif num == 2 or num == 3 then
    actor:command("sneeze")
elseif num == 4 then
    actor:emote("blinks heavily, trying to clear the tears out of " .. actor.hisher .. " eyes.")
elseif num == 5 then
    actor:send("Your nose feels all itchy.")
else
    actor:emote("wipes " .. actor.hisher .. " nose with " .. actor.hisher .. " sleeve.")
end

-- See if any smuggler is nearby to witness the un-Cestia-like sneezing.
local smuggler = nil
for _, person in ipairs(self:get_people()) do
    if person.zone_id == 363 then
        local lid = person.local_id
        if lid == 0 or lid == 1 or lid == 3 or lid == 4 or lid == 6 then
            smuggler = person
            break
        end
    end
end

if smuggler then
    local reaction = random(1, 5)
    if reaction == 1 then
        actor:send("You notice the smuggler paying close attention to you.")
    elseif reaction == 2 then
        smuggler:command("peer " .. tostring(actor.name))
    elseif reaction == 3 then
        smuggler:command("look " .. tostring(actor.name))
    elseif reaction == 4 then
        smuggler:emote("smiles sweetly.")
        wait(2)
        smuggler:emote("asks, 'Is everything alright?'")
    else
        smuggler:command("consider " .. tostring(actor.name))
    end
end$trig$, '831a6bf5f736a88bef49f077ffe1ad4c'),
  -- data/triggers/185/185_01_silania_welcome.lua
  (185, 1, $trig$wait(2)

local pp_stage = actor:get_quest_stage("pri_pal_subclass")
if pp_stage == 1 then
    actor:send(tostring(self.name) .. " says, 'You've returned!  Let's talk about your <b:cyan>quest</>.'")
    return
elseif pp_stage == 2 or pp_stage == 3 then
    actor:send(tostring(self.name) .. " says, 'Have you returned with the bronze chalice the diabolists stole?'")
    return
end

-- TODO(parity): wand/mace upgrade gating uses runtime-set quest stage strings
-- "wandstep"/"macestep" plus globals (wandstep, macestep, weapon) the legacy
-- system stored elsewhere. Confirm with rs design how subclass-step variables
-- are exposed before reactivating this branch.
local classgreet = "no"
local maxlevel = 0
if string.find(actor.class, "warrior") then
    if actor.race ~= "drow" and actor.race ~= "faerie_unseelie" then
        classgreet = "yes"
        maxlevel = 25
    end
elseif string.find(actor.class, "cleric") then
    if actor.race ~= "drow" and actor.race ~= "faerie_unseelie" then
        classgreet = "yes"
        maxlevel = 35
    end
end

if classgreet == "yes" and actor.level >= 10 and actor.level <= maxlevel then
    actor:send(tostring(self.name) .. " says, 'Some know not of their <b:cyan>destinies</>, others simply choose to ignore them.  Which of the two are you?'")
    wait(2)
    self:command("ponder " .. tostring(actor.name))
end$trig$, '9bb8f7c7fd85544ef9b3fe4fbd134c2d'),
  -- data/triggers/185/185_02_quest_preamble_silania.lua
  (185, 2, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"destiny", "destiny?", "destinies", "destinies?", "i"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local s = string.lower(speech)
if not (string.find(s, "destiny") or string.find(s, "destinies") or string.find(s, "i know")) then
    return true
end

if actor:get_quest_stage("pri_pal_subclass") then
    return true
end

-- Level/race gating per class.
local classquest = false
if string.find(actor.class, "cleric") then
    if actor.level >= 10 and actor.level <= 35 then
        if actor.race == "drow" or actor.race == "faerie_unseelie" then
            actor:send("<red>Your race may not subclass to priest.</>")
            return true
        end
        classquest = true
    end
elseif string.find(actor.class, "warrior") then
    if actor.level >= 10 and actor.level <= 25 then
        if actor.race == "drow" or actor.race == "faerie_unseelie" then
            actor:send("<red>Your race may not subclass to paladin.</>")
            return true
        end
        classquest = true
    end
else
    if actor.level >= 10 and actor.level <= 25 then
        actor:send(tostring(self.name) .. " says, 'Sorry, I cannot help you achieve your destiny.'")
    end
    return true
end

wait(2)

if not classquest then
    return true
end

if globals.use_subclass then
    actor:send(tostring(self.name) .. " says, 'I am currently helping another supplicant, one moment my child.'")
    return true
end

if actor.alignment <= 349 then
    actor:send(tostring(self.name) .. " says, 'I cannot help you if you are not good, little one.'")
    return true
end

if string.find(actor.class, "warrior") and actor.level >= 10 and actor.level <= 25 then
    self:command("nod " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Do ye wish to join the ranks of the holy warriors?'")
    globals.use_subclass = "Pal"
elseif string.find(actor.class, "cleric") and actor.level >= 10 and actor.level <= 35 then
    self:command("nod " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Do ye wish to join the ranks of the priests and help drive darkness from our world?'")
    globals.use_subclass = "Pri"
elseif actor.level < 10 then
    actor:send(tostring(self.name) .. " says, 'I appreciate your aspiring virtue.  Come and see me once you've gained more experience.'")
else
    actor:send(tostring(self.name) .. " says, 'You are already following your destiny.  I cannot help you any further.'")
end$trig$, '56fd11bde882f6c21f9317a514364d85'),
  -- data/triggers/185/185_03_start_quest_silania.lua
  (185, 3, $trig$local s = string.lower(speech)
if not (string.find(s, "yes") or string.find(s, "no")) then
    return true
end

local classquest = false
if string.find(actor.class, "cleric") then
    if actor.level >= 10 and actor.level <= 35 then
        if actor.race == "drow" or actor.race == "faerie_unseelie" then
            actor:send("<red>Your race may not subclass to priest.</>")
            return true
        end
        classquest = true
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'I appreciate your virtue.  Come and see me once you've gained more experience.'")
        return true
    else
        actor:send(tostring(self.name) .. " says, 'You are already following your destiny.  I cannot help you any further.'")
        return true
    end
elseif string.find(actor.class, "warrior") then
    if actor.level >= 10 and actor.level <= 25 then
        if actor.race == "drow" or actor.race == "faerie_unseelie" then
            actor:send("<red>Your race may not subclass to paladin.</>")
            return true
        end
        classquest = true
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'I appreciate your virtue.  Come and see me once you've gained more experience.'")
        return true
    else
        actor:send(tostring(self.name) .. " says, 'You are already following your destiny.  I cannot help you any further.'")
        return true
    end
end

wait(2)

if not classquest then
    return true
end

if string.find(s, "yes") then
    if actor.alignment > 349 and not actor:get_quest_stage("pri_pal_subclass") then
        if not globals.use_subclass then
            actor:send(tostring(self.name) .. " says, 'First, we must discuss your destiny.'")
        else
            actor:start_quest("pri_pal_subclass", globals.use_subclass)
            self:command("smile " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'You may check your <b:cyan>[subclass progress]</> or ask me to <b:cyan>[repeat]</> myself at any time.'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'It is necessary to make a quest such as this quite tough to ensure ensure you really want to do this.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I am sure you will complete the <b:cyan>quest</> though.'")
        end
    else
        actor:send(tostring(self.name) .. " says, 'I cannot help you if you are not good little one.'")
    end
else
    self:command("sigh")
    actor:send(tostring(self.name) .. " says, 'It is a shame we have so few willing to join us these days, but I cannot compel you.  Farewell, and I hope you come to reconsider your decision sometime.'")
    wait(2)
    actor:send("Silania makes a gesture with her hand and you are blinded for a second.")
    self.room:send_except(actor, "Silania makes a gesture with her hand and " .. tostring(actor.name) .. " disappears.")
    actor:teleport(get_room(185, 66))
end

globals.use_subclass = nil$trig$, 'ece81ac9eef8b52ee00a079252fdf6d9'),
  -- data/triggers/185/185_09_priest_paladin_subclass_quest_silania_status.lua
  (185, 9, $trig$local s = string.lower(speech)
if not (string.find(s, "subclass") or string.find(s, "progress")) then
    return true
end

wait(2)

local stage = actor:get_quest_stage("pri_pal_subclass")
if stage == 1 then
    actor:send(tostring(self.name) .. " says, 'You want to join the holy ranks of priests and paladins.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'It is necessary to make a quest such as this quite tough to ensure you really want to do this.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I am sure you will complete the <b:cyan>quest</> though.'")
    return
elseif stage == 2 then
    actor:send(tostring(self.name) .. " says, 'This is your quest to join the ranks of priests and paladins.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'One of our guests made off with our most sacred bronze chalice.'")
    self:command("steam")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'We have reason to believe it was a ruse by the filthy diabolists to try and weaken us.  Our Prior has offered to try and retrieve it for us, but...'")
    wait(2)
    self:command("think")
    actor:send(tostring(self.name) .. " says, 'I think perhaps that would be a bad idea and that you should find it instead.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Good luck, your quest has begun!'")
    self:command("bow")
    return
elseif stage == 3 then
    actor:send(tostring(self.name) .. " says, 'Have you found the bronze chalice the diabolists stole?'")
    return
end

-- No active quest: assess eligibility.
local check = false
if string.find(actor.class, "cleric") then
    if actor.level >= 10 and actor.level <= 35 then
        if actor.race == "drow" or actor.race == "faerie_unseelie" then
            actor:send("<red>Your race may not subclass to priest.</>")
            return true
        end
        check = true
    end
elseif string.find(actor.class, "warrior") then
    if actor.level >= 10 and actor.level <= 25 then
        if actor.race == "drow" or actor.race == "faerie_unseelie" then
            actor:send("<red>Your race may not subclass to paladin.</>")
            return true
        end
        check = true
    end
end

if check then
    actor:send(tostring(self.name) .. " says, 'You are not working to join the holy order.'")
elseif actor.level < 10 then
    actor:send(tostring(self.name) .. " says, 'I appreciate your aspiring virtue.  Come and see me once you've gained more experience.'")
else
    actor:send(tostring(self.name) .. " says, 'You are already following your destiny.  I cannot help you any further.'")
end$trig$, 'b857d34532e6c11d06f2edac6497ead5'),
  -- data/triggers/185/185_17_group_heal_doctor_speech1.lua
  (185, 17, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"healing", "healing?", "group", "assist?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local s = string.lower(speech)
if not (string.find(s, "healing") or string.find(s, "group") or string.find(s, "assist")) then
    return true
end
wait(2)
self:command("nod")
self.room:send(tostring(self.name) .. " says, 'I specialize in group healing.  It's a powerful spell")
self.room:send("</>involving complex prayers.  Not easy to learn.'")
if ((string.find(actor.class, "cleric") or string.find(actor.class, "priest") or string.find(actor.class, "diabolist")) and actor.level > 56) and actor:get_quest_stage("group_heal") == 0 then
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'But you look like a very capable healer!  Perhaps you can")
    self.room:send("</>help me out.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'I've heard there once was a way to create a portable")
    self.room:send("</>version of the spell.  I've been trying to figure it out, but most of my time")
    self.room:send("</>is spent tending to the abbey's injured.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Raiders from Split Skull and bandits from the Gothra Desert")
    self.room:send("</>have made it very difficult to get anything done around here!'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'If you can help me work on it, I can teach you the proper")
    self.room:send("</>prayers in exchange.'")
    wait(3)
    self:say("What do you say, are you interested in working with me?")
end$trig$, '2705cf5ae750bbf59fda0707687d2852'),
  -- data/triggers/185/185_18_group_heal_doctor_speech2.lua
  (185, 18, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "yes!", "yep", "yep!", "okay", "sure"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
if ((string.find(actor.class, "cleric") or string.find(actor.class, "priest") or string.find(actor.class, "diabolist")) and actor.level > 56) and actor:get_quest_stage("group_heal") == 0 then
    actor:start_quest("group_heal")
    self:say("Thank you so much!")
    wait(1)
    self:say("There is an immediate problem I need your help with.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'A shipment of medical supplies was coming to us from Anduin")
    self.room:send("</>via the Black Rock Trail.  Unfortunately the transport was robbed and the")
    self.room:send("</>entire shipment was stolen by bandits.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'The few who survived said a fierce bandit raider attacked")
    self.room:send("</>their wagon and headed off into the desert with their belongings.  They said")
    self.room:send("</>he fought like nothing they had ever seen before.  Some kind of frenzy of")
    self.room:send("</>swords and daggers.'")
    wait(6)
    self.room:send(tostring(self.name) .. " says, 'Please, do whatever you need to recover those supplies and")
    self.room:send("</>bring them to me.'")
    if world.count_mobiles(185, 22) == 0 then
        get_room(11, 0):at(function()
            self.room:spawn_mobile(185, 22)
        end)
        get_room(11, 0):at(function()
            self.room:spawn_object(161, 6)
        end)
        get_room(11, 0):at(function()
            self.room:spawn_object(161, 6)
        end)
        get_room(11, 0):at(function()
            self:command("give scimitar bandit")
        end)
        get_room(11, 0):at(function()
            self:command("give scimitar bandit")
        end)
        get_room(11, 0):at(function()
            self.room:find_actor("bandit"):command("wear all")
        end)
        get_room(11, 0):at(function()
            self.room:find_actor("bandit"):teleport(get_room(161, 86))
        end)
    elseif actor:get_quest_stage("group_heal") == 3 or actor:get_quest_stage("group_heal") == 4 then
        self:say("May I see them please?")
    elseif actor:get_quest_stage("group_heal") == 5 then
        self:say("May I see what they have to say?")
    end
end$trig$, '5edb23e4c4b26c7d386d8677698a9c1d'),
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
local is_ant = class ~= nil and string.find(tostring(class), "anti") ~= nil
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
            if victim and (victim.is_npc) and (victim.class ~= "warrior") and (victim.class ~= "ranger") and (not (string.find(victim.class, "anti"))) and (victim.class ~= "paladin") and (victim.class ~= "monk") then
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
globals.action = now$trig$, '3b15fc5db6b46f02cb0c6f2dea03d528'),
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
    elseif string.find(actor.class, "anti") then
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
return _return_value$trig$, '36e6ab2a6105ab19e323cc6b290ad270'),
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
elseif string.find(actor.class, "anti") then
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
return _return_value$trig$, '8a3f72de3526d030ad1ac566c5c6910a'),
  -- data/triggers/237/237_90_recall_nymrill.lua
  (237, 90, $trig$-- Converted from DG Script #23790: recall_nymrill
-- Original: OBJECT trigger, flags: COMMAND, probability: 2%
-- Black potion of recall. Evil-aligned drinkers (alignment <= -350) recall to a
-- class-appropriate Nymrill room and the potion is consumed. Other drinkers get a
-- flavor message and the quaff proceeds.
-- The DG numeric argument 2 is the OCMD_* location mask (carried), not a 2% chance. Legacy
-- re-issued `quaff black-potion-recall` for the non-evil drinker while also blocking the typed
-- one, which fired this trigger again without end; the typed quaff is now simply let through.

-- Command location mask 2: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: quaff
if cmd ~= "quaff" then
    return true  -- Not our command
end

if not actor.is_player then
    return true  -- the quaff goes ahead
end

if actor.alignment <= -350 then
    actor:send("You quaff a potion and begin to feel a little light-headed...")
    self.room:send_except(actor, tostring(actor.name) .. " quaffs a black potion of recall.")
    self.room:send_except(actor, tostring(actor.name) .. " disappears in a flash of darkness!")
    if string.find(actor.class, "thief") or string.find(actor.class, "assassin") or string.find(actor.class, "mercenary") or string.find(actor.class, "rogue") then
        actor:teleport(get_room(495, 25))
    elseif string.find(actor.class, "sorcerer") or string.find(actor.class, "cryomancer") or string.find(actor.class, "pyromancer") then
        actor:teleport(get_room(495, 22))
    elseif string.find(actor.class, "necromancer") then
        actor:teleport(get_room(495, 14))
    else
        actor:teleport(get_room(495, 12))
    end
    actor:command("look")
    world.destroy(self)
    return false
end

actor:send("As you quaff a potion, you get a funny burning sensation in your stomach...")
return true  -- the quaff goes ahead$trig$, '82fb2276ce98befe6ee471824eef4d73'),
  -- data/triggers/364/364_08_berserker_hjordis_greet.lua
  (364, 8, $trig$-- Converted from DG Script #36408: berserker_hjordis_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
-- switch on actor:get_quest_stage("berserker_subclass")
if actor:get_quest_stage("berserker_subclass") == 1 then
    actor:send(tostring(self.name) .. " says, 'You return!'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Let us discuss your <b:cyan>Wild Hunt</>!'")
elseif actor:get_quest_stage("berserker_subclass") == 2 then
    actor:send(tostring(self.name) .. " says, 'Will you answer the call?'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Let us challenge the Spirits for the right to prove ourselves!  If they deem you worthy, the Spirits send you a vision of a mighty <b:cyan>beast</>.'")
elseif actor:get_quest_stage("berserker_subclass") == 3 then
    actor:send(tostring(self.name) .. " says, 'You return!'")
    wait(4)
    actor:send(tostring(self.name) .. " says, '<b:red>Howl</> to the spirits and make your song known!'")
elseif actor:get_quest_stage("berserker_subclass") == 4 then
    actor:send(tostring(self.name) .. " says, 'Why are you here when you should be out hunting your prey?'")
else
    if string.find(actor.class, "warrior") then
        -- TODO(parity): legacy DG had `case ADD RESTRICTED RACES HERE` left as
        -- a placeholder; restricted races for berserker are still TBD.
        if actor.level >= 10 and actor.level <= 25 then
            actor:send(tostring(self.name) .. " says, 'Hail and well met!'")
            actor:send(tostring(self.name) .. " claps you on the back.")
            self.room:send_except(actor, tostring(self.name) .. " claps " .. tostring(actor.name) .. " on the back.")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Only the most ferocious souls find their way here.'")
            wait(2)
            self:command("peer " .. tostring(actor.name))
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I see you could be <b:cyan>among</> our number!'")
        end
    end
end$trig$, 'd74d6182a67e378f24e4baae03e94184'),
  -- data/triggers/364/364_09_berserker_hjordis_speech1.lua
  (364, 9, $trig$-- Converted from DG Script #36409: berserker_hjordis_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: among, number, who
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "among") or string.find(speech_lower, "number") or string.find(speech_lower, "who")) then
    return true
end
if string.find(actor.class, "warrior") then
    -- TODO(parity): legacy DG left placeholder for race restrictions:
    --   "Your race may not subclass to berserker." Restricted race list TBD.
    wait(2)
    if actor.level >= 10 and actor.level <= 25 then
        actor:send(tostring(self.name) .. " says, 'Aye, you have the mettle of the most fearsome of all warriors, a &9<blue>ber<red>ser&9ker</>!'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Do you think you have what it takes?'")
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'Build your rage further, then seek me out again.'")
    end
end$trig$, '6aabbfa5b5268c730c6d3b286480b92a'),
  -- data/triggers/364/364_10_berserker_hjordis_speech2.lua
  (364, 10, $trig$-- Converted from DG Script #36410: berserker_hjordis_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keyword: yes
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "yes") then
    return true
end
if string.find(actor.class, "warrior") then
    -- TODO(parity): legacy DG left placeholder for race restrictions:
    --   "Your race may not subclass to berserker." Restricted race list TBD.
    wait(2)
    if actor.level >= 10 and actor.level <= 25 then
        actor:start_quest("berserker_subclass", "Ber")
        actor:send(tostring(self.name) .. " says, 'Then prove it!'")
        self:command("laugh")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'There are a few shared rites that bind us together.  None is more revered than the <b:cyan>Wild Hunt</>.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Ask your <b:cyan>[subclass progress]</> if you need guidance.'")
    end
end$trig$, 'df84795e94c5909012a61070adfc9d89'),
  -- data/triggers/364/364_20_berserker_subclass_progress_checker.lua
  (364, 20, $trig$-- Speech keywords: subclass, progress
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "subclass") or string.find(speech_lower, "progress")) then
    return true
end

wait(2)
local stage = actor:get_quest_stage("berserker_subclass")

if stage == 1 then
    actor:send(tostring(self.name) .. " says, 'There are a few shared rites that bind us together.  None is more revered than the <b:cyan>Wild Hunt</>.'")
    return true
end

if stage == 2 then
    actor:send(tostring(self.name) .. " says, 'Let us challenge the Spirits for the right to prove ourselves!  If they deem you worthy, the Spirits send you a vision of a mighty <b:cyan>beast</>.'")
    return true
end

if stage == 3 then
    actor:send(tostring(self.name) .. " says, '<b:red>Howl</> to the spirits and make your song known!'")
    return true
end

if stage == 4 then
    -- Re-reveal the assigned quarry. Lookup mirrors 364_13's QUARRIES table.
    local QUARRIES = {
        [16105] = "a desert cave",
        [16310] = "some forested highlands",
        [20311] = "a vast plain",
        [55220] = "the frozen tundra",
    }
    local target = actor:get_quest_var("berserker_subclass:target")
    local place = QUARRIES[target]
    if target and place then
        local quarry_name = mobiles.template(math.floor(target / 100), target % 100).name
        actor:send("The Spirits reveal to you a vision of " .. tostring(quarry_name) .. "!")
        actor:send("You see it is in " .. tostring(place) .. "!")
    end
    -- TODO(parity): legacy script also fell through to a race-restriction
    -- "you won't be able to become a berserker" branch with placeholder
    -- "ADD RESTRICTED RACES HERE". Restricted-race list still TBD.
    if not string.find(actor.class, "warrior") then
        actor:send(tostring(self.name) .. " says, 'You won't be able to become a berserker, I'm afraid.'")
    end
    return true
end

-- stage 0 (or unset): not started yet.
if string.find(actor.class, "warrior") then
    if actor.level >= 10 and actor.level <= 25 then
        actor:send(tostring(self.name) .. " says, 'You aren't trying to join us yet!'")
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'You aren't ready to join us yet!'")
    else
        actor:send(tostring(self.name) .. " says, 'You won't be able to become a berserker, I'm afraid.'")
    end
else
    actor:send(tostring(self.name) .. " says, 'You won't be able to become a berserker, I'm afraid.'")
end
return true$trig$, 'bf0cb035fb431d1895b5736798dc3ea2'),
  -- data/triggers/390/390_01_flood_lady_greet.lua
  (390, 1, $trig$wait(1)
local stage = actor:get_quest_stage("flood")
if stage == 0 then
    if string.find(actor.class, "cryomancer") and actor.level > 80 then
        self:command("point " .. actor.name)
        self:emote("screams, 'YOU.'")
        wait(2)
        self:emote("screams, 'YOU WILL HELP ME DESTROY THIS SETTLEMENT.'")
    end
elseif stage == 1 then
    self.room:send(self.name .. " says, 'Why have you not yet convinced the other great")
    self.room:send("</>waters to assist me??'")
    self:emote("fumes.")
elseif stage == 2 then
    self.room:send(self.name .. " says, 'The waters are ready!  Give me back the heart and")
    self.room:send("</>the ocean will rage!'")
end$trig$, 'd7ac933f410b459a3b2d6d93824027c7'),
  -- data/triggers/390/390_02_flood_lady_speech.lua
  (390, 2, $trig$local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "flood")
        or string.find(speech_lower, "help")
        or string.find(speech_lower, "how")
        or string.find(speech_lower, "why")) then
    return true
end

wait(2)
local stage = actor:get_quest_stage("flood")
if stage == 0 then
    if string.find(actor.class, "cryomancer") and actor.level > 80 then
        actor:start_quest("flood")
        self.room:send(self.name .. " says, 'The masters of this settlement stole my most")
        self.room:send("</>precious treasures.  I will punish them with a cataclysm of rising tide and")
        self.room:send("</>raging torrents by calling to the great waters of Ethilien to my aid.  You will")
        self.room:send("</>be my envoy to their domains.'")
        wait(3)
        self:say("The great waters are:")
        self.room:send("<b:white>The Blue-Fog River and Lake</>")
        self.room:send("<b:white>Phoenix Feather Hot Springs</>")
        self.room:send("<b:white>Three-Falls River in the canyon</>")
        self.room:send("<b:white>The Greengreen Sea</>")
        self.room:send("<b:white>Sea's Lullaby</>")
        self.room:send("<b:white>Frost Lake</>")
        self.room:send("<b:white>Black Lake</>")
        self.room:send("<b:white>The Dreaming River in the Realm of the King of Dreams</>")
        wait(4)
        self.room:spawn_object(390, 0)
        self:command("give heart-ocean " .. actor.name)
        self.room:send(self.name .. " says, 'Standing in the waters with this, say:")
        self.room:send("<b:blue>the Arabel Ocean calls for aid</>.'")
        wait(4)
        self:say("They will respond.")
        wait(2)
        self.room:send(self.name .. " says, 'Tell them I long for <b:blue>revenge</>.'")
        wait(4)
        self.room:send(self.name .. " says, 'You will acquiesce to this request.  In exchange, I")
        self.room:send("</>will teach you to control the raging tides to demolish your enemies.'")
        wait(2)
        self.room:send(self.name .. " says, 'If you need, I can update you on your <b:white>[progress]</>.'")
    end
elseif stage == 1 then
    self.room:send(self.name .. " says, 'Why have you not yet convinced the other great")
    self.room:send("</>waters to assist me??'")
    self:emote("fumes.")
elseif stage == 2 then
    self.room:send(self.name .. " says, 'The waters are ready!  Give me back the heart and")
    self.room:send("</>the ocean will rage!'")
end$trig$, '949d45d904eaf4b730b19a9fa3c58d27'),
  -- data/triggers/430/430_52_word_command_dargo_greet.lua
  (430, 52, $trig$-- Converted from DG Script #43052: word_command_dargo_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
if self.room.zone_id == 430 and self.room.local_id == 148 then
    if globals.questor and globals.questor == actor.name then
        self:say("Thank the gods you found me again!  Help me get out of here!")
    elseif (string.find(actor.class, "priest") or string.find(actor.class, "diabolist")) and actor.level > 72 then
        self:say("Oh thank the gods, please help me!  Someone used a scroll")
        self.room:send("</>of World Teleport on me as a joke and I wound up here!'")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'I've been trying desperately to escape this place but every")
        self.room:send("</>time I think I found a way out, the demon reaper who rules this place")
        self.room:send("</>keeps pulling me back.'")
        wait(2)
        self:say("I don't know how long I've been down here...")
        self:command("sob")
        wait(2)
        self:say("Help me confront the demon and his servants and destroy them!")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'If you can get me out of this hell, I can teach you a")
        self.room:send("</>powerful spell.  Will you help me?'")
    else
        self:say("Do you have any priestly friends who can protect us from the")
        self.room:send("</>demon who rules this keep??  Or even someone who knows the demonic arts?'")
    end
end$trig$, '9114a5f080e6048c2d397f94eacd7611'),
  -- data/triggers/430/430_53_word_command_dargo_speech1.lua
  (430, 53, $trig$-- Converted from DG Script #43053: word_command_dargo_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes yes? sure okay yeah
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "yes?") or string.find(string.lower(speech), "sure") or string.find(string.lower(speech), "okay") or string.find(string.lower(speech), "yeah")) then
    return true  -- No matching keywords
end
wait(2)
if globals.questor == actor.name then
    self:say("Lead on!")
elseif actor:get_has_completed("word_command") then
    self:emote("stars in wide-eyed terror.")
    wait(2)
    self:say("Don't I know you already?!  Cyprianum is tormenting me again!!")
    wait(1)
    self.room:send(tostring(self.name) .. " screams, 'NOOOOOOOO!!!!!' as he runs wildly into the shadows!")
    world.destroy(self)
elseif (string.find(actor.class, "priest") or string.find(actor.class, "diabolist")) and actor.level > 72 then
    self:say("Thank you!")
    if not actor:get_quest_stage("word_command") then
        actor:start_quest("word_command")
    end
    globals.questor = actor.name
    self:follow(actor)
else
    self.room:send(tostring(self.name) .. " says, 'I don't know if you can protect me from the demonic forces")
    self.room:send("</>here...  You'll need in-depth knowledge of demons to get us out of")
    self.room:send("</>here alive!'")
end$trig$, 'c36a1ced192cc99294f9a292fbc79089'),
  -- data/triggers/481/481_150_burning_wall.lua
  (481, 150, $trig$-- Converted from DG Script #48250: burning wall
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level < 100 then
    if string.find(direction, "south") then
        if string.find(actor.class, "sorcerer") or string.find(actor.class, "pyromancer") or actor:get_quest_stage("fire_wand") > 7 then
            actor:send("The flames and lava bend around you as you pass through unharmed.")
        else
            local damage = (random(1, 40) + 40)
            local damage_dealt = actor:damage(damage)  -- type: fire
            actor:send("The flames scorch you as you try to approach the wall. (" .. tostring(damage_dealt) .. ")")
            actor:send("You seem to hear a voice whisper, 'This room is not for you.'")
            _return_value = true
        end
    end
end
return _return_value$trig$, '4dd293b7aa74f0712c3734e0bf1f2784'),
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
    if (victim.name ~= actor.name) and ((victim.class == "warrior") or (string.find(victim.class, "anti")) or (victim.class == "ranger") or (victim.class == "paladin") or (victim.class == "monk") or (victim.class == "mercenary") or (victim.class == "berserker")) then
        if victim.room == self.room then
            self:teleport(get_room(11, 0))
            self:teleport(actor.room)
            self.room:send("<b:white>The Leviathan thrashes about madly, switching opponents!</>")
            combat.engage(self, victim.name)
        end
    end
end$trig$, '9da9979306dd57570ec2eeb863212f00'),
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
    if string.find(string.lower(casters), tostring(victim.class), 1, true) then
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
end$trig$, 'c60fa35f435c4c52343e57b177701396'),
  -- data/triggers/489/489_33_severan_shockwave.lua
  (489, 33, $trig$self.room:send("<b:white>The white aura around Severan's body intensifies, increasing in brightness.</>")
wait(2)
self.room:send("<b:white>A powerful shockwave leaps off Severan's body as the aura flares wildly!</>")
local casters = "Sorcerer Necromancer Cryomancer Pyromancer Cleric Druid Diabolist Priest Shaman Conjurer"
for _, person in ipairs(self:get_people()) do
    if (person.zone_id ~= 489) and (person.level < 100) then
        local damage
        if string.find(string.lower(casters), tostring(person.class), 1, true) then
            damage = 100 + random(1, 50)
        else
            damage = 250 + random(1, 50)
        end
        if person:has_effect(Effect.Sanctuary) then
            damage = damage / 2
        end
        if person:has_effect(Effect.Stone) then
            damage = damage / 2
        end
        -- Chance for critical hit
        local variant = random(1, 15)
        if variant == 1 then
            damage = damage / 2
        elseif variant == 15 then
            damage = damage * 2
        end
        -- Halve damage AGAIN for major globe
        local globed = person:has_effect(Effect.Major_Globe)
        if globed then
            damage = damage / 2
        end
        local damage_dealt = person:damage(damage)  -- type: crush
        if damage_dealt == 0 then
            self.room:send_except(person, "<b:white>The blast passes through " .. tostring(person.name) .. ", causing no damage.</>")
            person:send("<b:white>The blast passes through you harmlessly.</>")
        elseif globed then
            self.room:send_except(person, "<b:red>The shimmering globe around " .. tostring(person.name) .. "'s body wavers as the blast overwhelms it!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
            person:send("<b:red>The <white>blast<red> passes through the shimmering globe around your body, striking you!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
        else
            self.room:send_except(person, "<b:white>The blast strikes " .. tostring(person.name) .. " violently, tearing at " .. tostring(person.possessive) .. " flesh!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
            person:send("<b:white>The blast strikes you violently, rending your flesh!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
        end
    end
end$trig$, 'bfb9d16feae28ae34da6dfea66ffbf59'),
  -- data/triggers/495/495_02_transfer_trig_49531.lua
  (495, 2, $trig$-- Command filter: west / w
if not (cmd == "west" or cmd == "w") then
    return true  -- Not our command
end

if not actor.is_player then
    return true
end

local class = actor.class or ""
local is_shadow_class = string.find(class, "necromancer")
    or string.find(class, "anti-paladin", 1, true)
    or string.find(class, "thief")
    or string.find(class, "assassin")
    or string.find(class, "mercenary")

if not is_shadow_class then
    return true
end

if actor.alignment < -349 then
    actor:send("Reality blurs and melts as you find yourself in a more dark and confined place.")
    actor:teleport(get_room(495, 33))
else
    actor:send("A cloak of shadow surrounds your being, choking your very breathe. Now you awake elsewhere.")
    actor:teleport(get_room(30, 2))
end$trig$, '6392cd5508670c46c765e78a573bd8eb'),
  -- data/triggers/495/495_03_auto_door_opener.lua
  (495, 3, $trig$-- Speech keyword filter: literal phrase (case-insensitive)
if not string.find(string.lower(speech), "i am child of borgan") then
    return true
end

if not actor.is_player then
    return true
end

if not string.find(actor.class or "", "necromancer") then
    return true
end

local stair_room = get_room(495, 13)
stair_room:exit("up"):set_state({hidden = false})
self:send("With a terrifying crash the ceiling above falls downward, ceasing. A stairway leads upwards.")
wait(20)
stair_room:exit("up"):set_state({hidden = true})$trig$, '622b6a89049803ac2c2644d2039a03e7'),
  -- data/triggers/495/495_04_transfer_trig.lua
  (495, 4, $trig$-- Command filter: east / e
if not (cmd == "east" or cmd == "e") then
    return true  -- Not our command
end

if not actor.is_player then
    return true
end

local class = actor.class or ""
local is_holy_class = string.find(class, "priest")
    or string.find(class, "cleric")
    or string.find(class, "paladin")
    or string.find(class, "ranger")
    or string.find(class, "monk")
    or string.find(class, "druid")

if not is_holy_class then
    return true
end

if actor.alignment < 350 then
    actor:send("You have no business here in the realm of shadow and death.")
    actor:send("You find yourself in a lighter place at peace.")
    actor:teleport(get_room(30, 2))
end$trig$, 'f662cd1abc83c6f564f32042cf556a94'),
  -- data/triggers/510/510_03_luchiaans_greeting.lua
  (510, 3, $trig$local magequest = magequest or 0
local clericquest = clericquest or 0
if actor.is_player and actor.level < 100 then
    if (string.find(actor.class, "necromancer") or string.find(actor.class, "sorcerer")) and magequest < 2 then
        wait(5)
        self:command("ponder")
        wait(2)
        self.room:send_except(actor, "Luchiaans leans close to " .. tostring(actor.name) .. ".")
        self:whisper(actor.name, "You and I could be partners in this, if you want? I could use an extra pair of hands.")
    end
    if string.find(actor.class, "warrior") then
        wait(5)
        self:command("ponder")
        wait(2)
        self:command("poke " .. tostring(actor.name))
        self:say("Hmm... not bad stock for my experiments.  I may save your corpse.")
        self:emote("grins diabolically.")
        self:command("cackle")
    end
    if (string.find(actor.class, "cleric") or string.find(actor.class, "priest")) and clericquest < 2 then
        wait(5)
        self:command("ponder")
        wait(2)
        self.room:send_except(actor, "Luchiaans leans close to " .. tostring(actor.name) .. ".")
        self:whisper(actor.name, "Can you teach me some of your healing spells?")
        self:whisper(actor.name, "I may have a need for the theory of regeneration.")
    end
end$trig$, '15190fabe9b442994f5124c23654ab20'),
  -- data/triggers/510/510_04_only_clerics_enter.lua
  (510, 4, $trig$if actor.level >= 100 then
    return true
end

if string.find(actor.class, "cleric") or string.find(actor.class, "priest") then
    actor:send("You feel a calmness come over you, as if the troubles of the world are washed away.")
    entry = (entry or 0) + 1
    return true
else
    actor:send("You can't seem to enter the room!  It is like stepping against a solid wall,")
    actor:send("&0but you can see in.")
    actor:send("You seem to hear a voice whisper, 'This room is not for you.'")
    return false
end$trig$, 'ea62ff130c759ae2d5449be589c65c3e'),
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

local clericquest = clericquest or 0
local magequest = magequest or 0

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
end$trig$, '777823f73183f1d3ec027deea3c9e4c3'),
  -- data/triggers/510/510_06_non_clerics_out.lua
  (510, 6, $trig$-- `self` is the room's actor handle; occupants live on its LuaRoom.
local room = self.room
if not room or room.actor_count == 0 then
    return true
end

local rnd = room.actors[random(1, room.actor_count)]
if not rnd or not rnd.is_player or rnd.level >= 100 then
    return true
end

if string.find(rnd.class, "cleric") or string.find(rnd.class, "priest") then
    return true
end

rnd:send("You feel a force pushing you out of the room - you are powerless to resist!")
room:send_except(rnd, tostring(rnd.name) .. " suddenly starts moving out of the room.")
rnd:teleport(get_room(510, 50))
rnd:send("You seem to hear a voice whisper, 'This room is not for you.'")
wait(8)
rnd:command("look")$trig$, '5867d623ef732714e5c9048930075a68'),
  -- data/triggers/533/533_08_wall_ice_sculptor_greet.lua
  (533, 8, $trig$wait(1)
if actor:get_quest_stage("type_wand") == "wandstep" then
    local wandstep = tonumber(actor:get_quest_var("type_wand:wandstep")) or 0
    local minlevel = (wandstep - 1) * 10
    if actor.level >= minlevel then
        if actor:get_quest_var("type_wand:greet") == 0 then
            self.room:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
            actor:set_quest_var("type_wand", "greet", 1)
        else
            self:say("Do you have what I need for the wand?")
        end
        wait(1)
    end
end
local stage = actor:get_quest_stage("wall_ice")
if stage == 0 then
    if actor.class and string.find(actor.class, "cryomancer") and actor.level > 56 then
        self:command("wave")
        self:say("Hey, you there, you look like a capable cryomancer!  Lend me a hand with this wall, will ya?")
        wait(2)
        self:say("We had a few nasty surprises with creatures slipping out from Frost Valley.  So Suralla sent me over to reinforce the wall blocking off the tunnel.")
        wait(2)
        self:say("I ran out of supplies and my spells can't make permanent walls.  Can you help me get more ice for the wall?")
    end
elseif stage == 1 then
    local ice = 20 - (tonumber(actor:get_quest_var("wall_ice:blocks")) or 0)
    if ice > 1 then
        self:say("Do you have the " .. tostring(ice) .. " remaining blocks of ice?")
    elseif ice == 1 then
        self:say("Do you have the last remaining block of ice?")
    end
end$trig$, '64c76cbecf4b6bc27829a9351cc3325f'),
  -- data/triggers/533/533_09_ice_wall_sculptor_speech.lua
  (533, 9, $trig$-- Speech keywords: yes, okay, wall, how, ice, supplies
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "yes") or string.find(speech_lower, "okay") or string.find(speech_lower, "wall") or string.find(speech_lower, "how") or string.find(speech_lower, "ice") or string.find(speech_lower, "supplies")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("wall_ice") == 0 then
    if actor.class and string.find(actor.class, "cryomancer") and actor.level > 56 then
        actor:start_quest("wall_ice")
        if actor.gender == "female" then
            self:say("Thank you so much ma'am!")
        elseif actor.gender == "male" then
            self:say("Thank you so much sir!")
        else
            self:say("Thank you so much!")
        end
        wait(1)
        self:say("What I need are blocks of living ice.  Using Wall of Ice I can fuse them together so they make a permanent barrier.  I chewed through my stock pile of living ice faster than I anticipated, so I need more.")
        wait(2)
        self:emote("writes some notes down on a piece of paper.")
        self.room:spawn_object(533, 26)
        self:command("give notes " .. tostring(actor.name))
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'This spell has a chance to capture animated energies of ice creatures in their remains.  Have the spell on you and say <b:cyan>'crystalize'</> in the presence of an ice creature before you defeat it.'")
        wait(4)
        self:say("The more powerful the creature, the more likely this spell will create a block of living ice from it.  But be careful, it only works on creatures actually made of ice!!")
        wait(4)
        self:say("Though there are a number of ice creatures in Frost Valley, any ice creature is fine.  I need 20 more blocks to finish this wall.")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'You can check your <b:white>[spell progress]</> at any time.'")
    elseif actor:get_quest_stage("wall_ice") == 1 then
        self:say("Hand 'em on over then!")
    end
end$trig$, 'd948e07f8824cc46e4f86d37be4ee2d4'),
  -- data/triggers/553/553_41_phase_2_anti-paladin_greet.lua
  (553, 41, $trig$-- Converted from DG Script #55341: phase_2_anti-paladin_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if string.find(actor.class, "anti") and actor.level >= 21 then
    if actor:get_quest_stage("phase_armor") == 0 then
        actor:start_quest("phase_armor")
    end
    if actor:get_quest_stage("phase_armor") == 1 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Welcome, would you like to do some <b:white>armor quests</>?\"")
        actor:send(tostring(self.name) .. " tells you, \"If so, just ask me, <b:white>Yes</> I would like to do some <b:white>armor quests</>\"")
    end
else
end$trig$, '8597af5be0a4c27539634c83a14bc8f1'),
  -- data/triggers/553/553_42_phase_2_anti-paladin_accept.lua
  (553, 42, $trig$-- Converted from DG Script #55342: Phase_2_anti-paladin_accept
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- This will recognize the acceptance of the phase armor quest
-- by a player and set the quest variable for later interaction.
-- 
if string.find(actor.class, "anti") then
    wait(2)
    if actor:get_quest_stage("phase_armor") == 1 then
        actor:advance_quest("phase_armor")
    end
    actor:send(tostring(self.name) .. " tells you, \"Excellent, I can make nice <b:white>boots</>, a <b:white>helm</>, <b:white>gauntlets</>,\"")
    actor:send(tostring(self.name) .. " tells you, \"<b:white>vambraces</>, <b:white>greaves</>, <b:white>plate</>, and a <b:white>bracer</>.\"")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"If you want to know about how to quest for one, ask me about\"")
    actor:send(tostring(self.name) .. " tells you, \"it and I will tell you the components you need to get for me\"")
    actor:send(tostring(self.name) .. " tells you, \"in order to receive your reward.\"")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Remember, you can ask me <b:white>status</> at any time,\"")
    actor:send(tostring(self.name) .. " tells you, \"and I'll tell you what you have given me so far.\"")
else
    actor:send(tostring(self.name) .. " tells you, \"Sorry, this quest is for anti-paladins only.\"")
end$trig$, 'd5fad3fcc938e8cc1be43beecc9c9c39'),
  -- data/triggers/553/553_43_phase_2_anti-paladin_boots.lua
  (553, 43, $trig$-- Converted from DG Script #55343: phase_2_anti-paladin_boots
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Boots ya ask?
-- 
-- This is for anti-paladins only
if string.find(actor.class, "anti") and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Boots ya ask? Well now I can make a fine pair of boots for the\"")
    actor:send(tostring(self.name) .. " tells you, \"anti-paladin types but I'll need 3 chrysobeyrl shards, and a set of\"")
    actor:send(tostring(self.name) .. " tells you, \"Crushed Plate Boots. Return these things to me in any order at\"")
    actor:send(tostring(self.name) .. " tells you, \"any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for anti-paladins only.")
end$trig$, '120a6570d9bf54bc022f5e0dc78218dc'),
  -- data/triggers/553/553_44_phase_2_anti-paladin_helm.lua
  (553, 44, $trig$-- Converted from DG Script #55344: phase_2_anti-paladin_helm
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- helm ya ask?
-- 
-- This is for anti-paladins only
if string.find(actor.class, "anti") and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Helm ya ask? Well now I can make a nice helm for the anti-paladin types\"")
    actor:send(tostring(self.name) .. " tells you, \"but I'll need 3 radiant ambers, and a Crushed\"")
    actor:send(tostring(self.name) .. " tells you, \"Helm. Return these things to me in any order at any time and I\"")
    actor:send(tostring(self.name) .. " tells you, \"will reward you.\"")
else
    actor:send("Sorry this quest is for anti-paladins only.")
end$trig$, 'dd057c751ee95ad9506e43b4ee2e1f90'),
  -- data/triggers/553/553_45_phase_2_anti-paladin_gauntlets.lua
  (553, 45, $trig$-- Converted from DG Script #55345: phase_2_anti-paladin_gauntlets
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Gauntlets ya ask?
-- 
-- This is for anti-paladins only
if string.find(actor.class, "anti") and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Gauntlets? Well now I can make a fine pair of gauntlets for the\"")
    actor:send(tostring(self.name) .. " tells you, \"anti-paladin types but I'll need 3 uncut tourmalines, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Crushed Gauntlets. Return these things to me in any\"")
    actor:send(tostring(self.name) .. " tells you, \"order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for anti-paladins only.")
end$trig$, 'a929634daee46111e30feb47b5a69586'),
  -- data/triggers/553/553_46_phase_2_anti-paladin_vambraces.lua
  (553, 46, $trig$-- Converted from DG Script #55346: phase_2_anti-paladin_vambraces
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Vambraces ya ask?
-- 
-- This is for anti-paladins only
if string.find(actor.class, "anti") and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Vambraces ya ask? Well now I can make a fine set of vambraces for\"")
    actor:send(tostring(self.name) .. " tells you, \"the anti-paladin types but I'll need 3 flawed jades, and a set of\"")
    actor:send(tostring(self.name) .. " tells you, \"Crushed Vambraces. Return these things to me in\"")
    actor:send(tostring(self.name) .. " tells you, \"any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for anti-paladins only.")
end$trig$, '13ec471560682be2c7a999fc6bf8909f'),
  -- data/triggers/553/553_47_phase_2_anti-paladin_greaves.lua
  (553, 47, $trig$-- Converted from DG Script #55347: phase_2_anti-paladin_greaves
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Greaves ya ask?
-- 
-- This is for anti-paladins only
if string.find(actor.class, "anti") and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Ah, protection for yer legs? Well now I can make a fine set of\"")
    actor:send(tostring(self.name) .. " tells you, \"greaves for the anti-paladin types but I'll need 3 enchanted jades, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Crushed Greaves. Return these things\"")
    actor:send(tostring(self.name) .. " tells you, \"to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for anti-paladins only.")
end$trig$, '7529537a0e8009580e78295b8857e79f'),
  -- data/triggers/553/553_48_phase_2_anti-paladin_plate.lua
  (553, 48, $trig$-- Converted from DG Script #55348: phase_2_anti-paladin_plate
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Plate ya ask?
-- 
-- This is for anti-paladins only
if string.find(actor.class, "anti") and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Body armor? Well now I can make a fine plate for the anti-paladins but\"")
    actor:send(tostring(self.name) .. " tells you, \"I'll need 3 emeralds, and a Crushed Plate. Return these\"")
    actor:send(tostring(self.name) .. " tells you, \"things to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for anti-paladins only.")
end$trig$, 'b3b3348c3acf969167a46cb46b5932f0'),
  -- data/triggers/553/553_49_phase_2_anti-paladin_bracer.lua
  (553, 49, $trig$-- Converted from DG Script #55349: phase_2_anti-paladin_bracer
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Bracer ya ask?
-- 
-- This is for anti-paladins only
if string.find(actor.class, "anti") and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Bracer ya ask? Well now I can make a protective bracer for the\"")
    actor:send(tostring(self.name) .. " tells you, \"anti-paladin types but I'll need 3 amber shards, and a Crushed Plate\"")
    actor:send(tostring(self.name) .. " tells you, \"Bracer. Return these things to me in any order at any time and\"")
    actor:send(tostring(self.name) .. " tells you, \"I will reward you.\"")
else
    actor:send("Sorry this quest is for anti-paladins only.")
end$trig$, '3f12b4530d52d7bd5124def43702887c'),
  -- data/triggers/554/554_51_phase_3_anti-paladin_greet.lua
  (554, 51, $trig$-- Converted from DG Script #55451: phase_3_anti-paladin_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if string.find(actor.class, "anti") and actor.level >= 41 then
    if actor:get_quest_stage("phase_armor") == 2 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Welcome, would you like to do some armor quests?\"")
        actor:send(tostring(self.name) .. " tells you, \"If so, just ask me, Yes I would like to do some armor quests\"")
    end
else
end$trig$, 'd35e1b82ba61737b06d5720b9ed7e158'),
  -- data/triggers/554/554_52_phase_3_anti-paladin_accept.lua
  (554, 52, $trig$-- Converted from DG Script #55452: Phase_3_anti-paladin_accept
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- This will recognize the acceptance of the phase armor quest
-- by a player and set the quest variable for later interaction.
-- 
if string.find(actor.class, "anti") then
    wait(2)
    if actor:get_quest_stage("phase_armor") == 2 then
        actor:advance_quest("phase_armor")
    end
    actor:send(tostring(self.name) .. " tells you, \"Excellent, I can make nice boots, a helm, gauntlets,\"")
    actor:send(tostring(self.name) .. " tells you, \"vambraces, greaves, plate, and a bracer.\"")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"If you want to know about how to quest for one, ask me about\"")
    actor:send(tostring(self.name) .. " tells you, \"it and I will tell you the components you need to get for me\"")
    actor:send(tostring(self.name) .. " tells you, \"in order to receive your reward.\"")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Remember, you can ask me status at any time,\"")
    actor:send(tostring(self.name) .. " tells you, \"and I'll tell you what you have given me so far.\"")
else
    actor:send(tostring(self.name) .. " tells you, \"Sorry, this quest is for anti-paladins only.\"")
end$trig$, 'd4cfeda655e59c9f7e9b4cebef9ac70a'),
  -- data/triggers/554/554_53_phase_3_anti-paladin_boots.lua
  (554, 53, $trig$-- Converted from DG Script #55453: phase_3_anti-paladin_boots
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Boots ya ask?
-- 
-- This is for anti-paladins only
if string.find(actor.class, "anti") and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Boots ya ask? Well now I can make a fine pair of boots for the\"")
    actor:send(tostring(self.name) .. " tells you, \"anti-paladin types but I'll need 3 handfulls of pearls, and a set of\"")
    actor:send(tostring(self.name) .. " tells you, \"Tarnished Plate Boots. Return these things to me in any order at\"")
    actor:send(tostring(self.name) .. " tells you, \"any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for anti-paladins only.")
end$trig$, '04883b8e7c9712dfe076ce427c47ef27'),
  -- data/triggers/554/554_54_phase_3_anti-paladin_helm.lua
  (554, 54, $trig$-- Converted from DG Script #55454: phase_3_anti-paladin_helm
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- helm ya ask?
-- 
-- This is for anti-paladins only
if string.find(actor.class, "anti") and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Helm ya ask? Well now I can make a nice helm for the anti-paladin types\"")
    actor:send(tostring(self.name) .. " tells you, \"but I'll need 3 radiant topazs, and a Tarnished\"")
    actor:send(tostring(self.name) .. " tells you, \"Helm. Return these things to me in any order at any time and I\"")
    actor:send(tostring(self.name) .. " tells you, \"will reward you.\"")
else
    actor:send("Sorry this quest is for anti-paladins only.")
end$trig$, '423f6ea0a8d66a395ce9b4a72e9d69ba'),
  -- data/triggers/554/554_55_phase_3_anti-paladin_gauntlets.lua
  (554, 55, $trig$-- Converted from DG Script #55455: phase_3_anti-paladin_gauntlets
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Gauntlets ya ask?
-- 
-- This is for anti-paladins only
if string.find(actor.class, "anti") and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Gauntlets? Well now I can make a fine pair of gauntlets for the\"")
    actor:send(tostring(self.name) .. " tells you, \"anti-paladin types but I'll need 3 chrysoberyls, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Tarnished Gauntlets. Return these things to me in any\"")
    actor:send(tostring(self.name) .. " tells you, \"order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for anti-paladins only.")
end$trig$, '1639b82e963c73a7786179b5d02844c5'),
  -- data/triggers/554/554_56_phase_3_anti-paladin_vambraces.lua
  (554, 56, $trig$-- Converted from DG Script #55456: phase_3_anti-paladin_vambraces
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Vambraces ya ask?
-- 
-- This is for anti-paladins only
if string.find(actor.class, "anti") and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Vambraces ya ask? Well now I can make a fine set of vambraces for\"")
    actor:send(tostring(self.name) .. " tells you, \"the anti-paladin types but I'll need 3 perfect aquamarines, and a set of\"")
    actor:send(tostring(self.name) .. " tells you, \"Tarnished Vambraces. Return these things to me in\"")
    actor:send(tostring(self.name) .. " tells you, \"any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for anti-paladins only.")
end$trig$, '7e51afcc06484fc24dad97b213857d65'),
  -- data/triggers/554/554_57_phase_3_anti-paladin_greaves.lua
  (554, 57, $trig$-- Converted from DG Script #55457: phase_3_anti-paladin_greaves
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Greaves ya ask?
-- 
-- This is for anti-paladins only
if string.find(actor.class, "anti") and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Ah, protection for yer legs? Well now I can make a fine set of\"")
    actor:send(tostring(self.name) .. " tells you, \"greaves for the anti-paladin types but I'll need 3 radiant opals, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Tarnished Greaves. Return these things\"")
    actor:send(tostring(self.name) .. " tells you, \"to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for anti-paladins only.")
end$trig$, '83d3e4ebcecfcf85b6a67816883c6553'),
  -- data/triggers/554/554_58_phase_3_anti-paladin_plate.lua
  (554, 58, $trig$-- Converted from DG Script #55458: phase_3_anti-paladin_plate
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Plate ya ask?
-- 
-- This is for anti-paladins only
if string.find(actor.class, "anti") and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Body armor? Well now I can make a fine plate for the anti-paladins but\"")
    actor:send(tostring(self.name) .. " tells you, \"I'll need 3 enchanted emeralds, and a Tarnished Plate. Return these\"")
    actor:send(tostring(self.name) .. " tells you, \"things to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for anti-paladins only.")
end$trig$, 'fca3b2643a9aecc2716a287603da6f3e'),
  -- data/triggers/554/554_59_phase_3_anti-paladin_bracer.lua
  (554, 59, $trig$-- Converted from DG Script #55459: phase_3_anti-paladin_bracer
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Bracer ya ask?
-- 
-- This is for anti-paladins only
if string.find(actor.class, "anti") and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Bracer ya ask? Well now I can make a protective bracer for the\"")
    actor:send(tostring(self.name) .. " tells you, \"anti-paladin types but I'll need 3 handfulls of jade, and a Tarnished Plate\"")
    actor:send(tostring(self.name) .. " tells you, \"Bracer. Return these things to me in any order at any time and\"")
    actor:send(tostring(self.name) .. " tells you, \"I will reward you.\"")
else
    actor:send("Sorry this quest is for anti-paladins only.")
end$trig$, 'f837a5dde9d40cf94691ac6851a43d9b'),
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
    elseif not string.find(string.lower(classes), actor.class, 1, true) or (classes == anti and actor.class == "paladin") then
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
return _return_value$trig$, '501ed1354845d1d73ebe24400c357b08'),
  -- data/triggers/557/557_01_phase_armor_-_start.lua
  (557, 1, $trig$-- Converted from DG Script #55701: Phase Armor - Start
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
wait(2)
local anti = "Anti-Paladin"
if not actor or not actor.can_be_seen then
    self:command("peer")
    self:say("I can't help you if I can't see you.")
    return _return_value
elseif not string.find(string.lower(classes), actor.class, 1, true) or (classes == anti and actor.class == "paladin") then
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
end$trig$, 'f1959f75c352a46702bd5efc8ac5ea30'),
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
elseif not string.find(string.lower(classes), actor.class, 1, true) or (classes == anti and actor.class == "paladin") then
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
end$trig$, '45049b1874f77113a36c7abab5223de7'),
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
    if not string.find(string.lower(classes), actor.class, 1, true) or (classes == anti and actor.class == "paladin") then
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
return _return_value$trig$, '133009f80071140ca7dab2b9a97d6490'),
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
elseif not string.find(string.lower(classes), actor.class, 1, true) or (classes == anti and actor.class == "paladin") then
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
end$trig$, 'a8cf610cb42ea8d500c640d48cf70ee2'),
  -- data/triggers/557/557_05_phase_armor_-_where.lua
  (557, 5, $trig$-- Converted from DG Script #55705: Phase Armor - Where
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
local anti = "Anti-Paladin"
local max_phase = 3
if not actor or not actor.can_be_seen then
    self:command("peer")
    self:say("I can't help you if I can't see you.")
    return true
elseif not string.find(string.lower(classes), actor.class, 1, true) or (classes == anti and actor.class == "paladin") then
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
end$trig$, '98afe9855dbee02f5ac41bb510e5f903'),
  -- data/triggers/564/564_00_hell_gate_diabolist_greet.lua
  (564, 0, $trig$wait(2)
local stage = actor:get_quest_stage("hell_gate")
if string.find(actor.class, "diabolist") and stage == 0 then
    self:command("bow " .. tostring(actor))
    self.room:send(tostring(self.name) .. " says, 'Welcome, dark disciple.")
    self.room:send("Has the hellish realm Garl'lixxil called you here as well?'")
elseif string.find(actor.class, "paladin") or string.find(actor.class, "priest") then
    self:say("You are not welcome here!")
    combat.engage(actor)
end
if stage == 1 then
    self:say("Have you found the spider-shaped dagger?")
elseif stage == 2 then
    self:say("Have you been able to locate the seven keys?")
elseif stage == 3 then
    self.room:send(tostring(self.name) .. " says, 'Ah, have you returned with the blood of the")
    self.room:send("sacrifices? <b:white>[Drop]</> it on the ground.'")
elseif stage == 4 then
    self:say("Give me the dagger to finish the rite.")
elseif stage == 5 then
    self:say("Quickly, slay Larathiel!")
end$trig$, '73b63898096db535288151ad3fb7f30c'),
  -- data/triggers/564/564_01_hell_gate_diabolist_speech1.lua
  (564, 1, $trig$-- Speech keyword: "yes"
if not string.find(string.lower(speech), "yes") then
    return true
end
wait(2)
if string.find(actor.class, "diabolist") and actor:get_quest_stage("hell_gate") == 0 then
    if actor.level > 80 then
        self.room:send(tostring(self.name) .. " says, 'Then it must be our fate to open the gates of")
        self.room:send("</>Hell together.  Come, <b:white>[enter]</> the <b:white>[circle]</> and join me.'")
    else
        self.room:send(tostring(self.name) .. " says, 'Interesting...")
        self.room:send("</>You are not yet strong enough to join me in my task.  Continue your journey'")
        self.room:send("</>and return when you are more experienced.'")
    end
elseif actor:get_quest_stage("hell_gate") > 0 then
    self:say("Let me see!")
end$trig$, 'ef34d02cb178aba055a6010e52d21d49'),
  -- data/triggers/564/564_02_hell_gate_diabolist_speech2.lua
  (564, 2, $trig$-- Speech keyword: "no"
if not string.find(string.lower(speech), "no") then
    return true
end
wait(2)
if string.find(actor.class, "diabolist") and actor:get_quest_stage("hell_gate") == 0 then
    self:say("Pity for you.  The demons must not think you worthy.")
elseif actor:get_quest_stage("hell_gate") > 0 then
    self:say("What are you waiting for?  Get to work!")
end$trig$, 'fa2ec46fdf294b19aa2d6a4701ccf211'),
  -- data/triggers/564/564_03_hell_gate_diabolist_command_enter.lua
  (564, 3, $trig$-- Command filter: enter
if cmd ~= "enter" then
    return true  -- Not our command, let it through unmodified
end

-- TODO(parity): Original DG had `case e: return 0` to let bare "enter"
-- abbreviations pass through unmodified; the Rust runtime's command
-- filter only fires on exact "enter" so that branch is unreachable.

if string.find(actor.class, "diabolist") and actor:get_quest_stage("hell_gate") == 0 then
    if arg == "c" or arg == "ci" or arg == "cir" or arg == "circ" or arg == "circl" or arg == "circle" then
        local priest = mobiles.template(564, 0).name
        if actor.level > 80 then
            actor:send("The circle of <red>fire</> burns hotly, enclosing you within.")
            self.room:send_except(actor, "The circle of <red>fire</> burns hotly, enclosing " .. tostring(actor.name) .. " within.")
            wait(1)
            self.room:send("A rumbling voice as deep as the pits of hell groans out of the fiery earth!")
            self.room:send("'<red>Delightful supplicants, I bid you welcome.  Open the door to Garl'lixxil and bring me to the world.  I will teach you powerful secrets so you may join me in slaughter.</>'")
            wait(5)
            self.room:send("'<red>To begin, find a dagger shaped like an arachnid.  You, " .. tostring(actor.name) .. ", shall seek it out and return here.  The other shall remain here and ensure the island is not disturbed.</>'")
            wait(4)
            self.room:send("The fires die down as the voice grows silent.")
            wait(3)
            actor:send(tostring(priest) .. " says, 'I will do my part.  I count on you to do yours.  If you need a reminder of your <b:cyan>[progress]</> you can ask me at any time.'")
            actor:start_quest("hell_gate")
        else
            actor:send("Your lack of experience prevents you from entering the circle of flames!")
            actor:send("</>")
            actor:send(tostring(priest) .. " says, 'Your will is strong but you lack knowledge.  Return after you have grown more.'")
        end
    else
        actor:send("There is no " .. tostring(arg) .. " here.")
    end
end
return true$trig$, '59edb2b988c61342727739211ce2def0'),
  -- data/triggers/580/580_02_charm_person_hinazuru_greet.lua
  (580, 2, $trig$local stage = actor:get_quest_stage("charm_person")
wait(2)
-- switch on stage
if stage == 1 then
    self:say("I see you have returned.")
    self:command("bow " .. tostring(actor.name))
    wait(1)
    self:say("Have you found " .. tostring(objects.template(480, 8).name) .. "?")
elseif stage == 2 then
    self:say("Welcome back.")
    self:command("bow " .. tostring(actor.name))
    wait(1)
    self:say("I hope you have been able to observe the methods of the troupe and return with a trophy.")
elseif stage == 3 then
    self:say("I am delighted to see you again.")
    self:command("bow " .. tostring(actor.name))
    wait(1)
    self:say("How is your search for the instruments coming along?  I truly look forward to hearing your tales.")
elseif stage == 4 then
    self.room:send(tostring(self.name) .. " says, 'Welcome back, I was not expecting to see you again so soon.  Are you having trouble locating your conversation partners?  I can update you on your <b:white>[spell progress]</> if you are.'")
else
    self:say("Welcome honored guest.")
    self:command("bow")
    wait(1)
    self:say("I am delighted to host you.")
    if (string.find(actor.class, "sorcerer") or string.find(actor.class, "illusionist") or string.find(actor.class, "bard")) and actor.level > 88 and stage == 0 then
        wait(1)
        self:say("You seem like you might be interested in some of my specialty services.")
    end
end$trig$, '1eb49e0ed46db552ae1a392df8556777'),
  -- data/triggers/580/580_03_charm_person_hinazuru_speech1.lua
  (580, 3, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"specialty", "services", "yes", "like", "what?", "services?", "speciality?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(actor.class, "sorcerer") or string.find(actor.class, "illusionist") or string.find(actor.class, "bard") then
    if actor.level > 88 then
        if actor:get_quest_stage("charm_person") == 0 then
            wait(2)
            self:say("I am not only a master of conversational and social arts, I am also highly trained in the mystic arts. Sorcerers and illusionists come from all across the world to learn my signature spell for charming others.")
            wait(2)
            self:say("If you are interested, I could teach you.  For a price.  100 platinum, at once, in advance, is my fee.")
        elseif actor:get_quest_stage("charm_person") == 1 then
            self:say("Marvelous!")
            wait(1)
            self:say("If you would be so kind as to give it to me, I can demonstrate its power.")
        end
    else
        self:say("Your determination is admirable, but I fear you still have some learning to do before I can teach you.")
    end
end$trig$, '37c903b820cadadab9ca570298631f2b'),
  -- data/triggers/580/580_04_charm_person_hinazuru_pay.lua
  (580, 4, $trig$if (string.find(actor.class, "sorcerer") or string.find(actor.class, "illusionist") or string.find(actor.class, "bard")) and actor.level > 88 and actor:get_quest_stage("charm_person") == 0 then
    actor:start_quest("charm_person")
    self:command("bow " .. tostring(actor.name))
    self:say("I give humble thanks for your payment.")
    wait(2)
    self:say("The first thing you will need is an implement which casts the spell you seek to learn so you may experiment with it.")
    wait(2)
    self:say("Only one such item exists in the world: a simple black metal rod buried in an extensive crypt in the Iron Hills.")
    wait(2)
    self:say("Please retrieve it and bring it back to me.")
    self:command("bow " .. tostring(actor.name))
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'During this training, if you need to check your <b:white>[spell progress]</>, you may ask at any time.'")
    self:command("bow " .. tostring(actor.name))
else
    self:say("I am deeply honored by your gratuity.")
    self:command("bow " .. tostring(actor.name))
end$trig$, '3de936ef15309838e513de316adf0d58'),
  -- data/triggers/584/584_12_dancer_quest_ask.lua
  (584, 12, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"hi", "help", "hello", "howdy", "quest"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if not actor.is_player then
    return true
end
if actor.level < 65 then
    return true
end
-- Already past stage 0 means they've already started or finished it.
if (actor:get_quest_stage("major_spell_quest") or 0) >= 1 then
    return true
end
if actor:get_has_completed("major_spell_quest") then
    return true
end

local class = tostring(actor.class)
local eligible = string.find(class, "sorcerer")
        or string.find(class, "cryomancer")
        or string.find(class, "pyromancer")

if eligible then
    wait(1)
    self:command("think")
    wait(1)
    actor:send(tostring(self.name) .. " says to you, 'I've been trapped here for so long.'")
    self:command("sigh")
    wait(1)
    actor:send(tostring(self.name) .. " says to you, 'The Prince has me enslaved against my will, will you help set me free?'")
    self:say("Yer a " .. class)
    actor:start_quest("major_spell_quest")
else
    self:command("grumble")
    self:say("Ok, I can talk, I swear " .. tostring(actor.name) .. " is a doofus.")
end$trig$, 'cf93a0143568beb953ffcf4a29f650a2'),
  -- data/triggers/586/586_01_dragons_health_myorrhed_speech.lua
  (586, 1, $trig$-- Speech keywords: egg, yes, no, why, procured, procure, task, value
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "egg") or string.find(speech_lower, "yes") or string.find(speech_lower, "no") or string.find(speech_lower, "why") or string.find(speech_lower, "procure") or string.find(speech_lower, "task") or string.find(speech_lower, "value")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("dragons_health") == 0 then
    wait(2)
    if string.find(speech, "egg?") or string.find(speech, "egg") then
        self:say("Yes, this egg here.")
        self:emote("gestures to the large bronze egg.")
        -- (empty room echo)
        self.room:send(tostring(self.name) .. " says, 'It's the last egg of the old bronze wyrm Dormynalth.")
        self.room:send("</>I am sworn to guard it until it hatches.'")
        -- (empty room echo)
        self:emote("utters a prayer of health and strength for the hatchling.")
        wait(5)
        if actor.level > 88 then
            if string.find(actor.class, "cleric") or string.find(actor.class, "priest") then
                self.room:send(tostring(self.name) .. " says, 'However, I could use some assistance from someone as capable")
                self.room:send("</>as you are.  If you're willing to help me, I can teach you a prayer to invoke")
                self.room:send("</>the health of dragons in exchange.'")
                wait(4)
                self:say("Are you interested?")
            end
        end
    elseif string.find(speech, "Yes") or string.find(speech, "yes?") then
        wait(2)
        if (string.find(actor.class, "cleric") or string.find(actor.class, "priest")) and actor.level > 88 then
            self:emote("smiles with gratitude.")
            actor:start_quest("dragons_health")
            wait(1)
            self:say("Good.  Allow me to explain the plan.")
            wait(2)
            self.room:send(tostring(self.name) .. " says, 'Dragon eggs like this one need the proper environment to grow")
            self.room:send("</>and develop.  Often this is a slow process, taking months or even years for")
            self.room:send("</>certain species.  But this process can be sped up by accumulating wealth into")
            self.room:send("</>a hoard for the unhatched dragon.'")
            wait(6)
            self.room:send(tostring(self.name) .. " says, 'You may be wondering <b:cyan>why</>.'")
        end
    end
elseif actor:get_quest_stage("dragons_health") == 1 then
    if string.find(speech, "why") or string.find(speech, "why?") then
        wait(2)
        self:say("Dragons love treasure.  This is well-known.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'On one level, they just love having it.  To many, all dragons,")
        self.room:send("</>good or evil, are personifications of greed.'")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'What many don't know is this love of treasure is more than")
        self.room:send("</>just habitual; it is instinctual.'")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'Dragons are compelled to hoard treasure because they draw")
        self.room:send("</>power directly from the <b:cyan>value</> of the artifacts they claim dominion over.'")
    elseif string.find(speech, "value") or string.find(speech, "value?") then
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'That value isn't always monetary.  Things imbued with precious")
        self.room:send("</>memories, little physical bits of ruins, even a plant that has been carried")
        self.room:send("</>from one land to another, all of that contributes to something's value.'")
        wait(2)
        self:say("And then of course there's the monetary value.")
        self:command("laugh")
        wait(6)
        self:say("We help the egg mature by increasing the value of its hoard.")
        wait(2)
        self.room:send(tostring(self.name) .. "'s eyes twinkle with mischief.")
        self.room:send(tostring(self.name) .. " says, 'It would be... valuable if you <b:cyan>\"procured\"</> a few items from the")
        self.room:send("</>hoards of chromatic dragons.'")
    elseif string.find(speech, "procured") or string.find(speech, "procured?") or string.find(speech, "procure") or string.find(speech, "procure?") then
        wait(2)
        self:say("Yes, that probably means you would have to slay them.")
        self:command("shrug")
        wait(5)
        self.room:send(tostring(self.name) .. " says, 'There is long-standing enmity between chromatic dragons, who")
        self.room:send("</>embody the abstract concepts of evil and maliciousness, and the metallic")
        self.room:send("</>dragons, who personify aloof goodness and righteousness.'")
        wait(5)
        self.room:send(tostring(self.name) .. " says, 'Fewer chromatic dragons means more space for metallic dragons.")
        self.room:send("</>To see if you're up to the <b:cyan>task</> though, let's start with something less")
        self.room:send("</>dangerous.'")
    elseif string.find(speech, "task") or string.find(speech, "task?") then
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'A young blue dragon has made a lair near the old tower west of")
        self.room:send("</>Anduin.  Bring back the crystal it keeps in its hoard for our hatchling.'")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'You may ask me about your <b:cyan>[progress]</> if you need a reminder.'")
    elseif string.find(speech, "No") or string.find(speech, "no?") then
        if (string.find(actor.class, "cleric") or string.find(actor.class, "priest")) and actor.level > 88 and actor:get_quest_stage("dragons_health") == 0 then
            self:say("That's alright.  We shall let nature take its course.")
            self:emote("gently pats the egg.")
        end
    end
end$trig$, 'e0e7e7ff47135c5af4754c7c9ed15367'),
  -- data/triggers/590/590_44_group_armor_forgemaster_greet.lua
  (590, 44, $trig$-- Converted from DG Script #59044: group_armor_forgemaster_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
local stage = actor:get_quest_stage("group_armor")
if ((string.find(actor.class, "cleric") and actor.level > 72) or (string.find(actor.class, "priest") and actor.level > 56)) and stage == 0 then
    self.room:send(tostring(self.name) .. " says, 'Well hello and welcome to the Sacred Haven's forge!")
    self.room:send("</>My name's Galen, son of Thorgrim, of the clan Grugnir.  I'm the resident")
    self.room:send("</>Forgemaster of the Sacred Haven.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'I'm working to prepare the paladins of the Haven")
    self.room:send("</>for their campaign against the evil races staking out Bluebonnet Pass by")
    self.room:send("</>forging an icon that will cast Group Armor.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Are you interested in helping out?'")
    -- (empty room echo)
    self.room:send(tostring(self.name) .. " says, 'You'll be able to learn the spell for yourself in the")
    self.room:send("</>process.'")
elseif stage == 1 then
    self:say("Have you returned with items that cast armor?")
elseif stage == 2 then
    self:say("I hope you've sourced a new forging hammer!")
elseif stage == 3 or stage == 4 then
    self:say("Any luck communing with the spirits of the forge?")
elseif stage == 5 then
    self:say("How goes the search for a protective amulet?")
elseif stage == 6 then
    self.room:send(tostring(self.name) .. " says, 'Welcome back!  I see the ghosts haven't eaten you yet!")
    self.room:send("</>Have you brought any ethereal armor?'")
end$trig$, 'f396ea81d1c200862334fa6f805c6ab2'),
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
if (string.find(actor.class, "cleric") and actor.level > 72) or (string.find(actor.class, "priest") and actor.level > 56) then
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
elseif (string.find(actor.class, "cleric") and actor.level < 72) or (string.find(actor.class, "priest") and actor.level < 56) then
    self.room:send(tostring(self.name) .. " says, 'I don't think you're quite ready to be a forge")
    self.room:send("</>acolyte yet.'")
    self:command("laugh")
    actor:send(tostring(self.name) .. " claps you on the back with his mighty hand!")
    self.room:send_except(actor, tostring(self.name) .. " claps " .. tostring(actor.name) .. " on the back with his mighty hand.")
elseif actor.class ~= "cleric" or actor.class ~= "priest" then
    self.room:send(tostring(self.name) .. " says, 'You may wish to prove your worth but I can only")
    self.room:send("</>work with those dedicated to divinity.'")
end$trig$, '0459f408834ad461d41a69c9c866e0c6'),
  -- data/triggers/615/615_51_creeping_doom_pixie_greet.lua
  (615, 51, $trig$-- Converted from DG Script #61551: creeping_doom_pixie_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
if string.find(actor.class, "druid") then
    if actor.level > 80 then
        if actor:get_quest_stage("creeping_doom") == 0 then
            self:emote("grumbles about pathetic mortals ruining the world.")
            self:say("Oh what's this?")
            self:command("peer " .. tostring(actor))
            wait(1)
            self:say("A servant of Nature!")
            wait(2)
            self:say("And a powerful one at that!")
            wait(1)
            self.room:send(tostring(self.name) .. " says, 'You!")
            self.room:send("</>You can help us remind the mortals how to treat the majesty of Nature!'")
        elseif actor:get_quest_stage("creeping_doom") == 5 then
            actor:send(tostring(self.name) .. " rushes to congratulate you!")
            wait(1)
            self.room:send(tostring(self.name) .. " says, 'The forest sings of your deed!  Raining doom down on")
            self.room:send("</>that place of genocide has restored balance to part of the Black Woods.'")
            wait(2)
            self.room:send(tostring(self.name) .. " says, 'You earned the right to be called Nature's Avenger")
            self.room:send("</>and the power that brings.'")
            wait(2)
            skills.set_level(actor, "creeping doom", 1000)
            actor:send("<blue>&9The nightmare of the Deep Dreaming touches your soul!")
            actor:send("You have mastered</> <red>Creeping <green>Doom<blue>&9!</>")
            actor:complete_quest("creeping_doom")
        elseif actor:get_quest_stage("creeping_doom") == 4 then
            self.room:send(tostring(self.name) .. " says, 'Is everything alright?")
            self.room:send("</>Do you need another seed?'")
        elseif actor:get_has_completed("creeping_doom") then
            self:say("Welcome back Avenger.")
        else
            self:say("Welcome back Dreamer.")
        end
    else
        self:say("Oh what's this?")
        self:command("peer " .. tostring(actor))
        wait(1)
        self:say("A servant of Nature!")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'You certainly have promise.  But you're too")
        self.room:send("</>inexperienced to act as Nature's Avenger.  Come back when you're ready for the")
        self.room:send("</>darkest of dreams.'")
    end
end$trig$, '85e2babb8aa3aeb78996cdba5818c3b3'),
  -- data/triggers/615/615_52_creeping_doom_pixie_speech.lua
  (615, 52, $trig$-- Converted from DG Script #61552: creeping_doom_pixie_speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
wait(2)
if string.find(actor.class, "druid") and actor:get_quest_stage("creeping_doom") == 0 and actor.level > 80 then
    self:command("grin")
    actor:start_quest("creeping_doom")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'This spell sends a carpet of living death made out of")
    self.room:send("</>Nature's Rage and Doom at your enemies and makes it EAT THEIR FACES OFF.  It's")
    self.room:send("</>unbridled and horrible, but needs very careful preparation.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'First, we choose violence and find symbols of")
    self.room:send("</>Nature's Rage.'")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Bring back a <green>cutting of the deadly vines</> on Mist")
    self.room:send("</>Mountain.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Also, bring a <red>ruby scarab</> and a <b:green>ceramic green spider</>'")
    self.room:send("</>because bug foci are sweet.'")
    -- (empty room echo)
    self:say("Both're in different monuments to the dead.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'If you need, you can check your <b:white>[progress]</> with me.'")
elseif actor:get_quest_stage("creeping_doom") == 4 then
    if actor:has_item(615, 18) then
        actor:send("<b:green>You already have " .. tostring(objects.template(615, 18).name) .. "!</>")
    else
        self.room:spawn_object(615, 18)
        self:command("give essence-natures-vengeance " .. tostring(actor.name))
        self:say("Be careful with it this time!")
    end
end$trig$, 'd19c4fb16d6171516ba14a2075442ada'),
  -- data/triggers/615/615_57_creeping_doom_pixie_speech2.lua
  (615, 57, $trig$-- Converted from DG Script #61557: creeping_doom_pixie_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: vengeance revenge avenger vessel? Abuses? vengeance? revenge? avenger? vessel abuses
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "vengeance") or string.find(string.lower(speech), "revenge") or string.find(string.lower(speech), "avenger") or string.find(string.lower(speech), "vessel?") or string.find(string.lower(speech), "abuses?") or string.find(string.lower(speech), "vengeance?") or string.find(string.lower(speech), "revenge?") or string.find(string.lower(speech), "avenger?") or string.find(string.lower(speech), "vessel") or string.find(string.lower(speech), "abuses")) then
    return true  -- No matching keywords
end
wait(2)
self.room:send(tostring(self.name) .. " says, 'Yes, we need a powerful priest of Nature to be our")
self.room:send("</>avenging avatar!'")
wait(2)
if string.find(actor.class, "druid") then
    if actor.level > 80 then
        self:say("Will you be our vessel?")
    else
        self:say("Come back after your power has grown some more.")
    end
end$trig$, '96924a66d1cc4b581cdd92c226889f04'),
  -- data/triggers/615/615_58_creeping_doom_pixie_speech3.lua
  (615, 58, $trig$-- Converted from DG Script #61558: creeping_doom_pixie_speech3
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: nature majesty treat remind nature? majesty? treat? remind?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "nature") or string.find(string.lower(speech), "majesty") or string.find(string.lower(speech), "treat") or string.find(string.lower(speech), "remind") or string.find(string.lower(speech), "nature?") or string.find(string.lower(speech), "majesty?") or string.find(string.lower(speech), "treat?") or string.find(string.lower(speech), "remind?")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "druid") then
    if actor.level > 80 then
        if actor:get_quest_stage("creeping_doom") == 0 then
            wait(2)
            self.room:send(tostring(self.name) .. " says, 'They have lost their respect for Nature and us,")
            self.room:send("</>its fey emissaries.  They slaughter our families like pigs.  They burn the")
            self.room:send("</>forests and overhunt the fields.'")
            wait(4)
            self.room:send(tostring(self.name) .. " says, 'They no longer fear us.")
            self.room:send("</>We who come for their children in the night.")
            self.room:send("</>We who bring nightmares to generations.")
            self.room:send("</>We who dream a Dream they should pray we never awaken from.'")
            wait(2)
            self:say("They have forgotten.")
            wait(4)
            self:say("We will make them remember.")
        end
    end
end$trig$, 'e8100ce180704ef7a9aa318ece207855'),
  -- data/triggers/615/615_59_creeping_doom_pixie_speech4.lua
  (615, 59, $trig$-- Converted from DG Script #61559: creeping_doom_pixie_speech4
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: remember remember? how how? forgotten forgotten?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "remember") or string.find(string.lower(speech), "remember?") or string.find(string.lower(speech), "how") or string.find(string.lower(speech), "how?") or string.find(string.lower(speech), "forgotten") or string.find(string.lower(speech), "forgotten?")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "druid") then
    if actor.level > 80 then
        if actor:get_quest_stage("creeping_doom") == 0 then
            self:say("I can teach you the power from Nature's darkest of")
            self.room:send("'dreams, Creeping Doom.'")
            wait(3)
            self:say("Use it to annihilate those who would defile the")
            self.room:send("'natural order.'")
            wait(3)
            self:say("Are you ready to be our avenger?")
        end
    end
end$trig$, 'c5d218c4e190268d717e4f38576d7282')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
