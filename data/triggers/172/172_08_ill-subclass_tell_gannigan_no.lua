-- Trigger: Ill-subclass: Tell Gannigan no
-- Zone: 172, ID: 8
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Player tells Gannigan "no" (does not remember the incantation). At
-- stage 4 he reminds them of "where the dough ever rises". At 5 he
-- decides he will see about their loyalty. Other stages get an eyebrow.
--
-- Original DG Script: #17208

local speech_lower = string.lower(speech)
if not string.find(speech_lower, "no") then
    return true  -- keyword not heard
end
wait(6)
-- switch on actor:get_quest_stage("illusionist_subclass")
if actor:get_quest_stage("illusionist_subclass") == 4 then
    actor:send(tostring(self.name) .. " says, 'Of course.  Here is the incantation: <b:cyan>\"where the dough ever rises\"</>.'")
    wait(4)
    self:say("Now get yourself quickly across the waterfall - The townspeople are almost upon us!")
elseif actor:get_quest_stage("illusionist_subclass") == 5 then
    self:say("We'll see about that.")
else
    self:command("peer " .. tostring(actor.name))
    wait(2)
    self:command("eyebrow")
end