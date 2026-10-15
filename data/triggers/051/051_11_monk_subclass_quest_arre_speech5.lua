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

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"fiend?", "fiend", "fiends?", "fiends", "who", "who?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("monk_subclass") ~= 2 then
    return
end
self:command("sigh " .. actor.name)
actor:send(self.name .. " says, 'Yes, fiends.  The filthy thieves from the blistering sands in North Caelia.'")
self:command("shiver")
wait(0.1)
actor:send(self.name .. " says, 'Personally I enjoy much cooler weather, but they seem to manage themselves fine there.'")
wait(0.2)
self:command("grin")
actor:send(self.name .. " says, 'I would not mind seeing them vanish outright, however.'")
self:emote("sighs again.")
wait(0.1)
actor:send(self.name .. " says, 'Enough, I have grown tired of your company.  You bring back bad memories.'")
actor:advance_quest("monk_subclass")
self.room:send(self.name .. " dismisses you.")
local dest = get_room(580, 25)
self.room:teleport_all(dest)
for _, a in ipairs(dest.actors) do
    a:command("look")
end
self:teleport(get_room(580, 24))