-- Trigger: reach_oven
-- Zone: 200, ID: 8
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #20008

-- Converted from DG Script #20008: reach_oven
-- Original: OBJECT trigger, flags: GET, probability: 100%
actor:damage(15)  -- type: fire
if damage_dealt ~= 0 then
    actor:send("As you reach into the oven your hand is suddenly burnt by the searing heat of the oven! (<red>" .. tostring(damage_dealt) .. "</>)")
    actor:send("But you still manage to retreive the bread.")
    self.room:send_except(actor, tostring(actor.name) .. " screams in pain as he reaches " .. tostring(actor.possessive) .. " hand into the oven.")
    self.room:send_except(actor, tostring(actor.name) .. " screams in pain as he reaches " .. tostring(actor.possessive) .. " hand into the oven. (<red>" .. tostring(damage_dealt) .. "</>)")
end