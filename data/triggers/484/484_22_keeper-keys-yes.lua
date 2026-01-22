-- Trigger: keeper-keys-yes
-- Zone: 484, ID: 22
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #48422

-- Converted from DG Script #48422: keeper-keys-yes
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
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
        if not person:get_quest_stage("doom_entrance") then
            person.name:start_quest("doom_entrance")
            local begin = 1
            person:send("<b:white>You have begun the quest to enter Lokari's Keep!</>")
        end
    elseif person then
        local i = i + 1
    end
    local a = a + 1
end
if begin then
    wait(2)
    self:command("bow " .. tostring(actor.name))
    self.room:send(tostring(self.name) .. " says, 'Then go ask the Oracle of the Hunt if you can prove your worth.'")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'When you have proved yourself to all three Oracles, please come see me again.'")
end  -- auto-close block