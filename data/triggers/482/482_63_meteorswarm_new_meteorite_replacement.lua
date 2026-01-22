-- Trigger: meteorswarm_new_meteorite_replacement
-- Zone: 482, ID: 63
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48263

-- Converted from DG Script #48263: meteorswarm_new_meteorite_replacement
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: I lost the meteorite
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "i") or string.find(string.lower(speech), "lost") or string.find(string.lower(speech), "the") or string.find(string.lower(speech), "meteorite")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("meteorswarm") > 2 and not actor:get_quest_var("meteorswarm:air") then
    wait(2)
    self:command("gasp")
    actor:send(tostring(self.name) .. " says, 'WHAT?!'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'How could you be so careless??''")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'You have no choice, you have to get a new meteorite.'")
    actor:set_quest_var("meteorswarm", "new", "yes")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You already know where the rock demon is.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Good luck.'")
end