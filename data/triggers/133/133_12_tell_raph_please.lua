-- Trigger: tell_raph_please
-- Zone: 133, ID: 12
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #13312
--
-- The reward step of the get_raph_food quest. After the actor finishes the
-- food chain, they 'tell raph please' (the surrounding plumbing is set up by
-- 133_07). At quest stage 9 we complete the quest and grant the actor a
-- class-appropriate skill / spell at full level. Casters get a fresh spell;
-- martial / hybrid classes get an enhanced skill (switch or pick lock)
-- whose proficiency scales with level.
wait(2)

if not actor.is_player then
    return true
end

if actor:get_quest_stage("get_raph_food") ~= 9 then
    actor:send(self.name .. " tells you, '" .. "What do you want, go about your business." .. "'")
    return true
end

actor:complete_quest("get_raph_food")

-- Spell rewards (full caster classes). The threshold messages warn the
-- player that their level is not yet high enough to actually cast the spell.
local spell_rewards = {
    Cleric      = { spell = "group heal",       min_level = 57 },
    Priest      = { spell = "group heal",       min_level = 57 },
    Diabolist   = { spell = "group heal",       min_level = 57 },
    Druid       = { spell = "invigorate",       min_level = 65 },
    Sorcerer    = { spell = "major globe",      min_level = 57 },
    Pyromancer  = { spell = "major globe",      min_level = 57 },
    Cryomancer  = { spell = "major globe",      min_level = 57 },
    Necromancer = { spell = "summon dracolich", min_level = 73 },
}

-- Skill rewards (martial / hybrid classes). proficiency = level * 10 + 50.
local skill_rewards = {
    Warrior    = "switch",
    Thief      = "pick lock",
    Paladin    = "switch",
    Antipaladin = "switch",
    Ranger     = "switch",
    Assassin   = "pick lock",
    Mercenary  = "switch",
    Monk       = "switch",
    Berserker  = "switch",
    Rogue      = "pick lock",
    Bard       = "pick lock",
}

local class = actor.class

for class_name, reward in pairs(spell_rewards) do
    if string.find(class, class_name) then
        self:command("smile " .. tostring(actor.name))
        skills.set_level(actor, reward.spell, 100)
        if actor.level < reward.min_level then
            actor:send(self.name .. " tells you, '" .. "You will not be able to use your new ability for several levels." .. "'")
        end
        actor:save()
        actor:send(self.name .. " tells you, '" .. "There you go, enjoy your new powers." .. "'")
        return true
    end
end

for class_name, skill in pairs(skill_rewards) do
    if string.find(class, class_name) then
        self:command("smile " .. tostring(actor.name))
        local total = actor.level * 10 + 50
        skills.set_level(actor, skill, total)
        actor:save()
        actor:send(self.name .. " tells you, '" .. "There you go, enjoy your enhanced skills." .. "'")
        return true
    end
end

return true
