-- Trigger: Anti-Paladin Diabolist Necromancer Subclass progress journal
-- Zone: 4, ID: 62
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #462

-- Converted from DG Script #462: Anti-Paladin Diabolist Necromancer Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local anti = "Anti-Paladin"
    local antipaladinraces = "faerie_seelie elf"
    local diabolistraces = "faerie_seelie elf"
    local necromancerraces = "faerie_seelie elf"
    if string.find(arg, "anti") and string.find(actor.class, "Warrior") and actor.level <= 25 and not (string.find(antipaladinraces, "actor.race")) then
        actor:send("<b:red>Anti-Paladin</>")
        local check = "yes"
    elseif string.find(arg, "Diabolist") and string.find(actor.class, "Cleric") and actor.level <= 35 and not (string.find(diabolistraces, "actor.race")) then
        actor:send("<magenta>Diabolist</>")
        local check = "yes"
    elseif string.find(arg, "Necromancer") and string.find(actor.class, "Sorcerer") and actor.level <= 45 and not (string.find(necromancerraces, "actor.race")) then
        actor:send("&9<blue>Necromancer</>")
        local check = "yes"
    end
    if string.find(check, "yes") then
        _return_value = false
        actor:send("Quest Master: " .. tostring(mobiles.template(85, 1).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        actor:send("This class is for evil characters only.")
        if actor:get_quest_stage("nec_anti_dia_subclass") then
            actor:send(tostring(mobiles.template(85, 1).name) .. " said to you:")
            -- switch on actor:get_quest_stage("nec_anti_dia_subclass")
            if actor:get_quest_stage("nec_anti_dia_subclass") == 1 then
                actor:send("Only the most cunning and strong will complete the <magenta>quest</> I set before you.")
                actor:send("I shall take great pleasure in your demise, but I will offer great rewards for your success.")
            elseif actor:get_quest_stage("nec_anti_dia_subclass") == 2 then
                actor:send("Many years ago, my pact with the demon realm allowed me to be master of this domain.")
                actor:send("All were subjugated, man, woman, and beast._")
                actor:send("One man would not bow though!")
                actor:send("My pitiful waste of a brother escaped my minions._")
                actor:send("Perhaps you will remedy that.")
            elseif actor:get_quest_stage("nec_anti_dia_subclass") == 3 or actor:get_quest_stage("nec_anti_dia_subclass") == 4 then
                actor:send("My wretched sibling, Ber...  I shall not utter his name!_")
                actor:send("I despise him and his reverent little life._")
                actor:send("He thinks he is safe now, beyond my grasp.  That FOOL!_")
            end
        end
    end
end
return _return_value