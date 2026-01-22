-- Trigger: academy_instructor_speech_expl_commands
-- Zone: 519, ID: 15
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Large script: 5264 chars
--
-- Original DG Script: #51915

-- Converted from DG Script #51915: academy_instructor_speech_expl_commands
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: look search doors scan movement
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "look") or string.find(string.lower(speech), "search") or string.find(string.lower(speech), "doors") or string.find(string.lower(speech), "scan") or string.find(string.lower(speech), "movement")) then
    return true  -- No matching keywords
end
if actor:get_quest_var("school:explore") == 6 then
    -- switch on speech
    if speech == "look" then
        actor:send(tostring(self.name) .. " tells you, 'As you look around the room, you'll get four big pieces of information:'")
        actor:send("</>")
        actor:send("</><b:magenta>1. The description of the room.</>")
        actor:send("</>   Tiny but crucial hints can appear in room descriptions - keep your eyes open!")
        actor:send("</>")
        actor:send("</><b:magenta>2. The visible exits from the room.</>")
        actor:send("</>   FieryMUD uses six directions: north, south, east, west, up, and down.")
        actor:send("</>   If an exit is visible, it will appear after a hyphen.")
        actor:send("</>   Closed exits like doors and trapdoors will have a # sign after them.")
        actor:send("</>")
        actor:send("<b:magenta>3. Any visible objects.</>")
        actor:send("</>   By default, all identical objects will appear on one line with a number on the left showing how many there are.")
        actor:send("</>")
        actor:send("</><b:magenta>4. All visible creatures.</>")
        actor:send("</>   All identical creatures will appear as one line.")
        actor:send("</>")
        actor:send("You can <b:cyan>LOOK</> at anything to gain more information about it.")
        actor:send("That can be objects, creatures, even the directions!")
    elseif speech == "search" then
        actor:send(tostring(self.name) .. " tells you, 'Throughout the world there are hundreds of hidden doors.")
        actor:send("There can be hints in the room description, or you can try to find them by typing <b:cyan>LOOK [direction]</>.")
        actor:send("</>")
        actor:send("To interact with the door, you have to <b:cyan>(SEA)RCH</> for it first.")
        actor:send("</>")
        actor:send("If you do know what you're looking for, you can type <b:cyan>SEARCH [keyword]</> to find it automatically.")
        actor:send("You might be able to guess the keywords from what you see when you look at things or in directions!")
        actor:send("</>")
        actor:send("If you don't know the keyword, you can just enter <b:cyan>SEARCH</>.")
        actor:send("You'll have a random chance to find any hidden doors.")
        actor:send("</>")
        actor:send("Be aware!  There is a small stun time after you <b:cyan>SEARCH</>!")
        actor:send("It can be very risky to use it in dangerous areas!'")
    elseif speech == "door" then
        actor:send(tostring(self.name) .. " tells you, 'Once you've uncovered a secret door you can interact with it like a normal door.")
        actor:send("You can use the <b:cyan>(O)PEN</> and <b:cyan>(CL)OSE</> commands to open doors or containers.")
        actor:send("Sometimes they might be locked though, and you'll need a key to unlock them.")
        actor:send("</>")
        actor:send("If you <b:cyan>LOOK EAST</>, you can see the curtain from this room is closed.")
        actor:send("To open it just use the <b:cyan>(O)PEN</> command.'</>")
    elseif speech == "scan" then
        actor:send(tostring(self.name) .. " tells you, 'You can <b:cyan>(SCA)N</> to see what's in the areas around you.")
        actor:send("It's free to use and very helpful for anticipating threats.")
        actor:send("Some classes are even able to see more than one room away.")
        actor:send("There is a slight delay after giving the <b:cyan>SCAN</> command, so be careful.'")
    elseif speech == "movement" then
        actor:send(tostring(self.name) .. " tells you, 'You can move in any direction there's an open exit.")
        actor:send("Just type <b:cyan>(N)ORTH (S)OUTH (E)AST (W)EST (U)P</> or <b:cyan>(D)OWN</>.")
        actor:send("</>")
        actor:send("In the lower-left corner of your screen you'll see a display that looks like this:")
        actor:send("<b:yellow>10h(10H) 100v(100V)</>")
        actor:send("The two numbers on the right are your <b:magenta>Movement Points</>.")
        actor:send("The first number is your <b:magenta>Current Movement Points</>.")
        actor:send("The second number is your <b:magenta>Maximum Movement Points</>.")
        actor:send("Your <b:magenta>Maximum</> will increase until level 50.")
        actor:send("</>")
        actor:send("When you move from room to room, your Movement Points go down.")
        actor:send("The amount of Movement Points needed to move around varies by terrain.")
        actor:send("If your Movement Points reach 0 you can't move until you rest.'")
    end
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'Would you like to review something else?")
    actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
end