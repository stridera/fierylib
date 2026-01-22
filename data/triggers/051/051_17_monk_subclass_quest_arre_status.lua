-- Trigger: monk_subclass_quest_arre_status
-- Zone: 51, ID: 17
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #5117

-- Converted from DG Script #5117: monk_subclass_quest_arre_status
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
-- switch on actor:get_quest_stage("monk_subclass")
if actor:get_quest_stage("monk_subclass") == 1 then
    wait(2)
    actor:send(tostring(self.name) .. " says, 'It is wonderful to hear of others wanting to join the Brotherhood of the Monks.  You will be rewarded for your success with wonderful training, but only those pure of mind will complete the <b:cyan>quest</>.'")
elseif actor:get_quest_stage("monk_subclass") == 2 then
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Alright, well sit back.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Usually people come in here promising me the return of something long lost of mine.'")
    self:command("scratch")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'The thing is, I have not always lead this life.  When I was young I was quite the rabble-rouser.'")
    self:emote("looks wistfully for a moment.")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Well, it is rather embarrassing, but...  I miss my old sash, and I want it back.'")
    wait(2)
    self:emote("shakes her head.")
    actor:send(tostring(self.name) .. " says, 'I was told it looked wonderful on me.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, '" .. tostring(actor.name) .. ", can you recover it?'")
    wait(1)
    actor:send(tostring(self.name) .. " whispers to you, 'Please?'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Long ago some ruthless <b:cyan>fiends</> made off with it.'")
elseif actor:get_quest_stage("monk_subclass") == 3 or actor:get_quest_stage("monk_subclass") == 4 then
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Have you recovered my sash from those thieves out west?  If you return my sash, I will complete your initiation as a monk.'")
else
    if string.find(actor.class, "Warrior") then
        -- switch on actor.race
        -- case ADD RESTRICTED RACES HERE
        -- if %actor.level% >= 10 && %actor.level% <= 25
        -- msend %actor% &1Your race may not subclass to monk.&0
        -- endif
        -- halt
        -- break
        wait(2)
        if actor.level >= 10 and actor.level <= 25 then
            actor:send(tostring(self.name) .. " says, 'You are not trying to join the Brotherhood.'")
        elseif actor.level < 10 then
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'Perhaps in time, after you've gained a little more experience, we can talk more.'")
        else
            actor:send(tostring(self.name) .. " says, 'Ah, you are no longer suited for my teachings.  So I shall not waste my time with you.'")
        end
    else
        actor:send(tostring(self.name) .. " says, 'Ah, you are not well suited to my teaching.  So I shall not waste my time with you.'")
    end
end  -- auto-close block