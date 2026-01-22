-- Trigger: tr'ven(replace old items)
-- Zone: 87, ID: 96
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #8796

-- Converted from DG Script #8796: tr'ven(replace old items)
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if object.id => 1 then
    local item = object.id
    local name = object.shortdesc
    wait(1)
    self:say(tostring(name) .. "?")
    world.destroy(object)
    wait(1)
    self:say("Yes, I think I can make " .. tostring(name) .. " as good as new.")
    self.room:spawn_object(vnum_to_zone(item), vnum_to_local(item))
    wait(1)
    actor:send("<blue>The air shudders as Tr'ven mutters a few words over " .. tostring(name) .. ".</>")
    self.room:send_except(actor, "The air shudders as Tr'ven mutters a few words over " .. tostring(name) .. ".")
    wait(1)
    self:emote("holds up " .. tostring(name) .. " and smiles at a job well done.")
    wait(2)
    self:command("give all " .. tostring(actor))
end