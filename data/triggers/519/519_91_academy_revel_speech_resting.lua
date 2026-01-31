-- Trigger: academy_revel_speech_resting
-- Zone: 519, ID: 91
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--   Large script: 6391 chars
--
-- Original DG Script: #51991

-- Converted from DG Script #51991: academy_revel_speech_resting
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: resting
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "resting")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("school") == 5 then
    -- switch on actor:get_quest_var("school:rest")
    if actor:get_quest_var("school:rest") == 1 then
        actor:send(tostring(self.name) .. " tells you, 'If you want to speed up your recovery, you can lay down and go to <b:cyan>SLEEP</>.")
        actor:send("There're some risks with sleeping.")
        actor:send("You won't be able to hear or see the world around you, so you won't know if danger is approaching.")
        actor:send("You won't be able to use <b:cyan>SAY</> or <b:cyan>SHOUT</>, or do anything most people can't normally do in their sleep.")
        actor:send("You can still <b:cyan>GOSSIP</>, <b:cyan>TELL</>, and check your <b:cyan>INVENTORY</> or <b:cyan>EQUIPMENT</> though!'")
        actor:send("</>")
        actor:send(tostring(self.name) .. " tells you, 'Take a quick nap!  Type <b:green>sleep</> to lay down.'")
    elseif actor:get_quest_var("school:rest") == 2 then
        actor:set_quest_var("school", "rest", 3)
    elseif actor:get_quest_var("school:rest") == 3 then
        actor:send(tostring(self.name) .. " tells you, 'You'll frequently notice yourself getting hungry or thirsty.")
        actor:send("You can speed up your recovery if you <b:cyan>EAT</> and <b:cyan>(DRI)NK</>.")
        actor:send("</>")
        actor:send("When you get thirsty it's time to <b:cyan>DRINK</>!")
        actor:send("Ethilien has a huge variety of drinkable liquids.")
        actor:send("Any of them will slake your thirst.")
        actor:send("The command is <b:cyan>DRINK [container]</>.")
        actor:send("</>")
        actor:send("When you <b:cyan>DRINK</>, you'll also regain some Movement Points, so make sure you carry a full waterskin so you can keep moving when you explore!")
        actor:send("</>")
        actor:send("And remember, magic potions are <red>not</> drinks.")
        actor:send("If you want to consume a potion, the commmand is <b:cyan>(Q)UAFF</>, not <b:cyan>(DRI)NK</>.'")
        wait(3)
        if not actor:has_item("20") and not actor:has_equipped("20") then
            actor:send(tostring(self.name) .. " tells you, 'Here's a new waterskin for you.")
            self.room:spawn_object(0, 20)
            self:command("give waterskin " .. tostring(actor))
        else
            actor:send(tostring(self.name) .. " tells you, 'You started play with a full waterskin.")
        end
        actor:send("</>Type <b:green>drink waterskin</> now to drink out of it.'")
    elseif actor:get_quest_var("school:rest") == 4 then
        actor:set_quest_var("school", "rest", 5)
    elseif actor:get_quest_var("school:rest") == 5 then
        actor:send(tostring(self.name) .. " tells you, 'Now you can <b:green>fill waterskin fountain</>.'")
    elseif actor:get_quest_var("school:rest") == 6 then
        actor:send(tostring(self.name) .. " tells you, 'Now we feast!'")
        wait(2)
        self.room:spawn_object(203, 5)
        self:command("give meat " .. tostring(actor.name))
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Ethilien is filled with edible foods.")
        actor:send("</>You can <b:cyan>EAT</> your way across the world! Being full increases your regeneration rate.")
        actor:send("Every time you <b:cyan>EAT</> you also immediately regain some Hit Points!")
        actor:send("Food has no other effects though.'")
        actor:send("</>")
        actor:send(tostring(self.name) .. " tells you, 'Come, feast with me!  Type <b:green>eat meat</>!'")
        self.room:spawn_object(203, 5)
    elseif actor:get_quest_var("school:rest") == 7 then
        actor:send(tostring(self.name) .. " tells you, 'There are just a few final things to know before you head out into the world.'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'The best place to start your adventures is the <b:yellow>FARMLAND</> immediately west of the town of Mielikki, the starting town above us.'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'The <b:cyan>HELP ZONE</> file will show you lots of places to explore.")
        actor:send("Type <b:green>help zone</> and check it out.'")
    elseif actor:get_quest_var("school:rest") == "complete" then
        actor:send(tostring(self.name) .. " tells you, 'When you're ready to stop playing, to safely log out, you have to find an inn.")
        actor:send("Talk to the inn's receptionist and <b:cyan>RENT</> a room.")
        actor:send("Think of inns like save points.")
        actor:send("Renting stores all your items for free.")
        actor:send("When you log back in, you'll be at the inn.'")
        actor:send("</>")
        if actor:get_quest_var("school:money") == "complete" and actor:get_quest_var("school:rest") == "complete" then
            actor:send(tostring(self.name) .. " tells you, '<b:green>Say finish</> to end the school.'")
        else
            actor:send(tostring(self.name) .. " tells you, '<b:green>Say money</> to finish your last lesson, or say <magenta>SKIP</> to jump to the end of the Academy.'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'Hit Points and Movement Points regenerate naturally over time.")
        actor:send("The rate is influenced by a number of factors, including position and nutrition.'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'You might not realize you're healing though, because your display only updates when you get some kind of input!'")
        wait(1)
        actor:send(tostring(self.name) .. " tells you, 'Your regeneration speeds up if you <b:cyan>(R)EST</> or <b:cyan>(SL)EEP</>.")
        actor:send("When you <b:cyan>REST</>, you sit down and relax.")
        actor:send("You remain awake, and can hear and see the world around you.")
        actor:send("You can do most things, including talking, eating, changing gear, and recovering spells.'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Take a load off!")
        actor:send("Type <b:green>rest</> to relax.'")
    end
end