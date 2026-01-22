-- Trigger: Ill-subclass: Gannigan greets the quester
-- Zone: 172, ID: 7
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #17207

-- Converted from DG Script #17207: Ill-subclass: Gannigan greets the quester
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
-- switch on actor:get_quest_stage("illusionist_subclass")
if actor:get_quest_stage("illusionist_subclass") == 1 or actor:get_quest_stage("illusionist_subclass") == 2 then
    self:emote("looks up from his paperwork briefly.")
    wait(1)
    self:emote("gasps in surprise, and rises quickly from his chair!")
    wait(1)
    self:command("hug " .. tostring(actor.name))
    wait(3)
    self:say("Cestia... my beloved.  Where have you been?")
elseif actor:get_quest_stage("illusionist_subclass") == 3 then
    self:emote("looks up from his paperwork.  He seems angry.")
    wait(1)
    self:say("So.  Already up to your old tricks?")
    wait(2)
    self:emote("appears saddened, but angry nonetheless.")
    wait(3)
    self:say("I am aware of the spell you cast, here in my home.  Tell me, what madness awaits us?")
elseif actor:get_quest_stage("illusionist_subclass") == 4 then
    self:say("Please, Cestia!  You must conceal yourself!  The forces of Mielikki will not overlook your crimes again!")
    wait(3)
    actor:send(tostring(self.name) .. " looks upon you with pleading in his eyes.")
    self.room:send_except(actor, tostring(self.name) .. " looks upon " .. tostring(actor.name) .. " with pleading in his eyes.")
    wait(2)
    self:say("You do remember the incantation, don't you?")
elseif actor:get_quest_stage("illusionist_subclass") == 5 then
    self:say("A raid?  How did you get the townsfolk back on your side?  It would be an amazing accomplishment -")
    wait(3)
    self:say("- if not for the vileness that must lie within your heart to turn upon me so!")
else
    self:emote("looks up from his paperwork briefly.")
    wait(2)
    self:command("snort")
end