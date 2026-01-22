-- Trigger: monk_subclass_quest_arre_speech5
-- Zone: 51, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5111

-- Converted from DG Script #5111: monk_subclass_quest_arre_speech5
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: fiend? fiends? who who? fiend fiends
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "fiend?") or string.find(string.lower(speech), "fiends?") or string.find(string.lower(speech), "who") or string.find(string.lower(speech), "who?") or string.find(string.lower(speech), "fiend") or string.find(string.lower(speech), "fiends")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("monk_subclass") == 2 then
    self:command("sigh " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Yes, fiends.  The filthy thieves from the blistering sands in North Caelia.'")
    self:command("shiver")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Personally I enjoy much cooler weather, but they seem to manage themselves fine there.'")
    wait(2)
    self:command("grin")
    actor:send(tostring(self.name) .. " says, 'I would not mind seeing them vanish outright, however.'")
    self:emote("sighs again.")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Enough, I have grown tired of your company.  You bring back bad memories.'")
    actor.name:advance_quest("monk_subclass")
    self.room:send(tostring(self.name) .. " dismisses you.")
    self.room:teleport_all(get_room(580, 25))
    self.room:find_actor("all"):command("look")
    self:teleport(get_room(580, 24))
end