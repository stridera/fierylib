-- Trigger: Try to drag exploding bag: bang
-- Zone: 302, ID: 6
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #30206

-- Makes the red leather bag explode if you try to drag it.
-- Applied to: o30209

-- Command filter: drag (must be the full word, not a prefix-match like 'd')
if cmd ~= "drag" then
    return true  -- Not our command
end
self.room:send_except(actor, tostring(actor.alias) .. " reaches for " .. tostring(self.shortdesc) .. ", but it suddenly <b:red>explodes!</>")
actor:send("As you reach for " .. tostring(self.shortdesc) .. ", it suddenly <b:red>explodes!</>")
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
return false  -- Block the drag command