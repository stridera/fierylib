-- Trigger: rianne-greet
-- Zone: 103, ID: 2
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #10302

-- Converted from DG Script #10302: rianne-greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(1)
if actor.id == -1 then
    if actor:get_quest_stage("resort_cooking") >= 1 then
        -- switch on actor:get_quest_stage("resort_cooking")
        if actor:get_quest_stage("resort_cooking") == 1 then
            local recipe = "Peach Cobbler"
        elseif actor:get_quest_stage("resort_cooking") == 2 then
            local recipe = "Seafood Salad"
        elseif actor:get_quest_stage("resort_cooking") == 3 then
            local recipe = "Fish Stew"
        elseif actor:get_quest_stage("resort_cooking") == 4 then
            local recipe = "Honey-Glazed Ham"
        elseif actor:get_quest_stage("resort_cooking") == 5 then
            local recipe = "Saffroned Jasmine Rice"
        else
            return _return_value
        end
        self.room:send(tostring(self.name) .. " says, 'Welcome back, " .. tostring(actor.name) .. "!")
        self.room:send("</>Have you brought me the ingredients for <b:white>" .. tostring(recipe) .. "?</>'")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Remember, you can look in the icebox to see what you've")
        self.room:send("</>already brought me.'")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Oh, and the recipe for <b:white>" .. tostring(recipe) .. "</> is on the wall!'")
    else
        self.room:send(tostring(self.name) .. " says, 'Welcome to Phoenix Feather Resort, " .. tostring(actor.name) .. "!")
        self.room:send("</>My name is " .. tostring(self.name) .. " and I am the cook here.'")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'But I could use a little help!  Being located up north")
        self.room:send("</>makes it hard to get everything I need for some of my more exotic dishes.'")
        wait(2)
        self:say(tostring(actor.name) .. " do you think you could help me?")
        self:command("smile " .. tostring(actor.name))
    end
end