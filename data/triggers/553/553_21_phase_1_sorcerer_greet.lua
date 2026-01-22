-- Trigger: phase_1_sorcerer_greet
-- Zone: 553, ID: 21
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #55321

-- Converted from DG Script #55321: phase_1_sorcerer_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
local SORC_SUB = (actor.class == "sorcerer"  or  actor.class == "necromancer"  or  actor.class == "conjurer"  or  actor.class == "cryomancer"  or  actor.class == "pyromancer")
if SORC_SUB then
    if actor:get_quest_stage("phase_armor") == 0 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Welcome, would you like to do some [<b:white>armor quests</>]?\"")
        actor:send(tostring(self.name) .. " tells you, \"If so, just ask me, <b:white>Yes</> I would like to do some <b:white>armor quests</>\"")
    end
else
end