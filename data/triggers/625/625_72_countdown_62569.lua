-- Trigger: countdown 62569
-- Zone: 625, ID: 72
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #62572

-- Converted from DG Script #62572: countdown 62569
-- Original: OBJECT trigger, flags: WEAR, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end
local maxcharge = 1
local delay = 200
globals.maxcharge = globals.maxcharge or true
globals.delay = globals.delay or true
if charges > 0 then
    local charges = charges - 1
    globals.charges = globals.charges or true
    self.room:send(tostring(self.shortdesc) .. " flashes brightly.")
    self.room:spawn_mobile(625, 69)
    self.room:find_actor("purity"):spawn_object(489, 28)
    self.room:find_actor("purity"):command("recite scroll " .. tostring(actor))
    world.destroy(self.room:find_object("purity"))
    local ready = 0
    globals.ready = globals.ready or true
else
    actor:send(tostring(self.shortdesc) .. "'s power is momentarily exhausted.")
end