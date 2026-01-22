-- Trigger: megalith_quest_priestess_greet
-- Zone: 123, ID: 0
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #12300

-- Converted from DG Script #12300: megalith_quest_priestess_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
-- This trigger is different depending on stage and where in the stage the questor is at
-- 
local item1 = (actor:get_quest_var("megalith_quest:item1"))
local item2 = (actor:get_quest_var("megalith_quest:item2"))
local item3 = (actor:get_quest_var("megalith_quest:item3"))
local item4 = (actor:get_quest_var("megalith_quest:item4"))
if (actor.id == -1) and (actor:get_quest_stage("megalith_quest") < 1) and (actor.level < 100) then
    wait(2)
    self.room:send(tostring(self.name) .. " looks up, startled to see new faces.")
    self:say("Goddess be praised!")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'We were attacked by the Unseelie Court and their monstrosities on our journey here through the forest.  I am deeply in need of <b:cyan>assistance</>!'")
    -- 
    -- Check in during stage 1, seeing if the questor has her tools or not
    -- 
elseif actor:get_quest_stage("megalith_quest") == 1 then
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Have you been able to find replacements for the sacred prophetic implements?  Do you need a reminder of your <b:cyan>[progress]?</>'")
    -- 
    -- If all the Keepers have been helped in stage 2, give the incantation to start stage 3
    -- 
elseif (actor:get_quest_stage("megalith_quest") == 2) and (actor:get_quest_var("megalith_quest:item1")) and (actor:get_quest_var("megalith_quest:item2")) and (actor:get_quest_var("megalith_quest:item3")) and (actor:get_quest_var("megalith_quest:item4")) then
    wait(2)
    self:say("We're ready to finish calling the elements!  If you wish to proceed, repeat after me:")
    self.room:send("</>")
    self.room:send("<b:cyan>Under the watchful eye of Earth, Air, Fire, and Water, we awaken this hallowed ground!</>")
    -- 
    -- If all the Keepers have not been helped in stage 2, do a check in
    -- 
elseif actor:get_quest_stage("megalith_quest") == 2 then
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'I hope your work with the Keepers is coming along well.  Do you need a reminder of your <b:cyan>[progress]?</>'")
    -- 
    -- If all the reliquaries have been returned and stage 4 is ready to start, ask if ready to proceed
    -- 
elseif (actor:get_quest_stage("megalith_quest") == 4) and (actor:get_quest_var("megalith_quest:reliquary")) then
    wait(2)
    self:say("It's time.  Are you ready to proceed?")
    -- 
    -- If all the reliquaries have not been returned yet in stage 3, do a check in
    -- 
elseif actor:get_quest_stage("megalith_quest") == 3 then
    wait(2)
    self:say("I hope you have had luck finding the reliquaries.")
    -- 
    -- If the quest was successfully completed, give a friendly welcome.
    -- 
elseif actor:get_has_completed("megalith_quest") then
    wait(2)
    if actor.gender == "female" then
        self:say("Hail and well met, Sister!")
    elseif actor.gender == "male" then
        self:say("Hail and well met, Brother!")
    else
        self:say("Hail and well met!")
    end
    -- 
    -- If the quest was failed,
    -- 
elseif actor:get_has_failed("megalith_quest") then
    wait(2)
    self:say("Welcome back.")
    wait(2)
    self:say("Had that we reunited under better blessings...")
    wait(3)
    self:say("Though perhaps we could try again?")
end