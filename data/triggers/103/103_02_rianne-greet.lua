-- Trigger: rianne-greet
-- Zone: 103, ID: 2
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #10302
-- Greets the player. If they are mid resort_cooking quest, reminds
-- them which recipe is in progress; otherwise, pitches the quest.

wait(1)
if not actor.is_player then
    return true
end

local stage = actor:get_quest_stage("resort_cooking")
if stage >= 1 then
    local recipe
    if stage == 1 then
        recipe = "Peach Cobbler"
    elseif stage == 2 then
        recipe = "Seafood Salad"
    elseif stage == 3 then
        recipe = "Fish Stew"
    elseif stage == 4 then
        recipe = "Honey-Glazed Ham"
    elseif stage == 5 then
        recipe = "Saffroned Jasmine Rice"
    else
        return true
    end
    self.room:send(self.name .. " says, 'Welcome back, " .. actor.name .. "!")
    self.room:send("</>Have you brought me the ingredients for <b:white>" .. recipe .. "?</>'")
    wait(1)
    self.room:send(self.name .. " says, 'Remember, you can look in the icebox to see what you've")
    self.room:send("</>already brought me.'")
    wait(2)
    self.room:send(self.name .. " says, 'Oh, and the recipe for <b:white>" .. recipe .. "</> is on the wall!'")
else
    self.room:send(self.name .. " says, 'Welcome to Phoenix Feather Resort, " .. actor.name .. "!")
    self.room:send("</>My name is " .. self.name .. " and I am the cook here.'")
    wait(2)
    self.room:send(self.name .. " says, 'But I could use a little help!  Being located up north")
    self.room:send("</>makes it hard to get everything I need for some of my more exotic dishes.'")
    wait(2)
    self:say(actor.name .. " do you think you could help me?")
    self:command("smile " .. actor.name)
end
