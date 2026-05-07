-- Trigger: dark_robed_yes
-- Zone: 590, ID: 7
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #59007

-- Converted from DG Script #59007: dark_robed_yes
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "yes") then
    return true  -- No matching keywords
end
wait(3)
-- Walk the speaker's group; start the Sacred Haven quest for any evil-aligned
-- members co-located with the dark adept. Continue with the dialogue if at
-- least one member qualifies (matches the speaker's own group).
local continue = false
for _, person in ipairs(actor.group or { actor }) do
    if person.room == self.room and person.alignment <= -350 then
        continue = true
        if not person:get_quest_stage("sacred_haven") then
            person:start_quest("sacred_haven")
            person:send("<b:white>You have begun the Sacred Haven quest!</>")
        end
    end
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