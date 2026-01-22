-- Trigger: exploding bag
-- Zone: 302, ID: 5
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #30205

-- Converted from DG Script #30205: exploding bag
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
-- Makes the red leather bag explode when taken, hurting just the person who took it.
-- Applied to: o30209
_return_value = false
self.room:send_except(actor, tostring(actor.alias) .. " reaches for " .. tostring(self.shortdesc) .. ", but it suddenly <b:red>explodes!</>")
actor:send("As you reach for " .. tostring(self.shortdesc) .. ", it suddenly <b:red>explodes!</>")
local damage = actor.level * 3 + random(1, 19)
local damage_dealt = actor:damage(damage)  -- type: slash
if damage_dealt == 0 then
    self.room:send_except(actor, "Shards of metal fly right by " .. tostring(actor.name) .. "!")
    actor:send("Shards of metal fly by!  Luckily, none of them hit you!")
else
    self.room:send_except(actor, "Shards of metal hit " .. tostring(actor.alias) .. " in the legs, causing serious wounds! (<red>" .. tostring(damage_dealt) .. "</>)")
    actor:send("<red>OUCH!</>  The shards cut your legs painfully! (<red>" .. tostring(damage_dealt) .. "</>)")
end
world.destroy(self)
return _return_value