-- Trigger: quest_eleweiss_ranger_druid_subclass_greet
-- Zone: 163, ID: 1
-- Type: MOB, Flags: GREET_ALL
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #16301

-- Converted from DG Script #16301: quest_eleweiss_ranger_druid_subclass_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
if actor.quest_stage[type_wand] == "wandstep" then
    local minlevel = (wandstep - 1) * 10
    if actor.level >= minlevel then
        if actor.quest_variable[type_wand:greet] == 0 then
            actor:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        else
            if actor.quest_variable[type_wand:wandtask1] and actor.quest_variable[type_wand:wandtask2] and actor.quest_variable[type_wand:wandtask3] then
                actor:send(tostring(self.name) .. " says, 'Oh good, you're all set!  Let me see the staff.'")
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I need for the " .. tostring(weapon) .. "?'")
            end
        end
    end
end
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