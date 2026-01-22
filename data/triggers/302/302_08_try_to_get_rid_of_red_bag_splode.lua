-- Trigger: Try to get rid of red bag, splode
-- Zone: 302, ID: 8
-- Type: OBJECT, Flags: DROP, GIVE
-- Status: CLEAN
--
-- Original DG Script: #30208

-- Converted from DG Script #30208: Try to get rid of red bag, splode
-- Original: OBJECT trigger, flags: DROP, GIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Makes the red leather bag explode when you try to drop or give it.
-- Applied to: o30209
_return_value = false
self.room:send_except(actor, tostring(actor.alias) .. " tries to let go of " .. tostring(self.shortdesc) .. ", but it suddenly <b:red>explodes!</>")
actor:send("As you release " .. tostring(self.shortdesc) .. ", it suddenly <b:red>explodes!</>")
local damage = actor.level * 3 + random(1, 19)
local damage_dealt = actor:damage(damage)  -- type: slash
if damage_dealt == 0 then
    self.room:send_except(actor, "Shards of metal fly right by " .. tostring(actor.name) .. "!")
    actor:send("Shards of metal fly by!  Luckily, none of them hit you!")
else
    self.room:send_except(actor, "Shards of metal hit " .. tostring(actor.alias) .. " in the legs, causing serious wounds! (<red>" .. tostring(damage_dealt) .. "</>)")
    actor:send("OUCH!  The shards cut your legs painfully! (<red>" .. tostring(damage_dealt) .. "</>)")
end
world.destroy(self)
return _return_value