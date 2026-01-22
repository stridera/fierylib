-- Trigger: eldest_speak3
-- Zone: 490, ID: 48
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49048

-- Converted from DG Script #49048: eldest_speak3
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: weapon weapon? oak oak? items items? dagon dagon?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "weapon") or string.find(string.lower(speech), "weapon?") or string.find(string.lower(speech), "oak") or string.find(string.lower(speech), "oak?") or string.find(string.lower(speech), "items") or string.find(string.lower(speech), "items?") or string.find(string.lower(speech), "dagon") or string.find(string.lower(speech), "dagon?")) then
    return true  -- No matching keywords
end
wait(2)
local person = actor
local i = person.group_size
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    local person = person.group_member[a]
    if person.room == self.room then
        if not person:get_quest_stage("griffin_quest") then
            person.name:start_quest("griffin_quest")
            person:send("<b:white>You have begun the Griffin Isle quest!</>")
        end
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end
self:say("Yes, a branch was taken from the holy oak with a mystic sword.  It was bound for the island aboard the St. Marvin, but the ship was lost in a storm.")
wait(2)
self:say("If only those sacred implements could be recovered, we may be able to finally move against the cult...  The island hermit may know more.")