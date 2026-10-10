-- Trigger: ambush
-- Zone: 87, ID: 10
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #8710
--
-- TODO(parity): legacy DG script appears to be a debug/stub ("checking..", "proc")
-- with no real ambush behavior. Body needs to be rewritten from design intent
-- (probably: low chance to spawn bandits when dragging, similar to #8702).

-- Converted from DG Script #8710: ambush
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: drag
if not (cmd == "drag") then
    return true  -- Not our command
end
self.room:send("checking..")
if random(1, 10) < 2 then
    self.room:send("proc")
end
