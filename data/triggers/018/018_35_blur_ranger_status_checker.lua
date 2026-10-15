-- Trigger: blur_ranger_status_checker
-- Zone: 18, ID: 35
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1835

-- Converted from DG Script #1835: blur_ranger_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"status", "status?", "progress", "progress?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
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