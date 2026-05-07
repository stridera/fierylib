-- Trigger: resurrection_talisman_replacement
-- Zone: 85, ID: 61
-- Type: MOB, Flags: SPEECH
--
-- Player on the resurrection quest says the magic phrase asking Norisent
-- for a new death talisman. Sets the "new" quest var so 085_50's GREET
-- hands one out next time the player returns to him.
--
-- Original DG Script: #8561

-- Converted from DG Script #8561: resurrection_talisman_replacement
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keyword: full phrase "i need a new talisman"
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "i need a new talisman") then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("resurrection_quest") > 4 then
    self:command("grumble")
    wait(1)
    self:say("I said not to lose that!")
    wait(2)
    actor:set_quest_var("resurrection_quest", "new", "yes")
    self.room:send(tostring(self.name) .. " says, 'Go harass Ziijhan again and maybe I'll consider giving you another.'")
end