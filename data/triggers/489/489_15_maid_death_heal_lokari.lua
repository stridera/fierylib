-- Trigger: maid death heal lokari
-- Zone: 489, ID: 15
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #48915

-- Converted from DG Script #48915: maid death heal lokari
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
--
-- Fired by trigger 14 (any maid's death). Lokari absorbs the dying maid's
-- spirit for 2000 HP. If the cleric maid was the one that died, set the
-- stop-casting flag so trigger 12's in-flight cast aborts.

-- TODO(parity): the original DG checked `random(<#people>)` to pick an actor;
-- the converter approximated that with room.actors but the value isn't really
-- used beyond a non-nil guard. Drop the indirection if the runtime guarantees
-- a triggering context.
if world.count_mobiles(489, 1) > 0 then
    self.room:send("Lokari absorbs the maid's spirit as it leaves her body.")
    get_room(489, 15):at(function()
        self.room:find_actor("lokari"):heal(2000)
    end)
end
wait(1)
if world.count_mobiles(489, 23) == 0 then
    globals.stop_casting = 1
end