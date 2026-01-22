-- Trigger: RoomForSwordDeath
-- Zone: 125, ID: 31
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12531

-- Converted from DG Script #12531: RoomForSwordDeath
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: automagic_trigger_from_12532
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "automagic_trigger_from_12532")) then
    return true  -- No matching keywords
end
self.room:spawn_object(125, 27)
wait(1)
self.room:send("The dancing sword falls to the ground, lifeless.")