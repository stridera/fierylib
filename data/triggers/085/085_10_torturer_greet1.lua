-- Trigger: torturer_greet1
-- Zone: 85, ID: 10
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #8510

-- Converted from DG Script #8510: torturer_greet1
-- Original: MOB trigger, flags: GREET, probability: 100%
if (actor:get_quest_stage("resurrection_quest") == 2 or actor:get_quest_var("resurrection_quest:new") == "yes") and bishop can_be_seen then
    local quester = actor.name
    self:say("You've made a fatal mistake, bishop!")
    wait(1)
    self:say("Your life is now forfeit!")
    self.room:find_actor("bishop"):say("<blue>Please, " .. tostring(quester) .. ", help me!</>")
    skills.execute(self, "backstab", self.room:find_actor("bishop"))
else
    skills.execute(self, "backstab", self.room:find_actor("actor"))
end