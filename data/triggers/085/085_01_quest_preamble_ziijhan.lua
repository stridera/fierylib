-- Trigger: quest_preamble_ziijhan
-- Zone: 85, ID: 1
-- Type: MOB, Flags: SPEECH
--
-- Player asks Ziijhan about destiny / I know my destiny. Validates class,
-- race and level eligibility for ant/dia/nec subclassing, then offers the
-- appropriate subclass quest if the player's alignment is dark enough.
--
-- Original DG Script: #8501

-- Converted from DG Script #8501: quest_preamble_ziijhan
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"destiny", "destinies", "i know"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("nec_dia_ant_subclass") > 0 then
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

wait(0.2)
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
return true