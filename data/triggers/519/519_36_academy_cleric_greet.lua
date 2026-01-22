-- Trigger: academy_cleric_greet
-- Zone: 519, ID: 36
-- Type: MOB, Flags: GREET_ALL
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--   Large script: 9989 chars
--
-- Original DG Script: #51936

-- Converted from DG Script #51936: academy_cleric_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
local stage = actor:get_quest_stage("school")
if stage == 3 or stage == 4 then
    if stage == 3 then
        -- switch on actor:get_quest_var("school:fight")
        if actor:get_quest_var("school:fight") == 1 then
            actor:send(tostring(self.name) .. " tells you, '<b:cyan>SPELL</> will show you all the spells you currently know.")
            actor:send("As a cleric, you know all the spells on the list.")
            actor:send("You don't need to write them down in a book to know them.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Check your spell list now by typing <b:green>spell</>.'")
        elseif actor:get_quest_var("school:fight") == 2 then
            actor:send("The syntax to cast is <b:cyan>(c)ast '[spell]' [target]</>.")
            actor:send("</>")
            actor:send("FieryMUD will try to match <b:cyan>abbreviations of spell names and targets.</>")
            actor:send("If a spell name has more than one word, you <b:cyan>must</> put single quotation marks <b:cyan>' '</> around the spell name.")
            actor:send("</>")
            actor:send("Spellcasting is not instaneous either.")
            actor:send("Each spell has a base length to cast.")
            actor:send("The <b:cyan>QUICK CHANT</> skill will help reduce casting time.'")
            wait(3)
            actor:send(tostring(self.name) .. " tells you, '<b:cyan>CAST</> the Cure Light spell, your most basic healing spell, on me.")
            actor:send("</>Type <b:green>cast 'cure light' professor</>.'")
        elseif actor:get_quest_var("school:fight") == 3 then
            actor:send("You can use the <b:cyan>(STU)DY</> command to see all the information about your spell slots, including:")
            actor:send("<b:magenta>1. How many spell slots you have")
            actor:send("2. Which spell slots you've used")
            actor:send("3. How long each slot will take to recover</>")
            actor:send("</>")
            actor:send("Check your current recovery status by typing <b:green>study</> now.'")
        elseif actor:get_quest_var("school:fight") == 4 then
            actor:send(tostring(self.name) .. " tells you, 'Spell slots will recover significantly faster if you <b:cyan>(MED)ITATE</>.")
            actor:send("I'll walk you through that process now.")
            actor:send("First, get comfortable.")
            actor:send("Type <b:green>rest</> to take a seat and settle down.'")
        elseif actor:get_quest_var("school:fight") == 5 then
            actor:send(tostring(self.name) .. " tells you, 'You should <b:cyan>(MED)ITATE</> to get into the proper state of mind.")
            actor:send("As it goes up, the <b:cyan>MEDITATE</> skill increases your <b:cyan>FOCUS</> score when you <b:cyan>MEDITATE</>.")
            actor:send("You can <b:cyan>MEDITATE</> as long as you're not in combat.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Type <b:green>meditate</> to start.'")
        elseif actor:get_quest_var("school:fight") == 6 then
            actor:set_quest_var("school", "fight", 7)
        elseif actor:get_quest_var("school:fight") == 7 then
            self.room:spawn_mobile(519, 0)
            self.room:send(tostring(self.name) .. " summons a horrible little monster!")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Killing creatures like this is how you gain experience.")
            actor:send("Gaining experience is how you go up in level.")
            actor:send("Player killing is generally not allowed in FieryMUD.")
            actor:send("This includes casting offensive spells at other players.")
            actor:send("</>")
            actor:send("</>Before you strike, take a moment to size up your opponent.")
            actor:send("Use the <b:cyan>(CO)NSIDER</> command to see what your chances are.")
            actor:send("Keep in mind FieryMUD is made for groups of 4-8, so the results of <b:cyan>CONSIDER</> aren't perfect")
            actor:send("Also keep in mind most of a cleric's strength is support.")
            actor:send("It will be harder for you to kill creatures alone.'")
            actor:send("</>")
            actor:send(tostring(self.name) .. " tells you, 'Type <b:green>consider monster</> for see chances.'")
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
            wait(1)
            self:command("bow " .. tostring(actor))
            actor:send(tostring(self.name) .. " tells you, 'Peace be upon you.'")
            wait(1)
            actor:send(tostring(self.name) .. " tells you, 'Greetings " .. tostring(actor.name) .. ".  I am Ethilien Academy's Professor of Divinity.  Welcome to our chapel.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'I understand you're here to learn the basics of spiritual <b:yellow>COMBAT</>.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Let's start by looking at your <b:cyan>(SK)ILLS</>.")
            actor:send("Type <b:green>skill</> to see what you can do.'")
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