-- Trigger: phase_1_warrior_greet
-- Zone: 553, ID: 11
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #55311

-- Converted from DG Script #55311: phase_1_warrior_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
local anti = "Anti-Paladin"
local WARRIOR_SUB = (actor.class == warrior  or  actor.class == paladin  or  actor.class == anti  or  actor.class == ranger  or  actor.class == monk)
if WARRIOR_SUB then
    if actor:get_quest_stage("phase_armor") == 0 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Welcome, would you like to do some [<b:white>armor quests</>]?\"")
        actor:send(tostring(self.name) .. " tells you, \"If so, just ask me, <b:white>Yes</> I would like to do some <b:white>armor quests</>\"")
    end
else
end