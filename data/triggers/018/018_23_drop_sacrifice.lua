-- Trigger: drop_sacrifice
-- Zone: 18, ID: 23
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #1823

-- Converted from DG Script #1823: drop_sacrifice
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if object.id > 1100 then
    if random(1, 100) < 5 then
        wait(1)
        self.room:send("The void guardian nods and says, \"I will accept this from you.  Begone!\"")
        self.room:send_except(actor.name, "The void guardian envelops " .. tostring(actor.name) .. ", who disappears.")
        actor.name:send("The void guardian envelops you, and you find yourself elsewhere.")
        actor.name:teleport(get_room(18, 41))
    else
        wait(1)
        self.room:send("The void guardian growls and says, \"You think this will appease me?  BAH!\"")
    end
end
world.destroy(object.name)