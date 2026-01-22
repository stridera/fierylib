-- Trigger: Assassin mask attack counter
-- Zone: 3, ID: 22
-- Type: OBJECT, Flags: ATTACK
-- Status: CLEAN
--
-- Original DG Script: #322

-- Converted from DG Script #322: Assassin mask attack counter
-- Original: OBJECT trigger, flags: ATTACK, probability: 100%
if actor:get_quest_stage("assassin_mask") >= 1 then
    if not actor:get_quest_var("assassin_mask:masktask1") then
        local attack_increase = actor:get_quest_var("assassin_mask:attack_counter") + 1
        actor.name:set_quest_var("assassin_mask", "attack_counter", attack_increase)
        if actor:get_quest_var("assassin_mask:attack_counter") >= actor:get_quest_stage("assassin_mask") * 100 then
            actor:set_quest_var("assassin_mask", "masktask1", 1)
            actor.name:set_quest_var("assassin_mask", "attack_counter", 0)
            actor:send("<b:yellow>You have perfected your bond with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end