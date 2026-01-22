-- Trigger: raph_get_donut_want_cheese
-- Zone: 133, ID: 5
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #13305

-- Converted from DG Script #13305: raph_get_donut_want_cheese
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor.id== -1 then
    wait(3)
    if object.vnun == 36303 then
        if actor:get_quest_stage("get_raph_food") == 4 then
            self:emote("whines as his tummy growls again.")
            wait(3)
            self:command("shake " .. tostring(actor.name))
            self:say("Thank you for the donuts but sadly I fear I am close too death to enjoy the sweets.  But perhaps if you would get me some cheese... that would really save me.")
            actor.name:advance_quest("get_raph_food")
            self:command("smile")
        else
            -- switch on actor:get_quest_stage("get_raph_food")
            if actor:get_quest_stage("get_raph_food") == 1 or actor:get_quest_stage("get_raph_food") == 2 then
                self:say("Unusual that you can get an object I have not even asked for yet.")
                wait(2)
                self:say("You shouldn't know to have this yet, cheater.")
            elseif actor:get_quest_stage("get_raph_food") == 3 then
                self:say("How ever did you manage to get the donuts without actually picking it up yourself?!")
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