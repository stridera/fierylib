-- Trigger: tempest_reset_quest
-- Zone: 238, ID: 14
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #23814

-- Converted from DG Script #23814: tempest_reset_quest
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: SecretCommandToResetQuest
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "secretcommandtoresetquest")) then
    return true  -- No matching keywords
end
self.room:find_actor("tempest-manifest"):destroy_item("blue-flame")
local has_flame = 0
globals.has_flame = globals.has_flame or true