-- Trigger: test trigger
-- Zone: 43, ID: 97
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4397

-- Converted from DG Script #4397: test trigger
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"run"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local person = actor
self.room:send("person is " .. tostring(person.name))
local i = person.group_size
self.room:send("group size is " .. tostring(person.group_size))
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    self.room:send("we are in the while loop")
    local member = actor.group_member[a]
    self.room:send("actor.group_member[a] is " .. tostring(member and member.name))
    if member and member.room == self.room then
        self.room:send("Person is in the room")
    elseif member then
        i = i + 1
        self.room:send("Person is not in the room")
    end
    a = a + 1
    self.room:send("Evaluating a")
end
self.room:send("done")