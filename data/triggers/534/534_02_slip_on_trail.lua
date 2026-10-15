-- Trigger: slip_on_trail
-- Zone: 534, ID: 2
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #53402

-- Converted from DG Script #53402: slip_on_trail
-- Original: WORLD trigger, flags: PREENTRY, probability: 5%

-- 5% chance to trigger
if not percent_chance(5) then
    return true
end
wait(0.2)
local rnd = self.room.actors[random(1, #self.room.actors)]
-- this trigger is in multiple rooms, socheck we are in right one
if rnd.room.zone_id == actor.room.zone_id and rnd.room.local_id == actor.room.local_id then
    -- check for flying first...
    if not (rnd:has_effect(Effect.Flying)) then
        local dam = 0
        rnd:send("You slip on the icy path and fall!")
        self.room:send_except(rnd, tostring(rnd.name) .. " slips and falls!")
        -- DG compared the room vnum to 53527-53530: zone 534, ids 127-130 (the rooms
        -- this trigger is attached to). Rooms are compared by (zone_id, local_id).
        local rzone = actor.room.zone_id
        local rid = actor.room.local_id
        -- The DG cases fall through (no break): each room adds its own damage and
        -- every lower room's, so the top of the trail is 100 + 75 + 50 + 25.
        if rzone == 534 and rid == 130 then
            dam = dam + 100 + 75 + 50 + 25
        elseif rzone == 534 and rid == 129 then
            dam = dam + 75 + 50 + 25
        elseif rzone == 534 and rid == 128 then
            dam = dam + 50 + 25
        elseif rzone == 534 and rid == 127 then
            dam = dam + 25
        end
        rnd:teleport(get_room(534, 17))
        local damage_dealt = rnd:damage(dam)  -- type: physical
        get_room(534, 17):at(function()
            -- rnd looks around
        end)
        get_room(534, 17):at(function()
            self.room:send_except(rnd, tostring(rnd.name) .. " comes tumbling down the ice trail from the east.")
        end)
    end
end