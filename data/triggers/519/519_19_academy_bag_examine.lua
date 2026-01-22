-- Trigger: academy_bag_examine
-- Zone: 519, ID: 19
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #51919

-- Converted from DG Script #51919: academy_bag_examine
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
wait(2)
if actor:get_quest_var("school:gear") == 14 then
    actor:set_quest_var("school", "gear", 15)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Now you can see everything inside the bag.")
    actor:send("You can check different bags by typing 2.bag, 3.bag, etc.")
    actor:send("</>")
    actor:send("The last step is to <b:cyan>(G)ET</> the item back out.")
    actor:send("You can type <b:cyan>GET [object] [container]</> for one thing, or <b:cyan>GET ALL [container]</> to get everything out.'")
    wait(2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Take that stick back out by typing <b:green>get stick bag</>.'")
end