-- Trigger: rec_axe
-- Zone: 200, ID: 17
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   -- UNCONVERTED: clothes.
--
-- Original DG Script: #20017

-- Converted from DG Script #20017: rec_axe
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor.id == -1 then
    if object.id == 20046 then
        wait(1)
        self.room:send(tostring(self.name) .. " begins to jump up and down excitedly.")
        self:say("Thank you very much!")
        self:say("Here is your reward for assisting me.")
        self.room:spawn_object(200, 47)
        wait(2)
        self.room:send("The small hurt woman pulls out a bright ball of light from inside her")
        -- UNCONVERTED: clothes.
        wait(2)
        self:command("give sun " .. tostring(actor.name))
        self:destroy_item("axe")
        wait(2)
        self:say("I must return to my children!")
        self.room:send("The small hurt woman quickly sneaks to the north.")
        world.destroy(self.room:find_actor("woman"))
    else
        self:move("e")
        self:move("n")
        self:move("d")
    else
        self:move("e")
        self:move("n")
        self:move("d")
    end  -- auto-close block
end  -- auto-close block