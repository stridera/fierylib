-- Trigger: academy_stick_drop
-- Zone: 519, ID: 12
-- Type: OBJECT, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #51912

-- Converted from DG Script #51912: academy_stick_drop
-- Original: OBJECT trigger, flags: DROP, probability: 100%
if actor:get_quest_var("school:gear") == 10 then
    actor:set_quest_var("school", "gear", 11)
    wait(2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Exactly.  Dropping objects leaves them for anyone else to pick up.")
    actor:send("Be careful!  Sometimes monsters can pick up things too!")
    actor:send("</>")
    actor:send("You can permanently destroy objects with the <b:cyan>(J)UNK</> command.'</>")
    wait(2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Try junking a stick by typing <b:green>junk stick</>.'</>")
elseif actor:get_quest_var("school:gear") == 13 and target.id == 18 then
    actor:set_quest_var("school", "gear", 14)
    wait(2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'That's how it's done.'")
    wait(2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'To see what's inside something, use <b:cyan>(EXA)MINE [target]</>.")
    actor:send("<b:cyan>EXAMINE</> will also show if something is open or closed.'")
    wait(2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Go ahead and <b:green>examine bag</> and see what you find.'")
end