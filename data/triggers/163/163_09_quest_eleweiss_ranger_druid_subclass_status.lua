-- Trigger: quest_eleweiss_ranger_druid_subclass_status
-- Zone: 163, ID: 9
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--
-- Original DG Script: #16309

-- Converted from DG Script #16309: quest_eleweiss_ranger_druid_subclass_status
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
local halfelf = "half-elf"
local stage = actor:get_quest_stage("ran_dru_subclass")
-- switch on stage
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
    if string.find(actor.class, "Cleric") then
        -- switch on actor.race
        -- case ADD NEW RESTRICTED RACES HERE
        -- if %actor.level% >= 10 && %actor.level% <= 35
        -- msend %actor% &1Your race may not subclass to druid.&0
        -- halt
        -- endif
        -- break
        if actor.level >= 10 and actor.level <= 35 then
            actor:send(tostring(self.name) .. " says, 'You are not on this quest.'")
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'Seek me again later when you have gained some more experience.'")
        else
            actor:send(tostring(self.name) .. " says, 'You have traveled too far on your current path to change your way.'")
        end
    elseif string.find(actor.class, "Warrior") then
        -- switch on actor.race
        -- case ADD NEW RESTRICTED RACES HERE
        -- if %actor.level% >= 10 && %actor.level% <= 25
        -- msend %actor% &1Your race may not subclass to ranger.&0
        -- halt
        -- endif
        -- break
        if actor.level >= 10 and actor.level <= 25 then
            actor:send(tostring(self.name) .. " says, 'You are not on this quest.'")
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'Seek me again later when you have gained some more experience.'")
        else
            actor:send(tostring(self.name) .. " says, 'You have traveled too far on your current path to change your way.'")
        end
    end
end  -- auto-close block