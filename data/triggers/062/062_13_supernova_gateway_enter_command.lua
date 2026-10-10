-- Trigger: supernova_gateway_enter_command
-- Zone: 62, ID: 13
-- Type: OBJECT, Flags: COMMAND
--
-- Activates the supernova gateway when a player carrying/wearing the
-- miniature sun (510, 73) types `enter ring` / `enter gateway`. Drains the
-- gateway (destroys self) so it can only be used once.
--
-- Original DG Script: #6213

-- The DG numeric argument 4 is the OCMD_* location mask (the gateway on the floor), not a
-- probability; the old synthetic `percent_chance(4)` gate is replaced by the location guard.

-- Command location mask 4: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: enter
if cmd ~= "enter" then
    return true  -- Not our command
end
if not (arg == "r" or arg == "ri" or arg == "rin" or arg == "ring"
   or arg == "g" or arg == "ga" or arg == "gat" or arg == "gate"
   or arg == "gatew" or arg == "gatewa" or arg == "gateway") then
    return true  -- Not the ring / gateway: legacy `default: return 0`
end
if not (actor:has_item(510, 73) or actor:has_equipped(510, 73)) then
    actor:send("The gateway is inactive.")
    return false  -- legacy `return 1`
end
actor:send("The gateway draws power from " .. tostring(objects.template(510, 73).name) .. " and activates!")
-- Legacy `return 0` ahead of the wait: the typed command goes ahead and the script carries on.
allow_command()
wait(2)
self.room:send("The gateway folds in on itself and collapses!")
world.destroy(self)
return true