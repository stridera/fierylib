-- Trigger: eldest_speak3
-- Zone: 490, ID: 48
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49048

-- Converted from DG Script #49048: eldest_speak3
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"weapon", "weapon?", "oak", "oak?", "items", "items?", "dagon", "dagon?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
local person = actor
local i = person.group_size
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    person = person.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("griffin_quest") == 0 then
            person:start_quest("griffin_quest")
            person:send("<b:white>You have begun the Griffin Isle quest!</>")
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end
self:say("Yes, a branch was taken from the holy oak with a mystic sword.  It was bound for the island aboard the St. Marvin, but the ship was lost in a storm.")
wait(2)
self:say("If only those sacred implements could be recovered, we may be able to finally move against the cult...  The island hermit may know more.")