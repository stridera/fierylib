-- Trigger: vulcera_dead
-- Zone: 481, ID: 43
-- Type: MOB, Flags: SPEECH, DEATH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #48143

-- Converted from DG Script #48143: vulcera_dead
-- Original: MOB trigger, flags: SPEECH, DEATH, probability: 100%

-- Speech keywords: run test
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "run") or string.find(string.lower(speech), "test")) then
    return true  -- No matching keywords
end
self.room:send("The ivory ring seems to shimmer for a second.")
if self.room ~= 48223 then
    self.room:teleport_all(get_room(482, 23))
    self.room:send("</>")
    self.room:send("<b:red>A burning hole erupts, sucking everything through it!</>")
    self.room:send("</>")
    local room = get_room("48223")
    local person = room.people
    while person do
        if person.id == -1 then
            -- person looks around
            local person = person.next_in_room
        end
    end
end
local person = actor
local i = actor.group_size
if i then
    local a = 1
else
    local a = 0
end
person = nil
while i >= a do
    local person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("fieryisle_quest") == 9 then
            person:set_quest_var("fieryisle_quest", "reward", "yes")
        end
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end
-- 
-- Complete Fiery Island
-- 
run_room_trigger(48145)