-- Trigger: prisoner_quest
-- Zone: 200, ID: 36
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #20036

-- Converted from DG Script #20036: prisoner_quest
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
wait(1)
self:emote("eyes light up with joy!")
wait(1)
self:say("Thank you so much for giving me my freedom!")
wait(1)
self:emote("pulls a small metal key out from his shirt.")
self.room:spawn_object(200, 66)
self:command("give metal " .. tostring(actor.name))
self:destroy_item("obsidian")
wait(1)
self:say("This key opens the small hovel that I dug in one of the cells of this prison.")
self:say("In it is hidden a great treasure.")
wait(1)
self:say("Good luck finding it.")
self:emote("unlocks the cell door.")
self:emote("opens the cell door.")
self:emote("sneaks away quietly.")
world.destroy(self.room:find_actor("prisoner"))