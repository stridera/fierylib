-- Trigger: Haggard brownie reaches safety
-- Zone: 120, ID: 21
-- Type: MOB, Flags: ENTRY
-- Status: CLEAN
--
-- Original DG Script: #12021

-- Converted from DG Script #12021: Haggard brownie reaches safety
-- Original: MOB trigger, flags: ENTRY, probability: 100%
if destination == 12000 then
    self:follow(self.room:find_actor("me"))
    wait(4)
    self:say("Thank you!  Thank you at last I am safe!")
    rescuer:award_exp(15000)
    rescuer:send("You gain experience!")
    wait(2)
    self:say("Ah, here is the travel pack I lost in that wretched forest.")
    self:emote("rummages in the pack for a few moments.")
    self.room:spawn_object(120, 20)
    self.room:spawn_object(120, 20)
    self.room:spawn_object(120, 21)
    self.room:spawn_object(120, 22)
    wait(4)
    self:say("Please take this.  It's not much, but it is all I can spare at the moment.")
    wait(2)
    self:command("give all.cookie " .. tostring(rescuer))
    self:command("give cup " .. tostring(rescuer))
    self:command("drop all.cookie")
    self:command("drop cup")
    wait(2)
    self:say("Goodbye now!")
    self:emote("trots off into the undergrowth.")
    world.destroy(self.room:find_actor("self"))
end