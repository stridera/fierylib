-- Trigger: supernova_gateway_enter_command
-- Zone: 62, ID: 13
-- Type: OBJECT, Flags: COMMAND
--
-- Activates the supernova gateway when a player carrying/wearing the
-- miniature sun (510, 73) types `enter ring` / `enter gateway`. Drains the
-- gateway (destroys self) so it can only be used once.
--
-- Original DG Script: #6213

-- TODO(parity): The original DG had probability=4 on the trigger, which is
-- almost certainly an authoring mistake (a 4% gate on a quest's only entry
-- point is broken). The synthetic `percent_chance(4)` gate has been removed.
-- Verify that the source intended 100%.

-- Command filter: enter
if cmd ~= "enter" then
    return true  -- Not our command
end
if not (actor:has_item(510, 73) or actor:has_equipped(510, 73)) then
    actor:send("The gateway is inactive.")
    return false
end
if arg == "r" or arg == "ri" or arg == "rin" or arg == "ring"
   or arg == "g" or arg == "ga" or arg == "gat" or arg == "gate"
   or arg == "gatew" or arg == "gatewa" or arg == "gateway" then
    actor:send("The gateway draws power from " .. tostring(objects.template(510, 73).name) .. " and activates!")
    wait(2)
    self.room:send("The gateway folds in on itself and collapses!")
    world.destroy(self)
    return true
end
actor:send("The gateway is inactive.")
return false