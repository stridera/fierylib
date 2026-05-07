-- Trigger: supernova_status_checker
-- Zone: 62, ID: 14
-- Type: MOB, Flags: SPEECH
--
-- "Progress" check on the Pyromancer guildmaster: tells the questor what to
-- do next based on their current supernova stage.
--
-- Original DG Script: #6214

if not string.find(string.lower(speech), "progress") then
    return true
end
local stage = actor:get_quest_stage("supernova")
wait(2)
if stage == 1 then
    self:say("You are trying to find one of Phayla's lamps.")
elseif stage == 2 then
    self:say("Have you found one of Phayla's lamps?")
elseif stage == 3 then
    self.room:send(tostring(self.name) .. " says, 'Phayla likes to visit the material plane to engage")
    self.room:send("</>in her favorite leisure activities.'")
    wait(2)
    local step3 = actor:get_quest_var("supernova:step3")
    if step3 == 4318 then
        self.room:send(tostring(self.name) .. " says, 'Recently, she was spotted in Anduin, taking in a")
        self.room:send("</>show from the best seat in the house.'")
    elseif step3 == 10316 then
        self.room:send(tostring(self.name) .. " says, 'I understand she frequents the hottest spring at")
        self.room:send("</>the popular resort up north.'")
    elseif step3 == 58062 then
        self.room:send(tostring(self.name) .. " says, 'She occasionally visits a small remote island")
        self.room:send("</>theatre, where she enjoys meditating in their reflecting room.'")
    end
    wait(2)
    self:say("You may be able to find a clue to her whereabouts there.")
elseif stage >= 4 then
    self.room:send(tostring(self.name) .. " says, 'Consult the clues Phayla left behind!")
    self.room:send("</>Be sure to <b:white>look</> at them by the light of your lamp!'")
end
return true