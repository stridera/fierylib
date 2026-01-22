-- Trigger: academy_rogue_greet
-- Zone: 519, ID: 26
-- Type: MOB, Flags: GREET_ALL
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--   Large script: 8578 chars
--
-- Original DG Script: #51926

-- Converted from DG Script #51926: academy_rogue_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
local stage = actor:get_quest_stage("school")
if stage == 3 or stage == 4 then
    if stage == 3 then
        -- switch on actor:get_quest_var("school:fight")
        if actor:get_quest_var("school:fight") == 1 then
            actor:send(tostring(self.name) .. " tells you, 'First, I want to introduce you to <b:cyan>(HID)E</>.")
            actor:send("If you're hidden, it makes it much harder for enemies to see you.")
            actor:send("If enemies can't see you, they can't attack you.")
            actor:send("It can get you out of some nasty scrapes.")
            actor:send("But if you do anything to draw attention to yourself, you'll stop hiding.")
            actor:send("</>")
            actor:send("You automatically <b:cyan>SNEAK</> if you move while hidden.")
            actor:send("<b:cyan>SNEAK</> helps you stay hidden as you walk.")
            actor:send("</>")
            actor:send("Both of these skills rely on the <b:cyan>HIDE</> command.'")
            actor:send("</>")
            actor:send(tostring(self.name) .. " tells you, 'Go ahead and give it a try!  Type <b:green>hide</>.'")
        elseif actor:get_quest_var("school:fight") == 2 then
            actor:send(tostring(self.name) .. " tells you, 'Killing creatures is how you gain experience.")
            actor:send("Gaining experience is how you advance in level.")
            actor:send("Player killing is generally not allowed in FieryMUD.'")
            actor:send("</>")
            actor:send(tostring(self.name) .. " tells you, 'Before you leap out of the shadows, take a moment to size up this creature.")
            actor:send("Use the <b:cyan>(CON)SIDER</> command to see what your chances are against it.")
            actor:send("Bare in mind FieryMUD is made for groups of 4-8, so the results of <b:cyan>CONSIDER</> aren't perfect.'")
            wait(7)
            if world.count_mobiles("51900") == 0 then
                self.room:spawn_mobile(519, 0)
                self.room:send(tostring(self.name) .. " summons a horrible little monster!")
            end
            actor:send(tostring(self.name) .. " tells you, 'Type <b:green>consider monster</> and see what happens.'")
        elseif actor:get_quest_var("school:fight") == "last" then
            actor:send(tostring(self.name) .. " tells you, 'To attack a creature use the <b:cyan>(KIL)L</> command.")
            actor:send("But as a rogue, you have a special opening attack!'")
            wait(3)
            actor:send(tostring(self.name) .. " tells you, 'The <b:cyan>(B)ACKSTAB</> command has a chance to do extreme damage.'")
            actor:send("</>")
            actor:send(tostring(self.name) .. " tells you, 'Type <b:green>backstab monster</> to start fighting.")
            actor:send("</>")
            actor:send("You can always use the <b:cyan>(FL)EE</> command to try to run away.")
            actor:send("It's a good idea to <b:cyan>FLEE</> if you start to run low on hit points.")
            actor:send("But if you try to flee and fail, you'll be stunned for a little bit.")
            actor:send("So don't wait until the last second to run!'")
            wait(3)
            if world.count_mobiles("51900") == 0 then
                self.room:spawn_mobile(519, 0)
                self.room:send(tostring(self.name) .. " summons a horrible little monster!")
            end
            wait(1)
            actor:send(tostring(self.name) .. " tells you, 'When you've killed the monster, <b:green>say loot</>.")
            actor:send("We'll continue from there.'")
        else
            actor:send("You sense the presence of someone behind you.")
            wait(2)
            actor:send(tostring(self.name) .. " pops out of the shadows!")
            actor:send(tostring(self.name) .. " shouts, 'Boo!'")
            self:command("grin " .. tostring(actor))
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Greetings " .. tostring(actor.name) .. ".  They call me Doctor Mischief.  I am the Rogue Master of Ethilien Academy.  Pleasure to meet you.'")
            self:command("bow " .. tostring(actor))
            wait(3)
            actor:send(tostring(self.name) .. " tells you, 'I understand you're here to learn the basics of stealth <b:yellow>COMBAT</>.'")
            self:command("nod")
            actor:send(tostring(self.name) .. " tells you, 'People with our skills do best in the shadows.  Start by typing <b:green>skill</> to see what you can do.'")
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