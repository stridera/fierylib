-- Trigger: holy_burn_the_wicked
-- Zone: 583, ID: 80
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #58380
-- Worn by paladins of high enough alignment: glows holy.
-- Worn by paladins below 750 alignment: forced to remove.
-- Worn by non-paladins: shakes / burns based on alignment, optionally damaging
-- evil wielders.

if actor.class == "Paladin" then
    if actor.alignment < 750 then
        wait(2)
        self.room:send("the holy blade of Godly vigor dulls in appearance.")
        actor:send("You are no longer holy enough to use this sacred weapon, you can no longer wield it.")
        self.room:send_except(actor, tostring(actor.name) .. "'s blade grows dull, unglowing.")
        actor:command("remove vigor")
    else  -- alignment >= 750
        wait(2)
        self.room:send("the holy blade of Godly vigor glows with a soft, white light.")
        actor:send("Your eyes widen with awe and splendor as you hold the holy blade of Godly vigor.")
        self.room:send_except(actor, tostring(actor.name) .. " is surrounded by a holy glow.")
    end
else  -- Non-paladin wielder
    if actor.alignment < -350 then
        wait(2)
        self.room:send("the holy blade of Godly vigor glows violently!")
        actor:send("The pain in your body is excruciating, you feel death.")
        local var_dam = random(1, 50) + 1517
        self.room:send_except(actor, tostring(actor.name) .. " convulses and life drains from his body. (<yellow>" .. tostring(var_dam) .. "</>)")
        actor:damage(var_dam)  -- type: physical
        -- Note: original DG warned this oforce can syserror if damage kills the victim.
        actor:command("remove vigor")
    else  -- alignment >= -350
        wait(2)
        self.room:send("the holy blade of Godly vigor vibrates unsteadily.")
        actor:send("This blade clearly is not happy to be in your hands.  Take care.")
        self.room:send_except(actor, tostring(actor.name) .. "'s hands shake unsteadily as he holds the blade.")
        actor:command("remove vigor")
    end
end