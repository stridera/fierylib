-- Trigger: tr'ven(replace old items)
-- Zone: 87, ID: 96
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #8796
--
-- TODO(parity): legacy DG conditional `if %object.vnum% >= 1` was a guard against
-- nil objects. Modern API receives `object` directly; the guard kept here is
-- effectively `if object` which is always true within RECEIVE handlers.

-- Converted from DG Script #8796: tr'ven(replace old items)
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if object then
    local zone = object.zone_id
    local local_id = object.local_id
    local name = object.shortdesc
    wait(1)
    self:say(tostring(name) .. "?")
    world.destroy(object)
    wait(1)
    self:say("Yes, I think I can make " .. tostring(name) .. " as good as new.")
    self.room:spawn_object(zone, local_id)
    wait(1)
    actor:send("<blue>The air shudders as Tr'ven mutters a few words over " .. tostring(name) .. ".</>")
    self.room:send_except(actor, "The air shudders as Tr'ven mutters a few words over " .. tostring(name) .. ".")
    wait(1)
    self:emote("holds up " .. tostring(name) .. " and smiles at a job well done.")
    wait(2)
    self:command("give all " .. tostring(actor.name))
end
