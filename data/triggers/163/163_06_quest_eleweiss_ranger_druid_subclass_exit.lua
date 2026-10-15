-- Trigger: quest_eleweiss_ranger_druid_subclass_exit
-- Zone: 163, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #16306

-- Player asks to "exit" or "leave" — wind catches them, teleport to room 74.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"exit", "exit?", "leave", "leave?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:say("Very well, goodbye little one.")
actor:send("A gust of wind, commanded by Eleweiss, catches you and moves you away.")
self.room:send_except(actor, "A gust of wind from Eleweiss moves " .. tostring(actor.name) .. " away.")
actor:teleport(get_room(163, 74))