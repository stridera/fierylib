-- Trigger: monk_subclass_quest_arre_speech2
-- Zone: 51, ID: 7
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5107

-- Converted from DG Script #5107: monk_subclass_quest_arre_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: reason reason?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "reason") or string.find(string.lower(speech), "reason?")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "Warrior") then
    -- switch on actor.race
    -- case ADD RESTRICTED RACES HERE
    -- if %actor.level% <= 25
    -- msend %actor% &1Your race may not subclass to monk.&0
    -- endif
    -- halt
    -- break
    wait(2)
    if not actor:get_quest_stage("monk_subclass") then
        if actor.level >= 10 then
            self:command("grumble")
            actor:send(tostring(self.name) .. " says, 'Yes a reason...'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'You do not know much do you?'")
            self:command("roll")
            self:command("mutter")
            wait(3)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'Are you certain you wish to study as a monk and have strength over mind and body alike?'")
        elseif actor.level < 10 then
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'Perhaps in time, after you've gained a little more experience, we can talk more.'")
        else
            actor:send(tostring(self.name) .. " says, 'Ah, you are no longer suited for my teachings.  So I shall not waste my time with you.'")
        end
    end
else
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Ah, you are not well suited to my teaching.  So I shall not waste my time with you.'")
end