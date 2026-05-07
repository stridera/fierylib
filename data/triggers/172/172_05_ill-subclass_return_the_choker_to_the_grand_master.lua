-- Trigger: Ill-subclass: Return the choker to the Grand Master
-- Zone: 172, ID: 5
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Player gives the Grand Master an item. If it's the real choker and the
-- quest is at the final stage (6), he completes the quest and prompts the
-- player to subclass. Otherwise he returns the gift unimpressed.
--
-- Original DG Script: #17205

if actor:get_quest_stage("illusionist_subclass") == 6 then
    wait(2)
    self:destroy_item("choker")
    wait(2)
    self:command("smile " .. tostring(actor.name))
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Fantastic work!  The smugglers must be in utter disarray!  You've done well.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'I can see that your skill in misdirection is extremely extremely promising.  You have my leave to join the illusionists.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Now, type <b:magenta>'subclass'</>.'")
    actor:complete_quest("illusionist_subclass")
    wait(2)
    self:command("wink " .. tostring(actor.name))
    return true
end

wait(2)
self:command("frown")
wait(2)
self:emote("peers closely at the choker.")
wait(3)
actor:send(tostring(self.name) .. " says, 'I'm sorry... there must be some mistake.  This isn't the choker I gave Cestia.'")
wait(1)
actor:send(tostring(self.name) .. " says, 'I'm certain of it.'")
wait(2)
self:emote("returns the choker.")
return true