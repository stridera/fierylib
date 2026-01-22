-- Trigger: blur_ranger_status_checker
-- Zone: 18, ID: 35
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1835

-- Converted from DG Script #1835: blur_ranger_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: status status? progress progress?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "status") or string.find(string.lower(speech), "status?") or string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?")) then
    return true  -- No matching keywords
end
wait(2)
local stage = actor:get_quest_stage("blur")
if stage == 2 then
    self.room:send(tostring(self.name) .. " says, 'Seek out and kill the Syric Warder and bring me his")
    self.room:send("</>sword.'")
elseif stage == 3 then
    self:say("Give me the Blade of the Forgotten Kings.")
elseif stage == 4 then
    self:say("It's time to race the four winds!")
    -- (empty room echo)
    self.room:send("The North Wind blows near the frozen town of Ickle.")
    self.room:send("The South Wind blows around the hidden standing stones in South Caelia.")
    self.room:send("The East Wind blows through an enormous volcano in the sea.")
    self.room:send("The West Wind blows through ruins across the vast Gothra plains.")
    wait(1)
    self:say("Are you ready?")
end