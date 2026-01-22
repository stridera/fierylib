-- Trigger: icicle-get
-- Zone: 238, ID: 4
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #23804

-- Converted from DG Script #23804: icicle-get
-- Original: OBJECT trigger, flags: GET, probability: 100%
if actor.id ~= 23814 and actor.id ~= 23815 then
    wait(1)
    actor:damage(50)  -- type: cold
    if damage_dealt > 0 then
        actor:send("The icicle freezes your fingers. (<blue>" .. tostring(damage_dealt) .. "</>)")
    end
end