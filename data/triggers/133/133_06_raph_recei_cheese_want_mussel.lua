-- Trigger: raph_recei_cheese_want_mussel
-- Zone: 133, ID: 6
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #13306

-- Converted from DG Script #13306: raph_recei_cheese_want_mussel
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor.id== -1 then
    wait(3)
    if object.vnun == 16015 then
        if actor:get_quest_stage("get_raph_food") == 6 then
            self:emote("groans hungrily.")
            wait(3)
            self:command("shake " .. tostring(actor.name))
            self:say("Thank you for the cheese, but sadly I fear only eating a mussel would save me.  I know I am getting picky, but I hear they have some magical healing properties.")
            self:say("Go humor an old man and get a mussel for me, so I might see another day.")
            wait(2)
            self:emote("looks sickly.")
            self:say("I have not had one since I was last down on that sea near those islands.")
            self:emote("licks his lips hungrily.")
            actor.name:advance_quest("get_raph_food")
            self:command("smile")
        else
            -- switch on actor:get_quest_stage("get_raph_food")
            if actor:get_quest_stage("get_raph_food") == 1 or actor:get_quest_stage("get_raph_food") == 2 or actor:get_quest_stage("get_raph_food") == 3 or actor:get_quest_stage("get_raph_food") == 4 then
                self:say("Unusual that you can get an object I have not even asked for yet.")
                wait(2)
                self:say("You shouldn't know to have this yet, cheater.")
            elseif actor:get_quest_stage("get_raph_food") == 5 then
                self:say("How ever did you manage to get the cheese without actually picking it up yourself?!")
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