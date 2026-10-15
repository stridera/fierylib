-- Trigger: quest_exit_arre
-- Zone: 51, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5110

-- Converted from DG Script #5110: quest_exit_arre
-- Original: MOB trigger, flags: SPEECH, probability: 100%
--
-- Player says "exit" -- Arre dismisses them back to the temple
-- entrance (580/1).

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"exit", "exit?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
self:command("sigh")
self:say("Again, my time has been wasted.  Very well, leave.")
actor:send(self.name .. " waves her arms, sending you out of her chamber.")
self.room:send_except(actor, self.name .. " sweeps her arms through the air, sending " .. actor.name .. " away.")
actor:teleport(get_room(580, 1))
actor:send("You blink and find yourself back on the pebbled path!")
actor:command("look")