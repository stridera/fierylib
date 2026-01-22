-- Trigger: tempest_start_quest
-- Zone: 238, ID: 13
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #23813

-- Converted from DG Script #23813: tempest_start_quest
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: SecretCommandToStartQuest
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "secretcommandtostartquest")) then
    return true  -- No matching keywords
end
if not has_flame then
    self.room:find_actor("tempest-manifest"):spawn_object(238, 22)
    self.room:find_actor("tempest-manifest"):command("hold blue-flame")
    local has_flame = 1
    globals.has_flame = globals.has_flame or true
end