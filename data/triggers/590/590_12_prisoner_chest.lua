-- Trigger: prisoner_chest
-- Zone: 590, ID: 12
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #59012

-- Converted from DG Script #59012: prisoner_chest
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: chest?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "chest?")) then
    return true  -- No matching keywords
end
wait(4)
local stage = 2
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
        if person:get_quest_stage("sacred_haven") >= stage then
            local continue = "yes"
            person.name:set_quest_var("sacred_haven", "find_key", 1)
            person:send("<b:white>You have advanced the quest!</>")
        end
    elseif person then
        local i = i + 1
    end
    local a = a + 1
end
if continue then
    actor:send(tostring(self.name) .. " whispers to you, 'Yes, I swiped the key for the chest off of one of the guards before I was confined, and hid it in the courtyard.'")
    wait(2)
    self:say("Now I must go, since I have been freed.")
    wait(3)
    self:emote("leaves east.")
    self:teleport(get_room(590, 91))
    world.destroy(self)
end