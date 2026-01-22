-- Trigger: Entry_from_chimney_to_plateau
-- Zone: 16, ID: 91
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1691

-- Converted from DG Script #1691: Entry_from_chimney_to_plateau
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: up
if not (cmd == "up") then
    return true  -- Not our command
end
if actor.size == "tiny" or actor.size == "small" or actor.size == "medium" then
    self.room:send_except(actor, tostring(actor.name) .. " leaves up.")
    actor:teleport(get_room(16, 39))
    -- actor looks around
    self.room:send_except(actor, tostring(actor.name) .. " enters from below.")
else
    actor:send("You're too large to go there.")
    return false
end