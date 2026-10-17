-- Playtest r14 U2/U3: academy tutorial wording (519)
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).
-- Guarded: a row is only touched while it still holds the previous committed
-- file (md5 of the body or of the whole file, with or without the final
-- newline), so rows edited in Muditor since then are left alone.

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/519/519_08_academy_instructor_command_equipment.lua
  (519, 8, $trig$-- Converted from DG Script #51908: academy_instructor_command_equipment
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: equipment
if not (cmd == "equipment") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "e" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:gear") or 0) == 3 then
    actor:set_quest_var("school", "gear", 4)
    actor:command("eq")
    wait(0.2)
    self:command("l " .. tostring(actor))
    actor:send(tostring(self.name) .. " tells you, 'You look well equipped to me!'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Another way to equip things is with the <b:cyan>(HO)LD</> command.")
    if actor:has_item(0, 23) or actor:has_equipped(0, 23) then
        actor:send("You started play with a torch.'")
    else
        actor:send("Here, take this torch for example.'")
        self.room:spawn_object(0, 23)
        self:command("give torch " .. tostring(actor))
    end
    wait(3)
    if actor:has_equipped(0, 23) then
        -- WEAR ALL already put the torch in the off-hand, so HOLD TORCH would only say
        -- "You are already holding..." and the lesson would stall: take the next step now.
        actor:set_quest_var("school", "gear", 5)
        actor:send(tostring(self.name) .. " tells you, 'Looks like you are already holding it, so you can skip that step.")
        actor:send("However, you need to turn it on before it provides you any light.")
        actor:send("The <b:cyan>(LI)GHT</> command turns lights on and off.")
        actor:send("You can just type <b:cyan>light torch</> to light it up.")
        actor:send("If it's already lit, you can type <b:cyan>light torch</> again to extinguish it.'")
        wait(3)
        actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Give it a try and type <b:green>light torch</>.'")
    else
        actor:send(tostring(self.name) .. " tells you, 'Type <b:green>hold torch</> to equip it.'")
    end
end
_return_value = true
return _return_value$trig$, ARRAY['1d8a8ea9d571391a7e0f6a05c22fa744', 'f51ee5bf8a1f5f69cc7d925ae8aa78dc', '386e7b8bf0843a58048fc2502f0d5cdf']),
  -- data/triggers/519/519_15_academy_instructor_speech_expl_commands.lua
  (519, 15, $trig$-- Converted from DG Script #51915: academy_instructor_speech_expl_commands
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"look", "search", "doors", "scan", "movement"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if (actor:get_quest_var("school:explore") or 0) == 6 then
    -- switch on speech
    do
        local _sw1 = string.lower(tostring(speech or ""))
        if _sw1 == "look" then
            actor:send(tostring(self.name) .. " tells you, 'As you look around the room, you'll get four big pieces of information:'")
            actor:send("</>")
            actor:send("</><b:magenta>1. The description of the room.</>")
            actor:send("</>   Tiny but crucial hints can appear in room descriptions - keep your eyes open!")
            actor:send("</>")
            actor:send("</><b:magenta>2. The visible exits from the room.</>")
            actor:send("</>   FieryMUD uses six directions: north, south, east, west, up, down.")
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
        elseif _sw1 == "search" then
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
        elseif _sw1 == "door" then
            actor:send(tostring(self.name) .. " tells you, 'Once you've uncovered a secret door you can interact with it like a normal door.")
            actor:send("You can use the <b:cyan>(O)PEN</> and <b:cyan>(CL)OSE</> commands to open doors or containers.")
            actor:send("Sometimes they might be locked though, and you'll need a key to unlock them.")
            actor:send("</>")
            actor:send("If you <b:cyan>LOOK EAST</>, you can see the curtain from this room is closed.")
            actor:send("To open it just use the <b:cyan>(O)PEN</> command.'</>")
        elseif _sw1 == "scan" then
            actor:send(tostring(self.name) .. " tells you, 'You can <b:cyan>(SCA)N</> to see what's in the areas around you.")
            actor:send("It's free to use and very helpful for anticipating threats.")
            actor:send("Some classes are even able to see more than one room away.")
            actor:send("There is a slight delay after giving the <b:cyan>SCAN</> command, so be careful.'")
        elseif _sw1 == "movement" then
            actor:send(tostring(self.name) .. " tells you, 'You can move in any direction there's an open exit.")
            actor:send("Just type <b:cyan>(N)ORTH (S)OUTH (E)AST (W)EST (U)P</> or <b:cyan>(D)OWN</>.")
            actor:send("</>")
            actor:send("In the lower-left corner of your screen you'll see a display that looks like this:")
            actor:send("<b:yellow>10h(10H) 100v(100V)</>")
            actor:send("The two numbers on the right are your <b:magenta>Stamina</>.")
            actor:send("The first number is your <b:magenta>Current Stamina</>.")
            actor:send("The second number is your <b:magenta>Maximum Stamina</>.")
            actor:send("Your <b:magenta>Maximum</> will increase until level 50.")
            actor:send("</>")
            actor:send("When you move from room to room, your Stamina goes down.")
            actor:send("The amount of Stamina needed to move around varies by terrain.")
            actor:send("If your Stamina reaches 0 you can't move until you rest.'")
        end
    end
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'Would you like to review something else?")
    actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
end$trig$, ARRAY['c65695d25e161b56f8028ab13665105c', '286644d1f08086554d54704614bf66a4', '3533972c35e8fe703c23ad7173658b15']),
  -- data/triggers/519/519_21_academy_instructor_command_scan.lua
  (519, 21, $trig$-- Converted from DG Script #51921: academy_instructor_command_scan
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: scan
if not (cmd == "scan") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" or _sw1 == "sc" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:explore") or 0) == 5 then
    actor:set_quest_var("school", "explore", 6)
    actor:command("scan")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'You can move in any direction there's an open exit.")
    actor:send("Just type <b:cyan>(N)ORTH (S)OUTH (E)AST (W)EST (U)P</> or <b:cyan>(D)OWN</>.")
    actor:send("</>")
    actor:send("In the lower-left corner of your screen you'll see a display that looks like this:")
    actor:send("<b:yellow>10h(10H) 100v(100V)</>")
    actor:send("The two numbers on the right are your <b:magenta>Stamina</>.")
    actor:send("The first number is your <b:magenta>Current Stamina</>.")
    actor:send("The second number is your <b:magenta>Maximum Stamina</>.")
    actor:send("Your <b:magenta>Maximum</> will increase until level 50.")
    actor:send("</>")
    actor:send("When you move from room to room, your Stamina goes down.")
    actor:send("The amount of Stamina needed to move around varies by terrain.")
    actor:send("If your Stamina reaches 0 you can't move until you rest.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Would you like to review exploration?")
    actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
