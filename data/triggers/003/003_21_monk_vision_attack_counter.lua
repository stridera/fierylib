-- Trigger: Monk vision attack counter
-- Zone: 3, ID: 21
-- Type: OBJECT, Flags: ATTACK
-- Status: CLEAN
--
-- Original DG Script: #321

-- Converted from DG Script #321: Monk vision attack counter
-- Original: OBJECT trigger, flags: ATTACK, probability: 100%
if actor:get_quest_stage("monk_vision") >= 1 then
    if not actor:get_quest_var("monk_vision:visiontask1") then
        local attack_increase = actor:get_quest_var("monk_vision:attack_counter") + 1
        actor.name:set_quest_var("monk_vision", "attack_counter", attack_increase)
        if actor:get_quest_var("monk_vision:attack_counter") >= actor:get_quest_stage("monk_vision") * 100 then
            actor:set_quest_var("monk_vision", "visiontask1", 1)
            actor.name:set_quest_var("monk_vision", "attack_counter", 0)
            actor:send("<b:yellow>You have perfected your bond with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end