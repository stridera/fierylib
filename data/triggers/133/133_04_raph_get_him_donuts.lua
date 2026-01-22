-- Trigger: raph_get_him_donuts
-- Zone: 133, ID: 4
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #13304

-- Converted from DG Script #13304: raph_get_him_donuts
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor.id== -1 then
    wait(3)
    if object.vnun == 16211 then
        if actor:get_quest_stage("get_raph_food") == 2 then
            self:emote("frowns as his tummy growls like a roar of thunder.")
            wait(3)
            self:command("shake " .. tostring(actor.name))
            self:say("Thank you for the grain but alas I'm too weak to make it into anything, go and get me a dozen donuts?")
            actor.name:advance_quest("get_raph_food")
            self:command("smile")
        else
            -- switch on actor:get_quest_stage("get_raph_food")
            if actor:get_quest_stage("get_raph_food") == 1 then
                self:say("How ever did you manage to get the grain without actually picking it up yourself?!")
                self:command("frown " .. tostring(actor.name))
            else
                self:say("What a lovely bit of food, thank you!")
                self:command("thank " .. tostring(actor.name))
                wait(2)
                self:say("Shame you were not performing a quest, you seem like you could have helped an old man.")
            end
        end
    end
end