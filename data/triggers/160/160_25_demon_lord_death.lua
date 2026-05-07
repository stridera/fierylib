-- Trigger: demon_lord_death
-- Zone: 160, ID: 25
-- Type: MOB, Flags: DEATH
--
-- Mystwatch spawn-cycle terminus: demon lord defeated. Marks every
-- present group member's mystwatch_quest step as "complete" — the next
-- step is to return the emerald shard (160,23) to the Templar Magistrate
-- in zone 30 for the reward (handled by 030,30 Myst_quest_reward).
--
-- Note: the message warns that group credit is NOT given for the shard
-- turn-in — only the player who actually delivers the shard receives the
-- exp/loot reward.

for i = 1, actor.group_size do
    local person = actor.group_member[i]
    if person and person.room == self.room then
        if person:get_quest_stage("mystwatch_quest") then
            person:set_quest_var("mystwatch_quest", "step", "complete")
            person:send("<b:white>You have slain the Demon Lord of Mystwatch!</>")
            person:send("<b:white>Group credit will not be given for returning the emerald shard to the Templar Magistrate.</>")
        end
    end
end
