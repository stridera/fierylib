-- Trigger: Rhell Merchant receive 1-2
-- Zone: 625, ID: 23
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62523

-- Converted from DG Script #62523: Rhell Merchant receive 1-2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- if the player returns the letter from Ruin, 'choice' is set to path 2: the golden sceptre of imanhotep
if actor:get_quest_stage("ursa_quest") == 1 then
    wait(2)
    world.destroy(object)
    actor.name:set_quest_var("ursa_quest", "choice", 2)
    actor.name:advance_quest("ursa_quest")
    wait(8)
    self:command("gasp")
    wait(1)
    self:say("Ruin has unlocked the secrets of lycanthropy?!")
    wait(2)
    self:emote("skims over the letter.")
    wait(3)
    self:command("frown")
    wait(2)
    self:say("I'm going to need some more help, it seems.")
    wait(2)
    self:say("Ruin speaks of an ancient king that once overcame his own case of lycanthropy.  He suggests if I follow this king's procedure closely, I may have a slight chance.")
    wait(2)
    self:say("He doesn't inspire much hope, does he?")
    self:command("sigh")
    wait(2)
    self:say("At any rate, the first thing he mentions here is a particular gold sceptre that symbolized the king's undying leadership.")
    wait(1)
    self:say("Such a symbol would likely have made its way into the hands of other mighty rulers.  Find the sceptre and bring it to me.")
end