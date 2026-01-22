-- Trigger: dark_robed_artifacts
-- Zone: 590, ID: 9
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #59009

-- Converted from DG Script #59009: dark_robed_artifacts
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: artifacts?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "artifacts?")) then
    return true  -- No matching keywords
end
wait(4)
local stage = 1
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
        if person:get_quest_var("sacred_haven:given_light") == 1 and person.alignment <= -350 then
            local continue = "yes"
            person.name:set_quest_var("sacred_haven", "find_blood", 1)
            if person:get_quest_stage("sacred_haven") == "stage" then
                person.name:advance_quest("sacred_haven")
                person:send("<b:white>You have advanced the quest!</>")
            end
        end
    elseif person then
        local i = i + 1
    end
    local a = a + 1
end
if continue then
    actor:send(tostring(self.name) .. " whispers to you, 'I had a vial of dragon's blood, a trinket of tattered leather, and a small shadow forged earring stolen from me.  They are held somewhere inside the Sacred Haven.'")
    wait(6)
    actor:send(tostring(self.name) .. " whispers to you, 'Once you find them all, I can meld two of them together to form a reward for you.'")
    wait(2)
    actor:send(tostring(self.name) .. " whispers to you, 'You will find a prisoner who is an ally of mine, and he might be able to help you.'")
    wait(6)
    actor:send(tostring(self.name) .. " tells you, 'Ask me <b:white>[what am I doing?]</> if you forget.'")
    wait(1)
    self:whisper(actor, "Now hurry, I need the items I have lost.")
end