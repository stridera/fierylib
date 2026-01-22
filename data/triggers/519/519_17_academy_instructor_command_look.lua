-- Trigger: academy_instructor_command_look
-- Zone: 519, ID: 17
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51917

-- Converted from DG Script #51917: academy_instructor_command_look
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: look
if not (cmd == "look") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor:get_quest_var("school:explore") == 1 and not arg then
    actor:set_quest_var("school", "explore", 2)
    -- actor looks around
    wait(2)
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
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'For example, type <b:green>look curtain</> to find more clues.'")
elseif actor:get_quest_var("school:explore") == 2 and arg == "curtain" then
    actor:set_quest_var("school", "explore", 3)
    actor:command("look curtain")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'And THAT is a hidden door!'")
    actor:send("</>")
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
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'But for now, type <b:green>search curtain</> and take a look!'")
end
_return_value = false
return _return_value