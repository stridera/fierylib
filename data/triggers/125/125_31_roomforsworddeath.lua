-- Trigger: RoomForSwordDeath
-- Zone: 125, ID: 31
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12531

-- Converted from DG Script #12531: RoomForSwordDeath
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- TODO(parity): legacy used a synthetic speech keyword to chain from #12530 (sword death).
-- The new convention is run_room_trigger(125, 31), which bypasses the speech keyword guard.
-- For now, only enforce the keyword guard if `speech` is actually populated.
if speech and speech ~= "" then
    local speech_lower = string.lower(speech)
    if not string.find(speech_lower, "automagic_trigger_from_12532") then
        return true  -- No matching keywords
    end
end
self.room:spawn_object(125, 27)
wait(1)
self.room:send("The dancing sword falls to the ground, lifeless.")