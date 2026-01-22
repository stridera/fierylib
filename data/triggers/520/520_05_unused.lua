-- Trigger: UNUSED
-- Zone: 520, ID: 5
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #52005

-- Converted from DG Script #52005: UNUSED
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
wait(5)
if smoke_demon ~= "pi" then
    if actor.id == -1 then
        self.room:spawn_mobile(520, 19)
        self.room:send("A spirit demon forms out of the air around you.")
        local smoke_demon = "pi"
        globals.smoke_demon = globals.smoke_demon or true
        self.room:find_actor("spirit-demon"):command("kill %actor.name%")
    end
end