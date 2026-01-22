-- Trigger: assistant_receive ball
-- Zone: 200, ID: 30
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #20030

-- Converted from DG Script #20030: assistant_receive ball
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor.id == -1 then
    if object.id == 3218 then
        self:command("pat " .. tostring(actor.name))
        self:say("You have done well")
        self.room:send("Yix'Xyua pulls something out of his clothes and gives it to his assistant.")
        self.room:spawn_object(200, 53)
        wait(1)
        self:say("Here is your reward for your bravery.")
        self:command("give gaze " .. tostring(actor.name))
        self:say("When we come up with a plan to destroy Ruin we will call for you.")
        world.destroy(self.room:find_actor("ball"))
    elseif object.id == 3217 then
        wait(1)
        self:say("The leader will deal with this, give it to him.")
        self:command("give staff " .. tostring(actor.name))
    end
end