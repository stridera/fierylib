-- Trigger: rianne-quest-start
-- Zone: 103, ID: 3
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #10303

-- Converted from DG Script #10303: rianne-quest-start
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: yes yes?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "yes?")) then
    return true  -- No matching keywords
end
if actor.id == -1 and actor:get_quest_stage("resort_cooking") < 1 then
    actor.name:start_quest("resort_cooking")
    wait(5)
    self.room:send(tostring(self.name) .. " says, 'Excellent!  The dish I am making next is <b:white>Peach Cobbler</>.'")
    wait(2)
    self:say("I will need you to find the following ingredients for me:")
    self.room:send("- <b:white>" .. tostring(objects.template(615, 1).name) .. "</>")
    self.room:send("- <b:white>" .. tostring(objects.template(237, 54).name) .. "</>")
    self.room:send("- <b:white>" .. tostring(objects.template(31, 14).name) .. "</>")
    self.room:send("- <b:white>" .. tostring(objects.template(350, 1).name) .. "</>")
    wait(2)
    self:say("Bring them to me quickly so that I may begin!")
    self:command("wink " .. tostring(actor.name))
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Oh!  And you can look at my recipe wall at any time to")
    self.room:send("</>see what else we need.'")
end