-- Trigger: Injured halfling help
-- Zone: 125, ID: 45
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #12545

-- Converted from DG Script #12545: Injured halfling help
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes Yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "yes")) then
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
        if person:get_quest_stage("krisenna_quest") < 2 then
            local instruct = 1
            if not person:get_quest_stage("krisenna_quest") then
                person.name:start_quest("krisenna_quest")
                person:send("<b:white>You have now begun the Tower in the Wastes quest!</>")
            end
        end
    elseif person then
        local i = i + 1
    end
    local a = a + 1
end
if instruct then
    self.room:send(tostring(self.name) .. "'s eyes brighten.")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'If you find him, tell him his brother is looking for him.'")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'If you need an update, you can check your <b:cyan>[progress]</> with me.'")
end