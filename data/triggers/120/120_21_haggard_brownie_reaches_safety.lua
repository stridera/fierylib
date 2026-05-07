-- Trigger: Haggard brownie reaches safety
-- Zone: 120, ID: 21
-- Type: MOB, Flags: ENTRY
-- Status: CLEAN
--
-- Original DG Script: #12021

-- Converted from DG Script #12021: Haggard brownie reaches safety
-- Original: MOB trigger, flags: ENTRY, probability: 100%
-- Brownie reaches the safe room (zone 120, room 0 — legacy vnum 12000).
-- Reward the rescuer recorded by trigger 120-10, drop the gifts, despawn.
if destination == 12000 then
    self:follow(self)
    wait(4)
    self:say("Thank you!  Thank you at last I am safe!")
    local rescuer = globals.rescuer
    if rescuer then
        rescuer:award_exp(15000)
        rescuer:send("You gain experience!")
    end
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
    if rescuer then
        self:command("give all.cookie " .. rescuer.name)
        self:command("give cup " .. rescuer.name)
    end
    self:command("drop all.cookie")
    self:command("drop cup")
    wait(2)
    self:say("Goodbye now!")
    self:emote("trots off into the undergrowth.")
    world.destroy(self)
end