-- Trigger: monk_subclass_quest_arre_speech5
-- Zone: 51, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5111

-- Converted from DG Script #5111: monk_subclass_quest_arre_speech5
-- Original: MOB trigger, flags: SPEECH, probability: 100%
--
-- "fiend(s)" / "who" keyword at stage 2 -- Arre tells the player about
-- the desert thieves, advances the quest to stage 3, dismisses the room
-- to 580/25, and herself returns to 580/24.

-- Speech keywords: fiend, fiends, who
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "fiend") or string.find(speech_lower, "who")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("monk_subclass") ~= 2 then
    return
end
self:command("sigh " .. actor.name)
actor:send(self.name .. " says, 'Yes, fiends.  The filthy thieves from the blistering sands in North Caelia.'")
self:command("shiver")
wait(1)
actor:send(self.name .. " says, 'Personally I enjoy much cooler weather, but they seem to manage themselves fine there.'")
wait(2)
self:command("grin")
actor:send(self.name .. " says, 'I would not mind seeing them vanish outright, however.'")
self:emote("sighs again.")
wait(1)
actor:send(self.name .. " says, 'Enough, I have grown tired of your company.  You bring back bad memories.'")
actor:advance_quest("monk_subclass")
self.room:send(self.name .. " dismisses you.")
local dest = get_room(580, 25)
self.room:teleport_all(dest)
for _, a in ipairs(dest.actors) do
    a:command("look")
end
self:teleport(get_room(580, 24))