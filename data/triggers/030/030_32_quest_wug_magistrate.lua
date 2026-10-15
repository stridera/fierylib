-- Trigger: quest_wug_magistrate
-- Zone: 30, ID: 32
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3032

-- Converted from DG Script #3032: quest_wug_magistrate
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"power", "something", "what", "found"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
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