-- Trigger: TCD_Entrance
-- Zone: 30, ID: 34
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3034

-- Converted from DG Script #3034: TCD_Entrance
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: knock
if not (cmd == "knock") then
    return true  -- Not our command
end
actor:send("A dark and sinister looking portal opens suddenly and pulls you inside.")
self.room:send_except(actor, "A dark and sinister looking portal opens suddenly and pulls " .. tostring(actor.name) .. " inside.")
doors.set_state(get_room(30, 34), "up", {action = "room"})
actor:move("up")
doors.set_state(get_room(30, 34), "up", {action = "purge"})