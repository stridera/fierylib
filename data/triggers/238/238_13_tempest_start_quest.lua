-- Trigger: tempest_start_quest
-- Zone: 238, ID: 13
-- Type: WORLD, Flags: SPEECH
--
-- Run-from-other-trigger entry point (mage_speak2 fires this in the Tempest's
-- room via run_room_trigger). Spawns the quest blue-flame on the Tempest and
-- has it hold the flame, but only once per zone reset.

-- Speech keywords: SecretCommandToStartQuest
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "secretcommandtostartquest") then
    return true  -- No matching keywords
end
if not globals.has_flame then
    local tempest = self.room:find_actor("tempest-manifest")
    tempest:spawn_object(238, 22)
    tempest:command("hold blue-flame")
    globals.has_flame = true
end
