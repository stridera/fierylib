-- Trigger: look_into_globe
-- Zone: 534, ID: 16
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #53416

-- Converted from DG Script #53416: look_into_globe
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
wait(3)
-- TODO(parity): legacy comparisons used room vnums 53466 (Lirne's ruined
-- tower, zone 534/id 66) and 53570 (intact past tower, zone 535/id 70).
-- actor.room is now a Room object; compare via zone_id/local_id.
local rzone = actor.room.zone_id
local rid = actor.room.local_id
if rzone == 534 and rid == 66 then
    actor:send("Hmm, the view in the globe is very similar to the one in this room, except the tower is whole.")
elseif rzone == 535 and rid == 70 then
    actor:send("Wow, the globe is a miniature model of this room, freaky!")
end