-- Trigger: Priest_Paladin_Subclass_Quest_Silania_Status
-- Zone: 185, ID: 9
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--
-- Original DG Script: #18509

-- Converted from DG Script #18509: Priest_Paladin_Subclass_Quest_Silania_Status
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
wait(2)
-- switch on actor:get_quest_stage("pri_pal_subclass")
if actor:get_quest_stage("pri_pal_subclass") == 1 then
    actor:send(tostring(self.name) .. " says, 'You want to join the holy ranks of priests and paladins.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'It is necessary to make a quest such as this quite tough to ensure you really want to do this.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I am sure you will complete the <b:cyan>quest</> though.'")
elseif actor:get_quest_stage("pri_pal_subclass") == 2 then
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
elseif actor:get_quest_stage("pri_pal_subclass") == 3 then
    actor:send(tostring(self.name) .. " says, 'Have you found the bronze chalice the diabolists stole?'")
else
    if string.find(actor.class, "Cleric") then
        -- switch on actor.race
        if actor.level >= 10 and actor.level <= 35 then
            if actor.race == "drow" or actor.race == "faerie_unseelie" then
                actor:send("<red>Your race may not subclass to priest.</>")
                return _return_value
            end
        else
            local check = "yes"
        end
    elseif string.find(actor.class, "Warrior") then
        -- switch on actor.race
        if actor.level >= 10 and actor.level <= 25 then
            if actor.race == "drow" or actor.race == "faerie_unseelie" then
                actor:send("<red>Your race may not subclass to paladin.</>")
                return _return_value
            end
        else
            local check = "yes"
        end
    end
    if check == "yes" then
        if (string.find(actor.class, "Warrior") and actor.level >= 10 and actor.level <= 25) or (string.find(actor.class, "Cleric") and actor.level >= 10 and actor.level <= 35) then
            actor:send(tostring(self.name) .. " says, 'You are not working to join the holy order.'")
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'I appreciate your aspiring virtue.  Come and see me once you've gained more experience.'")
        else
            actor:send(tostring(self.name) .. " says, 'You are already following your destiny.  I cannot help you any further.'")
        end
    end
end  -- auto-close block