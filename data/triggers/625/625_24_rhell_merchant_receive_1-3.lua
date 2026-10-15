-- Trigger: Rhell Merchant receive 1-3
-- Zone: 625, ID: 24
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62524

-- Converted from DG Script #62524: Rhell Merchant receive 1-3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- if the player returns the letter from the hermit, 'choice' is set to path 3: the ring of stolen life
-- DG receive arg list (62512): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 625 and object.id == 12)
) then
    return true
end

if actor:get_quest_stage("ursa_quest") == 1 then
    wait(0.2)
    world.destroy(object)
    actor:set_quest_var("ursa_quest", "choice", 3)
    actor:advance_quest("ursa_quest")
    wait(0.8)
    self:say("He has always told me he's found a cure for everything he's ever heard of.  I just need you to help gather some things.")
    wait(2)
    self:say("He says a devourer has a ring with power to heal.  Do you know what ring he means?  Please, go get this ring.  Devourers are drawn to magic, and burrow to avoid the sun.  That is all I know.")
end