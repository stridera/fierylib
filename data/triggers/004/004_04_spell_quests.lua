-- Trigger: Spell quests
-- Zone: 4, ID: 4
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 79 if statements
--   Large script: 22953 chars
--
-- Original DG Script: #404

-- Converted from DG Script #404: Spell quests
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "spell") or string.find(arg, "spells") or string.find(arg, "chant") or string.find(arg, "chants") or string.find(arg, "song") or string.find(arg, "songs") or string.find(arg, "music") then
    _return_value = false
    local relocateclasses = "Sorcerer Cryomancer Pyromancer"
    local spellquestclasses = "Ranger Druid Sorcerer Illusionist Cryomancer Pyromancer Diabolist Cleric Priest Bard Necromancer Monk"
    actor:send("<yellow>==== SPELL, CHANT, AND SONG QUESTS ====</>")
    if string.find(spellquestclasses, "actor.class") then
        actor:send("<b:yellow>[Look]</> at the key words in a quest title for your current status.")
        actor:send("<yellow>=======================================</>_")
        actor:send("<b:green>AVAILABLE QUESTS:</>_")
        if actor.level >= 30 then
            if string.find(actor.class, "Monk") then
                actor:send("<b:green>&uTremors of Saint Augustine</>")
                actor:send("Minimum Level: 30")
                if actor:get_quest_stage("monk_chants") > 1 then
                    local status = "Completed!"
                elseif actor:get_quest_stage("monk_chants") == 1 then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
                actor:send("<b:green>&uTempest of Saint Augustine</>")
                actor:send("Minimum Level: 40")
                if actor:get_quest_stage("monk_chants") > 2 then
                    local status = "Completed!"
                elseif actor:get_quest_stage("monk_chants") == 2 then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
                actor:send("<b:green>&uBlizzards of Saint Augustine</>")
                actor:send("Minimum Level: 50")
                if actor:get_quest_stage("monk_chants") > 3 then
                    local status = "Completed!"
                elseif actor:get_quest_stage("monk_chants") == 3 then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(relocateclasses, "actor.class") then
                actor:send("<b:green>&uMajor Globe</>")
                actor:send("Minimum Level: 57")
                if actor:get_has_completed("major_globe_spell") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("major_globe_spell") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Priest") or string.find(actor.class, "Cleric") or string.find(actor.class, "Diabolist") then
                actor:send("<b:green>&uGroup Heal</>")
                actor:send("Minimum Level: 57")
                if actor:get_has_completed("group_heal") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("group_heal") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Priest") then
                actor:send("<b:green>&uGroup Armor</>")
                actor:send("Minimum Level: 57")
                if actor:get_has_completed("group_armor") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("group_armor") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Cryomancer") then
                actor:send("<b:green>&uWall of Ice</>")
                actor:send("Minimum Level: 57")
                if actor:get_has_completed("wall_ice") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("wall_ice") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Illusionist") or string.find(actor.class, "Bard") then
                actor:send("<b:green>&uIllusory Wall</>")
                actor:send("Minimum Level: 57")
                if actor:get_has_completed("illusory_wall") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("illusory_wall") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Diabolist") then
                actor:send("<b:green>&uHellfire and Brimstone&")
                actor:send("Minimum Level: 57")
                if actor:get_has_completed("hellfire_brimstone") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("hellfire_brimstone") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Monk") then
                actor:send("<b:green>&uAria of Dissonance</>")
                actor:send("Minimum Level: 60")
                if actor:get_quest_stage("monk_chants") > 4 then
                    local status = "Completed!"
                elseif actor:get_quest_stage("monk_chants") == 4 then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
        end
        if actor.level >= 60 then
            if string.find(relocateclasses, "actor.class") then
                actor:send("<b:green>&uRelocate</>")
                actor:send("Minimum Level: 65")
                if actor:get_has_completed("relocate_spell_quest") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("relocate_spell_quest") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Priest") or string.find(actor.class, "Diabolist") then
                actor:send("<b:green>&uBanish</>")
                actor:send("Minimum Level: 65")
                if actor:get_has_completed("banish") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("banish") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
        end
        if actor.level >= 65 then
            if string.find(actor.class, "Bard") then
                actor:send("<b:green>&uHearthsong</>")
                actor:send("Minimum Level: 70")
                actor:send("Note: This chant must be granted directly by the gods and cannot be tracked in the quest journal._")
            end
            if string.find(actor.class, "Cleric") then
                actor:send("<b:green>&uGroup Armor</>")
                actor:send("Minimum Level: 73")
                if actor:get_has_completed("group_armor") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("group_armor") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
                actor:send("<b:green>&uGroup Recall</>")
                actor:send("Minimum Level: 73")
                actor:send("Note: This chant must be granted directly by the gods and cannot be tracked in the quest journal._")
            end
            if string.find(actor.class, "Druid") then
                actor:send("<b:green>&uMoonwell</>")
                actor:send("Minimum Level: 73")
                if actor:get_has_completed("moonwell_spell_quest") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("moonwell_spell_quest") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Sorcerer") then
                actor:send("<b:green>&uMeteorswarm</>")
                actor:send("Minimum Level: 73")
                if actor:get_has_completed("meteorswarm") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("meteorswarm") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Bard") then
                actor:send("<b:green>&uMajor Paralysis</>")
                actor:send("Minimum Level: 73")
                actor:send("Note: This chant must be granted directly by the gods and cannot be tracked in the quest journal._")
            end
            if string.find(actor.class, "diabolist") or string.find(actor.class, "Priest") then
                actor:send("<b:green>&uWord of Command</>")
                if actor:get_has_completed("word_command") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("word_command") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Cryomancer") then
                actor:send("<b:green>&uWaterform</>")
                actor:send("Minimum Level: 73")
                if actor:get_has_completed("waterform") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("waterform") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Monk") then
                actor:send("<b:green>&uApocalyptic Anthem</>")
                actor:send("Minimum Level: 75")
                if actor:get_quest_stage("monk_chants") > 5 then
                    local status = "Completed!"
                elseif actor:get_quest_stage("monk_chants") == 5 then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
        end
        if actor.level >= 75 then
            if string.find(actor.class, "Bard") then
                actor:send("<b:green>&uCrown of Madness</>")
                actor:send("Minimum Level: 80")
                actor:send("Note: This chant must be granted directly by the gods and cannot be tracked in the quest journal._")
            end
            if string.find(actor.class, "Monk") then
                actor:send("<b:green>&uFires of Saint Augustine</>")
                actor:send("Minimum Level: 80")
                if actor:get_quest_stage("monk_chants") > 6 then
                    local status = "Completed!"
                elseif actor:get_quest_stage("monk_chants") == 6 then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Ranger") then
                actor:send("<b:green>&uBlur</>")
                actor:send("Minimum Level: 81")
                if actor:get_has_completed("blur") then
                    local status = "Completed!"
                elseif actor:get_has_failed("blur") then
                    local status = "Failed"
                elseif actor:get_quest_stage("blur") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Druid") then
                actor:send("<b:green>&uCreeping Doom</>")
                actor:send("Minimum Level: 81")
                if actor:get_has_completed("creeping_doom") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("creeping_doom") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Necromancer") then
                actor:send("<b:green>&uDegeneration</>")
                actor:send("Minimum Level: 81")
                if actor:get_has_completed("degeneration") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("degeneration") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Cryomancer") then
                actor:send("<b:green>&uFlood</>")
                actor:send("Minimum Level: 81")
                if actor:get_has_completed("flood") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("flood") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Priest") then
                actor:send("<b:green>&uHeavens Gate</>")
                actor:send("Minimum Level: 81")
                if actor:get_has_completed("heavens_gate") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("heavens_gate") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Diabolist") then
                actor:send("<b:green>&uHell Gate</>")
                actor:send("Minimum Level: 81")
                if actor:get_has_completed("hell_gate") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("hell_gate") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Pyromancer") then
                actor:send("<b:green>&uMeteorswarm</>")
                actor:send("Minimum Level: 81")
                if actor:get_has_completed("meteorswarm") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("meteorswarm") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Cleric") or string.find(actor.class, "Priest") or string.find(actor.class, "Diabolist") then
                actor:send("<b:green>&uResurrection</>")
                actor:send("Minimum Level: 81")
                if actor:get_has_completed("resurrection_quest") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("resurrection_quest") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Sorcerer") then
                actor:send("<b:green>&uWizard Eye</>")
                actor:send("Minimum Level: 81")
                if actor:get_has_completed("wizard_eye") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("wizard_eye") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
        end
        if actor.level >= 85 then
            if string.find(actor.class, "Sorcerer") or string.find(actor.class, "Bard") or string.find(actor.class, "Illusionist") then
                actor:send("<b:green>&uCharm Person</>")
                actor:send("Minimum Level: 89")
                if actor:get_has_completed("charm_person") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("charm_person") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Cleric") or string.find(actor.class, "Priest") then
                actor:send("<b:green>&uDragons Health</>")
                actor:send("Minimum Level: 89")
                if actor:get_has_completed("dragons_health") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("dragons_health") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Ranger") then
                actor:send("<b:green>&uGreater Displacement</>")
                actor:send("Minimum Level: 89")
                actor:send("Note: This chant must be granted directly by the gods and cannot be tracked in the quest journal._")
            end
            if string.find(actor.class, "Cryomancer") then
                actor:send("<b:green>&uIce Shards</>")
                actor:send("Minimum Level: 89")
                if actor:get_has_completed("ice_shards") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("ice_shards") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Pyromancer") then
                actor:send("<b:green>&uSupernova</>")
                actor:send("Minimum Level: 89")
                if actor:get_has_completed("supernova") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("supernova") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Bard") then
                actor:send("<b:green>&uEnrapture</>")
                actor:send("Minimum Level: 90")
                actor:send("Note: This chant must be granted directly by the gods and cannot be tracked in the quest journal._")
            end
        end
        if actor.level >= 90 then
            if string.find(actor.class, "Necromancer") then
                actor:send("<b:green>&uShift Corpse</>")
                actor:send("Minimum Level: 97")
                if actor:get_has_completed("shift_corpse") then
                    local status = "Completed!"
                elseif actor:get_quest_stage("shift_corpse") then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
            if string.find(actor.class, "Monk") then
                actor:send("<b:green>&uSeed of Destruction</>")
                actor:send("Minimum Level: 99")
                if actor:get_quest_stage("monk_chants") > 7 then
                    local status = "Completed!"
                elseif actor:get_quest_stage("monk_chants") == 7 then
                    local status = "In Progress"
                else
                    local status = "Not Started"
                end
                actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            end
        end
    else
        actor:send("There are no spell, song, or chant quests available for " .. tostring(actor.class) .. " characters._")
        actor:send("<yellow>=======================================</>")
    end
end
return _return_value