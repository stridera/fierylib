-- Trigger: Ill-subclass: Grand Master restarts
-- Zone: 172, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Player says 'restart'. The Grand Master refreshes the Cestia disguise
-- and hands them a fresh vial of disturbance so they can try the heist
-- again.
--
-- Original DG Script: #17204

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"restart"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

if string.find(actor.class, "sorcerer")
    and actor.level > 9 and actor.level < 46
    and actor:get_quest_stage("illusionist_subclass") > 0 then
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'Very well, if you insist.'")
    actor:restart_quest("illusionist_subclass")
    wait(1)
    self:emote("rummages about in his things.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Here is another vial.'")
    wait(1)
    self.room:spawn_object(172, 15)
    self:command("give vial " .. tostring(actor.name))
    wait(2)
    actor:send(tostring(self.name) .. " says, 'And don't muck it up this time!'")
end