-- Trigger: look_into_globe
-- Zone: 534, ID: 16
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #53416

-- Converted from DG Script #53416: look_into_globe
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
wait(3)
local snowglobe = "snow-globe"
local glassglobe = "glass-globe"
if actor.room == 53466 then
    actor:send("Hmm, the view in the globe is very similar to the one in this room, except the tower is whole.")
elseif actor.room == 53570 then
    actor:send("Wow, the globe is a miniature model of this room, freaky!")
end