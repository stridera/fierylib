-- Trigger: raph_recei_mussel
-- Zone: 133, ID: 7
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #13307

-- Converted from DG Script #13307: raph_recei_mussel
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor.id== -1 then
    wait(3)
    if object.vnun == 49024 then
        if actor:get_quest_stage("get_raph_food") == 8 then
            self:emote("smiles a bit as his tummy growls very much.")
            wait(3)
            self:command("shake " .. tostring(actor.name))
            self:say("I thank you for all of your effort, but I am afraid you are too late.  Death is coming for me.")
            actor.name:advance_quest("get_raph_food")
            actor.name:send(self.name .. " tells you, '" .. "If you would like your prize, 'tell raph Please'." .. "'")
            wait(2)
        else
            -- switch on actor:get_quest_stage("get_raph_food")
            if actor:get_quest_stage("get_raph_food") == 1 or actor:get_quest_stage("get_raph_food") == 2 or actor:get_quest_stage("get_raph_food") == 3 or actor:get_quest_stage("get_raph_food") == 4 or actor:get_quest_stage("get_raph_food") == 5 or actor:get_quest_stage("get_raph_food") == 6 then
                self:say("Unusual that you can get an object I have not even asked for yet.")
                wait(2)
                self:say("You shouldn't know to have this yet, cheater.")
            elseif actor:get_quest_stage("get_raph_food") == 7 then
                self:say("How ever did you manage to get the mussel without actually picking it up yourself?!")
                self:command("frown " .. tostring(actor.name))
            else
                self:say("What a lovely bit of food, thank you!")
                self:command("thank " .. tostring(actor.name))
                wait(2)
                self:say("Shame you were not performing a quest, you seem like you could have helped an old man.")
            end
            wait(2)
        end
    end
end