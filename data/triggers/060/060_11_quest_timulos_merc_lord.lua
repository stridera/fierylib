-- Trigger: quest_timulos_merc_lord
-- Zone: 60, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #6011

-- Converted from DG Script #6011: quest_timulos_merc_lord
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"lord", "lord?", "who", "who?", "pay", "pay?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "mercenary" and actor:get_quest_stage("merc_ass_thi_subclass") == 1 then
    actor:advance_quest("merc_ass_thi_subclass")
    actor:send(tostring(self.name) .. " says, 'Well, a great Lord, who shall remain unnamed, has lost a cloak.'")
    self:command("smirk")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'He has come to me for its return.  If you went and procured it, he would be grateful.'")
    self:command("grin")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'And if he is grateful, I would be as well, and your training would be finished.  It would be quite a payday for a <b:cyan>cloak</>.'")
end