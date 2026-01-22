-- Trigger: quest_eleweiss_ranger_druid_subclass_greet
-- Zone: 163, ID: 1
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #16301

-- Converted from DG Script #16301: quest_eleweiss_ranger_druid_subclass_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
-- NOTE: The wand upgrade portion of this trigger was removed due to incomplete
-- variable references in the original DG script (type_wand, wandstep, weapon).
-- Only the ranger/druid subclass greeting remains functional.
-- switch on actor.race
-- case ADD NEW RESTRICTED RACES HERE
-- halt
-- break
if (string.find(actor.class, "Warrior") and (actor.level >= 10 and actor.level <= 25)) or (string.find(actor.class, "Cleric") and (actor.level >= 10 and actor.level <= 35)) then
    if not actor:get_quest_stage("ran_dru_subclass") then
        self:emote("grins casually.")
        actor:send(tostring(self.name) .. " says, 'Some know the ways of the woods, others are ignorant.  Do you know the <b:cyan>ways</> or not?'")
        self:emote("puts a more serious look on his face.")
    elseif actor:get_quest_stage("ran_dru_subclass") == 4 and not actor:get_has_completed("ran_dru_subclass") then
        actor:send(tostring(self.name) .. " says, 'Have you the jewel of the heart?'")
    end
end