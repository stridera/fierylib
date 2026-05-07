-- Trigger: quest_eleweiss_ranger_druid_subclass_status
-- Zone: 163, ID: 9
-- Type: MOB, Flags: SPEECH
--
-- Original DG Script: #16309
-- Probability: 0% (disabled in source data; data-layer probability gate handles activation)
--
-- Player asks Eleweiss for "subclass progress" — replays the stage-appropriate
-- prompt, or scolds them off if they're not eligible at all.

local sl = string.lower(speech)
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
    if string.find(actor.class, "Cleric") then
        if actor.level >= 10 and actor.level <= 35 then
            actor:send(tostring(self.name) .. " says, 'You are not on this quest.'")
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'Seek me again later when you have gained some more experience.'")
        else
            actor:send(tostring(self.name) .. " says, 'You have traveled too far on your current path to change your way.'")
        end
    elseif string.find(actor.class, "Warrior") then
        if actor.level >= 10 and actor.level <= 25 then
            actor:send(tostring(self.name) .. " says, 'You are not on this quest.'")
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'Seek me again later when you have gained some more experience.'")
        else
            actor:send(tostring(self.name) .. " says, 'You have traveled too far on your current path to change your way.'")
        end
    end
end
