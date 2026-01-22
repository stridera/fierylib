-- Trigger: quest_relocate_druid_death
-- Zone: 492, ID: 53
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #49253

-- Converted from DG Script #49253: quest_relocate_druid_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
self.room:send("A slender druid screams, 'No! I had made my escape already!'")
self.room:send("A slender druid chokes on some blood and dies.")