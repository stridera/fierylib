-- Trigger: Monk vision attack counter
-- Zone: 2, ID: 121
-- Type: OBJECT, Flags: ATTACK
--
-- Counts wielder attacks; once they reach (stage * 100) the bond completes
-- (visiontask1) and the counter resets so the next stage can be earned.
if actor:get_quest_stage("monk_vision") >= 1 then
    if not actor:get_quest_var("monk_vision:visiontask1") then
        local attack_increase = actor:get_quest_var("monk_vision:attack_counter") + 1
        actor:set_quest_var("monk_vision", "attack_counter", attack_increase)
        if actor:get_quest_var("monk_vision:attack_counter") >= actor:get_quest_stage("monk_vision") * 100 then
            actor:set_quest_var("monk_vision", "visiontask1", 1)
            actor:set_quest_var("monk_vision", "attack_counter", 0)
            actor:send("<b:yellow>You have perfected your bond with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end