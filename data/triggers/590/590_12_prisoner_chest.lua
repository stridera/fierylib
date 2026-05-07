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
-- Mark every co-located group member at quest stage >= 2 with find_key.
local continue = false
for _, person in ipairs(actor.group or { actor }) do
    if person.room == self.room and person:get_quest_stage("sacred_haven") >= 2 then
        continue = true
        person:set_quest_var("sacred_haven", "find_key", 1)
        person:send("<b:white>You have advanced the quest!</>")
    end
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