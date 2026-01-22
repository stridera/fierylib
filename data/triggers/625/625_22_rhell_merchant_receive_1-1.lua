-- Trigger: Rhell Merchant receive 1-1
-- Zone: 625, ID: 22
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62522

-- Converted from DG Script #62522: Rhell Merchant receive 1-1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- the emperor's letter is returned, 'choice' is set to path 1: item is pepper, from graveyard.
if actor:get_quest_stage("ursa_quest") == 1 then
    wait(1)
    actor.name:set_quest_var("ursa_quest", "choice", 1)
    actor.name:advance_quest("ursa_quest")
    self:say("News from the Emperor?!  This is fantastic!")
    wait(1)
    self:emote("breathes a sigh of relief.")
    wait(2)
    self:emote("reads " .. tostring(object.shortdesc) .. ".")
    world.destroy(object)
    wait(3)
    self:say("He tells me this spring, if it's the spring he's read about in the archives, has the power to heal me, but not without the help of a few other items of power.")
    wait(1)
    self:emote("continues to read.")
    wait(2)
    self:say("The first thing his instructions call for is peppercorn.  I'm not sure where to get that, but sales prices for pepper always always seem lowest in the Anduin area.  Please bring me some.")
end