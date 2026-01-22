-- Trigger: brother
-- Zone: 125, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12503

-- Converted from DG Script #12503: brother
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: brother Brother brother? Brother?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "brother") or string.find(string.lower(speech), "brother") or string.find(string.lower(speech), "brother?") or string.find(string.lower(speech), "brother?")) then
    return true  -- No matching keywords
end
-- switch on actor:get_quest_stage("krisenna_quest")
if actor:get_quest_stage("krisenna_quest") == 0 or actor:get_quest_stage("krisenna_quest") == 1 then
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Our father warned him not to go... But he wouldn't")
    self.room:send("</>listen.'")
    wait(2)
    self:say("Now he's probably dead...")
    wait(1)
    self:emote("starts bawling like a baby.")
    wait(3)
    self:emote("sobs, 'You've got to find him!!  Will you find him?'")
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
else
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'He was very dear to me... foolhardy, but a good")
    self.room:send("</>brother.'")
end