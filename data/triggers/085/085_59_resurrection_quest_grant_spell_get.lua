-- Trigger: Resurrection_quest_grant_spell_get
-- Zone: 85, ID: 59
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #8559

-- Converted from DG Script #8559: Resurrection_quest_grant_spell_get
-- Original: OBJECT trigger, flags: GET, probability: 100%
if actor:get_quest_stage("resurrection_quest") > 10 then
    wait(1)
    actor:send("You thumb through the book and find Norisent has taught you all you need to know.")
    -- Spawn the AI helper mob (mob 85,51) which is responsible for granting
    -- the Resurrect spell, then have it teach the actor.
    local ai_mob = self.room:spawn_mobile(85, 51)
    if ai_mob then
        ai_mob:command("mskillset " .. tostring(actor.name) .. " resurrect")
        wait(2)
        world.destroy(ai_mob)
    end
    actor:send("<b:cyan>You have learned Resurrect.</>")
    self.room:send(tostring(self.shortdesc) .. " crumbles to dust and blows away.")
    actor:complete_quest("resurrection_quest")
    if not actor:get_quest_var("hell_trident:helltask5") and actor:get_quest_stage("hell_trident") == 2 then
        actor:set_quest_var("hell_trident", "helltask5", 1)
    end
    world.destroy(self)
end