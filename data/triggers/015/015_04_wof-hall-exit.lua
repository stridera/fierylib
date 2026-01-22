-- Trigger: wof-hall-exit
-- Zone: 15, ID: 4
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1504

-- Converted from DG Script #1504: wof-hall-exit
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: exit
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "exit")) then
    return true  -- No matching keywords
end
if actor.id == -1 then
    wait(1)
    self.room:send("The <magenta>runes</> fly off the walls and float to the center of the room.")
    wait(2)
    actor:send("<b:white>You feel your essence melting away into nothingness and reforming...</>")
    self.room:send_except(actor, "<b:white>" .. tostring(actor.name) .. " seems to melt away!</>")
    actor:teleport(get_room(30, 9))
    self.room:send_except(actor, "<b:white>" .. tostring(actor.name) .. " appears out of nowhere!</>")
    get_room(30, 9):at(function()
        -- actor looks around
    end)
end