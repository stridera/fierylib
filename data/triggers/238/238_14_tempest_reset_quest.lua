-- Trigger: tempest_reset_quest
-- Zone: 238, ID: 14
-- Type: WORLD, Flags: SPEECH
--
-- Run-from-other-trigger entry point (mage_receive / mage_speak3 wrong-answer
-- branch fires this in the Tempest's room). Removes the held blue-flame and
-- clears the global flag so a fresh tempest_start_quest can re-equip it.

-- Speech keywords: SecretCommandToResetQuest
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "secretcommandtoresetquest") then
    return true  -- No matching keywords
end
self.room:find_actor("tempest-manifest"):destroy_item("blue-flame")
globals.has_flame = false
