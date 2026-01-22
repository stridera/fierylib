-- Trigger: Room 1888 - massive harming
-- Zone: 18, ID: 2
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1802

-- Converted from DG Script #1802: Room 1888 - massive harming
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: (This script automatically called from mob 1850 in trigger 1801)
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "(this") or string.find(string.lower(speech), "script") or string.find(string.lower(speech), "automatically") or string.find(string.lower(speech), "called") or string.find(string.lower(speech), "from") or string.find(string.lower(speech), "mob") or string.find(string.lower(speech), "1850") or string.find(string.lower(speech), "in") or string.find(string.lower(speech), "trigger") or string.find(string.lower(speech), "1801)")) then
    return true  -- No matching keywords
end
local person = self.people
while person do
    local next = person.next_in_room
    if person.id == -1 then
        person:damage(100)  -- type: physical
    end
    local person = next
end