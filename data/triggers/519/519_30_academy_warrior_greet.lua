-- Trigger: academy_warrior_greet
-- Zone: 519, ID: 30
-- Type: MOB, Flags: GREET_ALL
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--   Large script: 10381 chars
--
-- Original DG Script: #51930

-- Converted from DG Script #51930: academy_warrior_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
local stage = actor:get_quest_stage("school")
if stage == 3 or stage == 4 then
    if stage == 3 then
        -- switch on actor:get_quest_var("school:fight")
        if actor:get_quest_var("school:fight") == 1 then
            actor:send(tostring(self.name) .. " tells you, 'You need to take your combat <b:cyan>(SK)ILLS</> into consideration as well.")
            actor:send("Warriors have a wide variety of special <b:cyan>SKILLS</>.")
            actor:send("Type <b:green>skill</> to see what they are.'")
        elseif actor:get_quest_var("school:fight") == 2 then
            actor:send("One of your most basic skills is <b:cyan>KICK</>.")
            actor:send("It's an extra attack that delivers some bonus damage.")
            actor:send("There is a short stun after you <b:cyan>KICK</>.")
            actor:send("So be very, very careful about spamming the skill.")
            actor:send("</>")
            actor:send("You probably won't land a kick for many levels, but keep trying.")
            actor:send("Practice makes perfect.'")
            actor:send("</>")
            wait(3)
            if world.count_mobiles("51900") == 0 then
                self.room:spawn_mobile(519, 0)
                self.room:send(tostring(self.name) .. " summons a horrible little monster!")
                wait(1)
            end
            actor:send(tostring(self.name) .. " tells you, 'Give it a try!")
            actor:send("Type <b:green>kick monster</>.'")
            if not actor:has_item("1150") and not actor:has_equipped("1150") then
            elseif actor:get_quest_var("school:fight") == 3 then
                actor:send(tostring(self.name) .. " takes a wooden shield off a rack.")
                self.room:spawn_object(11, 50)
                self:command("give shield " .. tostring(actor))
                actor:send("</>")
                actor:send(tostring(self.name) .. " tells you, 'Equip that with <b:green>wear shield</>.'")
            elseif actor:has_item("1150") then
                actor:send(tostring(self.name) .. " tells you, 'Equip that " .. get_obj_noadesc("1150") .. " I gave you with <b:green>wear shield</>.'")
            elseif actor:has_equipped("1150") then
                actor:set_quest_var("school", "fight", 4)
            end
        elseif actor:get_quest_var("school:fight") == 4 then
            actor:send(tostring(self.name) .. " tells you, '<b:cyan>BASH</> deals some damage, but more importantly it <b:red>knocks your opponent down</>.")
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
            wait(3)
            if world.count_mobiles("51900") == 0 then
                self.room:spawn_mobile(519, 0)
                self.room:send(tostring(self.name) .. " summons a horrible little monster!")
                wait(1)
            end
            actor:send(tostring(self.name) .. " tells you, 'I want you to practice bashing now.")
            actor:send("</>Type <b:green>bash monster</>.  Don't worry, I'm here to protect you.'</>")
            if world.count_mobiles("51900") == 0 then
            elseif actor:get_quest_var("school:fight") == "last" then
                self.room:spawn_mobile(519, 0)
                self.room:send(tostring(self.name) .. " summons a horrible little monster!")
                wait(1)
            end
            actor:send(tostring(self.name) .. " tells you, 'To attack a creature use the <b:cyan>(KIL)L</> command.")
            actor:send("Type <b:green>kill monster</> to start fighting.")
            actor:send("</>")
            actor:send(tostring(self.name) .. " tells you, 'When you've killed the monster, I'll teach you about <b:yellow>LOOT</> and <b:yellow>TOGGLES</>.'")
            actor:send("<b:green>Say loot</> when you're ready to continue.'")
        else
            actor:send(tostring(self.name) .. " turns to greet you.")
            wait(2)
            self:command("salute " .. tostring(actor))
            actor:send(tostring(self.name) .. " tells you, 'Well met soldier!'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Greetings " .. tostring(actor.name) .. ".  I am the Warmaster of Ethilien Academy.  Welcome to our ranks.'")
            wait(3)
            actor:send(tostring(self.name) .. " tells you, 'I understand you're here to learn <b:yellow>COMBAT</> basics.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Well then grunt, fall in and listen up!'")
            wait(3)
            self.room:spawn_mobile(519, 0)
            self.room:send(tostring(self.name) .. " summons a horrible little monster!")
            wait(3)
            actor:send(tostring(self.name) .. " tells you, 'Killing creatures like this is how you gain experience.")
            actor:send("You gain experience to advance in level.")
            actor:send("Player killing is generally not allowed in FieryMUD.'")
            -- (empty send to actor)
            actor:send("Before you charge in, take a moment to size up your opponent.")
            actor:send("Use the <b:cyan>(CON)SIDER</> command to see what your chances are against it.")
            actor:send("Bare in mind FieryMUD is made for groups of 4-8 players, so the results of <b:cyan>CONSIDER</> aren't perfect.'")
            wait(3)
            actor:send(tostring(self.name) .. " tells you, 'Type <b:green>consider monster</> and see what happens.'")
        end
        actor:send("</>")
        actor:send(tostring(self.name) .. " tells you, 'You can also say <magenta>SKIP</> at any time to talk about <b:yellow>LOOT</> and <b:yellow>TOGGLES</> instead.'")
    elseif stage == 4 then
        -- switch on actor:get_quest_var("school:loot")
        if actor:get_quest_var("school:loot") == 1 then
            actor:send(tostring(self.name) .. " tells you, 'When something dies, it usually leaves behind a <b:yellow>corpse</>.'")
            wait(1)
            self:command("poke " .. tostring(actor))
            actor:send(tostring(self.name) .. " tells you, 'That goes for you too kid.'")
            wait(3)
            actor:send(tostring(self.name) .. " tells you, 'A corpse is like a container.")
            actor:send("You can <b:cyan>EXAMINE corpse</> it to see what it has on it.  You can")
            actor:send("</><b:cyan>GET [object] corpse</> to take something specific, or you can <b:cyan>GET ALL corpse</> to take everything on it.")
            actor:send("Corpses keep their names as keywords so you can use those too.")
            actor:send("</>")
            actor:send("You can't pick up a corpse, but you can <b:cyan>DRAG</> them from room to room.")
            actor:send("You need <b:cyan>CONSENT</> to drag a player corpse though.")
            actor:send("</>")
            actor:send("If YOU die, you have to trudge all the way back to the room you died in, then get everything from your body, like <b:cyan>GET ALL corpse</>, to get your stuff.'")
            actor:send("</>")
            actor:send(tostring(self.name) .. " tells you, 'For now just type <b:green>get all corpse</> and we'll keep moving.'")
        elseif actor:get_quest_var("school:loot") == 2 then
            actor:send(tostring(self.name) .. " tells you, 'The other thing I need to show you is the <b:cyan>TOGGLE</> command.")
            actor:send("Typing <b:cyan>TOGGLE</> alone will show you everything you can set.")
            actor:send("<b:cyan>AUTOLOOT</> picks up everything from a corpse instantly.")
            actor:send("<b:cyan>AUTOTREAS</> picks up only \"treasure\" like coins and gems.")
            actor:send("Each toggle has a <b:cyan>HELP</> file with more information.'")
            actor:send("</>")
            actor:send(tostring(self.name) .. " tells you, 'For now, let's get you ready to gather and share loot.")
            actor:send("Type <b:green>toggle autoloot</> to loot future kills!'")
        elseif actor:get_quest_var("school:loot") == 3 then
            actor:send(tostring(self.name) .. " tells you, 'When playing with others it's considered polite to share the wealth.")
            actor:send("You can share money with the <b:cyan>SPLIT</> command.")
            actor:send("With <b:cyan>TOGGLE AUTOSPLIT</> on the game will automatically do that when you pick up money.'")
            actor:send("</>")
            actor:send(tostring(self.name) .. " tells you, 'Type <b:green>toggle autosplit</> to set that.'")
        elseif actor:get_quest_var("school:loot") == 4 then
            actor:send(tostring(self.name) .. " tells you, 'The last combat tip is checking your <b:cyan>(TRO)PHY</> list.")
            actor:send("<b:cyan>TROPHY</> shows a record of the last 24 creatures you've killed and how many times you've killed them.'")
            actor:send("</>")
            actor:send(tostring(self.name) .. " tells you, 'Type <b:green>trophy</> and see your record.'")
        else
            actor:send(tostring(self.name) .. " tells you, '<b:green>Say loot</> to learn about <b:yellow>LOOT</> and <b:yellow>TOGGLES.'")
        end
        actor:send("</>")
        actor:send(tostring(self.name) .. " tells you, 'You can also say <magenta>SKIP</> to move on to the next teacher.'")
    end
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'You can also say <magenta>EXIT</> at any time to leave the Academy.'")
end