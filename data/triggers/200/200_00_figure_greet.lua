-- Trigger: figure_greet
-- Zone: 200, ID: 0
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #20000

-- Converted from DG Script #20000: figure_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 then
    if direction == "west" then
        wait(1)
        self:command("roar " .. tostring(actor.name))
        self:say("Are you friend or foe of Ruin Wormheart?")
        self:command("glare " .. tostring(actor.name))
    end  -- auto-close block
end  -- auto-close block