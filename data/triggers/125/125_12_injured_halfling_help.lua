-- Trigger: Injured Halfling help
-- Zone: 125, ID: 12
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12512

-- Converted from DG Script #12512: Injured Halfling help
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: help help?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "help") or string.find(string.lower(speech), "help?")) then
    return true  -- No matching keywords
end
-- switch on actor:get_quest_stage("krisenna_quest")
if actor:get_quest_stage("krisenna_quest") == 0 then
    wait(1)
    self:say("You'll help??")
    wait(1)
    self:emote("looks quite relieved.")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'About a month ago, my brother came here and we")
    self.room:send("</>haven't heard from him since.'")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'They say he went into the tower, never to be seen")
    self.room:send("</>again.'")
    wait(1)
    self:emote("bursts into tears.")
    wait(4)
    self:say("I went after him, but I got hurt quite badly.")
    wait(1)
    self:emote("limps about a bit.")
    wait(3)
    self:say("Could you... find my brother?")
elseif actor:get_quest_stage("krisenna_quest") == 1 then
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Have you found my brother yet?  He must be in the")
    self.room:send("</>tower somewhere!'")
elseif actor:get_quest_stage("krisenna_quest") == 2 then
    wait(1)
    self:say("He's dead??  Oh no!")
    wait(2)
    self:command("cry")
    wait(2)
    self:emote("dries his tears on his bloodstained sleeve.")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'He carried our grandfather's warhammer.  The")
    self.room:send("</>warhammer is very precious to my family.  Would you please find it?")
    self.room:send("</>I will reward you as best I can!'")
elseif actor:get_quest_stage("krisenna_quest") == 3 or actor:get_quest_stage("krisenna_quest") == 4 then
    wait(1)
    self:say("A... demon has the warhammer, you say?")
    wait(2)
    self:command("cringe")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'I must have that warhammer!  Losing my brother is")
    self.room:send("</>bad enough!'")
else
    -- You already returned the warhammer to him.
    wait(1)
    self:say("I thank you again for finding my brother, friend.")
    wait(2)
    self:say("I will be returning home soon...")
end