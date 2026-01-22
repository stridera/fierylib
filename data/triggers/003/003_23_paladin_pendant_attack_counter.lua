-- Trigger: Paladin pendant attack counter
-- Zone: 3, ID: 23
-- Type: OBJECT, Flags: ATTACK
-- Status: CLEAN
--
-- Original DG Script: #323

-- Converted from DG Script #323: Paladin pendant attack counter
-- Original: OBJECT trigger, flags: ATTACK, probability: 100%
if actor:get_quest_stage("paladin_pendant") >= 1 then
    if not actor:get_quest_var("paladin_pendant:necklacetask1") then
        local attack_increase = actor:get_quest_var("paladin_pendant:attack_counter") + 1
        actor.name:set_quest_var("paladin_pendant", "attack_counter", attack_increase)
        if actor:get_quest_var("paladin_pendant:attack_counter") >= actor:get_quest_stage("paladin_pendant") * 100 then
            actor:set_quest_var("paladin_pendant", "necklacetask1", 1)
            actor.name:set_quest_var("paladin_pendant", "attack_counter", 0)
            actor:send("<b:yellow>You have perfected your bond with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end