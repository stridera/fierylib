-- Trigger: resurrection_talisman_replacement
-- Zone: 85, ID: 61
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8561

-- Converted from DG Script #8561: resurrection_talisman_replacement
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: I need a new talisman
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "i") or string.find(string.lower(speech), "need") or string.find(string.lower(speech), "a") or string.find(string.lower(speech), "new") or string.find(string.lower(speech), "talisman")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("resurrection_quest") > 4 then
    self:command("grumble")
    wait(1)
    self:say("I said not to lose that!")
    wait(2)
    actor:set_quest_var("resurrection_quest", "new", "yes")
    self.room:send(tostring(self.name) .. " says, 'Go harass Ziijhan again and maybe I'll consider giving you")
    self.room:send("</>another.'")
end