-- Trigger: creeping_doom_pixie_speech
-- Zone: 615, ID: 52
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #61552

-- Converted from DG Script #61552: creeping_doom_pixie_speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
wait(2)
if string.find(actor.class, "Druid") and actor:get_quest_stage("creeping_doom") == 0 and actor.level > 80 then
    self:command("grin")
    actor.name:start_quest("creeping_doom")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'This spell sends a carpet of living death made out of")
    self.room:send("</>Nature's Rage and Doom at your enemies and makes it EAT THEIR FACES OFF.  It's")
    self.room:send("</>unbridled and horrible, but needs very careful preparation.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'First, we choose violence and find symbols of")
    self.room:send("</>Nature's Rage.'")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Bring back a <green>cutting of the deadly vines</> on Mist")
    self.room:send("</>Mountain.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Also, bring a <red>ruby scarab</> and a <b:green>ceramic green spider</>'")
    self.room:send("</>because bug foci are sweet.'")
    -- (empty room echo)
    self:say("Both're in different monuments to the dead.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'If you need, you can check your <b:white>[progress]</> with me.'")
elseif actor:get_quest_stage("creeping_doom") == 4 then
    if actor:has_item("61518") then
        actor:send("<b:green>You already have " .. tostring(objects.template(615, 18).name) .. "!</>")
    else
        self.room:spawn_object(615, 18)
        self:command("give essence-natures-vengeance " .. tostring(actor.name))
        self:say("Be careful with it this time!")
    end
end