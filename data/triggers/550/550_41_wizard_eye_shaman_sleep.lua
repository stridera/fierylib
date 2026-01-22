-- Trigger: wizard_eye_shaman_sleep
-- Zone: 550, ID: 41
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #55041

-- Converted from DG Script #55041: wizard_eye_shaman_sleep
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: sleep
if not (cmd == "sleep") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("wizard_eye") == 12 then
    _return_value = false
    wait(1)
    actor:send("A hazy dreamscape appears before you.")
    -- (empty room echo)
    actor:send("The Great Snow Leopard comes into focus!")
    actor:send("The Great Snow Leopard says, 'Come, follow where I walk.'")
    wait(2)
    actor:send("The Great Snow Leopard leads you on a journey through crisp, cold, snowy mountains...")
    wait(3)
    actor:send("hot burning deserts, sweltering jungles of sweet scented flowers...")
    wait(3)
    actor:send("distant mysterious islands of alien sounds...")
    wait(3)
    actor:send("through cities of people speaking languages you do not understand...")
    wait(6)
    actor:send("Soaring through the open sky, the Great Snow Leopard roars to shake the heavens!")
    -- (empty room echo)
    actor:send("In the echoes of the roar, you can see shape distant lands!")
    actor:send("The nature of the spell becomes clear!")
    actor.name:complete_quest("wizard_eye")
    skills.set_level(actor, "wizard eye", 100)
    actor:send("<b:cyan>You have learned Wizard Eye!</>")
else
    _return_value = false
end
return _return_value