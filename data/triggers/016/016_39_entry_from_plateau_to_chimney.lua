-- Trigger: Entry_from_plateau_to_chimney
-- Zone: 16, ID: 39
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1639

-- Converted from DG Script #1639: Entry_from_plateau_to_chimney
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: down
if not (cmd == "down") then
    return true  -- Not our command
end
if actor.size == "tiny" or actor.size == "small" or actor.size == "medium" then
    self.room:send_except(actor, tostring(actor.name) .. " leaves down.")
    actor:teleport(get_room(16, 91))
    -- actor looks around
    self.room:send_except(actor, tostring(actor.name) .. " enters from above.")
else
    actor:send("You're too large to go there.")
    return _return_value
end