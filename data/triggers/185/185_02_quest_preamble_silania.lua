-- Trigger: quest_preamble_silania
-- Zone: 185, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 14 if statements
--
-- Original DG Script: #18502

-- Converted from DG Script #18502: quest_preamble_silania
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: destiny destiny? destinies destinies? I
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "destiny") or string.find(string.lower(speech), "destiny?") or string.find(string.lower(speech), "destinies") or string.find(string.lower(speech), "destinies?") or string.find(string.lower(speech), "i")) then
    return true  -- No matching keywords
end
if (string.find(speech, "destiny") or string.find(speech, "destinies") or string.find(speech, "I")) and not actor:get_quest_stage("pri_pal_subclass") then
    if string.find(actor.class, "Cleric") then
        -- switch on actor.race
        if actor.level >= 10 and actor.level <= 35 then
            if actor.race == "drow" or actor.race == "faerie_unseelie" then
                actor:send("<red>Your race may not subclass to priest.</>")
                return _return_value
            end
        else
            local classquest = "yes"
        end
    elseif string.find(actor.class, "Warrior") then
        -- switch on actor.race
        if actor.level >= 10 and actor.level <= 25 then
            if actor.race == "drow" or actor.race == "faerie_unseelie" then
                actor:send("<red>Your race may not subclass to paladin.</>")
                return _return_value
            end
        else
            local classquest = "yes"
        end
    else
        if actor.level >= 10 and actor.level <= 25 then
            actor:send(tostring(self.name) .. " says, 'Sorry, I cannot help you achieve your destiny.'")
        end
    end
end
wait(2)
if classquest == "yes" then
    if use_subclass then
        actor:send(tostring(self.name) .. " says, 'I am currently helping another supplicant, one moment my child.''")
        return _return_value
    end
    if actor.alignment > 349 then
        if string.find(actor.class, "Warrior") and actor.level >= 10 and actor.level <= 25 then
            self:command("nod " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'Do ye wish to join the ranks of the holy warriors?'")
            local use_subclass = "Pal"
            globals.use_subclass = globals.use_subclass or true
        elseif string.find(actor.class, "Cleric") and actor.level >= 10 and actor.level <= 35 then
            self:command("nod " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'Do ye wish to join the ranks of the priests and help drive darkness from our world?'")
            local use_subclass = "Pri"
            globals.use_subclass = globals.use_subclass or true
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'I appreciate your aspiring virtue.  Come and see me once you've gained more experience.'")
        else
            actor:send(tostring(self.name) .. " says, 'You are already following your destiny.  I cannot help you any further.'")
        end
    else
        actor:send(tostring(self.name) .. " says, 'I cannot help you if you are not good, little one.'")
    end
end