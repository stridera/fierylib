-- Trigger: fountain_whisper
-- Zone: 18, ID: 3
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1803

-- Converted from DG Script #1803: fountain_whisper
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: drink
if not (cmd == "drink") then
    return true  -- Not our command
end
if random(1, 100) > 75 then
    self.room:send("The wind whispers, 'Please... help us!'")
end
return true