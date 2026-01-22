-- Trigger: pasty_speak1
-- Zone: 481, ID: 26
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48126

-- Converted from DG Script #48126: pasty_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: help aid yes friend
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "help") or string.find(string.lower(speech), "aid") or string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "friend")) then
    return true  -- No matching keywords
end
wait(2)
self.room:send(tostring(self.name) .. " says, 'Not long after I escaped in here, I met someone who had been changed into a pile of rock.'")
wait(2)
self:command("frown")
self.room:send(tostring(self.name) .. " says, 'It was strange though, it must have been Vulcera, but he never said a word against her.'")
wait(1)
self:command("shrug")
self:emote("waves a bloody piece of paper in your face.")
self.room:send(tostring(self.name) .. " says, 'This was a spell of reversal to help him, but now I have no idea where he is.  Perhaps the wise woman will give you a spell too and we can search faster.'")
local stage = 1
local person = actor
local i = person.group_size
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    local person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("fieryisle_quest") == "stage" then
            person.name:advance_quest("fieryisle_quest")
            person:send("<b:white>You have advanced your quest!</>")
        end
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end