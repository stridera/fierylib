-- Trigger: shadow_demon_death
-- Zone: 160, ID: 23
-- Type: MOB, Flags: DEATH
--
-- Mystwatch spawn-cycle link 8: shadow demon → storm demon. Spawns a
-- storm demon (160,8) in staging room (160,95), then either:
--   * 33% — equips both the storm orb (160,6) and demon key (160,22);
--   * 67% — equips only the key, but the orb is still given (without
--     wear) to any present group member on Druid Moonwell quest or
--     Sorcerer Wizard Eye quest, since both quests need to recover it
--     from the demon's corpse.
-- Then teleports the storm demon to its lair (160,76) and purges. Every
-- present group member on mystwatch_quest advances "shadow" → "storm".
--
-- Fixes a pre-existing bug: the legacy script only advanced the quest in
-- the 67% branch.

if world.count_mobiles(160, 8) < 1 then
    get_room(160, 95):at(function()
        self.room:spawn_mobile(160, 8)
    end)

    local equip_orb = random(1, 100) <= 33

    if equip_orb then
        -- 33%: storm demon worn-equips both orb and key.
        get_room(160, 95):at(function()
            self.room:find_actor("storm"):spawn_object(160, 6)
        end)
        get_room(160, 95):at(function()
            self.room:find_actor("storm"):spawn_object(160, 22)
        end)
        get_room(160, 95):at(function()
            self.room:find_actor("storm"):command("wear all")
        end)
    else
        -- 67%: orb is only given when a present group member needs it
        -- for Moonwell (Druid) or Wizard Eye (Sorcerer) quests.
        local needs_orb = false
        for i = 1, actor.group_size do
            local person = actor.group_member[i]
            if person and person.room == self.room then
                local moonwell = person:get_quest_stage("moonwell_spell_quest") or 0
                local eye = person:get_quest_stage("wizard_eye") or 0
                if moonwell > 0 or eye > 0 then
                    needs_orb = true
                    break
                end
            end
        end
        if needs_orb then
            get_room(160, 95):at(function()
                self.room:find_actor("storm"):spawn_object(160, 6)
            end)
            get_room(160, 95):at(function()
                self.room:find_actor("storm"):command("wear all")
            end)
        end
        get_room(160, 95):at(function()
            self.room:find_actor("storm"):spawn_object(160, 22)
        end)
    end

    get_room(160, 95):at(function()
        self.room:find_actor("storm"):teleport(get_room(160, 76))
    end)
end

-- Advance every present group member's mystwatch_quest step.
for i = 1, actor.group_size do
    local person = actor.group_member[i]
    if person and person.room == self.room then
        if person:get_quest_stage("mystwatch_quest") then
            person:set_quest_var("mystwatch_quest", "step", "storm")
            person:send("<b:white>You have advanced the quest!</>")
        end
    end
end

-- Cleanup: purge any leftovers in the staging room.
get_room(160, 95):at(function()
    self.room:purge()
end)
self.room:send("A violent lightning storm continues outside...")
