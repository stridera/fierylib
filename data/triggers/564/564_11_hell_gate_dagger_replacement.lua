-- Trigger: hell_gate_dagger_replacement
-- Zone: 564, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #56411

-- Converted from DG Script #56411: hell_gate_dagger_replacement
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: I need a new dagger
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "i") or string.find(string.lower(speech), "need") or string.find(string.lower(speech), "a") or string.find(string.lower(speech), "new") or string.find(string.lower(speech), "dagger")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("hell_gate") == 3 then
    actor:set_quest_var("hell_gate", "new", "yes")
    self:command("grumble")
    self.room:send(tostring(self.name) .. " says, 'I don't have another.  You'll have to find a")
    self.room:send("</>replacement.'")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'If you can find another, I will verify it")
    self.room:send("</>will work.'")
end