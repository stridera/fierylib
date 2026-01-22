-- Trigger: hell_gate_diabolist_speech2
-- Zone: 564, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #56402

-- Converted from DG Script #56402: hell_gate_diabolist_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: no
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
end
wait(2)
if string.find(actor.class, "Diabolist") and actor:get_quest_stage("hell_gate") == 0 then
    self:say("Pity for you.  The demons must not think you worthy.")
elseif actor:get_quest_stage("hell_gate") > 0 then
    self:say("What are you waiting for?  Get to work!")
end