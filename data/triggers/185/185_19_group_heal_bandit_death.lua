-- Trigger: group_heal_bandit_death
-- Zone: 185, ID: 19
-- Type: MOB, Flags: DEATH
--
-- When the bandit raider dies: any present group member at quest stage
-- 1 of group_heal advances and triggers the supplies drop (185,13).
-- For other present player members, drop a random class gem
-- (557, 37..47).

local supplies_dropped = false

local function process(person)
    if person.room ~= self.room then
        return
    end
    if person:get_quest_stage("group_heal") == 1 then
        if not supplies_dropped then
            person:advance_quest("group_heal")
            self.room:spawn_object(185, 13)
            supplies_dropped = true
        else
            person:advance_quest("group_heal")
        end
    elseif person.is_player then
        local what_gem_drop = random(1, 11)
        self.room:spawn_object(557, 36 + what_gem_drop)
    end
end

if actor.group and #actor.group > 0 then
    for _, person in ipairs(actor.group) do
        process(person)
    end
else
    process(actor)
end
