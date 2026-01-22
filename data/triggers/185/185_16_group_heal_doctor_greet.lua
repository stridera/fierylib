-- Trigger: group_heal_doctor_greet
-- Zone: 185, ID: 16
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #18516

-- Converted from DG Script #18516: group_heal_doctor_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
local stage = actor:get_quest_stage("group_heal")
if actor.id == -1 and stage == 0 then
    self:say("Greetings!")
    wait(2)
    self:say("What kind of healing I can assist you with today?")
elseif stage == 1 then
    self:say("Welcome back!")
    wait(2)
    self:say("Have you been able to track down the bandit raiders yet?")
    if world.count_mobiles("18522") == 0 then
        get_room(11, 0):at(function()
            self.room:spawn_mobile(185, 22)
        end)
        get_room(11, 0):at(function()
            self.room:spawn_object(161, 6)
        end)
        get_room(11, 0):at(function()
            self.room:spawn_object(161, 6)
        end)
        get_room(11, 0):at(function()
            self:command("give scimitar bandit")
        end)
        get_room(11, 0):at(function()
            self:command("give scimitar bandit")
        end)
        get_room(11, 0):at(function()
            self.room:find_actor("bandit"):command("wear all")
        end)
        get_room(11, 0):at(function()
            self.room:find_actor("bandit"):teleport(get_room(161, 86))
        end)
    end
elseif stage == 2 then
    self:say("Welcome back!")
    wait(2)
    self:say("Do you have the stolen supplies?")
elseif stage == 3 or stage == 4 then
    self:say("Welcome back!")
    wait(2)
    self:say("Do you have the records of the ritual?")
elseif stage == 5 then
    local total = 6 - actor:get_quest_var("group_heal:total")
    if total == 6 then
        self:say("Ah you've returned!")
        wait(2)
        self:say("Have you been able to consult with any of the chefs?")
    elseif total == 1 then
        self:say("Ah you've returned!")
        wait(2)
        self:say("Have you been able to consult with the last chef yet?")
    else
        self:say("Ah you've returned!")
        wait(2)
        self:say("Have you been able to consult with any of the " .. tostring(total) .. " remaining chefs?")
    end
    self.room:send(tostring(self.name) .. " says, 'And if you need a new copy of the Rite, just say:")
    self.room:send("</><b:yellow>\"I lost the Rite\"</> and I will give you a new one.'")
elseif stage == 6 then
    self:say("Good to see you again!")
    wait(2)
    self:say("I hope the distribution of those medical packets is going well.")
end