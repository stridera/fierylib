-- Trigger: prince_receive1
-- Zone: 480, ID: 9
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #48009

-- Converted from DG Script #48009: prince_receive1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor.id == -1 then
    if object.id == 48031 then
        if actor.alignment > 350 then
            self:say("Ah, even though I did not strike the killing blow, I can feel the years of desire for revenge have been completed.")
            self:say("Thank you " .. tostring(actor.name) .. ", I hope this gift will help you against the king.")
        else
            self:say("Hmm, although your motives are not pure, you have done me a great service.")
            wait(1)
            self:say("In return I will give you this staff, may you find it a help as you continue in your quest.")
        end
        self.room:spawn_object(480, 19)
        self:command("give staff " .. tostring(actor.name))
        self:destroy_item("head_of_the_infidel")
    end
end