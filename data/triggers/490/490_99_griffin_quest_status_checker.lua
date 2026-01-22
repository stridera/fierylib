-- Trigger: griffin_quest_status_checker
-- Zone: 490, ID: 99
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49099

-- Converted from DG Script #49099: griffin_quest_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: quest progress
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "quest") or string.find(string.lower(speech), "progress")) then
    return true  -- No matching keywords
end
local stage = actor:get_quest_stage("griffin_quest")
wait(2)
if actor:get_has_completed("griffin_quest") then
    self.room:send(tostring(self.name) .. " says, 'You have destroyed Adramalech and his cult!  Thank you, " .. tostring(actor.name) .. "!'")
    return _return_value
end
-- switch on stage
if stage == 0 then
    self.room:send(tostring(self.name) .. " says, 'I need to see if it is still possible to destroy the cult of the griffin.  Find the wreck of the St. Marvin and retrieve the cutting from the sacred oak.'")
elseif stage == 1 then
    self.room:send(tostring(self.name) .. " says, 'The sword used to cut the oak is also critical.  Bring me the mystic sword from the wreck of the St. Marvin.'")
elseif stage == 2 then
    self.room:send(tostring(self.name) .. " says, 'You'll need oracular guidance.  Go to the Seer and say <b:white>'Earle sends me'</>'")
elseif stage == 3 then
    self.room:send(tostring(self.name) .. " says, 'Get assistance from the strongest person on the island.  Find Derceta and return her crystal earring to her.'")
elseif stage == 4 then
    self.room:send(tostring(self.name) .. " says, 'The entrance to the cult's lair is hidden under a massive boulder.  Find Derceta, return her earring again, and ask her to move the boulder.'")
elseif stage == 5 then
    self.room:send(tostring(self.name) .. " says, 'Find the cult's altar and destroy it.  Go through the gate Derceta unearthed and drop the sapling at the cult's altar.'")
elseif stage == 6 then
    self:say("It is time to destroy the cult!  Slay Dagon!")
elseif stage == 7 then
    self:say("Bring the griffin skin to Awura.")
elseif stage == 8 then
    self.room:send(tostring(self.name) .. " says, 'Now you can strike the final blow and destroy the essence of the god of the cult itself.  Seek out the hidden entrance to the other realms and destroy Adramalech.'")
end