end
_return_value = true
return _return_value$trig$, ARRAY['4364bba5167e3cf7501f715ad42ad159', '5a3d1ba45d4a123404c44479de1e6c0a', 'ecfad2c3a23a3fdef449ce5fe3d6a7fa']),
  -- data/triggers/519/519_23_academy_clerk_greet.lua
  (519, 23, $trig$-- Converted from DG Script #51923: academy_clerk_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(0.2)
if actor:get_quest_stage("school") == 2 then
    if (actor:get_quest_var("school:prep") or 0) == 1 then
        actor:set_quest_var("school", "prep", "complete")
        actor:send(tostring(self.name) .. " tells you, 'Aww, a fresh-faced adventurer, how sweet.'")
        self:command("chuckle")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Well kid, let's get ya ready to fight!")
        actor:send("I have two quick things to introduce you to:")
        actor:send("<b:yellow>HIT POINTS</>, and <b:yellow>(SC)ORE</>.")
        actor:send("</>")
        actor:send("<b:green>Say</> one or the other to learn about it.")
        actor:send("You can also say <magenta>SKIP</> to move to the next lesson.'")
    elseif (actor:get_quest_var("school:score") or 0) == 1 then
        actor:send(tostring(self.name) .. " tells you, 'Let's pick up where we left off.'")
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, '<b:cyan>SCORE</> is how you see all the numeric stuff about yourself:")
        actor:send("Experience, Hit Points, Stamina, Stats, Saves, blah blah blah.'")
        wait(8)
        actor:send(tostring(self.name) .. " tells you, 'Check it out by typing <b:green>score</> now.'")
    end
elseif actor:get_quest_stage("school") == 3 then
    -- switch on actor.class
    do
        local _sw1 = string.lower(tostring(actor.class or ""))
        if _sw1 == "rogue" or _sw1 == "thief" or _sw1 == "assassin" or _sw1 == "mercenary" or _sw1 == "bard" then
            actor:send(tostring(self.name) .. " tells you, 'I see you're a stealthy type.  You'll do best in lessons with Doctor Mischief.  Proceed <b:green>down</> to their classroom.'")
        elseif _sw1 == "sorcerer" or _sw1 == "cryomancer" or _sw1 == "pyromancer" or _sw1 == "necromancer" or _sw1 == "illusionist" then
            actor:send(tostring(self.name) .. " tells you, 'I see you're an arcane spell caster.  You would definitely benefit from the Chair of Arcane Studies' seminar on spellcasting.  Proceed <b:green>south</> to his laboratory.'")
        elseif _sw1 == "cleric" or _sw1 == "priest" or _sw1 == "diabolist" or _sw1 == "druid" then
            actor:send(tostring(self.name) .. " tells you, 'I see you're a divine spell caster.  You would definitely benefit from private classes with the Professor of Divinity.  Proceed <b:green>east</> to his chapel.'")
        elseif _sw1 == "warrior" or _sw1 == "paladin" or _sw1 == "anti-paladin" or _sw1 == "ranger" or _sw1 == "monk" or _sw1 == "berserker" then
            actor:send(tostring(self.name) .. " tells you, 'I see you're a fighter type.  You'll do best learning from the Academy's Warmaster.  Proceed <b:green>north</> to her arena.'")
        else
            actor:send(tostring(self.name) .. " tells you, 'I have no idea where to send you.  Ask a god for help!'")
        end
    end
end$trig$, ARRAY['4c31fd0f1dccb1fa441f8ce5c59eba89', '58809b40c8ba36c71289332903c4a9bf', 'f5453545d1d02637f5cc1a58f5f419e3']),
  -- data/triggers/519/519_24_academy_clerk_command_score.lua
  (519, 24, $trig$-- Converted from DG Script #51924: academy_clerk_command_score
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: score
if not (cmd == "score") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" then
        _return_value = true
        return _return_value
    end
end
if actor:get_quest_stage("school") == 2 then
    if (actor:get_quest_var("school:score") or 0) == 1 then
        actor:set_quest_var("school", "score", "complete")
        actor:command("score")
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, 'Yep, just like that.  The experience bar in that")
        actor:send("</>listing will fill as you kill stuff.  When it reaches full,")
        actor:send("</>you'll be ready to level!'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Are you ready to continue?")
        actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
    end
end
_return_value = true
return _return_value$trig$, ARRAY['c8ab92afa58cc0053bb600b517d9b813', '28ed1b72f59c308a4a63de98ca71951a', '3a85dfff59fc8264542f39830c6673c9']),
  -- data/triggers/519/519_27_academy_rogue_command_skill.lua
  (519, 27, $trig$-- Converted from DG Script #51927: academy_rogue_command_skill
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: skills
if not (cmd == "skills") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" then
        _return_value = true
        return _return_value
    end
end
if actor:get_quest_stage("school") == 3 and not actor:get_quest_var("school:fight") then
    actor:set_quest_var("school", "fight", 1)
    actor:command("skill")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Unlike many MUDs you will not need to train or practice your skills with a trainer or Guild Master.")
    actor:send("Skills will improve gradually as you use them.")
    actor:send("The percentage next to each skill name shows how well you know it.")
    actor:send("<b:cyan>The word in parentheses is your rank, starting at \"novice\" and growing as the percentage does.</>'")
    wait(3)
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
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Go ahead and give it a try!  Type <b:green>hide</>.'")
end
_return_value = true
return _return_value$trig$, ARRAY['210e765cd2f1a83b467fde36ff6666ac', '43911320720fe7921ca18f19b3510943', '3dad804e6762daa4fbeb188b9cc8d44d']),
  -- data/triggers/519/519_29_academy_rogue_command_consider.lua
  (519, 29, $trig$-- Converted from DG Script #51929: academy_rogue_command_consider
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: consider
if not (cmd == "consider") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "c" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:fight") or 0) == 2 then
    actor:set_quest_var("school", "fight", "last")
    actor:command("consider " .. tostring(arg))
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'To attack a creature use the <b:cyan>(KIL)L</> command.")
    actor:send("But as a rogue, you have a special opening attack!'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'The <b:cyan>(B)ACKSTAB</> command has a chance to do extreme damage.'")
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>backstab monster</> to start fighting.")
    -- (empty send to actor)
    actor:send("You can always use the <b:cyan>(FL)EE</> command to try to run away.")
    actor:send("It's a good idea to <b:cyan>FLEE</> if you start to run low on hit points.")
    actor:send("But if you try to flee and fail, you'll be stunned for a little bit.")
    actor:send("So don't wait until the last second to run!'</>")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'When you've killed the monster, I'll teach you about <b:yellow>LOOT</> and <b:yellow>TOGGLES</>.'")
    actor:send("<b:green>Say loot</> when you're ready to continue.")
end
_return_value = true
return _return_value$trig$, ARRAY['e7dbf19a8ac77ce890feb64865ca73d4', 'f3fb8bbb0397b4fbbb9127fae04a50fb', '0e9a50a45ab190af3ed755118d78c2d3']),
  -- data/triggers/519/519_30_academy_warrior_greet.lua
  (519, 30, $trig$-- Converted from DG Script #51930: academy_warrior_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(0.2)
local stage = actor:get_quest_stage("school")
if stage == 3 or stage == 4 then
    if stage == 3 then
        -- switch on actor:get_quest_var("school:fight")
        do
            local _sw1 = string.lower(tostring(actor:get_quest_var("school:fight") or ""))
            local _run1 = false
            repeat
                if _run1 or tonumber(_sw1) == 1 then
                    _run1 = true
                    actor:send(tostring(self.name) .. " tells you, 'You need to take your combat <b:cyan>(SK)ILLS</> into consideration as well.")
                    actor:send("Warriors have a wide variety of special <b:cyan>SKILLS</>.")
                    actor:send("Type <b:green>skill</> to see what they are.'")
                    break
                end
                if _run1 or tonumber(_sw1) == 2 then
                    _run1 = true
                    actor:send("One of your most basic skills is <b:cyan>KICK</>.")
                    actor:send("It's an extra attack that delivers some bonus damage.")
                    actor:send("There is a short stun after you <b:cyan>KICK</>.")
                    actor:send("So be very, very careful about spamming the skill.")
                    actor:send("</>")
                    actor:send("You probably won't land a kick for many levels, but keep trying.")
                    actor:send("Practice makes perfect.'")
                    actor:send("</>")
                    wait(3)
                    if world.count_mobiles(519, 0) == 0 then
                        self.room:spawn_mobile(519, 0)
                        self.room:send(tostring(self.name) .. " summons a horrible little monster!")
                        wait(1)
                    end
                    actor:send(tostring(self.name) .. " tells you, 'Give it a try!")
                    actor:send("Type <b:green>kick monster</>.'")
                    break
                end
                if _run1 or tonumber(_sw1) == 3 then
                    _run1 = true
                    if not actor:has_item(11, 50) and not actor:has_equipped(11, 50) then
                        actor:send(tostring(self.name) .. " takes a wooden shield off a rack.")
                        self.room:spawn_object(11, 50)
                        self:command("give shield " .. tostring(actor))
                        actor:send("</>")
                        actor:send(tostring(self.name) .. " tells you, 'Equip that with <b:green>wear shield</>.  If your off-hand is already full (the torch, say), <b:cyan>remove torch</> first.'")
                        break
                    elseif actor:has_item(11, 50) then
                        actor:send(tostring(self.name) .. " tells you, 'Equip that wooden shield I gave you with <b:green>wear shield</>.  If your off-hand is already full (the torch, say), <b:cyan>remove torch</> first.'")
                        break
                    elseif actor:has_equipped(11, 50) then
                        actor:set_quest_var("school", "fight", 4)
                    end
                end
                if _run1 or tonumber(_sw1) == 4 then
                    _run1 = true
                    actor:send(tostring(self.name) .. " tells you, '<b:cyan>BASH</> deals some damage, but more importantly it <b:red>knocks your opponent down</>.")
                    actor:send("That <b:red>prevents your opponent from attacking you</> and <b:red>stops spellcasters from casting spells</>.")
                    actor:send("</>")
                    actor:send("Bashing is a complex maneuver.")
                    actor:send("First, it helps to be wearing a shield.")
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
                    if world.count_mobiles(519, 0) == 0 then
                        self.room:spawn_mobile(519, 0)
                        self.room:send(tostring(self.name) .. " summons a horrible little monster!")
                        wait(1)
                    end
                    actor:send(tostring(self.name) .. " tells you, 'I want you to practice bashing now.")
                    actor:send("</>Type <b:green>bash monster</>.  Don't worry, I'm here to protect you.'</>")
                    break
                end
                if _run1 or _sw1 == "last" then
                    _run1 = true
                    if world.count_mobiles(519, 0) == 0 then
                        self.room:spawn_mobile(519, 0)
                        self.room:send(tostring(self.name) .. " summons a horrible little monster!")
                        wait(1)
                    end
                    actor:send(tostring(self.name) .. " tells you, 'To attack a creature use the <b:cyan>(KIL)L</> command.")
                    actor:send("Type <b:green>kill monster</> to start fighting.")
                    actor:send("</>")
                    actor:send(tostring(self.name) .. " tells you, 'When you've killed the monster, I'll teach you about <b:yellow>LOOT</> and <b:yellow>TOGGLES</>.'")
                    actor:send("<b:green>Say loot</> when you're ready to continue.")
                    break
                end
                do  -- default
                    _run1 = true
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
            until true
        end
        actor:send("</>")
        actor:send(tostring(self.name) .. " tells you, 'You can also say <magenta>SKIP</> at any time to talk about <b:yellow>LOOT</> and <b:yellow>TOGGLES</> instead.'")
    elseif stage == 4 then
        -- switch on actor:get_quest_var("school:loot")
        do
            local _sw2 = string.lower(tostring(actor:get_quest_var("school:loot") or ""))
            if tonumber(_sw2) == 1 then
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
            elseif tonumber(_sw2) == 2 then
                actor:send(tostring(self.name) .. " tells you, 'The other thing I need to show you is the <b:cyan>TOGGLE</> command.")
                actor:send("Typing <b:cyan>TOGGLE</> alone will show you everything you can set.")
                actor:send("<b:cyan>AUTOLOOT</> picks up everything from a corpse instantly.")
                actor:send("<b:cyan>AUTOTREAS</> picks up only \"treasure\" like coins and gems.")
                actor:send("Each toggle has a <b:cyan>HELP</> file with more information.'")
                actor:send("</>")
                actor:send(tostring(self.name) .. " tells you, 'For now, let's get you ready to gather and share loot.")
                actor:send("Type <b:green>toggle autoloot</> to loot future kills!'")
            elseif tonumber(_sw2) == 3 then
                actor:send(tostring(self.name) .. " tells you, 'When playing with others it's considered polite to share the wealth.")
                actor:send("You can share money with the <b:cyan>SPLIT</> command.")
                actor:send("With <b:cyan>TOGGLE AUTOSPLIT</> on the game will automatically do that when you pick up money.'")
                actor:send("</>")
                actor:send(tostring(self.name) .. " tells you, 'Type <b:green>toggle autosplit</> to set that.'")
            elseif tonumber(_sw2) == 4 then
                actor:send(tostring(self.name) .. " tells you, 'The last combat tip is checking your <b:cyan>(TRO)PHY</> list.")
                actor:send("<b:cyan>TROPHY</> shows a record of the last 24 creatures you've killed and how many times you've killed them.'")
                actor:send("</>")
                actor:send(tostring(self.name) .. " tells you, 'Type <b:green>trophy</> and see your record.'")
            else
                actor:send(tostring(self.name) .. " tells you, '<b:green>Say loot</> to learn about <b:yellow>LOOT</> and <b:yellow>TOGGLES.'")
            end
        end
        actor:send("</>")
        actor:send(tostring(self.name) .. " tells you, 'You can also say <magenta>SKIP</> to move on to the next teacher.'")
    end
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'You can also say <magenta>EXIT</> at any time to leave the Academy.'")
end$trig$, ARRAY['d846cf901c1c25a1690c8aacbd7fb640', '68a42a37d6875bd7ffd14729dad3149c', 'f28a386c9a64d1d1f15bdff8ed8c0c44', '58bbf97166cedc4bc1b767b1dcb8a7d2']),
  -- data/triggers/519/519_32_academy_warrior_command_skill.lua
  (519, 32, $trig$-- Converted from DG Script #51932: academy_warrior_command_skill
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: skills
if not (cmd == "skills") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:fight") or 0) == 1 then
    actor:set_quest_var("school", "fight", 2)
    actor:command("skill")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Unlike many MUDs you will not need to train or practice your skills with a trainer or Guild Master.")
    actor:send("Skills will improve gradually as you use them.")
    actor:send("The percentage next to each skill name shows how well you know it.")
    actor:send("<b:cyan>The word in parentheses is your rank, starting at \"novice\" and growing as the percentage does.</>")
    actor:send("</>")
    actor:send("One of your most basic skills is <b:cyan>KICK</>.")
    actor:send("It's an extra attack that delivers some bonus damage.")
    actor:send("There is a short stun after you <b:cyan>KICK</>.")
    actor:send("So be very, very careful about spamming the skill.")
    actor:send("</>")
    actor:send("You probably won't land a kick for many levels, but keep trying.")
    actor:send("Practice makes perfect.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Give it a try!")
    actor:send("Type <b:green>kick monster</>.'")
end
_return_value = true
return _return_value$trig$, ARRAY['eeb54ceb43f1998b2f25ae5c482b4722', '3e4f64547db9bcfee341d5f37dfab478', 'b154382f58db8b78cb252103ca6e9f77']),
  -- data/triggers/519/519_33_academy_warrior_command_kick.lua
  (519, 33, $trig$-- Converted from DG Script #51933: academy_warrior_command_kick
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: kick
if not (cmd == "kick") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if (actor:get_quest_var("school:fight") or 0) == 2 then
    actor:set_quest_var("school", "fight", 3)
    actor:command("kick " .. tostring(arg))
    wait(0.2)
    local monster = self.room:find_actor("monster")
    if monster then
        world.destroy(monster)
        self.room:send(tostring(self.name) .. " rushes in to break up the fight!")
    end
    wait(0.1)
    self.room:spawn_mobile(519, 0)
    wait(0.3)
    actor:send(tostring(self.name) .. " tells you, 'Excellent job!")
    actor:send("You're ready to try out your other important skill, <b:cyan>BASH</>.'")
    wait(2)
    actor:send(tostring(self.name) .. " takes a wooden shield off a rack.")
    self.room:spawn_object(11, 50)
    self:command("give shield " .. tostring(actor))
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Equip that with <b:green>wear shield</>.  If your off-hand is already full (the torch, say), <b:cyan>remove torch</> first.'")
end
_return_value = true
return _return_value$trig$, ARRAY['811c723a6b1050fd089e80a8b02ea327', 'c968f77f8224190f7054ed9a1437a684', '8d5462534ea756580765fbf95e1ab455']),
  -- data/triggers/519/519_34_academy_shield_wear.lua
  (519, 34, $trig$-- Converted from DG Script #51934: academy_shield_wear
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
if (actor:get_quest_var("school:fight") or 0) == 3 then
    actor:set_quest_var("school", "fight", 4)
    wait(0.2)
    actor:send(tostring(mobiles.template(519, 4).name) .. " tells you, '<b:cyan>(BAS)H</> deals some damage, but more importantly it <b:red>knocks your opponent down</>.")
    actor:send("That <b:red>prevents your opponent from attacking you</> and <b:red>stops spellcasters from casting spells</>.")
    actor:send("</>")
    actor:send("Bashing is a complex maneuver.")
    actor:send("First, it helps to be wearing a shield.")
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
    if world.count_mobiles(519, 0) == 0 then
        self.room:spawn_mobile(519, 0)
        self.room:send(tostring(mobiles.template(519, 4).name) .. " summons a horrible little monster!")
        wait(1)
    end
    actor:send(tostring(mobiles.template(519, 4).name) .. " tells you, 'I want you to practice bashing now.")
    actor:send("Type <b:green>bash monster</>.  Don't worry, I'm here to protect you.'</>")
end$trig$, ARRAY['a54140b559156bc8833bb133e38659b3', '0fcde9b3b69ef971b709e58a4931b24e', 'ee15ed9ebc37640bfa86a98feae0233b']),
  -- data/triggers/519/519_35_academy_warrior_command_bash.lua
  (519, 35, $trig$-- Converted from DG Script #51935: academy_warrior_command_bash
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: bash
if not (cmd == "bash") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "b" or _sw1 == "ba" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:fight") or 0) == 4 then
    actor:set_quest_var("school", "fight", "last")
    actor:command("bash " .. tostring(arg))
    wait(0.2)
    local monster = self.room:find_actor("monster")
    wait(0.2)
    if monster then
        world.destroy(monster)
        self.room:send(tostring(self.name) .. " breaks up the fight.")
    end
    actor:send(tostring(self.name) .. " tells you, 'Good attempt!'")
    self.room:spawn_mobile(519, 0)
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'To attack a creature use the <b:cyan>(KIL)L</> command.")
    actor:send("</>")
    actor:send("You have to be standing to fight though and you probably fell down after trying to bash.")
    actor:send("Type <b:cyan>(ST)AND</> to get back up.")
    actor:send("Then type <b:green>kill monster</> to start fighting.")
    self:command("point monster")
    actor:send("</>")
    actor:send("You can always use the <b:cyan>(FL)EE</> command to try to run away.")
    actor:send("It's a good idea to <b:cyan>FLEE</> if you start to run low on hit points.")
    actor:send("If you try to flee and fail, you'll be stunned for a little bit.")
    actor:send("So don't wait until the last second to run!")
    actor:send("</>")
    actor:send("Feel free to use any of the skills you've learned to kill this monster.")
    actor:send("Be careful not to get locked by skill stun though!'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'When you've killed the monster, I'll teach you about <b:yellow>LOOT</> and <b:yellow>TOGGLES</>.'")
    actor:send("<b:green>Say loot</> when you're ready to continue.")
end
_return_value = true
return _return_value$trig$, ARRAY['d9872a09c678719416a787defe5f7a10', '720fce02f2d53bfd23f9c1ffc72480f1', '39da208d5edc82f94b5b20883d8081d1']),
  -- data/triggers/519/519_36_academy_cleric_greet.lua
  (519, 36, $trig$-- Converted from DG Script #51936: academy_cleric_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(0.2)
local stage = actor:get_quest_stage("school")
if stage == 3 or stage == 4 then
    if stage == 3 then
        -- switch on actor:get_quest_var("school:fight")
        do
            local _sw1 = string.lower(tostring(actor:get_quest_var("school:fight") or ""))
            local _run1 = false
            repeat
                if _run1 or tonumber(_sw1) == 1 then
                    _run1 = true
                    actor:send(tostring(self.name) .. " tells you, '<b:cyan>SPELL</> will show you all the spells you currently know.")
                    actor:send("As a cleric, you know all the spells on the list.")
                    actor:send("You don't need to write them down in a book to know them.'")
                    wait(2)
                    actor:send(tostring(self.name) .. " tells you, 'Check your spell list now by typing <b:green>spell</>.'")
                    break
                end
                if _run1 or tonumber(_sw1) == 2 then
                    _run1 = true
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
                    break
                end
                if _run1 or tonumber(_sw1) == 3 then
                    _run1 = true
                    actor:send("You can use the <b:cyan>(STU)DY</> command to see all the information about your spell slots, including:")
                    actor:send("<b:magenta>1. How many spell slots you have")
                    actor:send("2. Which spell slots you've used")
                    actor:send("3. How long each slot will take to recover</>")
                    actor:send("</>")
                    actor:send("Check your current recovery status by typing <b:green>study</> now.'")
                    break
                end
                if _run1 or tonumber(_sw1) == 4 then
                    _run1 = true
                    actor:send(tostring(self.name) .. " tells you, 'Spell slots will recover significantly faster if you <b:cyan>(MED)ITATE</>.")
                    actor:send("I'll walk you through that process now.")
                    actor:send("First, get comfortable.")
                    actor:send("Type <b:green>rest</> to take a seat and settle down.'")
                    break
                end
                if _run1 or tonumber(_sw1) == 5 then
                    _run1 = true
                    actor:send(tostring(self.name) .. " tells you, 'You should <b:cyan>(MED)ITATE</> to get into the proper state of mind.")
                    actor:send("As it goes up, the <b:cyan>MEDITATE</> skill increases your <b:cyan>FOCUS</> score when you <b:cyan>MEDITATE</>.")
                    actor:send("You can <b:cyan>MEDITATE</> as long as you're not in combat.'")
                    wait(2)
                    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>meditate</> to start.'")
                    break
                end
                if _run1 or tonumber(_sw1) == 6 then
                    _run1 = true
                    actor:set_quest_var("school", "fight", 7)
                end
                if _run1 or tonumber(_sw1) == 7 then
                    _run1 = true
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
                    break
                end
                if _run1 or _sw1 == "last" then
                    _run1 = true
                    if world.count_mobiles(519, 0) == 0 then
                        self.room:spawn_mobile(519, 0)
                        self.room:send(tostring(self.name) .. " summons a horrible little monster!")
                        wait(1)
                    end
                    actor:send(tostring(self.name) .. " tells you, 'To attack a creature use the <b:cyan>(KIL)L</> command.")
                    actor:send("Type <b:green>kill monster</> to start fighting.")
                    actor:send("</>")
                    actor:send(tostring(self.name) .. " tells you, 'When you've killed the monster, I'll teach you about <b:yellow>LOOT</> and <b:yellow>TOGGLES</>.'")
                    actor:send("<b:green>Say loot</> when you're ready to continue.")
                    break
                end
                do  -- default
                    _run1 = true
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
            until true
        end
        actor:send("</>")
        actor:send(tostring(self.name) .. " tells you, 'You can also say <magenta>SKIP</> at any time to talk about <b:yellow>LOOT</> and <b:yellow>TOGGLES</> instead.'")
    elseif stage == 4 then
        -- switch on actor:get_quest_var("school:loot")
        do
            local _sw2 = string.lower(tostring(actor:get_quest_var("school:loot") or ""))
            if tonumber(_sw2) == 1 then
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
            elseif tonumber(_sw2) == 2 then
                actor:send(tostring(self.name) .. " tells you, 'The other thing I need to show you is the <b:cyan>TOGGLE</> command.")
                actor:send("Typing <b:cyan>TOGGLE</> alone will show you everything you can set.")
                actor:send("<b:cyan>AUTOLOOT</> picks up everything from a corpse instantly.")
                actor:send("<b:cyan>AUTOTREAS</> picks up only \"treasure\" like coins and gems.")
                actor:send("Each toggle has a <b:cyan>HELP</> file with more information.'")
                actor:send("</>")
                actor:send(tostring(self.name) .. " tells you, 'For now, let's get you ready to gather and share loot.")
                actor:send("Type <b:green>toggle autoloot</> to loot future kills!'")
            elseif tonumber(_sw2) == 3 then
                actor:send(tostring(self.name) .. " tells you, 'When playing with others it's considered polite to share the wealth.")
                actor:send("You can share money with the <b:cyan>SPLIT</> command.")
                actor:send("With <b:cyan>TOGGLE AUTOSPLIT</> on the game will automatically do that when you pick up money.'")
                actor:send("</>")
                actor:send(tostring(self.name) .. " tells you, 'Type <b:green>toggle autosplit</> to set that.'")
            elseif tonumber(_sw2) == 4 then
                actor:send(tostring(self.name) .. " tells you, 'The last combat tip is checking your <b:cyan>(TRO)PHY</> list.")
                actor:send("<b:cyan>TROPHY</> shows a record of the last 24 creatures you've killed and how many times you've killed them.'")
                actor:send("</>")
                actor:send(tostring(self.name) .. " tells you, 'Type <b:green>trophy</> and see your record.'")
            else
                actor:send(tostring(self.name) .. " tells you, '<b:green>Say loot</> to learn about <b:yellow>LOOT</> and <b:yellow>TOGGLES.'")
            end
        end
        actor:send("</>")
        actor:send(tostring(self.name) .. " tells you, 'You can also say <magenta>SKIP</> to move on to the next teacher.'")
    end
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'You can also say <magenta>EXIT</> at any time to leave the Academy.'")
end$trig$, ARRAY['16f1eb2a813fe04907b84e319a5c4374', '09f11ae5983b8757db175cb3a7ea644c', 'b8bab64f9df6d49b86fe7c69a2df0c57']),
  -- data/triggers/519/519_37_academy_cleric_command_skill.lua
  (519, 37, $trig$-- Converted from DG Script #51937: academy_cleric_command_skill
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: skills
if not (cmd == "skills") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" then
        _return_value = true
        return _return_value
    end
end
if actor:get_quest_stage("school") == 3 and not actor:get_quest_var("school:fight") then
    actor:set_quest_var("school", "fight", 1)
    actor:command("skill")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Unlike many MUDs you will not need to train or practice your skills with a trainer or Guild Master.")
    actor:send("Skills will improve gradually as you use them.")
    actor:send("The percentage next to each skill name shows how well you know it.")
    actor:send("<b:cyan>The word in parentheses is your rank, starting at \"novice\" and growing as the percentage does.</>")
    actor:send("</>")
    actor:send("Your most important skills are the <b:cyan>spheres</>.")
    actor:send("These are a measure of your proficiency in a type of magic.")
    actor:send("They increase whenever you <b:cyan>CAST</> a spell.")
    actor:send("The spheres are not spells or attacks themselves.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'There are four steps to using divine magic:'")
    actor:send("1. <b:cyan>(R)EST</>")
    actor:send("2. <b:cyan>(MED)ITATE</>")
    actor:send("3. <b:cyan>(PR)AY</>")
    actor:send("4. <b:cyan>(C)AST</></>")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'To see what spells you actually know type <b:green>spell</>.'")
end
_return_value = true
return _return_value$trig$, ARRAY['cae88df69e2807b82464fcc4d37fcffe', '5aeae110aeadce04b7de6016757c2727', '4e8d48ed274022bbe3123594af73431c']),
  -- data/triggers/519/519_44_academy_cleric_command_consider.lua
  (519, 44, $trig$-- Converted from DG Script #51944: academy_cleric_command_consider
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: consider
if not (cmd == "consider") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local thing = "horrible-little-monster"
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "c" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:fight") or 0) == 7 then
    actor:set_quest_var("school", "fight", "last")
    actor:command("con " .. tostring(arg))
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Very good.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'To attack a creature, use the <b:cyan>(KIL)L</> command. Type <b:green>kill monster</> to start fighting.")
    actor:send("</>")
    actor:send("Feel free to use any of the skills you've learned.")
    actor:send("</>")
    actor:send("You can always use the <b:cyan>(FL)EE</> command to try to run away.")
    actor:send("It's a good idea if you start to run low on hit points.")
    actor:send("If you try to flee and fail, you'll be stunned for a little bit.")
    actor:send("You cannot flee while casting a spell either!")
    actor:send("So don't wait until the last second to run!'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'When you've killed the monster, I'll teach you about <b:yellow>LOOT</> and <b:yellow>TOGGLES</>.'")
    actor:send("<b:green>Say loot</> when you're ready to continue.")
end
_return_value = true
return _return_value$trig$, ARRAY['817bdb7556543c26242ce2b0d363ac06', 'f9947295d96eaf6dcb9e610e94b9e9e0', '0e5ede7fff059b3f92f10cf31e39b2ba']),
  -- data/triggers/519/519_45_academy_sorcerer_greet.lua
  (519, 45, $trig$-- Converted from DG Script #51945: academy_sorcerer_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(0.2)
local stage = actor:get_quest_stage("school")
if stage == 3 or stage == 4 then
    if stage == 3 then
        -- switch on actor:get_quest_var("school:fight")
        do
            local _sw1 = string.lower(tostring(actor:get_quest_var("school:fight") or ""))
            local _run1 = false
            repeat
                if _run1 or tonumber(_sw1) == 1 then
                    _run1 = true
                    actor:send("As a sorcerer you need extensive notes to cast correctly, which you must <b:cyan>SCRIBE</> in a <b:cyan>SPELLBOOK</>.")
                    actor:send("This means always carrying your <b:cyan>SPELLBOOK</> with you to cast spells.'")
                    wait(3)
                    actor:send(tostring(self.name) .. " tells you, 'I'll walk you through the <b:cyan>SCRIBE</> process now.")
                    actor:send("</>First, you have to get comfortable.  Type <b:green>rest</> to take a seat and settle down.'")
                    break
                end
                if _run1 or tonumber(_sw1) == 2 then
                    _run1 = true
                    actor:send(tostring(self.name) .. " tells you, 'As a sorcerer, you need to <b:cyan>SCRIBE</> spells in your spellbook.")
                    actor:send("<b:cyan>(SPE)LL</> will show you all the spells you can <b:cyan>SCRIBE</>.")
                    actor:send("You must <b:cyan>HOLD</> a <b:yellow>SPELLBOOK</> with blank pages and a <b:yellow>PEN</> of some kind to scribe.")
                    if not actor:has_equipped(10, 29) and not actor:has_item(10, 29) and not actor:has_equipped(11, 54) and not actor:has_item(11, 54) then
                        actor:send("Looks like you need a book and pen!")
                        self.room:spawn_object(11, 54)
                        self.room:spawn_object(10, 29)
                        self:command("give book " .. tostring(actor))
                        self:command("give pen " .. tostring(actor))
                    else
                        actor:send("All new sorcerers start with an empty book and quill.")
                    end
                    actor:send("</>")
                    actor:send("Once you leave the Academy, you many only <b:cyan>SCRIBE</> spells in the presence of your <b:yellow>Guild Master</>.'")
                    actor:send("</>")
                    actor:send(tostring(self.name) .. " tells you, 'Check your spell list by typing <b:green>spell</>.'")
                    break
                end
                if _run1 or tonumber(_sw1) == 3 then
                    _run1 = true
                    actor:send(tostring(self.name) .. " tells you, 'For now, you're going to learn <b:yellow>magic missile</>.")
                    actor:send("</>")
                    actor:send("<b:cyan>(REM)OVE</> anything in your hands.")
                    actor:send("Then <b:cyan>(H)OLD</> your spellbook.'")
                    actor:send("</>")
                    if actor:get_worn("wield") then
                        actor:send(tostring(self.name) .. " tells you, 'You need to <b:green>remove</> the weapon in your hands.'")
                    end
                    if actor:get_worn("hold") then
                        actor:send(tostring(self.name) .. " tells you, 'You need to <b:green>remove</> the item in your hands.'")
                    end
                    if actor:get_worn("hold2") then
                        actor:send(tostring(self.name) .. " tells you, 'You need to <b:green>remove</> the item in your hands.'")
                    end
                    if actor:get_worn("2hwield") then
                        actor:send(tostring(self.name) .. " tells you, 'You need to <b:green>remove</> the item in your hands.'")
                    end
                    actor:send("</>")
                    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>hold spellbook</> to grab your book.'")
                    break
                end
                if _run1 or tonumber(_sw1) == 4 then
                    _run1 = true
                    actor:send(tostring(self.name) .. " tells you, 'Next, <b:cyan>(H)OLD</> your quill.")
                    if not actor:has_equipped(11, 54) and not actor:has_item(11, 54) then
                        actor:send("Looks like you need a new one.'")
                        self.room:spawn_object(11, 54)
                        self:command("give pen " .. tostring(actor))
                    else
                        actor:send("You started with one.'")
                    end
                    wait(1)
                    actor:send("</>Type <b:cyan>hold quill</> to grab your quill.'")
                    break
                end
                if _run1 or tonumber(_sw1) == 5 then
                    _run1 = true
                    actor:send(tostring(self.name) .. " tells you, 'Now you can <b:cyan>SCRIBE</> any spell on your spell list.")
                    actor:send("Each spell takes up pages in your spellbook.")
                    actor:send("The number of pages is affected by your <b:cyan>SCRIBE</> skill.")
                    actor:send("You can write any spell you know in your spellbook as long as you're with your Guild Master and your spellbook enough blank pages left in it.'")
                    actor:send("</>")
                    actor:send(tostring(self.name) .. " tells you, 'For now, just type <b:green>scribe magic missile</>.'")
                    break
                end
                if _run1 or tonumber(_sw1) == 6 then
                    _run1 = true
                    actor:set_quest_var("school", "fight", 6)
                end
                if _run1 or tonumber(_sw1) == 7 then
                    _run1 = true
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
                    actor:send("</>")
                    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>consider monster</> for see chances.'")
                    break
                end
                if _run1 or tonumber(_sw1) == 8 then
                    _run1 = true
                    if world.count_mobiles(519, 0) == 0 then
                        self.room:spawn_mobile(519, 0)
                        self.room:send(tostring(self.name) .. " summons a horrible little monster!")
                        wait(1)
                    end
                    actor:send(tostring(self.name) .. " tells you, 'To attack a creature use the <b:cyan>(KIL)L</> command.")
                    actor:send("As a sorcerer however, your strength comes from your magic.")
                    actor:send("It's often best to start combat with an offensive spell.")
                    actor:send("If you're lucky, you'll kill your opponent out-right.'")
                    wait(2)
                    actor:send(tostring(self.name) .. " tells you, 'To <b:cyan>CAST</> type <b:cyan>(c)ast '[spell]' [target]</>.")
                    actor:send("</>")
                    actor:send("</>FieryMUD will try to match <b:cyan>abbreviations of spell names and targets.</>")
                    actor:send("If a spell name has more than one word you <b:cyan>must</> put single quotation marks <b:cyan>' '</> around it.")
                    actor:send("</>")
                    actor:send("</>Spellcasting is not instaneous either.")
                    actor:send("Each spell has a base length to cast.")
                    actor:send("Your proficiency in <b:cyan>QUICK CHANT</> will reduce casting time.")
                    actor:send("</>")
                    actor:send("Once you <b:cyan>CAST</> a spell you have to <b:cyan>MEMORIZE</> it before you can cast it again.'")
                    wait(2)
                    self:command("point monster")
                    actor:send("</>")
                    actor:send(tostring(self.name) .. " tells you, '<b:cyan>CAST</> your spell at that monster.")
                    actor:send("Type <b:green>cast 'magic missile' monster</>.'")
                    actor:send("</>")
                    actor:send(tostring(self.name) .. " tells you, 'When you've killed the monster, <b:green>say recovery</> I'll teach you about <b:yellow>SPELL RECOVERY</>.'")
                    break
                end
                if _run1 or tonumber(_sw1) == 9 then
                    _run1 = true
                    actor:send("You can use the <b:cyan>(STU)DY</> command to see all the information about your spell slots, including:")
                    actor:send("<b:magenta>1. How many spell slots you have")
                    actor:send("2. Which spell slots you've used")
                    actor:send("3. How long each slot will take to recover</>")
                    actor:send("</>")
                    actor:send("Check your current recovery status by typing <b:green>study</> now.'")
                    break
                end
                if _run1 or tonumber(_sw1) == 10 then
                    _run1 = true
                    actor:send(tostring(self.name) .. " tells you, 'Spell slots will recover significantly faster if you <b:cyan>(MED)ITATE</>.")
                    actor:send("I'll walk you through that process now.")
                    actor:send("First, get comfortable.")
                    actor:send("Type <b:green>rest</> to take a seat and settle down.'")
                    break
                end
                if _run1 or tonumber(_sw1) == 11 then
                    _run1 = true
                    actor:send(tostring(self.name) .. " tells you, 'You should <b:cyan>(MED)ITATE</> to get into the proper state of mind.")
                    actor:send("As it goes up, the <b:cyan>MEDITATE</> skill increases your <b:cyan>FOCUS</> score when you <b:cyan>MEDITATE</>.")
                    actor:send("You can <b:cyan>MEDITATE</> as long as you're not in combat.'")
                    wait(2)
                    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>meditate</> to start.'")
                    break
                end
                if _run1 or tonumber(_sw1) == 12 then
                    _run1 = true
                    actor:set_quest_var("school", "fight", "complete")
                    actor:advance_quest("school")
                    wait(0.2)
                    actor:send(tostring(self.name) .. " tells you, 'Next I'll teach you about <b:yellow>LOOT</> and <b:yellow>TOGGLES</>.'")
                    actor:send("<b:green>Say loot</> when you're ready to continue.")
                    break
                end
                do  -- default
                    _run1 = true
                    actor:send(tostring(self.name) .. " turns to greet you.")
                    wait(2)
                    self:command("nod " .. tostring(actor))
                    actor:send(tostring(self.name) .. " tells you, 'Ah a new student!'")
                    wait(2)
                    actor:send(tostring(self.name) .. " tells you, 'Greetings " .. tostring(actor.name) .. ".  I am the Chair of Arcane Studies at Ethilien Academy.  Welcome to my laboratory.'")
                    self:command("bow " .. tostring(actor))
                    wait(3)
                    actor:send(tostring(self.name) .. " tells you, 'I assume you're here for the basics of magical <b:yellow>combat</>.'")
                    wait(3)
                    actor:send(tostring(self.name) .. " tells you, 'Let's start by looking at your <b:cyan>(SK)ILLS</>.")
                    actor:send("</>Type <b:green>skill</> to see what you can do.'")
                end
            until true
        end
        actor:send("</>")
        actor:send(tostring(self.name) .. " tells you, 'You can also say <magenta>SKIP</> at any time to talk about <b:yellow>LOOT</> and <b:yellow>TOGGLES</> instead.'")
    elseif stage == 4 then
        -- switch on actor:get_quest_var("school:loot")
        do
            local _sw2 = string.lower(tostring(actor:get_quest_var("school:loot") or ""))
            if tonumber(_sw2) == 1 then
                actor:send(tostring(self.name) .. " tells you, 'When something dies, it usually leaves behind a <b:yellow>corpse</>.'")
                wait(1)
                self:command("poke " .. tostring(actor))
                actor:send(tostring(self.name) .. " tells you, 'That goes for you too kid.'")
                wait(1)
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
            elseif tonumber(_sw2) == 2 then
                actor:send(tostring(self.name) .. " tells you, 'The other thing I need to show you is the <b:cyan>TOGGLE</> command.")
                actor:send("Typing <b:cyan>TOGGLE</> alone will show you everything you can set.")
                actor:send("<b:cyan>AUTOLOOT</> picks up everything from a corpse instantly.")
                actor:send("<b:cyan>AUTOTREAS</> picks up only \"treasure\" like coins and gems.")
                actor:send("Each toggle has a <b:cyan>HELP</> file with more information.'")
                actor:send("</>")
                actor:send(tostring(self.name) .. " tells you, 'For now, let's get you ready to gather and share loot.")
                actor:send("Type <b:green>toggle autoloot</> to loot future kills!'")
            elseif tonumber(_sw2) == 3 then
                actor:send(tostring(self.name) .. " tells you, 'When playing with others it's considered polite to share the wealth.")
                actor:send("You can share money with the <b:cyan>SPLIT</> command.")
                actor:send("With <b:cyan>TOGGLE AUTOSPLIT</> on the game will automatically do that when you pick up money.'")
                actor:send("</>")
                actor:send(tostring(self.name) .. " tells you, 'Type <b:green>toggle autosplit</> to set that.'")
            elseif tonumber(_sw2) == 4 then
                actor:send(tostring(self.name) .. " tells you, 'The last combat tip is checking your <b:cyan>(TRO)PHY</> list.")
                actor:send("<b:cyan>TROPHY</> shows a record of the last 24 creatures you've killed and how many times you've killed them.'")
                actor:send("</>")
                actor:send(tostring(self.name) .. " tells you, 'Type <b:green>trophy</> and see your record.'")
            else
                actor:send(tostring(self.name) .. " tells you, '<b:green>Say loot</> to learn about <b:yellow>LOOT</> and <b:yellow>TOGGLES.'")
            end
        end
        actor:send("</>")
        actor:send(tostring(self.name) .. " tells you, 'You can also say <magenta>SKIP</> to move on to the next teacher.'")
    end
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'You can also say <magenta>EXIT</> at any time to leave the Academy.'")
end$trig$, ARRAY['4600bda4115d937f6e38b01295a22e32', 'a51c5c931b5e3aa4c8f894de6f4ac624', '88cbae13766e666b5dc54fe11f2652fb']),
  -- data/triggers/519/519_46_academy_sorcerer_command_skill.lua
  (519, 46, $trig$-- Converted from DG Script #51946: academy_sorcerer_command_skill
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: skills
if not (cmd == "skills") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" then
        _return_value = true
        return _return_value
    end
end
if actor:get_quest_stage("school") == 3 and not actor:get_quest_var("school:fight") then
    actor:set_quest_var("school", "fight", 1)
    actor:command("skill")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Unlike many MUDs you will not need to train or practice your skills with a trainer or Guild Master.")
    actor:send("Skills will improve gradually as you use them.")
    actor:send("The percentage next to each skill name shows how well you know it.")
    actor:send("<b:cyan>The word in parentheses is your rank, starting at \"novice\" and growing as the percentage does.</>")
    actor:send("</>")
    actor:send("Your most important skills are the <b:cyan>spheres</>.")
    actor:send("These indicate of your proficiency in a type of magic.")
    actor:send("They increase whenever you <b:cyan>CAST</> a spell.")
    actor:send("The spheres are not spells or attacks themselves.")
    actor:send("</>")
    actor:send("As a sorcerer you need extensive notes to cast correctly.")
    actor:send("This means always carrying your <b:cyan>SPELLBOOK</> with you so you can refer to and <b:cyan>(ME)MORIZE</> your notes.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'There are five steps to casting:'")
    actor:send("1. <b:magenta>(R)EST</>")
    actor:send("2. <b:magenta>SCRIBE</>")
    actor:send("3. <b:magenta>(MED)ITATE</>")
    actor:send("4. <b:magenta>(ME)MORIZE</>")
    actor:send("5. <b:magenta>(C)AST</></>")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'I'll walk you through that process now.")
    actor:send("</>First, you have to get comfortable.  Type <b:green>rest</> to take a seat and settle down.'")
end
_return_value = true
return _return_value$trig$, ARRAY['5e961ea4155be7ebb0b98fb1d064c531', 'b40cf21ff922b951bef8c6fb2bbad33d', '52b71ee7c81a2e1d5638d19d63c06ec9']),
  -- data/triggers/519/519_51_academy_sorcerer_command_stand.lua
  (519, 51, $trig$-- Converted from DG Script #51951: academy_sorcerer_command_stand
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: stand
if not (cmd == "stand") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:fight") or 0) == 6 then
    actor:set_quest_var("school", "fight", 7)
    actor:command("stand")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'With the spell scribed you can <b:cyan>CAST</> it.")
    actor:send("Unlike many other MUDs, <red>FieryMUD does not use mana.</>")
    actor:send("You can cast any spell from your list as long as you have available <b:cyan>SPELL SLOTS</> of the same level or higher.")
    actor:send("</>")
    actor:send("At level 1, you have only one Circle 1 spell slot.")
    actor:send("You can use that spell slot to <b:cyan>CAST</> any Circle 1 spell.")
    actor:send("You gain more spells slots as you increase in level.'")
    wait(2)
    self.room:spawn_mobile(519, 0)
    self.room:send(tostring(self.name) .. " summons a horrible little monster!")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'Killing creatures like this is how you gain experience.")
    actor:send("Gaining experience is how you go up in level.")
    actor:send("Player killing is generally not allowed in FieryMUD.")
    actor:send("This includes casting offensive spells at other players.")
    actor:send("</>")
    actor:send("</>Before you strike, take a moment to size up your opponent.")
    actor:send("Use the <b:cyan>(CO)NSIDER</> command to see what your chances are.")
    actor:send("Keep in mind FieryMUD is made for groups of 4-8, so the results of <b:cyan>CONSIDER</> aren't perfect")
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>consider monster</> for see chances.'")
elseif (actor:get_quest_var("school:fight") or 0) == 12 then
    actor:set_quest_var("school", "fight", "complete")
    actor:advance_quest("school")
    actor:command("stand")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Next I'll teach you about <b:yellow>LOOT</> and <b:yellow>TOGGLES</>.'")
    actor:send("<b:green>Say loot</> when you're ready to continue.")
end
_return_value = true
return _return_value$trig$, ARRAY['50f95dd6723ff15925efd9480859a631', '590db7d9a06a0fa3bf2a0091df952029', '606f98cf74144809786d7d4f3b186a77']),
  -- data/triggers/519/519_61_academy_revel_command_wake.lua
  (519, 61, $trig$-- Converted from DG Script #51961: academy_revel_command_wake
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: wake
if not (cmd == "wake") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "w" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:rest") or 0) == 2 then
    actor:set_quest_var("school", "rest", 3)
    actor:command("wake")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Good morning sunshine!'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'You'll frequently notice yourself getting hungry or thirsty.")
    actor:send("You can speed up your recovery if you <b:cyan>EAT</> and <b:cyan>(DRI)NK</>.")
    actor:send("</>")
    actor:send("When you get thirsty it's time to <b:cyan>DRINK</>!")
    actor:send("Ethilien has a huge variety of drinkable liquids.")
    actor:send("Any of them will slake your thirst.")
    actor:send("The command is <b:cyan>DRINK [container]</>.")
    actor:send("</>")
    actor:send("When you <b:cyan>DRINK</>, you'll also regain some Stamina, so make sure you carry a full waterskin so you can keep moving when you explore!")
    actor:send("</>")
    actor:send("And remember, magic potions are <red>not</> drinks.")
    actor:send("If you want to consume a potion, the commmand is <b:cyan>(Q)UAFF</>, not <b:cyan>(DRI)NK</>.'")
    wait(2)
    if not actor:has_item(0, 20) and not actor:has_equipped(0, 20) then
        actor:send(tostring(self.name) .. " tells you, 'Here's a new waterskin for you.")
        self.room:spawn_object(0, 20)
        self:command("give waterskin " .. tostring(actor))
    else
        actor:send(tostring(self.name) .. " tells you, 'You started play with a full waterskin.")
    end
    actor:send("Type <b:green>drink waterskin</> now to drink out of it.'")
end
_return_value = true
return _return_value$trig$, ARRAY['4e30fa5b53fa1d41fe86a37991e91240', 'c54b6b4d3c6fe72702ab67f26ee5dae3', '2e84a805e1b1a4c6c9488ae2d697d056']),
  -- data/triggers/519/519_83_academy_instructor_speech_exploration.lua
  (519, 83, $trig$-- Converted from DG Script #51983: academy_instructor_speech_exploration
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"exploration"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("school") == 1 then
    if actor:get_quest_var("school:explore") ~= "complete" then
        if (actor:get_quest_var("school:speech") and actor:get_quest_var("school:speech") ~= "complete") or (actor:get_quest_var("school:gear") and actor:get_quest_var("school:gear") ~= "complete") then
            actor:send(tostring(self.name) .. " tells you, 'You have to finish your other lesson first.'")
            return true
        end
        if actor:get_quest_var("school:explore") then
            actor:send(tostring(self.name) .. " tells you, 'Let's resume your <b:yellow>EXPLORATION</> lessons.'")
        end
        -- switch on actor:get_quest_var("school:explore")
        do
            local _sw1 = string.lower(tostring(actor:get_quest_var("school:explore") or ""))
            if tonumber(_sw1) == 2 then
                actor:send(tostring(self.name) .. " tells you, 'As you look around the room, you'll get four big pieces of information:'")
                actor:send("</>")
                actor:send("</><b:magenta>1. The description of the room.</>")
                actor:send("</>   Tiny but crucial hints can appear in room descriptions - keep your eyes open!")
                actor:send("</>")
                actor:send("</><b:magenta>2. The visible exits from the room.</>")
                actor:send("</>   FieryMUD uses six directions: north, south, east, west, up, down.")
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
                wait(3)
                actor:send(tostring(self.name) .. " tells you, 'For example, type <b:green>look curtain</> to find more clues.'")
            elseif tonumber(_sw1) == 3 then
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
                wait(3)
                actor:send(tostring(self.name) .. " tells you, 'But for now, type <b:green>search curtain</> and take a look!'")
            elseif tonumber(_sw1) == 4 then
                actor:command("search curtain")
                actor:send(tostring(self.name) .. " tells you, 'Once you've uncovered a secret door you can interact with it like a normal door.")
                actor:send("You can use the <b:cyan>(O)PEN</> and <b:cyan>(CL)OSE</> commands to open doors or containers.")
                actor:send("Sometimes they might be locked though, and you'll need a key to unlock them.")
                actor:send("</>")
                actor:send("If you <b:cyan>LOOK EAST</>, you can see the curtain from this room is closed.")
                actor:send("To open it just use the <b:cyan>(O)PEN</> command.'</>")
                wait(3)
                actor:send(tostring(self.name) .. " tells you, 'Type <b:green>open curtain</> to see how it works.'")
            elseif tonumber(_sw1) == 5 then
                actor:send(tostring(self.name) .. " tells you, 'You can <b:cyan>(SCA)N</> to see what's in the areas around you.")
                actor:send("It's free to use and very helpful for anticipating threats.")
                actor:send("Some classes are even able to see more than one room away.")
                actor:send("There is a slight delay after giving the <b:cyan>SCAN</> command, so be careful.'")
                wait(3)
                actor:send(tostring(self.name) .. " tells you, 'Give it a go!  Type <b:green>scan</>.'")
            elseif tonumber(_sw1) == 6 then
                actor:send(tostring(self.name) .. " tells you, 'You can move in any direction there's an open exit.")
                actor:send("Just type <b:cyan>(N)ORTH (S)OUTH (E)AST (W)EST (U)P</> or <b:cyan>(D)OWN</>.")
                actor:send("</>")
                actor:send("In the lower-left corner of your screen you'll see a display that looks like this:")
                actor:send("<b:yellow>10h(10H) 100v(100V)</>")
                actor:send("The two numbers on the right are your <b:magenta>Stamina</>.")
                actor:send("The first number is your <b:magenta>Current Stamina</>.")
                actor:send("The second number is your <b:magenta>Maximum Stamina</>.")
                actor:send("Your <b:magenta>Maximum</> will increase until level 50.")
                actor:send("</>")
                actor:send("When you move from room to room, your Stamina goes down.")
                actor:send("The amount of Stamina needed to move around varies by terrain.")
                actor:send("If your Stamina reaches 0 you can't move until you rest.'")
                wait(3)
                actor:send(tostring(self.name) .. " tells you, 'Would you like to review exploration?")
                actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
            else
                actor:set_quest_var("school", "explore", 1)
                actor:send(tostring(self.name) .. " tells you, 'Let's learn how to <b:yellow>EXPLORE</>!'")
                wait(1)
                actor:send(tostring(self.name) .. " tells you, 'First things first. It's critical to understand your surroundings.")
                actor:send("Your basic investigation command is <b:cyan>(L)OOK</>.")
                actor:send("For now, just try typing <b:green>look</> and see what you find.'")
            end
        end
    end
end$trig$, ARRAY['7f8fda171348703b4cb8a010cbbb4441', 'e0768a5ca8caccd8ba83410a717deb1b', 'a92c6251ca1bcfcb6043335448a974a8']),
  -- data/triggers/519/519_86_academy_clerk_speech_hit_points.lua
  (519, 86, $trig$-- Converted from DG Script #51986: academy_clerk_speech_hit_points
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: hit points (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]hit points[%s%p]") then
    return true  -- Not the phrase
end
wait(0.2)
if actor:get_quest_stage("school") == 2 then
    actor:set_quest_var("school", "hp", "complete")
    actor:send(tostring(self.name) .. " tells you, 'Look at the prompt in the lower-left corner of your screen again.")
    actor:send("The two numbers on the left are your <b:red>Hit Points</>.")
    actor:send("The first number is your <b:red>Current Hit Points</>.")
    actor:send("The second number is your <b:red>Maximum Hit Points</>.")
    actor:send("Your <b:red>Maximum</> increases every time you level.")
    actor:send("</>")
    actor:send("When you get hit in combat, your current Hit Points go down.")
    actor:send("If your Hit Points reach 0, you die.")
    actor:send("So <b:cyan>FLEE</> or heal before they run low.")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'Are you ready to continue?")
    actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
end$trig$, ARRAY['8264dc3a7ec8200f9862262197ebd104', '67ed13fda59d9b82bb3e69540c440c19', '76619564e41fc07057c89867bf0e0873']),
  -- data/triggers/519/519_87_academy_clerk_speech_score.lua
  (519, 87, $trig$-- Converted from DG Script #51987: academy_clerk_speech_score
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"score"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("school") == 2 then
    actor:set_quest_var("school", "score", 1)
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, '<b:cyan>SCORE</> is how you see all the numeric stuff about yourself:")
    actor:send("Experience, Hit Points, Stamina, Stats, Saves, blah blah blah.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Check it out by typing <b:green>score</> now.'")
end$trig$, ARRAY['9cc7a1c5f04f60a25ec8e9a55ddb4ef0', 'dd930327cc50220160ef1e4b6956ad70', 'd4b208b3910554a82497c974a80a167c']),
  -- data/triggers/519/519_89_academy_combat_speech_skip.lua
  (519, 89, $trig$-- Converted from DG Script #51989: academy_combat_speech_skip
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"skip"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("school") == 3 then
    actor:set_quest_var("school", "fight", "complete")
    actor:advance_quest("school")
    actor:send(tostring(self.name) .. " tells you, 'Certainly.  We'll skip combat and talk about <b:yellow>LOOT</> and <b:yellow>TOGGLES</>.")
    self.room:spawn_mobile(519, 0)
    combat.engage(self, self.room:find_actor("monster"))
    actor:send("<b:green>Say loot</> when you're ready to continue.")
elseif actor:get_quest_stage("school") == 4 then
    actor:set_quest_var("school", "loot", "complete")
    actor:advance_quest("school")
    actor:send(tostring(self.name) .. " tells you, 'Certainly.  You'll continue to the <b:green>east</>.'")
end$trig$, ARRAY['7ee5f965e93126b5b84a93bb2eb88f28', '8a16ba92294ec02569142df5b4fb53d0', 'f3b37c2cdc76ae9d3a40986f1f214513']),
  -- data/triggers/519/519_91_academy_revel_speech_resting.lua
  (519, 91, $trig$-- Converted from DG Script #51991: academy_revel_speech_resting
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"resting"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("school") == 5 then
    -- switch on actor:get_quest_var("school:rest")
    do
        local _sw1 = string.lower(tostring(actor:get_quest_var("school:rest") or ""))
        local _run1 = false
        repeat
            if _run1 or tonumber(_sw1) == 1 then
                _run1 = true
                actor:send(tostring(self.name) .. " tells you, 'If you want to speed up your recovery, you can lay down and go to <b:cyan>SLEEP</>.")
                actor:send("There're some risks with sleeping.")
                actor:send("You won't be able to hear or see the world around you, so you won't know if danger is approaching.")
                actor:send("You won't be able to use <b:cyan>SAY</> or <b:cyan>SHOUT</>, do anything most people can't normally do in their sleep.")
                actor:send("You can still <b:cyan>GOSSIP</>, <b:cyan>TELL</>, and check your <b:cyan>INVENTORY</> or <b:cyan>EQUIPMENT</> though!'")
                actor:send("</>")
                actor:send(tostring(self.name) .. " tells you, 'Take a quick nap!  Type <b:green>sleep</> to lay down.'")
                break
            end
            if _run1 or tonumber(_sw1) == 2 then
                _run1 = true
                actor:set_quest_var("school", "rest", 3)
            end
            if _run1 or tonumber(_sw1) == 3 then
                _run1 = true
                actor:send(tostring(self.name) .. " tells you, 'You'll frequently notice yourself getting hungry or thirsty.")
                actor:send("You can speed up your recovery if you <b:cyan>EAT</> and <b:cyan>(DRI)NK</>.")
                actor:send("</>")
                actor:send("When you get thirsty it's time to <b:cyan>DRINK</>!")
                actor:send("Ethilien has a huge variety of drinkable liquids.")
                actor:send("Any of them will slake your thirst.")
                actor:send("The command is <b:cyan>DRINK [container]</>.")
                actor:send("</>")
                actor:send("When you <b:cyan>DRINK</>, you'll also regain some Stamina, so make sure you carry a full waterskin so you can keep moving when you explore!")
                actor:send("</>")
                actor:send("And remember, magic potions are <red>not</> drinks.")
                actor:send("If you want to consume a potion, the commmand is <b:cyan>(Q)UAFF</>, not <b:cyan>(DRI)NK</>.'")
                wait(3)
                if not actor:has_item(0, 20) and not actor:has_equipped(0, 20) then
                    actor:send(tostring(self.name) .. " tells you, 'Here's a new waterskin for you.")
                    self.room:spawn_object(0, 20)
                    self:command("give waterskin " .. tostring(actor))
                else
                    actor:send(tostring(self.name) .. " tells you, 'You started play with a full waterskin.")
                end
                actor:send("</>Type <b:green>drink waterskin</> now to drink out of it.'")
                break
            end
            if _run1 or tonumber(_sw1) == 4 then
                _run1 = true
                actor:set_quest_var("school", "rest", 5)
            end
            if _run1 or tonumber(_sw1) == 5 then
                _run1 = true
                actor:send(tostring(self.name) .. " tells you, 'Now you can <b:green>fill waterskin fountain</>.'")
                break
            end
            if _run1 or tonumber(_sw1) == 6 then
                _run1 = true
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
                break
            end
            if _run1 or tonumber(_sw1) == 7 then
                _run1 = true
                actor:send(tostring(self.name) .. " tells you, 'There are just a few final things to know before you head out into the world.'")
                wait(2)
                actor:send(tostring(self.name) .. " tells you, 'The best place to start your adventures is the <b:yellow>FARMLAND</> immediately west of the town of Mielikki, the starting town above us.'")
                wait(2)
                actor:send(tostring(self.name) .. " tells you, 'The <b:cyan>HELP ZONE</> file will show you lots of places to explore.")
                actor:send("Type <b:green>help zone</> and check it out.'")
                break
            end
            if _run1 or _sw1 == "complete" then
                _run1 = true
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
                break
            end
            do  -- default
                _run1 = true
                actor:send(tostring(self.name) .. " tells you, 'Hit Points and Stamina regenerate naturally over time.")
                actor:send("The rate is influenced by a number of factors, including position and nutrition.'")
                wait(2)
                actor:send(tostring(self.name) .. " tells you, 'You might not realize you're healing though, because your display only updates when you get some kind of input!'")
                wait(1)
                actor:send(tostring(self.name) .. " tells you, 'Hit Points only regenerate while you <b:cyan>(R)EST</> or <b:cyan>(SL)EEP</>.  Standing still recovers Stamina only.")
                actor:send("When you <b:cyan>REST</>, you sit down and relax.")
                actor:send("You remain awake, and can hear and see the world around you.")
                actor:send("You can do most things, including talking, eating, changing gear, and recovering spells.'")
                wait(2)
                actor:send(tostring(self.name) .. " tells you, 'Take a load off!")
                actor:send("Type <b:green>rest</> to relax.'")
            end
        until true
    end
end$trig$, ARRAY['9937624f6b63d810ea1e441254cdd070', '1798cfb159952e403ee7c36be2e11679', '312c04df63863d22cc474383e3927281']),
  -- data/triggers/519/519_92_academy_revel_speech_money.lua
  (519, 92, $trig$-- Converted from DG Script #51992: academy_revel_speech_money
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"money"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("school") == 5 and not actor:get_quest_var("school:money") then
    actor:set_quest_var("school", "money", 1)
    actor:send(tostring(self.name) .. " tells you, 'You can <b:cyan>GET</>, <b:cyan>DROP</>, and <b:cyan>GIVE</> money like items.")
    actor:send("To check your current wealth, use <b:cyan>WEALTH</>.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'During your downtime you may want to visit a bank.")
    actor:send("It's important to keep money in the bank so that when you die, you'll have emergency funds to get back to your corpse!")
    actor:send("</>")
    actor:send("I myself happen to be a certified banker!")
    actor:send("</>")
    actor:send("At a bank you can <b:cyan>DEPOSIT</> and <b:cyan>WITHDRAW</> money.")
    wait(3)
    self:command("give 5 gold 5 silver 5 copper " .. tostring(actor.name))
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Let's try out depositing money, like this:")
    actor:send("<b:cyan>DEPOSIT [amount] [platinum|gold|silver|copper]</>, or <b:cyan>DEPOSIT ALL</>.")
    actor:send("One kind of coin at a time; with no coin named, the amount is in copper.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>deposit 1 gold</>.'")
end$trig$, ARRAY['6124b94f16bdff463ac76fabe4eb105e', '6a2fed97aba4c97bb91c7c8577f679d7', '5d32745dbec2148a9ef7957ad3b6ac1a'])
) AS v(zone_id, id, commands, old_md5s)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = ANY (v.old_md5s)
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
