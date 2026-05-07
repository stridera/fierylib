-- Trigger: Rogue cloak attack counter
-- Zone: 2, ID: 125
-- Type: OBJECT, Flags: ATTACK
--
-- Counts wielder attacks; once they reach (stage * 100) the bond completes
-- (cloaktask1) and the counter resets so the next stage can be earned.
if actor:get_quest_stage("rogue_cloak") >= 1 then
    if not actor:get_quest_var("rogue_cloak:cloaktask1") then
        local attack_increase = actor:get_quest_var("rogue_cloak:attack_counter") + 1
        actor:set_quest_var("rogue_cloak", "attack_counter", attack_increase)
        if actor:get_quest_var("rogue_cloak:attack_counter") >= actor:get_quest_stage("rogue_cloak") * 100 then
            actor:set_quest_var("rogue_cloak", "cloaktask1", 1)
            actor:set_quest_var("rogue_cloak", "attack_counter", 0)
            actor:send("<b:yellow>You have perfected your bond with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end