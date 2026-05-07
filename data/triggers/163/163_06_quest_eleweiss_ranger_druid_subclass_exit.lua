-- Trigger: quest_eleweiss_ranger_druid_subclass_exit
-- Zone: 163, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #16306

-- Player asks to "exit" or "leave" — wind catches them, teleport to room 74.

if not (string.find(speech, "exit") or string.find(speech, "leave")) then
    return true
end
self:say("Very well, goodbye little one.")
actor:send("A gust of wind, commanded by Eleweiss, catches you and moves you away.")
self.room:send_except(actor, "A gust of wind from Eleweiss moves " .. tostring(actor.name) .. " away.")
actor:teleport(get_room(163, 74))