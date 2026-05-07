-- Trigger: wof-hall-exit
-- Zone: 15, ID: 4
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1504
--
-- Speech-keyword "exit" warps a player out of the WoF Hall and back to the
-- Town Center Fountain (30:9), with a melt-away/reform message.
--
-- TODO: Original DG probability was 0% (effectively disabled in legacy).
-- Trigger fires deterministically here; if intended to remain disabled,
-- remove the trigger registration. If intended to fire on every match,
-- the current behavior is correct.

-- Speech keywords: exit
if not string.find(string.lower(speech), "exit") then
    return true  -- No matching keywords
end

if actor.is_player then
    wait(1)
    self.room:send("The <magenta>runes</> fly off the walls and float to the center of the room.")
    wait(2)
    actor:send("<b:white>You feel your essence melting away into nothingness and reforming...</>")
    self.room:send_except(actor, "<b:white>" .. tostring(actor.name) .. " seems to melt away!</>")
    actor:teleport(get_room(30, 9))
    -- Note: send_except below references the *origin* room (self.room) but the
    -- actor is no longer there post-teleport; original DG sent the appearance
    -- message to the destination. Sending appearance to destination room:
    get_room(30, 9):send_except(actor, "<b:white>" .. tostring(actor.name) .. " appears out of nowhere!</>")
end
return true
