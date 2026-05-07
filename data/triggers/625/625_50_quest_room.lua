-- Trigger: quest room
-- Zone: 625, ID: 50
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #62550

-- Converted from DG Script #62550: quest room
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
--
-- Called from 625_34/35/36/37 once the player has handed in the
-- final quest item. `self` is the room. Locate the player who
-- is at stage 6 of ursa_quest and run the matching cinematic.
local quester
for _, person in ipairs(self.actors) do
    if person.is_player and person:get_quest_stage("ursa_quest") == 6 then
        quester = person
        break
    end
end
if not quester then
    self.room:find_actor("mild"):say("Where did you go?")
    return true
end
if quester:get_quest_stage("ursa_quest") == 6 then
    -- now find the right script to run, based on that players questvar: choice
    if quester:get_quest_var("ursa_quest:choice") == 1 then
        wait(5)
        self.room:send("The mild mannered merchant says, 'Fantastic.  Now let's see what miracle the Emperor has found.'")
        self.room:find_actor("mild"):emote("digs a slight divot into the ground with the end of the thorny staff.")
        self.room:find_actor("mild"):emote("places the pepper and plant into the divot.")
        self.room:find_actor("mild"):emote("leaves the thorny staff standing erect out of the ground.")
        wait(2)
        self.room:find_actor("mild"):command("hold pitcher")
        self.room:find_actor("mild"):command("pour pitcher out")
        self.room:find_actor("mild"):emote("gently fills the pitcher from the Sacred Spring.")
        wait(1)
        self.room:find_actor("mild"):emote("pours sacred water over the thorny staff.")
        self.room:send("The ground at the base of the staff quickly soaks up the water as it trickles down.")
        wait(3)
        self.room:send("At the base of the <white>thorny staff</> <b:green>life</> breaks forth!")
        self.room:send("A <green>vine</> crawls up the <white>staff</>, weaving between the <white>thorns</>.")
        wait(1)
        self.room:send("The <green>vine completely covers the </><white>thorny</> <green>staff.</>")
        wait(2)
        self.room:send("The mild mannered merchant reaches out his hand and grasps the <white>thorny</> <green>staff</>.")
        self.room:send("The <green>vine</> soaks up the <red>blood</> as the <white>thorns</> pierce the merchant's hand.")
        wait(2)
        self.room:send("<yellow>The merchant contorts wildly, shifting unevenly between man and beast, but retains his grasp on the <green>staff.</>")
        wait(2)
        self.room:send("The mild mannered merchant removes his wounded hand, and the <green>vine</> recedes back into the earth, taking with it the blood and the thorns.")
        self.room:find_actor("mild"):emote("takes a moment to catch his breath.")
        wait(3)
        self.room:find_actor("merchant"):emote("pulls <green>The Redeeming Staff</> from the ground.")
        -- load staff and give it to the player
        wait(2)
        self.room:spawn_object(625, 9)
        self.room:find_actor("mild"):command("get staff")
        self.room:find_actor("mild"):emote("runs his hand down the smooth staff.")
        wait(2)
        self.room:send("The mild mannered merchant says, 'I can not thank you enough!  I have myself back!'")
        wait(1)
        self.room:find_actor("mild"):command("give staff " .. tostring(quester))
        self.room:send("The mild mannered merchant says, 'I feel a lot of power in this staff.  I hope it can serve you well.'")
        wait(2)
        self.room:find_actor("mild"):say("And have these as a show of my gratitude.")
        for _ = 1, 3 do
            self.room:find_actor("mild"):spawn_object(557, 36 + random(1, 11))
        end
        self.room:find_actor("mild"):command("give all.gem " .. tostring(quester))
        self.room:find_actor("mild"):command("tip " .. tostring(quester))
        self.room:find_actor("mild"):emote("leaves north toward Blue Fog Trail.")
        world.destroy(self.room:find_actor("merchant"))
    elseif quester:get_quest_var("ursa_quest:choice") == 2 then
        wait(1)
        self.room:find_actor("mild"):say("Good enough.")
        self.room:find_actor("mild"):command("wear " .. tostring(object))
        self.room:find_actor("mild"):command("drink firebreather")
        wait(2)
        self.room:find_actor("mild"):emote("suddenly falls face-down on the ground, holding the dagger in place.")
        self.room:send("The dagger drives home!")
        wait(1)
        self.room:send("The mild mannered merchant contorts wildly, flashing, his form unclear.")
        wait(1)
        self.room:send("More beast than man, <yellow>Ursa roars in pain,</> the dagger gleaming in his heart.")
        wait(2)
        self.room:find_actor("mild"):emote("slumps silently to the ground, and the dagger clatters to the ground beside him.")
        wait(5)
        self.room:find_actor("mild"):command("groan")
        wait(3)
        self.room:find_actor("mild"):emote("looks himself up down.")
        wait(1)
        self.room:find_actor("mild"):say("It worked!  I did it!")
        wait(1)
        self.room:find_actor("mild"):emote("removes each of the king's items, many of them having undergone radical changes in the ordeal.")
        self.room:find_actor("mild"):emote("tosses them one by one into the pool, letting them sink to the bottom.")
        wait(1)
        self.room:find_actor("mild"):say("Thanks, pal!")
        self.room:find_actor("mild"):emote("disappears up the trail toward Blue-Fog Trail.")
        world.destroy(self.room:find_actor("mild"))
        wait(2)
        self.room:send("on the banks of the pool, something catches your eye.")
        wait(1)
        self.room:send("The diadem, having formed into hollow but hard glass, washes to the shore.")
        self.room:send("Upon second inspection you can see the form of the enraged Ursa, as if it were trying to escape its new glass home.")
        self.room:send("Several glittering gems wash up along with it.")
        for _ = 1, 3 do
            self.room:spawn_object(557, 36 + random(1, 11))
        end
        self.room:spawn_object(625, 8)
    elseif quester:get_quest_var("ursa_quest:choice") == 3 then
        wait(1)
        self.room:find_actor("mild"):emote("tosses the anvil to the ground with a grunt.")
        wait(3)
        self.room:find_actor("mild"):emote("places the ring of stolen life on the anvil.")
        wait(1)
        self.room:find_actor("mild"):emote("wields the Golden Druidstaff.")
        wait(3)
        self.room:send("<b:green>The mild mannered merchant </><b:red>CRUSHES</><b:green> the ring of stolen life with a swift blow.</>")
        wait(2)
        self.room:find_actor("mild"):emote("gathers the powdered ring into the milk, gives it a swirl, and drinks the milk to the last drop.")
        wait(2)
        self.room:send("The mild mannered merchant says, 'That should do the job.  I'm feeling better already!'")
        wait(4)
        self.room:send("You hear a deep grumbling, from the direction of the merchant.")
        wait(4)
        self.room:find_actor("merchant"):emote("frantically pulls a misty blue sword from his things.")
        self.room:send("The mild mannered merchant says, 'It's coming back!  I don't think I'll be able to regain control!'")
        self.room:send("A mild mannered merchant falls on his own sword! (<b:red>564</>)")
        wait(2)
        self.room:send("<yellow>A mild mannered merchant lets out a disturbing <blue>ROAR</><yellow> as the last of his humanity slips away.</>")
        world.destroy(self.room:find_actor("mild"))
        self.room:spawn_mobile(625, 50)
        self.room:spawn_object(625, 7)
        self.room:find_actor("ursa"):command("get sword")
        self.room:find_actor("ursa"):command("wi sword")
        for _ = 1, 3 do
            self.room:find_actor("ursa"):spawn_object(557, 36 + random(1, 11))
        end
    end
    --
    -- Compute experience reward, capped at level 50, scaled by class.
    --
    local expcap
    if quester.level < 50 then
        expcap = quester.level
    else
        expcap = 50
    end
    local expmod
    if expcap < 9 then
        expmod = (((expcap * expcap) + expcap) / 2) * 55
    elseif expcap < 17 then
        expmod = 440 + ((expcap - 8) * 125)
    elseif expcap < 25 then
        expmod = 1440 + ((expcap - 16) * 175)
    elseif expcap < 34 then
        expmod = 2840 + ((expcap - 24) * 225)
    elseif expcap < 49 then
        expmod = 4640 + ((expcap - 32) * 250)
    elseif expcap < 90 then
        expmod = 8640 + ((expcap - 48) * 300)
    else
        expmod = 20940 + ((expcap - 89) * 600)
    end
    --
    -- Adjust exp award by class so all classes receive the same proportionate amount.
    --
    if quester.class == "Warrior" or quester.class == "Berserker" then
        -- 110% of standard
        expmod = expmod + (expmod / 10)
    elseif quester.class == "Paladin" or quester.class == "Anti-Paladin" or quester.class == "Ranger" then
        -- 115% of standard
        expmod = expmod + ((expmod * 2) / 15)
    elseif quester.class == "Sorcerer" or quester.class == "Pyromancer" or quester.class == "Cryomancer" or quester.class == "Illusionist" or quester.class == "Bard" then
        -- 120% of standard
        expmod = expmod + (expmod / 5)
    elseif quester.class == "Necromancer" or quester.class == "Monk" then
        -- 130% of standard
        expmod = expmod + ((expmod * 2) / 5)
    end
    quester:send("<b:yellow>You gain experience!</>")
    local setexp = expmod * 10
    for _ = 1, 10 do
        quester:award_exp(setexp)
    end
    quester:complete_quest("ursa_quest")
end