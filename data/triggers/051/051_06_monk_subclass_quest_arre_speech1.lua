-- Trigger: monk_subclass_quest_arre_speech1
-- Zone: 51, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5106

-- Converted from DG Script #5106: monk_subclass_quest_arre_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: here here? where where?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "here") or string.find(string.lower(speech), "here?") or string.find(string.lower(speech), "where") or string.find(string.lower(speech), "where?")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "Warrior") then
    -- switch on actor.race
    -- case ADD RESTRICTED RACES HERE
    -- if %actor.level% >= 10 && %actor.level% <= 25
    -- msend %actor% &1Your race may not subclass to monk.&0
    -- endif
    -- halt
    -- break
    wait(2)
    if actor.level < 10 then
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " says, 'Perhaps in time, after you've gained a little more experience, we can talk more.'")
    elseif actor.level >= 10 and actor.level <= 25 then
        wait(2)
        self:command("chuckle")
        actor:send(tostring(self.name) .. " says, 'Do you not know where you are?  Silly youth.'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Why did you come to my chambers if you do not have a reason?'")
        wait(1)
        self:command("frown")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'I suppose you are here for the same <b:cyan>reason</> as everyone else that ever visits me.'")
        self:command("sigh")
    else
        actor:send(tostring(self.name) .. " says, 'Ah, you are no longer suited for my teachings.  So I shall not waste my time with you.'")
    end
else
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Ah, you are not well suited to my teaching.  So I shall not waste my time with you.'")
end