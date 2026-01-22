-- Trigger: Firework being taken
-- Zone: 615, ID: 97
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #61597

-- Converted from DG Script #61597: Firework being taken
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
if burning == 1 then
    _return_value = false
    actor:damage(2)  -- type: fire
    if damage_dealt ~= 0 then
        self.room:send_except(actor, tostring(actor.name) .. " tries to take " .. tostring(self.shortdesc) .. ", but burns " .. tostring(actor.possessive) .. " fingers! (<red>" .. tostring(damage_dealt) .. "</>)")
        actor:send("Ouch!! You burnt your fingers on " .. tostring(self.shortdesc) .. "! (<red>" .. tostring(damage_dealt) .. "</>)")
    else
        actor:send("An angry smoke pixie comes out of nowhere and kicks " .. tostring(self.shortdesc) .. " away from your grubby, grabby fingers.")
        self.room:send_except(actor, tostring(actor.name) .. " reaches for " .. tostring(self.shortdesc) .. ", but a smoke pixie swoops down and kicks it away!")
    end
else
    _return_value = true
    local on_ground = 0
    globals.on_ground = globals.on_ground or true
end
return _return_value