-- Trigger: jemnon_speak2
-- Zone: 482, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48203

-- Converted from DG Script #48203: jemnon_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: rock monster stone guardian demon
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "rock") or string.find(string.lower(speech), "monster") or string.find(string.lower(speech), "stone") or string.find(string.lower(speech), "guardian") or string.find(string.lower(speech), "demon")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("meteorswarm") == 1 then
    actor:send(tostring(self.name) .. " says, 'Itsss made outta rocks!  So much rocks!  A rack MONSTER!'")
    wait(1)
    self:emote("looks confused.")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Nuuuuuhhh a ROOK mahnster!'")
    wait(1)
    self:command("shake")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Uuuuhhhhhh ROCK monster!  Yeah, a rock monster.  Terrible place I saw it.'")
end