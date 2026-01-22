-- Trigger: Ill-subclass: Tell Gannigan yes
-- Zone: 172, ID: 9
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #17209

-- Converted from DG Script #17209: Ill-subclass: Tell Gannigan yes
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
wait(6)
-- switch on actor:get_quest_stage("illusionist_subclass")
if actor:get_quest_stage("illusionist_subclass") == 4 then
    self:say("I thought you might.  Hurry off to the safe room!")
    wait(4)
    self:say("Please, Cestia!  I'll not have you clubbed by the filthy Mielikki militia!")
elseif actor:get_quest_stage("illusionist_subclass") == 5 then
    self:command("snort")
    wait(3)
    self:say("I had no doubt of it.  You never knew loyalty.  I should have seen it when you hurt that illusionist so cavalierly.")
else
    self:command("glare " .. tostring(actor.name))
    wait(2)
    self:command("ponder")
end