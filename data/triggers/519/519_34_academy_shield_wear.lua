-- Trigger: academy_shield_wear
-- Zone: 519, ID: 34
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #51934

-- Converted from DG Script #51934: academy_shield_wear
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
if actor:get_quest_var("school:fight") == 3 then
    actor:set_quest_var("school", "fight", 4)
    wait(2)
    actor:send(tostring(mobiles.template(519, 4).name) .. " tells you, '<b:cyan>(BAS)H</> deals some damage, but more importantly it <b:red>knocks your opponent down</>.")
    actor:send("That <b:red>prevents your opponent from attacking you</> and <b:red>stops spellcasters from casting spells</>.")
    actor:send("</>")
    actor:send("Bashing is a complex maneuver.")
    actor:send("First, you must be wearing a shield.")
    actor:send("Second, you have to be similar sizes.")
    actor:send("Anything too big and you'll bounce off.")
    actor:send("Anything too small and you'll miss.")
    actor:send("</>")
    actor:send("There's another big risk to using <b:cyan>BASH</>.")
    actor:send("If you miss, which is very likely when you're starting out, <b:red>you will be unable to fight back until you stand up.</>")
    actor:send("</>")
    actor:send("Like most combat skills, there is a brief stun after using it.")
    actor:send("So spamming it can trap you in a very deadly situation.'")
    wait(2)
    if world.count_mobiles("51900") == 0 then
        self.room:find_actor("warmaster"):command("mload mob 51900")
        self.room:send(tostring(mobiles.template(519, 4).name) .. " summons a horrible little monster!")
        wait(1)
    end
    actor:send(tostring(mobiles.template(519, 4).name) .. " tells you, 'I want you to practice bashing now.")
    actor:send("Type <b:green>bash monster</>.  Don't worry, I'm here to protect you.'</>")
end