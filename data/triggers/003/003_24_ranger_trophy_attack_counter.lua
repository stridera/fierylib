-- Trigger: Ranger trophy attack counter
-- Zone: 3, ID: 24
-- Type: OBJECT, Flags: ATTACK
-- Status: CLEAN
--
-- Original DG Script: #324

-- Converted from DG Script #324: Ranger trophy attack counter
-- Original: OBJECT trigger, flags: ATTACK, probability: 100%
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