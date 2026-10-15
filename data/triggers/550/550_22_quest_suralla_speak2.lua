-- Trigger: quest_suralla_speak2
-- Zone: 550, ID: 22
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55022

-- Converted from DG Script #55022: quest_suralla_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"quest", "reward"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("cryomancer_subclass") == 1 then
    actor:advance_quest("cryomancer_subclass")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'It is quite simple.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'My counterpart, the great Emmath Firehand, long ago battled with me once.'")
    self:emote("reminisces for a brief moment, looking thoughtful.")
    wait(0.1)
    actor:send(tostring(self.name) .. " says, 'It was not serious by any means, but it did end in a stalemate.  The catch however...'")
    wait(1)
    self:command("sigh")
    wait(1)
    actor:send(tostring(self.name) .. " says, '... is that what we battled over may still be <b:cyan>suffering</>.'")
    self:emote("sighs deeply again.")
end