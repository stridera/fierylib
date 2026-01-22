-- Trigger: archon_sceptre_wield
-- Zone: 22, ID: 19
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #2219

-- Converted from DG Script #2219: archon_sceptre_wield
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
if actor.id == -1 then
    wait(1)
    if string.find(actor.class, "Anti") then
        actor:send("You feel a great surge of power rush through your body.")
        self.room:send_except(actor, "The eyes of " .. tostring(actor.name) .. " begin to burn brightly.")
        wait(1)
        self.room:send_except(actor, "Blackened horns protrude from atop the head of " .. tostring(actor.name) .. ".")
    else
        local dmg = random(1, 100)
        actor:send("Your mind is " .. tostring(actor.class) .. " by horrific images and a sense of extreme pain.")
        local dmg = dmg + 150
        local damage_dealt = actor:damage(dmg)  -- type: physical
        actor:command("remove sceptre")
        actor:command("drop sceptre")
    end
else
    wait(1)
    actor:send("You can't have the Sceptre of the Archon.  You're not worthy!")
    actor:command("remove sceptre")
    actor:command("drop sceptre")
end