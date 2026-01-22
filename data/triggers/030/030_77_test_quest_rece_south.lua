-- Trigger: test_quest_rece_south
-- Zone: 30, ID: 77
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #3077

-- Converted from DG Script #3077: test_quest_rece_south
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor.id == -1 then
    if object.id == 3080 then
        if actor:get_quest_stage("zzurs_funky_quest") == 4 then
            wait(1)
            self:command("gasp")
            self:destroy_item("necklace")
            self:say("My brother is alive! woo hoo!")
            wait(2)
            self.room:spawn_object(160, 9)
            self:command("give shield " .. tostring(actor.name))
            self:say("take that as an expression of my grattitude!")
            actor.name:complete_quest("zzurs_funky_quest")
        else
            wait(1)
            self:say("Yes! My brother is alive!")
            wait(1)
            self:say("Thank you!")
            self:destroy_item("necklace")
        end
    else
        self:command("eye " .. tostring(actor.name))
    end
else
end