-- Trigger: rianne-quest-start
-- Zone: 103, ID: 3
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #10303
-- Player says "yes" near Rianne; if they have not yet started
-- the resort_cooking quest, kicks it off with the Peach Cobbler
-- recipe and lists the four ingredients.
-- DG narg=1 = word-boundary speech match (not a probability).

-- Speech keyword match: "yes"
local s = string.lower(speech)
if not (string.find(s, "yes") or string.find(s, "yes?")) then
    return true
end

if actor.is_player and actor:get_quest_stage("resort_cooking") < 1 then
    actor:start_quest("resort_cooking")
    wait(5)
    self.room:send(tostring(self.name) .. " says, 'Excellent!  The dish I am making next is <b:white>Peach Cobbler</>.'")
    wait(2)
    self:say("I will need you to find the following ingredients for me:")
    self.room:send("- <b:white>" .. tostring(objects.template(615, 1).name) .. "</>")
    self.room:send("- <b:white>" .. tostring(objects.template(237, 54).name) .. "</>")
    self.room:send("- <b:white>" .. tostring(objects.template(30, 114).name) .. "</>")
    self.room:send("- <b:white>" .. tostring(objects.template(350, 1).name) .. "</>")
    wait(2)
    self:say("Bring them to me quickly so that I may begin!")
    self:command("wink " .. tostring(actor.name))
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Oh!  And you can look at my recipe wall at any time to")
    self.room:send("</>see what else we need.'")
end