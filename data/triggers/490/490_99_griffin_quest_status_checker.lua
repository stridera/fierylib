-- Trigger: griffin_quest_status_checker
-- Zone: 490, ID: 99
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49099

-- Converted from DG Script #49099: griffin_quest_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: quest progress (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]quest progress[%s%p]") then
    return true  -- Not the phrase
end
local stage = actor:get_quest_stage("griffin_quest")
wait(0.2)
if actor:get_has_completed("griffin_quest") then
    self.room:send(tostring(self.name) .. " says, 'You have destroyed Adramalech and his cult!  Thank you, " .. tostring(actor.name) .. "!'")
    return true
end
-- switch on stage
do
    local _sw1 = string.lower(tostring(stage or ""))
    local _run1 = false
    repeat
        if _run1 or tonumber(_sw1) == 0 then
            _run1 = true
            self.room:send(tostring(self.name) .. " says, 'I need to see if it is still possible to destroy the cult of the griffin.  Find the wreck of the St. Marvin and retrieve the cutting from the sacred oak.'")
            break
        end
        if _run1 or tonumber(_sw1) == 1 then
            _run1 = true
            self.room:send(tostring(self.name) .. " says, 'The sword used to cut the oak is also critical.  Bring me the mystic sword from the wreck of the St. Marvin.'")
            break
        end
        if _run1 or tonumber(_sw1) == 2 then
            _run1 = true
            self.room:send(tostring(self.name) .. " says, 'You'll need oracular guidance.  Go to the Seer and say <b:white>'Earle sends me'</>'")
            break
        end
        if _run1 or tonumber(_sw1) == 3 then
            _run1 = true
            self.room:send(tostring(self.name) .. " says, 'Get assistance from the strongest person on the island.  Find Derceta and return her crystal earring to her.'")
            break
        end
        if _run1 or tonumber(_sw1) == 4 then
            _run1 = true
            self.room:send(tostring(self.name) .. " says, 'The entrance to the cult's lair is hidden under a massive boulder.  Find Derceta, return her earring again, and ask her to move the boulder.'")
            break
        end
        if _run1 or tonumber(_sw1) == 5 then
            _run1 = true
            self.room:send(tostring(self.name) .. " says, 'Find the cult's altar and destroy it.  Go through the gate Derceta unearthed and drop the sapling at the cult's altar.'")
            break
        end
        if _run1 or tonumber(_sw1) == 6 then
            _run1 = true
            self:say("It is time to destroy the cult!  Slay Dagon!")
            break
        end
        if _run1 or tonumber(_sw1) == 7 then
            _run1 = true
            self:say("Bring the griffin skin to Awura.")
        end
        if _run1 or tonumber(_sw1) == 8 then
            _run1 = true
            self.room:send(tostring(self.name) .. " says, 'Now you can strike the final blow and destroy the essence of the god of the cult itself.  Seek out the hidden entrance to the other realms and destroy Adramalech.'")
        end
    until true
end