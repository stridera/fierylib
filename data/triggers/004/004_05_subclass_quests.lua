-- Trigger: Subclass quests
-- Zone: 4, ID: 5
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 22 if statements
--   Large script: 8298 chars
--
-- Original DG Script: #405

-- Converted from DG Script #405: Subclass quests
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "subclass") then
    _return_value = false
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
    actor:send("<yellow>=========== SUBCLASS QUESTS ===========</>")
    if (string.find(actor.class, "cleric") and actor.level < 35) or (string.find(actor.class, "sorcerer") and actor.level < 45) or ((string.find(actor.class, "warrior") or string.find(actor.class, "rogue")) and actor.level < 25) then
        actor:send("Subclass quests involve finding a specific quest master and performing some kind of special deed.")
        actor:send("Eligibility for subclasses depends on your base class, your race, and your alignment.")
        actor:send("Characters must be at least level 10 to subclass._")
        actor:send("A character may only ever undertake a single subclass quest.")
        actor:send("Once a subclass quest has begun, it is not possible to start a different one.")
        actor:send("<yellow>=======================================</>_")
        actor:send("<b:green>AVAILABLE QUESTS:</>")
        if actor:get_quest_var("nec_dia_ant_subclass:subclass_name") == "Nec" then
            actor:send("- &9<blue>Necromancer</>")
            local status = "running"
        elseif actor:get_quest_var("nec_dia_ant_subclass:subclass_name") == "Diabolist" then
            actor:send("- <magenta>Diabolist</>")
            local status = "running"
        elseif actor:get_quest_var("nec_dia_ant_subclass:subclass_name") == "anti" then
            actor:send("- <b:red>Anti-Paladin</>")
            local status = "running"
        elseif actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "Mercernary" then
            actor:send("- &9<blue>Mercenary</>")
            local status = "running"
        elseif actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "Assassin" then
            actor:send("- <red>Assassin</>")
            local status = "running"
        elseif actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "Thief" then
            actor:send("- <b:red>Thief</>")
            local status = "running"
        elseif actor:get_quest_var("pri_pal_subclass:subclass_name") == "Priest" then
            actor:send("- <b:cyan>Priest</>")
            local status = "running"
        elseif actor:get_quest_var("pri_pal_subclass:subclass_name") == "Paladin" then
            actor:send("- <b:white>Paladin</>")
            local status = "running"
        elseif actor:get_quest_var("ran_dru_subclass:subclass_name") == "Ranger" then
            actor:send("- <b:green>Ranger</>")
            local status = "running"
        elseif actor:get_quest_var("ran_dru_subclass:subclass_name") == "Druid" then
            actor:send("- <green>Druid</>")
            local status = "running"
        elseif actor:get_quest_stage("monk_subclass") then
            actor:send("- <yellow>Monk</>")
            local status = "running"
        elseif actor:get_quest_stage("pyromancer_subclass") then
            actor:send("- <b:red>Pyromancer</>")
            local status = "running"
        elseif actor:get_quest_stage("cryomancer_subclass") then
            actor:send("- <b:blue>Cryomancer</>")
            local status = "running"
        elseif actor:get_quest_stage("illusionist_subclass") then
            actor:send("- <b:magenta>Illusionist</>")
            local status = "running"
        elseif actor:get_quest_stage("bard_subclass") then
            actor:send("- <b:magenta>Bard</>")
            local status = "running"
        elseif actor:get_quest_stage("berserker_subclass") then
            actor:send("- &9<blue>Berserker</>")
            local status = "running"
        else
            if string.find(actor.class, "Sorcerer") then
                if not (string.find(cryoraces, "actor.race")) then
                    actor:send("- <b:blue>Cryomancer</>_")
                end
                if not (string.find(illusionraces, "actor.race")) then
                    actor:send("- <b:magenta>Illusionist</>_")
                end
                if not (string.find(necromancerraces, "actor.race")) then
                    actor:send("- &9<blue>Necromancer</>")
                    actor:send("</>   <cyan>(This class is for evil characters only)</>_")
                end
                if not (string.find(pyroraces, "actor.race")) then
                    actor:send("- <b:red>Pyromancer</>_")
                end
            elseif string.find(actor.class, "Cleric") then
                if not (string.find(diabolistraces, "actor.race")) then
                    actor:send("- <magenta>Diabolist</>")
                    actor:send("</>   <cyan>(This class is for evil characters only)</>_")
                end
                if not (string.find(druidraces, "actor.race")) then
                    actor:send("- <green>Druid</>")
                    actor:send("</>   <cyan>(This class is for neutral characters only)</>_")
                end
                if not (string.find(priestraces, "actor.race")) then
                    actor:send("- <b:cyan>Priest</>")
                    actor:send("</>   <cyan>(This class is for good characters only)</>_")
                end
            elseif string.find(actor.class, "Rogue") then
                if not (string.find(assassinraces, "actor.race")) then
                    actor:send("- <red>Assassin</>")
                    actor:send("</>   <cyan>(This class is for evil characters only)</>_")
                end
                if not (string.find(bardraces, "actor.race")) then
                    actor:send("- <b:magenta>Bard</>_")
                end
                if not (string.find(mercenaryraces, "actor.race")) then
                    actor:send("- &9<blue>Mercenary</>_")
                end
                if not (string.find(thiefraces, "actor.race")) then
                    actor:send("- <b:red>Thief</>_")
                end
            elseif string.find(actor.class, "Warrior") then
                if not (string.find(antipaladinraces, "actor.race")) then
                    actor:send("- <b:red>Anti-Paladin</>")
                    actor:send("</>   <cyan>(This class is for evil characters only)</>_")
                end
                if not (string.find(berserkerraces, "actor.race")) then
                    actor:send("- &9<blue>Berserker</>_")
                end
                if not (string.find(monkraces, "actor.race")) then
                    actor:send("- <yellow>Monk</>_")
                end
                if not (string.find(paladinraces, "actor.race")) then
                    actor:send("- <b:white>Paladin</>")
                    actor:send("</>   <cyan>(This class is for good characters only)</>_")
                end
                if not (string.find(rangerraces, "actor.race")) then
                    actor:send("- <b:green>Ranger</>")
                    actor:send("</>   <cyan>(This class is for good characters only)</>_")
                end
            end
        end
        if status == "running" then
            actor:send("<cyan>Status: In Progress</>_")
        end
    else
        if string.find(actor.class, "Warrior") or string.find(actor.class, "Cleric") or string.find(actor.class, "Sorcerer") or string.find(actor.class, "Rogue") then
            actor:send("You have no subclass quests available.")
        else
            actor:send("You have already completed the quest to subclass to " .. tostring(actor.class) .. ".")
        end
    end
end
return _return_value