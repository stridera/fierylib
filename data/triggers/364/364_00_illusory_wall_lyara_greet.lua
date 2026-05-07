-- Trigger: illusory_wall_lyara_greet
-- Zone: 364, ID: 0
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Lyara stands and salutes any newcomer. If they are a high-level
-- Illusionist/Bard with no quest progress, drop a hook line about the
-- Eldorian Guard. If mid-quest, prompt them about supplies / studies.
--
-- Original DG Script: #36400

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