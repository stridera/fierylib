-- Trigger: berserker_target_death
-- Zone: 364, ID: 15
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Death trigger for the three lighter Wild Hunt quarries (file 364_16
-- handles the bear miniboss with loot drops). Completes the quest if this
-- mob was the killer's assigned target.
--
-- Original DG Script: #36415

if actor:get_quest_stage("berserker_subclass") == 4
    and actor:get_quest_var("berserker_subclass:target") == self.id
then
    actor:send("<b:cyan>Congratulations, you have succeeded in your Wild Hunt!</>")
    actor:send("<b:cyan>You have earned the right to become a &9<blue>Ber<red>ser&9ker<b:cyan>!</>")
    actor:send("Type '<b:yellow>subclass</>' to proceed.")
    actor:complete_quest("berserker_subclass")
end