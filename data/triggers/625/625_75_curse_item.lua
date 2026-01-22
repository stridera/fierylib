-- Trigger: curse item
-- Zone: 625, ID: 75
-- Type: OBJECT, Flags: CAST
-- Status: CLEAN
--
-- Original DG Script: #62575

-- Converted from DG Script #62575: curse item
-- Original: OBJECT trigger, flags: CAST, probability: 100%
self.room:send("<red>" .. tostring(actor.name) .. "'s spell attempts to disrupt " .. tostring(self.shortdesc) .. "'s cursed nature.</>")
wait(1)
if object:get_flagged("not DROP") then
    self.room:send("<red>" .. tostring(self.shortdesc) .. " is undiminished by " .. tostring(actor.name) .. "'s spell.</>")
else
    self.room:send("<red>" .. tostring(self.shortdesc) .. " turns to ashes, no longer held together by the Pit Fiends curse.</>")
    self.room:send(tostring(self.shortdesc) .. " crumbles to dust and blows away.</>")
    world.destroy(self)
end