-- Trigger: only_clerics_enter
-- Zone: 510, ID: 4
-- Type: WORLD, Flags: PREENTRY
--
-- Original DG Script: #51004
-- Gates a sanctified chamber: clerics and priests pass through with a
-- calming message; everyone else (sub-immortal) is bounced with a
-- "this room is not for you" notice. Tracks an `entry` counter so
-- subsequent triggers can tell first-comers from returners.

if actor.level >= 100 then
    return true
end

if string.find(actor.class, "Cleric") or string.find(actor.class, "Priest") then
    actor:send("You feel a calmness come over you, as if the troubles of the world are washed away.")
    entry = (entry or 0) + 1
    return true
else
    actor:send("You can't seem to enter the room!  It is like stepping against a solid wall,")
    actor:send("&0but you can see in.")
    actor:send("You seem to hear a voice whisper, 'This room is not for you.'")
    return false
end
