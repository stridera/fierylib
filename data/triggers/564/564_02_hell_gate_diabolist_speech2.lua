-- Trigger: hell_gate_diabolist_speech2
-- Zone: 564, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #56402
--
-- "no" reply to the diabolist's greet question. Mirror of 564_01 for
-- the negative branch.

-- Speech keyword: "no"
if not string.find(string.lower(speech), "no") then
    return true
end
wait(2)
if string.find(actor.class, "Diabolist") and actor:get_quest_stage("hell_gate") == 0 then
    self:say("Pity for you.  The demons must not think you worthy.")
elseif actor:get_quest_stage("hell_gate") > 0 then
    self:say("What are you waiting for?  Get to work!")
end