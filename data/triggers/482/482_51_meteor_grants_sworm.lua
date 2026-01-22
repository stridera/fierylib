-- Trigger: meteor grants sworm
-- Zone: 482, ID: 51
-- Type: OBJECT, Flags: USE
-- Status: CLEAN
--
-- Original DG Script: #48251

-- Converted from DG Script #48251: meteor grants sworm
-- Original: OBJECT trigger, flags: USE, probability: 100%
if actor:get_quest_stage("meteorswarm") == 5 then
    wait(1)
    skills.set_level(actor.name, "meteorswarm", 100)
    actor.name:complete_quest("meteorswarm")
    actor:send("<b:red>You have learned the ability to call meteors from the sky!</>")
    wait(1)
    self.room:send("The meteorite crumbles to ash and blows away.")
    world.destroy(self)
end