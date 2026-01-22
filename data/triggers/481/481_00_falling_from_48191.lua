-- Trigger: falling_from_48191
-- Zone: 481, ID: 0
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #48100

-- Converted from DG Script #48100: falling_from_48191
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if direction == "west" then
    wait(5)
    local rndm = room.actors[random(1, #room.actors)]
    if not (rndm:get_eff_flagged("FLY")) then
        rndm:send("You feel your feet start slipping toward the pit!")
        wait(3)
        if rndm.room == 48191 then
            rndm:send("You slip into the pit!")
            self.room:send_except(rndm, "You watch in horror as " .. tostring(rndm.name) .. " slips into the pit!")
            rndm:teleport(get_room(481, 92))
            -- rndm looks around
        end
        rndm = nil
    end
end