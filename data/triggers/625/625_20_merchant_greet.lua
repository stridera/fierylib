-- Trigger: merchant greet
-- Zone: 625, ID: 20
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #62520

-- Converted from DG Script #62520: merchant greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if actor.id == -1 then
    if actor:get_quest_stage("ursa_quest") < 1 then
        local greet = random(1, 100)
        if greet > 70 then
            self:say("I don't want to hurt you!")
        elseif greet > 40 then
            self:say("Stay back!  I don't want to hurt anyone else.")
        elseif greet > 20 then
            self:say("Please, help me.")
        else
            self:emote("cowers, hoping you'll pass by.")
        end
    elseif actor:get_quest_stage("ursa_quest") > 0 then
        self:say("Do you have anything for me?")
    end
end