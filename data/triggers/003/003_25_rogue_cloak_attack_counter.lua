-- Trigger: Rogue cloak attack counter
-- Zone: 3, ID: 25
-- Type: OBJECT, Flags: ATTACK
-- Status: CLEAN
--
-- Original DG Script: #325

-- Converted from DG Script #325: Rogue cloak attack counter
-- Original: OBJECT trigger, flags: ATTACK, probability: 100%
if actor:get_quest_stage("rogue_cloak") >= 1 then
    if not actor:get_quest_var("rogue_cloak:cloaktask1") then
        local attack_increase = actor:get_quest_var("rogue_cloak:attack_counter") + 1
        actor.name:set_quest_var("rogue_cloak", "attack_counter", attack_increase)
        if actor:get_quest_var("rogue_cloak:attack_counter") >= actor:get_quest_stage("rogue_cloak") * 100 then
            actor:set_quest_var("rogue_cloak", "cloaktask1", 1)
            actor.name:set_quest_var("rogue_cloak", "attack_counter", 0)
            actor:send("<b:yellow>You have perfected your bond with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end