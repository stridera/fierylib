-- Trigger: Ill-subclass: Tell Gannigan no
-- Zone: 172, ID: 8
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #17208

-- Converted from DG Script #17208: Ill-subclass: Tell Gannigan no
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: no
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
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