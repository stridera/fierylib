-- Trigger: curse item
-- Zone: 625, ID: 75
-- Type: OBJECT, Flags: CAST
-- Status: CLEAN
--
-- Original DG Script: #62575

-- Converted from DG Script #62575: curse item
-- Original: OBJECT trigger, flags: CAST, probability: 100%
--
-- TODO(parity): The legacy DG check was `if !DROP / !` (i.e. the item is
-- still flagged NODROP — the curse is intact). The converter rendered
-- this as `object:get_flagged("not DROP")` which is a bare DG remnant.
-- Replace with the runtime's NODROP flag check once the canonical name
-- is settled.
self.room:send("<red>" .. tostring(actor.name) .. "'s spell attempts to disrupt " .. tostring(self.shortdesc) .. "'s cursed nature.</>")
wait(1)
if self:get_flagged("NODROP") then
    self.room:send("<red>" .. tostring(self.shortdesc) .. " is undiminished by " .. tostring(actor.name) .. "'s spell.</>")
else
    self.room:send("<red>" .. tostring(self.shortdesc) .. " turns to ashes, no longer held together by the Pit Fiends curse.</>")
    self.room:send(tostring(self.shortdesc) .. " crumbles to dust and blows away.</>")
    world.destroy(self)
end