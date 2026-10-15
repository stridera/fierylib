-- Trigger: prisoner_yes
-- Zone: 590, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #59011

-- Converted from DG Script #59011: prisoner_yes
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.4)
if actor:get_quest_stage("sacred_haven") >= 2 and actor.is_player and actor.level < 100 then
    self:command("grin")
    actor:send(tostring(self.name) .. " whispers to you, 'Good, we have been trying to retrieve")
    actor:send("</>our stolen artifacts when I was captured and place here.'")
    wait(0.5)
    actor:send(tostring(self.name) .. " whispers to you, 'I've learned of the location of")
    actor:send("</>the earring.  It's locked in a chest.'")
end