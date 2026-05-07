-- Trigger: Firework being taken
-- Zone: 615, ID: 97
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #61597

-- Converted from DG Script #61597: Firework being taken
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
if globals.burning == 1 then
    _return_value = true
    -- TODO(parity): Original used DG damage_dealt sentinel to detect
    -- when an actor's fire-immunity reduced damage to zero. Until the
    -- Rust API exposes the dealt amount, we emit the burn message
    -- unconditionally and trust the engine to gate damage.
    local dmg = actor:damage(2, "fire") or 2
    self.room:send_except(actor, tostring(actor.name) .. " tries to take " .. tostring(self.shortdesc) .. ", but burns " .. tostring(actor.hisher) .. " fingers! (<red>" .. tostring(dmg) .. "</>)")
    actor:send("Ouch!! You burnt your fingers on " .. tostring(self.shortdesc) .. "! (<red>" .. tostring(dmg) .. "</>)")
else
    _return_value = false
    globals.on_ground = 0
end
return _return_value