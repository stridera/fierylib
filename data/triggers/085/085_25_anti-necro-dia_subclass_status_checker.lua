-- Trigger: Anti-Necro-Dia subclass status checker
-- Zone: 85, ID: 25
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--
-- Original DG Script: #8525

-- Converted from DG Script #8525: Anti-Necro-Dia subclass status checker
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: subclass progress
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "subclass") or string.find(string.lower(speech), "progress")) then
    return true  -- No matching keywords
end
-- switch on actor:get_quest_stage("nec_anti_dia_subclass")
if actor:get_quest_stage("nec_anti_dia_subclass") == 1 then
    actor:send(tostring(self.name) .. " says, 'So you come crawling back.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Only the most cunning and strong will complete the <magenta>quest</> I set before you.  I shall take great pleasure in your demise, but I will offer great rewards for your success.'")
elseif actor:get_quest_stage("nec_anti_dia_subclass") == 2 then
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
elseif actor:get_quest_stage("nec_anti_dia_subclass") == 3 or actor:get_quest_stage("nec_anti_dia_subclass") == 4 then
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
    if actor.alignment < -349 then
        if string.find(actor.class, "Warrior") and actor.level <= 25 then
            -- switch on actor.race
            if actor.race == "elf" or actor.race == "faerie_seelie" then
                local classgreet = "no"
            else
                local classgreet = "yes"
                local maxlevel = 25
            end
        elseif string.find(actor.class, "Cleric") and actor.level <= 35 then
            -- switch on actor.race
            if actor.race == "elf" or actor.race == "faerie_seelie" then
                local classgreet = "no"
            else
                local classgreet = "yes"
                local maxlevel = 35
            end
        elseif string.find(actor.class, "Sorcerer") and actor.level <= 45 then
            -- switch on actor.race
            if actor.race == "elf" or actor.race == "faerie_seelie" then
                local classgreet = "no"
            else
                local classgreet = "yes"
            end
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
end  -- auto-close block