-- Trigger: quest_preamble_ziijhan
-- Zone: 85, ID: 1
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 18 if statements
--   Large script: 5047 chars
--
-- Original DG Script: #8501

-- Converted from DG Script #8501: quest_preamble_ziijhan
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: destiny destiny? destinies destinies? I
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "destiny") or string.find(string.lower(speech), "destiny?") or string.find(string.lower(speech), "destinies") or string.find(string.lower(speech), "destinies?") or string.find(string.lower(speech), "i")) then
    return true  -- No matching keywords
end
if string.find(speech, "destiny") or string.find(speech, "destinies") or string.find(speech, "I") know then
    if not actor:get_quest_stage("nec_dia_ant_subclass") then
        if string.find(actor.class, "Warrior") then
            -- switch on actor.race
            if actor.level >= 10 and actor.level <= 25 then
                if actor.race == "elf" or actor.race == "faerie_seelie" then
                    actor:send("<red>Your race may not subclass to anti-paladin.</>")
                    return _return_value
                end
            else
                local classquest = 1
            end
        elseif string.find(actor.class, "Cleric") then
            -- switch on actor.race
            if actor.level >= 10 and actor.level <= 35 then
                if actor.race == "elf" or actor.race == "faerie_unseelie" then
                    actor:send("<red>Your race may not subclass to diabolist.</>")
                    return _return_value
                end
            else
                local classquest = 1
            end
        elseif string.find(actor.class, "Sorcerer") then
            -- switch on actor.race
            if actor.level >= 10 and actor.level <= 45 then
                if actor.race == "elf" or actor.race == "faerie_seelie" then
                    actor:send("<red>Your race may not subclass to necromancer.</>")
                    return _return_value
                end
            else
                local classquest = 1
            end
        else
            if actor.level >= 10 and actor.level <= 25 then
                actor:send(tostring(self.name) .. " says, 'Sorry, I cannot help you achieve your destiny.'")
            end
        end
        if classquest == 1 then
            wait(2)
            if use_subclass then
                actor:send(tostring(self.name) .. " says, 'Sorry little one.  I am already setting up one quest - come back in a moment.'")
                return _return_value
            end
            if actor.alignment < -349 then
                self:command("nod " .. tostring(actor.name))
                if string.find(actor.class, "Warrior") then
                    if actor.level >= 10 and actor.level <= 25 then
                        actor:send(tostring(self.name) .. " says, 'Do ye wish to join the ranks of the unholy warriors?'")
                        local use_subclass = "Ant"
                    elseif actor.level < 10 then
                        actor:send(tostring(self.name) .. " says, 'Strong thirst for slaughter for one so young.  Come back once you've gained some more experience.'")
                    else
                        actor:send(tostring(self.name) .. " says, 'You are already following your destiny.  I cannot help you any further.'")
                    end
                elseif string.find(actor.class, "Cleric") then
                    if actor.level >= 10 and actor.level <= 35 then
                        actor:send(tostring(self.name) .. " says, 'Do ye wish to join the ranks of the diabolists and derive power from madness and darkness?'")
                        local use_subclass = "Dia"
                        actor:send(tostring(self.name) .. " says, 'Strong thirst for madness for one so young.  Come back once you've gained some more experience.'")
                    else
                        actor:send(tostring(self.name) .. " says, 'You are already following your destiny.  I cannot help you any further.'")
                    end
                elseif string.find(actor.class, "Sorcerer") then
                    if actor.level >= 10 and actor.level <= 45 then
                        actor:send(tostring(self.name) .. " says, 'Do ye wish to join the ranks of the necromancers and have power over death?'")
                        local use_subclass = "Nec"
                    elseif actor.level < 10 then
                        actor:send(tostring(self.name) .. " says, 'Strong thirst for death for one so young.  Come back once you've gained some more experience.'")
                    else
                        actor:send(tostring(self.name) .. " says, 'You are already following your destiny.  I cannot help you any further.'")
                    end
                end
                globals.use_subclass = globals.use_subclass or true
            else
                actor:send(tostring(self.name) .. " says, 'Begone, fool.  You are far too righteous to join our brotherhood.'")
            end
        end
    end
end  -- auto-close block