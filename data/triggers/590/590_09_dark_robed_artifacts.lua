-- Trigger: dark_robed_artifacts
-- Zone: 590, ID: 9
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #59009

-- Converted from DG Script #59009: dark_robed_artifacts
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: artifacts?
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "artifacts?") then
    return true  -- No matching keywords
end
wait(4)
-- Walk the speaker's group; for any evil-aligned member that already gave the
-- adornment of light, mark them as searching for blood and advance the quest
-- if they're still on stage 1.
local continue = false
for _, person in ipairs(actor.group or { actor }) do
    if person.room == self.room and person:get_quest_var("sacred_haven:given_light") == 1 and person.alignment <= -350 then
        continue = true
        person:set_quest_var("sacred_haven", "find_blood", 1)
        if person:get_quest_stage("sacred_haven") == 1 then
            person:advance_quest("sacred_haven")
            person:send("<b:white>You have advanced the quest!</>")
        end
    end
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