-- Trigger: quest_wug_magistrate
-- Zone: 30, ID: 32
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3032

-- Converted from DG Script #3032: quest_wug_magistrate
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: power something what found
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "power") or string.find(string.lower(speech), "something") or string.find(string.lower(speech), "what") or string.find(string.lower(speech), "found")) then
    return true  -- No matching keywords
end
wait(2)
if actor.level < 30 then
    self:command("nod")
    actor:send(tostring(self.name) .. " tells you, 'They have discovered a secret chamber below")
    actor:send("</>the main temple.  It seems something down there is using extraordinary")
    actor:send("</>magical power for reasons that aren't yet clear.'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'You're not yet known in the realm, which is")
    actor:send("</>perfect for my plan.  No one will know you're there on a mission.  Go")
    actor:send("</>investigate and find out what is using this power.  Destroy it if you")
    actor:send("</>must, just don't let one of those deranged mystics get it!'")
end