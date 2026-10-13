-- Trigger: Spell quests
-- Zone: 4, ID: 4
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #404

-- Converted from DG Script #404: Spell quests
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
                elseif actor:get_quest_stage("major_globe_spell") > 0 then
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
                elseif actor:get_quest_stage("group_heal") > 0 then
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
                elseif actor:get_quest_stage("group_armor") > 0 then
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
                elseif actor:get_quest_stage("wall_ice") > 0 then
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
                elseif actor:get_quest_stage("illusory_wall") > 0 then
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
                elseif actor:get_quest_stage("hellfire_brimstone") > 0 then
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
                elseif actor:get_quest_stage("relocate_spell_quest") > 0 then
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
                elseif actor:get_quest_stage("banish") > 0 then
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
                elseif actor:get_quest_stage("group_armor") > 0 then
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
                elseif actor:get_quest_stage("moonwell_spell_quest") > 0 then
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
                elseif actor:get_quest_stage("meteorswarm") > 0 then
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
                elseif actor:get_quest_stage("word_command") > 0 then
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
                elseif actor:get_quest_stage("waterform") > 0 then
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
                elseif actor:get_quest_stage("blur") > 0 then
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
                elseif actor:get_quest_stage("creeping_doom") > 0 then
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
                elseif actor:get_quest_stage("degeneration") > 0 then
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
                elseif actor:get_quest_stage("flood") > 0 then
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
                elseif actor:get_quest_stage("heavens_gate") > 0 then
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
                elseif actor:get_quest_stage("hell_gate") > 0 then
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
                elseif actor:get_quest_stage("meteorswarm") > 0 then
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
                elseif actor:get_quest_stage("resurrection_quest") > 0 then
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
                elseif actor:get_quest_stage("wizard_eye") > 0 then
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
                elseif actor:get_quest_stage("charm_person") > 0 then
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
                elseif actor:get_quest_stage("dragons_health") > 0 then
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
                elseif actor:get_quest_stage("ice_shards") > 0 then
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
                elseif actor:get_quest_stage("supernova") > 0 then
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
                elseif actor:get_quest_stage("shift_corpse") > 0 then
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
return _return_value