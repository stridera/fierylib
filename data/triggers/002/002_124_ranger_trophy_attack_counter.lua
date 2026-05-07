-- Trigger: Ranger trophy attack counter
-- Zone: 2, ID: 124
-- Type: OBJECT, Flags: ATTACK
--
-- Counts wielder attacks; once they reach (stage * 100) the bond completes
-- (trophytask1) and the counter resets so the next stage can be earned.
if actor:get_quest_stage("ranger_trophy") >= 1 then
    if not actor:get_quest_var("ranger_trophy:trophytask1") then
        local attack_increase = actor:get_quest_var("ranger_trophy:attack_counter") + 1
        actor:set_quest_var("ranger_trophy", "attack_counter", attack_increase)
        if actor:get_quest_var("ranger_trophy:attack_counter") >= actor:get_quest_stage("ranger_trophy") * 100 then
            actor:set_quest_var("ranger_trophy", "trophytask1", 1)
            actor:set_quest_var("ranger_trophy", "attack_counter", 0)
            actor:send("<b:green>You have perfected your bond with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end