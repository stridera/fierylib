-- Trigger: illusory_wall_lyara_greet
-- Zone: 364, ID: 0
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #36400

-- Converted from DG Script #36400: illusory_wall_lyara_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(1)
self:emote("looks up in surprise.")
self:say("Well hello there!")
self:command("stand")
self:command("salute")
wait(2)
if (string.find(actor.class, "illusionist") or string.find(actor.class, "bard")) and actor.level > 56 and actor:get_quest_stage("illusory_wall") == 0 then
    self.room:send(tostring(self.name) .. " says, 'Well well well, an up-and-coming Illusionist!  The")
    self.room:send("</>Guard must need reinforcements.'")
elseif actor:get_quest_stage("illusory_wall") == 1 then
    self:say("Have you found the requisite supplies?")
elseif actor:get_quest_stage("illusory_wall") > 1 then
    self:say("I hope your studies are continuing well.")
end