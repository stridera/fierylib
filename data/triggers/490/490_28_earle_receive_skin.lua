-- Trigger: Earle receive skin
-- Zone: 490, ID: 28
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #49028

-- Converted from DG Script #49028: Earle receive skin
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (49001): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 490 and object.id == 1)
) then
    return true
end

-- griffin skin given
self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
self:emote("grimaces a bit as he accepts " .. tostring(object.shortdesc) .. ".")
self:say("An ugly thing, is it not?  It must be utterly destroyed, for it carries Dagon's taint and stench wherever it goes.")
self:say("Take it to Awura.  She will know how to deal with it.")
self:emote("lifts " .. tostring(object.shortdesc) .. " on one finger, and hands it back.")
actor:send("<b:white>You have advanced the quest!</>")
actor:send("<b:white>Group credit will not be given when delivering the skin to Awura.</>")
return false  -- legacy return 0: the giver keeps the item
