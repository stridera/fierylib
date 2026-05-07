-- Trigger: Ill-subclass: Grand Master starts
-- Zone: 172, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Player says 'begin' to the Grand Master. If they're an eligible sorcerer
-- with no quest in progress, he disguises them as Cestia, gives the vial,
-- and starts the illusionist subclass quest.
--
-- Original DG Script: #17203

local speech_lower = string.lower(speech)
if not string.find(speech_lower, "begin") then
    return true  -- keyword not heard
end

if not string.find(actor.class, "Sorcerer") then
    return true
end
if actor.level < 10 or actor.level > 45 then
    return true
end
if actor:get_quest_stage("illusionist_subclass") ~= 0 then
    return true  -- already mid-quest; 'restart' is the right keyword
end

wait(1)
actor:send(tostring(self.name) .. " says, 'Good, good.  Please stand still while I enchant you so that the smugglers will see you as Cestia.'")
wait(3)
self:emote("utters the words, 'incognito'.")
wait(2)
actor:send(tostring(self.name) .. " says, 'Now... take this vial.'")
self.room:spawn_object(172, 15)
self:command("give vial " .. tostring(actor.name))
wait(2)
actor:send(tostring(self.name) .. " says, 'Now go to the hideout, <b:cyan>drop the vial</>, and quickly go to to see the leader.  Remember not to let anyone see you drop it!'")
wait(2)
actor:send(tostring(self.name) .. " says, 'Come back and ask for <b:cyan>help</> if you get stuck!'")
actor:start_quest("illusionist_subclass", "Illusionist")