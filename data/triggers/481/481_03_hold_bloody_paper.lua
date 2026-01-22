-- Trigger: hold_bloody_paper
-- Zone: 481, ID: 3
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #48103

-- Converted from DG Script #48103: hold_bloody_paper
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
if actor.id == -1 then
    wait(4)
    actor:send("You feel a burning pain in your hand as the magic tries to activate.")
    actor:damage(50)  -- type: physical
    actor:send("You gasp in pain and drop the paper.")
    self.room:send_except(actor, tostring(actor.name) .. " gasps in pain and drops the paper.")
    actor:command("rem bloody-parchment")
    actor:command("drop bloody-parchment")
    wait(1)
    actor:send("The magic fails to activate, there is too much damage to the parchment.")
    self.room:send_except(actor, "The parchment glows for a second then fades.")
end