-- Trigger: monk_subclass_quest_arre_speech1
-- Zone: 51, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5106

-- Converted from DG Script #5106: monk_subclass_quest_arre_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%
--
-- Initial "where am I" hint -- nudges Warriors toward asking about her
-- "reason". Non-warriors are dismissed.
--
-- TODO(parity): legacy DG had a placeholder for restricted races
-- ("ADD RESTRICTED RACES HERE") which was never filled in.

-- Speech keywords: here, where
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "here") or string.find(speech_lower, "where")) then
    return true  -- No matching keywords
end
if not string.find(actor.class, "Warrior") then
    wait(2)
    actor:send(self.name .. " says, 'Ah, you are not well suited to my teaching.  So I shall not waste my time with you.'")
    return
end
wait(2)
if actor.level < 10 then
    self:command("eye " .. actor.name)
    actor:send(self.name .. " says, 'Perhaps in time, after you've gained a little more experience, we can talk more.'")
elseif actor.level <= 25 then
    wait(2)
    self:command("chuckle")
    actor:send(self.name .. " says, 'Do you not know where you are?  Silly youth.'")
    wait(1)
    actor:send(self.name .. " says, 'Why did you come to my chambers if you do not have a reason?'")
    wait(1)
    self:command("frown")
    wait(1)
    actor:send(self.name .. " says, 'I suppose you are here for the same <b:cyan>reason</> as everyone else that ever visits me.'")
    self:command("sigh")
else
    actor:send(self.name .. " says, 'Ah, you are no longer suited for my teachings.  So I shall not waste my time with you.'")
end