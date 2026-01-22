-- Trigger: academy_wear_pen
-- Zone: 519, ID: 90
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #51990

-- Converted from DG Script #51990: academy_wear_pen
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
if actor:get_quest_var("school:fight") == 4 then
    actor:set_quest_var("school", "fight", 5)
    wait(2)
    actor:send(tostring(mobiles.template(519, 6).name) .. " tells you, 'Wonderful, you're all set!")
    actor:send("Now you can <b:cyan>SCRIBE</> any spell on your spell list.")
    actor:send("Each spell takes up pages in your spellbook.")
    actor:send("The number of pages is affected by your <b:cyan>SCRIBE</> skill.'")
    wait(1)
    actor:send(tostring(mobiles.template(519, 6).name) .. " tells you, 'You can write any spell you know in your spellbook as long as you're with your Guild Master and your spellbook enough blank pages left in it.'")
    wait(2)
    actor:send(tostring(mobiles.template(519, 6).name) .. " tells you, 'For now, just type <b:green>scribe magic missile</>.'")
end