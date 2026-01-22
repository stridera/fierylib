-- Trigger: test trigger
-- Zone: 43, ID: 97
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4397

-- Converted from DG Script #4397: test trigger
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: run
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "run")) then
    return true  -- No matching keywords
end
local person = actor
self.room:send("person is " .. tostring(person.name))
local i = person.group_size
self.room:send("group size is " .. tostring(person.group_size))
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    self.room:send("we are in the while loop")
    local person = actor.group_member[a]
    self.room:send("actor.group_member[a] is " .. tostring(person.name))
    if person.room == self.room then
        self.room:send("Person is in the room")
    elseif person then
        local i = i + 1
        self.room:send("Person is not in the room")
    end
    local a = a + 1
    self.room:send("Evaluating a")
end
self.room:send("done")