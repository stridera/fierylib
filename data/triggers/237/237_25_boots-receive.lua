-- Trigger: boots-receive
-- Zone: 237, ID: 25
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #23725

-- Converted from DG Script #23725: boots-receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor.is_player then
    wait(1)
    if actor:get_quest_stage("sunfire_rescue") == 1 then
        if object.zone_id == 520 and object.local_id == 8 then
            -- Real elven boots
            actor:advance_quest("sunfire_rescue")
            self:command("smile " .. tostring(actor.name))
            self:emote("slips his feet out of the shackles and wears the boots.")
            self:say("Thank you.")
            wait(1)
            self:say("And the cloak? Do you have the cloak? Give it to me, please!")
        end
        if object.zone_id == 520 and object.local_id == 24 then
            -- Cursed boots
            self:emote("looks at the boots carefully.")
            self:say("These are the cursed boots.  If you have the real ones, please...")
            self:say("These cannot help me at all.")
            self:say("Do you have the real ones? I need them.")
        end
    end
end