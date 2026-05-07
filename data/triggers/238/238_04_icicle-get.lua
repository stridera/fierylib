-- Trigger: icicle-get
-- Zone: 238, ID: 4
-- Type: OBJECT, Flags: GET
--
-- Picking up the icicle deals cold damage to the actor's hands,
-- except for the invisible stalker (238:14) and ethereal stalker (238:15)
-- who are immune.
if not (actor.zone_id == 238 and (actor.local_id == 14 or actor.local_id == 15)) then
    wait(1)
    actor:damage(50)  -- type: cold
    if damage_dealt > 0 then
        actor:send("The icicle freezes your fingers. (<blue>" .. tostring(damage_dealt) .. "</>)")
    end
end
