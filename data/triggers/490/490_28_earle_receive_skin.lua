-- Trigger: Earle receive skin
-- Zone: 490, ID: 28
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #49028

-- Converted from DG Script #49028: Earle receive skin
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- griffin skin given
_return_value = false
self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
wait(2)
self:emote("grimaces a bit as he accepts " .. tostring(object.shortdesc) .. ".")
wait(4)
self:say("An ugly thing, is it not?  It must be utterly destroyed, for it carries Dagon's taint and stench wherever it goes.")
wait(8)
self:say("Take it to Awura.  She will know how to deal with it.")
self:emote("lifts " .. tostring(object.shortdesc) .. " on one finger, and hands it back.")
actor:send("<b:white>You have advanced the quest!</>")
actor:send("<b:white>Group credit will not be given when delivering the skin to Awura.</>")
return _return_value