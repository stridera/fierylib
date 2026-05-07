-- Trigger: Resurrect_greet
-- Zone: 85, ID: 50
-- Type: MOB, Flags: GREET
--
-- Norisent's greet for cleric/priest/diabolist visitors: hands out a
-- replacement death talisman if the resurrection_quest "new" var was set
-- (player asked for one), nudges low-stage players to start the quest,
-- comments on stage 3, and pushes high-level non-quest visitors away.
--
-- Original DG Script: #8550

-- Converted from DG Script #8550: Resurrect_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(1)
if actor.class == "cleric" or actor.class == "priest" or actor.class == "diabolist" then
    if actor.level < 81 then
        wait(1)
        self:say("You've done well for yourself, little one.  Come back when you are stronger and perhaps I'll have something for you.")
        self:command("pat " .. tostring(actor.name))
    elseif actor.level < 100 then
        if actor:get_quest_var("resurrection_quest:new") == "yes" then
            self:say("I've heard what happened.  Ziijhan will be furious!")
            self:command("cackle")
            wait(2)
            self:command("roll")
            self:say("Fine, I suppose I can help you.")
            wait(1)
            self:emote("pulls another talisman from his robes.")
            wait(1)
            self.room:spawn_object(85, 50)
            self:command("give talisman " .. tostring(actor.name))
        elseif actor:get_quest_stage("resurrection_quest") < 1 then
            self:command("smile")
            self:say("What brings a young cleric to my home?  Has your order sent you to steal my books again?  Or could it be that your order has forgotten how the resurrection incantations are to be performed?")
        elseif actor:get_quest_stage("resurrection_quest") == 3 then
            wait(1)
            self:command("grin " .. tostring(actor.name))
            wait(3)
            self:say("I've heard what happened.  Ziijhan will be furious!")
            self:command("cackle")
            wait(4)
            self:command("ponder")
            self:say("Perhaps you could be useful to me after all.")
            return true
        end
    else
        self:say("Come to steal my books again?!  You will not learn the art of resurrection by arcane magic.  You will only become an abomination like myself.  Go seek out the divine arts.")
        wait(2)
        self:say("NOW LEAVE OR ATTACK ME, IF YOU DARE!")
    end
end