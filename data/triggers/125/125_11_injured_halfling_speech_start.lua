-- Trigger: injured halfling speech start
-- Zone: 125, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12511

-- Converted from DG Script #12511: injured halfling speech start
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: hi hello hi? hello? progress progress? status status?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "hi") or string.find(string.lower(speech), "hello") or string.find(string.lower(speech), "hi?") or string.find(string.lower(speech), "hello?") or string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?") or string.find(string.lower(speech), "status") or string.find(string.lower(speech), "status?")) then
    return true  -- No matching keywords
end
-- switch on actor:get_quest_stage("krisenna_quest")
if actor:get_quest_stage("krisenna_quest") == 0 then
    wait(1)
    self:emote("looks panicked.")
    wait(1)
    self:say("You've got to help me...")
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