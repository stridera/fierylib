-- Trigger: berserker_command_dig
-- Zone: 364, ID: 7
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Player digs a temporary path through the snow connecting rooms 364:29 and
-- 364:31 for ~25 seconds, then the snow drifts back in and the exits hide.
--
-- Original DG Script: #36407

-- Command filter: full word "dig" only
if cmd ~= "dig" then
    return true
end
if actor.is_player then
    local r29 = get_room(364, 29)
    local r31 = get_room(364, 31)
    actor:send("You dig out a path through the snow.")
    self.room:send_except(actor, tostring(actor.name) .. " digs out a path through the snow.")
    r29:send("The way south has been cleared.")
    r31:send("The way north has been cleared.")
    r29:exit("south"):set_state({hidden = false})
    r31:exit("north"):set_state({hidden = false})
    wait(15)
    r29:send("The snow begins to drift back in...")
    r31:send("The snow begins to drift back in...")
    wait(10)
    r29:send("The snow has completely covered the path south.")
    r31:send("The snow has completely covered the path north.")
    r29:exit("south"):set_state({hidden = true})
    r31:exit("north"):set_state({hidden = true})
end
return true