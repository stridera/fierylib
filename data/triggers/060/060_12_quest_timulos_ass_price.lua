-- Trigger: quest_timulos_ass_price
-- Zone: 60, ID: 12
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #6012

-- Converted from DG Script #6012: quest_timulos_ass_price
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"price?", "price"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "assassin" and actor:get_quest_stage("merc_ass_thi_subclass") == 1 then
    actor:advance_quest("merc_ass_thi_subclass")
    actor:send(tostring(self.name) .. " says, 'Yes, a great price.'")
    self:command("grin")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'I have some rich men unhappy with the politics of the region in question.  You could help with those <b:cyan>politics</> if you wish.'")
end