-- Trigger: UNUSED
-- Zone: 520, ID: 5
-- Type: WORLD, Flags: PREENTRY
-- Status: UNUSED
--
-- Original DG Script: #52005
-- Marked UNUSED in source data; retained for parity. PREENTRY hook would
-- spawn a spirit demon (520:19) the first time a player enters and order it
-- to attack. The `smoke_demon` global gates it to once per zone reset.
-- TODO(parity): `actor` is not bound for PREENTRY in our runtime; this
-- trigger needs a runtime PREENTRY actor binding before it can be enabled.

wait(5)
if globals.smoke_demon ~= "pi" then
    if actor and actor.is_player then
        self.room:spawn_mobile(520, 19)
        self.room:send("A spirit demon forms out of the air around you.")
        globals.smoke_demon = "pi"
        local demon = self.room:find_actor("spirit-demon")
        if demon then
            demon:command("kill " .. tostring(actor.name))
        end
    end
end