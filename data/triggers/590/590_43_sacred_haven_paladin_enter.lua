-- Trigger: sacred_haven_paladin_enter
-- Zone: 590, ID: 43
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #59043

-- Converted from DG Script #59043: sacred_haven_paladin_enter
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
if actor.alignment >= 350 then
    if actor.class == "Paladin" or actor.class == "Priest" or actor.class == "Cleric" then
        wait(2)
        self:command("rem key")
        self:command("unlock door")
        wait(2)
        self:command("open door")
        self:command("hold key")
        wait(2)
        self:command("bow " .. tostring(actor.name))
        self:say("Welcome to the Sacred Haven, fellow warrior.")
    end
end