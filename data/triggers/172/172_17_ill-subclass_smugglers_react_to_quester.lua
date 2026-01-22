-- Trigger: Ill-subclass: Smugglers react to quester
-- Zone: 172, ID: 17
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #17217

-- Converted from DG Script #17217: Ill-subclass: Smugglers react to quester
-- Original: MOB trigger, flags: GREET, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
-- switch on actor:get_quest_stage("illusionist_subclass")
if actor:get_quest_stage("illusionist_subclass") == 0 or actor:get_quest_stage("illusionist_subclass") == 1 or actor:get_quest_stage("illusionist_subclass") == 2 then
    wait(2)
    self:command("gasp")
    wait(2)
    self:say("Cestia!  How nice it is to see you again.")
    wait(3)
    self:command("smile " .. tostring(actor.name))
elseif actor:get_quest_stage("illusionist_subclass") == 3 then
    wait(2)
    self:command("look " .. tostring(actor.name))
    wait(3)
    self:command("ponder")
elseif actor:get_quest_stage("illusionist_subclass") == 4 then
    wait(1)
    self:emote("looks rather worried.")
    wait(3)
    self:say("I hope they don't make it this far.  I'm not that good at fighting!")
elseif actor:get_quest_stage("illusionist_subclass") == 5 then
    wait(1)
    self:command("glare " .. tostring(actor.name))
    wait(2)
    self:say("Cestia, I heard you brought a posse from Mielikki with you!")
    wait(4)
    self:say("We ought to offer you up to them!")
elseif actor:get_quest_stage("illusionist_subclass") == 6 then
    wait(1)
    self:say("Aha!  If it isn't the little thief herself!")
    wait(4)
    combat.engage(self, actor.name)
end