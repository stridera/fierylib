-- Trigger: monk_subclass_quest_arre_speech2
-- Zone: 51, ID: 7
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5107

-- Converted from DG Script #5107: monk_subclass_quest_arre_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%
--
-- Follow-up to speech1: when the player asks Arre about her "reason",
-- prompt them to commit (yes/no) to the subclass quest.
--
-- TODO(parity): legacy DG had a placeholder for restricted races
-- ("ADD RESTRICTED RACES HERE") which was never filled in.

-- Speech keyword: reason
if not string.find(string.lower(speech), "reason") then
    return true  -- No matching keywords
end
if not string.find(actor.class, "Warrior") then
    wait(2)
    actor:send(self.name .. " says, 'Ah, you are not well suited to my teaching.  So I shall not waste my time with you.'")
    return
end
-- Only react before the quest has started (stage nil/0).
local stage = actor:get_quest_stage("monk_subclass")
if stage and stage ~= 0 then
    return
end
wait(2)
if actor.level < 10 then
    self:command("eye " .. actor.name)
    actor:send(self.name .. " says, 'Perhaps in time, after you've gained a little more experience, we can talk more.'")
elseif actor.level <= 25 then
    self:command("grumble")
    actor:send(self.name .. " says, 'Yes a reason...'")
    wait(1)
    actor:send(self.name .. " says, 'You do not know much do you?'")
    self:command("roll")
    self:command("mutter")
    wait(3)
    self:command("eye " .. actor.name)
    actor:send(self.name .. " says, 'Are you certain you wish to study as a monk and have strength over mind and body alike?'")
else
    actor:send(self.name .. " says, 'Ah, you are no longer suited for my teachings.  So I shall not waste my time with you.'")
end