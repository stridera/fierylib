-- Trigger: quest_timulos_ass_price
-- Zone: 60, ID: 12
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #6012

-- Converted from DG Script #6012: quest_timulos_ass_price
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: price? price
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "price?") or string.find(string.lower(speech), "price")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "assassin" and actor:get_quest_stage("merc_ass_thi_subclass") == 1 then
    actor.name:advance_quest("merc_ass_thi_subclass")
    actor:send(tostring(self.name) .. " says, 'Yes, a great price.'")
    self:command("grin")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'I have some rich men unhappy with the politics of the region in question.  You could help with those <b:cyan>politics</> if you wish.'")
end