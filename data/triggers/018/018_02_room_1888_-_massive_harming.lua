-- Trigger: Room 1888 - massive harming
-- Zone: 18, ID: 2
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1802

-- Converted from DG Script #1802: Room 1888 - massive harming
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Guard: speech may be nil when called programmatically from another trigger
if not speech then return true end

-- Speech keywords: (This script automatically called from mob 1850 in trigger 1801)
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "(this") or string.find(speech_lower, "script") or string.find(speech_lower, "automatically") or string.find(speech_lower, "called") or string.find(speech_lower, "from") or string.find(speech_lower, "mob") or string.find(speech_lower, "1850") or string.find(speech_lower, "in") or string.find(speech_lower, "trigger") or string.find(speech_lower, "1801)")) then
    return true  -- No matching keywords
end
-- Damage all players in the room
-- Note: self is a Room for WORLD triggers
for _, person in ipairs(self.actors) do
    if person.is_player then
        person:damage(100)
    end
end
