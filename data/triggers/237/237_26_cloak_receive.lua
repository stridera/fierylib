-- Trigger: cloak_receive
-- Zone: 237, ID: 26
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #23726

-- Converted from DG Script #23726: cloak_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor.id == -1 then
    if actor:get_quest_stage("sunfire_rescue") == 2 then
        if object.id == 52009 then
            wait(1)
            actor.name:advance_quest("sunfire_rescue")
            self:emote("carefully looks at the cloak.")
            self:say("This is it! Thank you!")
            self:emote("unshackles his arms and wears the cloak on his shoulders.")
            wait(1)
            self:say("And the ring?  If you have the ring, please give it to me!")
            self:say("Then I can finally escape....")
        end
        if object.id == 52026 then
            self:emote("runs his hands over the cloak quickly.")
            self:say("This is the cursed cloak!")
            self:emote("looks angry.")
            wait(1)
            self:say("Well? Do you have the real cloak to give to me?")
            self:emote("taps his foot impatiently.")
        end
    end
end