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
wait(2)
local rnd = room.actors[random(1, #room.actors)]
-- this trigger is in multiple rooms, socheck we are in right one
if rnd.room == actor.room then
    -- check for flying first...
    if not (rnd:has_effect(Effect.Flying)) then
        local dam = 0
        rnd:send("You slip on the icy path and fall!")
        self.room:send_except(rnd, tostring(rnd.name) .. " slips and falls!")
        -- switch on actor.room
        if actor.room == 53530 then
            local dam = dam + 100
        elseif actor.room == 53529 then
            local dam = dam + 75
        elseif actor.room == 53528 then
            local dam = dam + 50
        elseif actor.room == 53527 then
            local dam = dam + 25
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