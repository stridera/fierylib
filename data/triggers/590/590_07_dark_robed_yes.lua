-- Trigger: dark_robed_yes
-- Zone: 590, ID: 7
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #59007

-- Converted from DG Script #59007: dark_robed_yes
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
wait(3)
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
        if person.alignment <= -350 then
            local continue = "yes"
            if not person:get_quest_stage("sacred_haven") then
                person.name:start_quest("sacred_haven")
                person:send("<b:white>You have begun the Sacred Haven quest!</>")
            end
        end
    elseif person then
        local i = i + 1
    end
    local a = a + 1
end
if continue then
    actor:send(tostring(self.name) .. " steps in closer towards you and rests his hand on your shoulder.")
    self.room:send_except(actor, tostring(self.name) .. " steps in closer towards " .. tostring(actor.name) .. " and rests its hand on " .. tostring(actor.possessive) .. " shoulder.")
    wait(6)
    actor:send(tostring(self.name) .. " tells you, 'Bring me an adornment of light from one of the sanctuary priests and I will be convinced that you are capable enough that my key will not be wasted.'")
    wait(6)
    actor:send(tostring(self.name) .. " tells you, 'Ask me <b:white>[what am I doing?]</> if you forget.'")
    wait(9)
    self.room:send(tostring(self.name) .. " says, 'Now be gone with you, and hurry before they destroy my artifacts.'")
end