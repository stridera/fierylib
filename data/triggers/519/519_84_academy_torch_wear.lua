-- Trigger: academy_torch_wear
-- Zone: 519, ID: 84
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #51984

-- Converted from DG Script #51984: academy_torch_wear
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
if actor:get_quest_var("school:gear") == 4 then
    actor:set_quest_var("school", "gear", 5)
    wait(2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Notice you have a torch equipped now.")
    actor:send("However, you need to turn it on before it provides you any light.")
    actor:send("The <b:cyan>(LI)GHT</> command turns lights on and off.")
    actor:send("You can just type <b:cyan>light torch</> to light it up.")
    actor:send("If it's already lit, you can type <b:cyan>light torch</> again to extinguish it.'")
    wait(3)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Give it a try and type <b:green>light torch</>.'")
end