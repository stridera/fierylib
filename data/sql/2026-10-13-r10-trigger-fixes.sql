-- Playtest r10: Academy gear/explore/sorcerer-spell deadlocks (put fires DROP with target; bare look; spells), guild armor quest (557:2-4: real item names, == slot match, progress answers, vnum-keyed turn-ins), command-arg truthiness (quest journal, leather ball, throatcut).
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).
-- Guarded: a row is only touched while it still holds the previous committed
-- body (md5), so rows edited in Muditor since then are left alone.

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/004/004_00_quest_journal.lua
  (4, 0, $trig$-- Converted from DG Script #400: Quest Journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == nil or arg == "" then
    actor:send("This journal tracks all your quest information as you journey through Ethilien!")
    actor:send("<yellow>=====================================<==/>")
    actor:send("<yellow>OVERVIEW</>")
    actor:send("Quests will be revealed in this journal as you become eligible to take them on.  There are main indexes organized around the type of quest, then detailed entries for each individual quest.")
    actor:send("The quest journal will always have your most recent personal quest records in it, no matter which copy you look at.")
    actor:send("</>")
    actor:send("To look at a category of quests, type \"look journal (category name)\".")
    actor:send("To look at a specific quest, type: \"look journal (quest name)\".")
    actor:send("</>")
    actor:send("For more on the general quest system, see <b:cyan>[HELP QUEST]</>.")
    actor:send("<yellow>=====================================<==/>")
    actor:send("There are five types of quests:")
    actor:send("1. <b:yellow>ADVENTURE</> quests")
    actor:send("- These quests take you through areas and explore the story behind each place you encounter.  These quests often culminate in a boss battle and have excellent rewards!_")
    actor:send("2. <b:yellow>EQUIPMENT</> quests")
    actor:send("- These quests take you all across the world reward you with top-tier equipment.  These often take many levels to complete and require vast exploration, but some are focused on a particular zone.")
    actor:send("3. <b:yellow>HEROES FOR HIRE</> quests")
    actor:send("- These quests are types of bounty hunts, tasking you with hunting down a particular target.  They increase in difficulty across a hero's lifetime!")
    actor:send("4. <b:yellow>SPELL</> quests")
    actor:send("- These quests challenge you to take on the strongest monsters, find the most valuable treasures, and delve into the deepest secrets Fiery has to offer.  The rewards are supreme magic, unrivaled magic.  Quest songs and chants are included in this category.")
    actor:send("5. <b:yellow>SUBCLASS</> quests.")
    actor:send("- These quests can be undertaken by a low-level character to change from a core class to a subclass.  Much more information can be found in <b:cyan>[HELP SUBCLASS]</>.")
    actor:send("- Only characters in core classes within the proper level range will see what quests are available to them on this page.")
    actor:send("_")
    actor:send("Read or look at any of the five sections above to see what's currently available: ADVENTURE, EQUIPMENT, HIRE, SPELL, SUBCLASS.")
    _return_value = true
end
return _return_value$trig$, 'd7c2619b3126e1bb8e93185345d1839a'),
  -- data/triggers/030/030_109_leather_ball_bounce.lua
  (30, 109, $trig$-- Converted from DG Script #3109: leather_ball_bounce
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: bounce
if not (cmd == "bounce") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = false
if arg ~= nil and arg ~= "" then
    if actor.room ~= arg.room then
        actor:send("Bounce the ball on who?  They don't seem to be here!")
    else
        arg:teleport(get_room(11, 0))
        self.room:send_except(actor, tostring(actor.name) .. " throws " .. tostring(self.shortdesc) .. " at " .. tostring(arg.name) .. ", bouncing it off " .. tostring(arg.possessive) .. " forehead!")
        arg:teleport(actor.room)
        arg:send(tostring(actor.name) .. " throws " .. tostring(self.shortdesc) .. " at you, bouncing it off your forehead!")
        actor:send("You launch " .. tostring(self.shortdesc) .. " at " .. tostring(arg.name) .. ", bouncing it off " .. tostring(arg.possessive) .. " forehead!")
    end
else
    self.room:send_except(actor, tostring(actor.name) .. " bounces " .. tostring(self.shortdesc) .. " on the ground a few times.")
    actor:send("You dribble " .. tostring(self.shortdesc) .. " around yourself a little bit.")
end
return _return_value$trig$, 'c1b010c7e46fabfbd7d2cd543e14fbf5'),
  -- data/triggers/484/484_17_prevent_throatcut.lua
  (484, 17, $trig$-- Converted from DG Script #48417: prevent throatcut
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: throatcut
if not (cmd == "throatcut") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
if cmd == "t" or cmd == "th" then
    _return_value = true
    return _return_value
end
if arg ~= nil and arg ~= "" then
    -- TODO(parity): these legacy vnum lists (4XXXX) need to be remapped to
    -- new (zone, local_id) pairs. For now we compare arg.id (the local id)
    -- against the trailing two-digit portion of each legacy vnum for
    -- triggers in zone 484/485/486; cross-zone entries will be missed.
    local no_throat = " 48400 48414 48500 48502 48503 48505 48513 48514 48515 48630 48631 48634 48803 48812 48813 48909 48919 "
    local undead    = " 48404 48405 48902 48903 48905 48912 48913 48914 48915 48921 48922 48923 "
    local boss      = " 48406 48504 48506 48507 48510 48632 48633 48635 48806 48809 48814 48901 48910 48911 48917 48918 "
    local arg_token = " " .. tostring(arg.id) .. " "
    if string.find(no_throat, arg_token, 1, true) then
        _return_value = false
        actor:send("But " .. tostring(arg.name) .. " doesn't even have a throat to cut!")
    elseif string.find(undead, arg_token, 1, true) then
        _return_value = false
        actor:send("<b:red>" .. tostring(arg.name) .. " gurgles as you slice into " .. tostring(arg.possessive) .. " throat, but there is little effect!</> (<yellow>0</>)")
        self.room:send_except(actor, "<b:red>" .. tostring(arg.name) .. " looks expressionless as " .. tostring(actor.name) .. " slices into " .. tostring(arg.possessive) .. " throat!</> (<yellow>0</>)")
        arg:command("kill " .. tostring(actor.name))
    elseif string.find(boss, arg_token, 1, true) then
        _return_value = false
        actor:send("You just can't seem to get close enough to " .. tostring(arg.possessive) .. " throat...")
    end
else
    _return_value = true
end
return _return_value$trig$, 'dc224e4ba1958c7b773394336910a2bf'),
  -- data/triggers/519/519_12_academy_stick_drop.lua
  (519, 12, $trig$-- Converted from DG Script #51912: academy_stick_drop
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
elseif actor:get_quest_var("school:gear") == 13 and target and target.id == 18 then
    actor:set_quest_var("school", "gear", 14)
    wait(2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'That's how it's done.'")
    wait(2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'To see what's inside something, use <b:cyan>(EXA)MINE [target]</>.")
    actor:send("<b:cyan>EXAMINE</> will also show if something is open or closed.'")
    wait(2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Go ahead and <b:green>examine bag</> and see what you find.'")
end$trig$, '1fa12c3378a0aa9462268caadb9bcbcf'),
  -- data/triggers/519/519_17_academy_instructor_command_look.lua
  (519, 17, $trig$-- Converted from DG Script #51917: academy_instructor_command_look
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: look
if not (cmd == "look") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if actor:get_quest_var("school:explore") == 1 and (arg == nil or arg == "") then
    actor:set_quest_var("school", "explore", 2)
    -- actor looks around
    wait(2)
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
_return_value = true
return _return_value$trig$, '0b3cb9bc781d5c7a72c14adc3bdcc705'),
  -- data/triggers/519/519_48_academy_sorcerer_command_spell.lua
  (519, 48, $trig$-- Converted from DG Script #51948: academy_sorcerer_command_spell
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: spells
if not (cmd == "spells") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
if cmd == "s" or cmd == "sp" then
    _return_value = true
    return _return_value
end
if actor:get_quest_var("school:fight") == 2 then
    actor:set_quest_var("school", "fight", 3)
    actor:command("spells")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Spells are divided up by Circle.")
    actor:send("For now you only have access to Circle 1 spells.")
    actor:send("You gain access to a new Circle every 8 levels.")
    actor:send("You can find out what any spell does by consulting the <b:cyan>HELP</> file.")
    actor:send("</>")
    actor:send("For now, you're going to learn <b:yellow>magic missile</>.")
    actor:send("</>")
    actor:send("<b:cyan>(REM)OVE</> anything in your hands.")
    actor:send("Then <b:cyan>(H)OLD</> your spellbook.'")
    wait(2)
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
    if not actor:has_equipped(10, 29) and not actor:has_item(10, 29) then
        actor:send(tostring(self.name) .. " tells you, 'Looks like you need a new book too.'")
        self.room:spawn_object(10, 29)
        self:command("give book " .. tostring(actor))
        actor:send("</>")
    end
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>hold spellbook</> to grab your book.'")
end
_return_value = true
return _return_value$trig$, '9b86d9ae3651a48e492cd5142422388d'),
  -- data/triggers/557/557_02_phase_armor_-_armor.lua
  (557, 2, $trig$-- Converted from DG Script #55702: Phase Armor - Armor
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
-- DG `%get.obj_shortdesc/noadesc/pldesc[VNUM]%` (legacy dg_scripts.cpp): VNUM = zone * 100 + id.
local function proto_short(vnum)
    vnum = tonumber(vnum)
    if not vnum then return "[no description for object ?]" end
    local name = objects.template(math.floor(vnum / 100), vnum % 100).name
    if name == nil or name == "" then return "[no description for object " .. vnum .. "]" end
    return name
end
local function without_article(s)
    for _, a in ipairs({"a pair ", "a ", "an ", "some ", "the "}) do
        if string.lower(string.sub(s, 1, #a)) == a then return string.sub(s, #a + 1) end
    end
    return s
end
local function proto_noa(vnum)
    return without_article(proto_short(vnum))
end
local function proto_plural(vnum)
    local s = proto_short(vnum)
    if string.lower(string.sub(s, 1, 5)) == "some " then
        return "quantities of " .. string.sub(s, 6)
    end
    local u = without_article(s)
    local last2, last1 = string.sub(u, -2, -2), string.sub(u, -1)
    local function consonant(c) return c:match("%a") ~= nil and not c:match("[aeiouAEIOU]") end
    if #u < 2 then return u .. "'s" end
    if last1 == "s" and last2 ~= "s" then return u end  -- already plural ("mittens")
    if (last2 == "e" or last2 == "i") and last1 == "z" then return u .. "zes" end
    if last1 == "x" or last1 == "z" or u:sub(-2) == "sh" or u:sub(-2) == "ss" or u:sub(-2) == "ch"
       or (consonant(last2) and last1 == "o") then
        return u .. "es"
    end
    if consonant(last2) and last1 == "y" then return u:sub(1, -2) .. "ies" end
    return u .. "s"
end
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"boots", "slippers", "sandals", "helm", "cap", "circlet", "coif", "turban", "gauntlets", "gloves", "fistwraps", "vambraces", "sleeves", "greaves", "pants", "leggings", "plate", "guard", "jerkin", "tunic", "robe", "bracer", "bracelet", "mittens", "crown", "doublet"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- DG globals set on this mob by its init (LOAD) trigger, 557:10-39
local classes = self:getvar("classes")
local phase = self:getvar("phase")
local feet_gem = self:getvar("feet_gem")
local head_gem = self:getvar("head_gem")
local hands_gem = self:getvar("hands_gem")
local arms_gem = self:getvar("arms_gem")
local legs_gem = self:getvar("legs_gem")
local body_gem = self:getvar("body_gem")
local wrist_gem = self:getvar("wrist_gem")
local feet_armor = self:getvar("feet_armor")
local head_armor = self:getvar("head_armor")
local hands_armor = self:getvar("hands_armor")
local arms_armor = self:getvar("arms_armor")
local legs_armor = self:getvar("legs_armor")
local body_armor = self:getvar("body_armor")
local wrist_armor = self:getvar("wrist_armor")
local feet_name = self:getvar("feet_name")
local head_name = self:getvar("head_name")
local hands_name = self:getvar("hands_name")
local arms_name = self:getvar("arms_name")
local legs_name = self:getvar("legs_name")
local body_name = self:getvar("body_name")
local wrist_name = self:getvar("wrist_name")
if classes == nil or phase == nil then
    return true  -- the init trigger has not run for this mob
end
wait(2)
local anti = "Anti-Paladin"
-- If you add more types of armor, you need to add their
-- keywords in the argument field for this trigger.
if not actor or not actor.can_be_seen then
    self:command("peer")
    self:say("I can't help you if I can't see you.")
    return true
elseif not string.find(string.lower(classes), actor.class, 1, true) or (classes == anti and actor.class == "paladin") then
    if string.find(classes, "and") then
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the")
        actor:send("</>" .. tostring(classes))
        actor:send("</>classes only.'")
    else
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the")
        actor:send("</>" .. tostring(classes))
        actor:send("</>class only.'")
    end
    return true
elseif actor.level <= 20 * (phase - 1) then
    actor:send(tostring(self.name) .. " tells you, 'Sorry, why don't you come back when you've")
    actor:send("</>gained more experience?'")
    return true
elseif actor:get_quest_stage("phase_armor") < phase then
    actor:send(tostring(self.name) .. " tells you, 'I don't think you're ready for my quests yet.'")
    return true
end
-- Original DG selected the slot whose `<slot>_name` contains the speech
-- (`%hands_name%? /= %speech%`: `/=` is a substring test, and the `?` lets
-- a trailing question mark in the speech still match).
local function slot_matches(slot_name)
    return slot_name ~= nil and string.find(string.lower(tostring(slot_name)) .. "?", string.lower(speech), 1, true) ~= nil
end
local name, gem_id, armor_id
if slot_matches(hands_name) then
    name = "pair of " .. tostring(hands_name)
    gem_id = hands_gem
    armor_id = hands_armor
elseif slot_matches(feet_name) then
    name = "pair of " .. tostring(feet_name)
    gem_id = feet_gem
    armor_id = feet_armor
elseif slot_matches(wrist_name) then
    name = wrist_name
    gem_id = wrist_gem
    armor_id = wrist_armor
elseif slot_matches(head_name) then
    name = head_name
    gem_id = head_gem
    armor_id = head_armor
elseif slot_matches(arms_name) then
    name = "pair of " .. tostring(arms_name)
    gem_id = arms_gem
    armor_id = arms_armor
elseif slot_matches(legs_name) then
    name = "pair of " .. tostring(legs_name)
    gem_id = legs_gem
    armor_id = legs_armor
elseif slot_matches(body_name) then
    name = body_name
    gem_id = body_gem
    armor_id = body_armor
end
if name then
    actor:send(tostring(self.name) .. " tells you, 'Well, I can make a fine " .. tostring(name) .. " for you, but")
    actor:send("</>I'll need <b:cyan>" .. proto_short(armor_id) .. "</> and <b:cyan>three " .. proto_plural(gem_id) .. "</>.")
    actor:send("</>Bring these things to me in any order, at any time, and I will reward you.'")
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'You will find them on creatures across the world.")
    if phase == 1 then
        actor:send("</>Creatures <b:cyan>up to level 20</> will drop them.'")
    elseif phase == 2 then
        actor:send("</>Creatures <b:cyan>level 20 to 40</> will drop them.'")
    elseif phase == 3 then
        actor:send("</>Creatures <b:cyan>level 40 to 70</> will drop them.'")
    end
else
    actor:send(tostring(self.name) .. " peers at you oddly.")
    self.room:send_except(actor, tostring(self.name) .. " peers at " .. tostring(actor.name) .. " oddly.")
    actor:send(tostring(self.name) .. " tells you, 'I don't think I can make that for you.'")
end$trig$, 'a9e9f68b8008addbab6e08e6658276f2'),
  -- data/triggers/557/557_03_phase_armor_-_receive.lua
  (557, 3, $trig$-- Converted from DG Script #55703: Phase Armor - Receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG `%get.obj_shortdesc/noadesc/pldesc[VNUM]%` (legacy dg_scripts.cpp): VNUM = zone * 100 + id.
local function proto_short(vnum)
    vnum = tonumber(vnum)
    if not vnum then return "[no description for object ?]" end
    local name = objects.template(math.floor(vnum / 100), vnum % 100).name
    if name == nil or name == "" then return "[no description for object " .. vnum .. "]" end
    return name
end
local function without_article(s)
    for _, a in ipairs({"a pair ", "a ", "an ", "some ", "the "}) do
        if string.lower(string.sub(s, 1, #a)) == a then return string.sub(s, #a + 1) end
    end
    return s
end
local function proto_noa(vnum)
    return without_article(proto_short(vnum))
end
local function proto_plural(vnum)
    local s = proto_short(vnum)
    if string.lower(string.sub(s, 1, 5)) == "some " then
        return "quantities of " .. string.sub(s, 6)
    end
    local u = without_article(s)
    local last2, last1 = string.sub(u, -2, -2), string.sub(u, -1)
    local function consonant(c) return c:match("%a") ~= nil and not c:match("[aeiouAEIOU]") end
    if #u < 2 then return u .. "'s" end
    if last1 == "s" and last2 ~= "s" then return u end  -- already plural ("mittens")
    if (last2 == "e" or last2 == "i") and last1 == "z" then return u .. "zes" end
    if last1 == "x" or last1 == "z" or u:sub(-2) == "sh" or u:sub(-2) == "ss" or u:sub(-2) == "ch"
       or (consonant(last2) and last1 == "o") then
        return u .. "es"
    end
    if consonant(last2) and last1 == "y" then return u:sub(1, -2) .. "ies" end
    return u .. "s"
end
-- DG globals set on this mob by its init (LOAD) trigger, 557:10-39
local classes = self:getvar("classes")
local phase = self:getvar("phase")
local feet_gem = self:getvar("feet_gem")
local head_gem = self:getvar("head_gem")
local hands_gem = self:getvar("hands_gem")
local arms_gem = self:getvar("arms_gem")
local legs_gem = self:getvar("legs_gem")
local body_gem = self:getvar("body_gem")
local wrist_gem = self:getvar("wrist_gem")
local feet_armor = self:getvar("feet_armor")
local head_armor = self:getvar("head_armor")
local hands_armor = self:getvar("hands_armor")
local arms_armor = self:getvar("arms_armor")
local legs_armor = self:getvar("legs_armor")
local body_armor = self:getvar("body_armor")
local wrist_armor = self:getvar("wrist_armor")
local feet_reward = self:getvar("feet_reward")
local head_reward = self:getvar("head_reward")
local hands_reward = self:getvar("hands_reward")
local arms_reward = self:getvar("arms_reward")
local legs_reward = self:getvar("legs_reward")
local body_reward = self:getvar("body_reward")
local wrist_reward = self:getvar("wrist_reward")
if classes == nil or phase == nil then
    return true  -- the init trigger has not run for this mob
end
local _return_value = true  -- Default: allow action
-- The init trigger stores legacy vnums (zone * 100 + id); compare the
-- turned-in object the same way.
local object_id = (tonumber(object.zone_id) or 0) * 100 + (tonumber(object.local_id) or 0)
if object_id == hands_armor or object_id == hands_gem or object_id == feet_armor or object_id == feet_gem or object_id == wrist_armor or object_id == wrist_gem or object_id == head_armor or object_id == head_gem or object_id == arms_armor or object_id == arms_gem or object_id == legs_armor or object_id == legs_gem or object_id == body_armor or object_id == body_gem then
    local anti = "Anti-Paladin"
    if not actor or not actor.can_be_seen then
        _return_value = true
        self:command("peer")
        actor:send(tostring(self.name) .. " says, 'I can't help you if I can't see you.'")
        return _return_value
    end
    if not string.find(string.lower(classes), actor.class, 1, true) or (classes == anti and actor.class == "paladin") then
        _return_value = true
        if string.find(classes, "and") then
            actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the " .. tostring(classes) .. " classes only.'")
        else
            actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the " .. tostring(classes) .. " class only.'")
        end
        return _return_value
    elseif actor.level <= 20 * (phase - 1) then
        _return_value = true
        actor:send(tostring(self.name) .. " tells you, 'Sorry, why don't you come back when you've gained more experience?'")
        actor:send(tostring(self.name) .. " refuses your item.")
        return _return_value
    elseif actor:get_quest_stage("phase_armor") < phase then
        _return_value = true
        actor:send(tostring(self.name) .. " tells you, 'I don't think you're ready for my armor quests yet.'")
        actor:send(tostring(self.name) .. " refuses your item.")
        return _return_value
    end
    -- DG `case <armor>` falls through into `case <gem>`: both set the slot's
    -- multiplier and reward, only the armor sets `is_armor`.
    local is_armor, exp_x, reward_id
    local slot_table = {
        {hands_armor, hands_gem, 1, hands_reward},
        {feet_armor, feet_gem, 2, feet_reward},
        {wrist_armor, wrist_gem, 3, wrist_reward},
        {head_armor, head_gem, 4, head_reward},
        {arms_armor, arms_gem, 6, arms_reward},
        {legs_armor, legs_gem, 8, legs_reward},
        {body_armor, body_gem, 10, body_reward},
    }
    for _, sl in ipairs(slot_table) do
        if object_id == sl[1] then
            is_armor = 1
        end
        if object_id == sl[1] or object_id == sl[2] then
            exp_x = sl[3]
            reward_id = sl[4]
            break
        end
    end
    if is_armor then
        local armor_key = tostring(object_id) .. "_armor_acquired"
        local armor_count = actor:get_quest_var("phase_armor:" .. armor_key) or 0
        if armor_count < 1 then
            _return_value = false
            wait(1)
            world.destroy(object)
            armor_count = armor_count + 1
            actor:set_quest_var("phase_armor", armor_key, armor_count)
            actor:send(tostring(self.name) .. " tells you, 'Hey now, what have we here!?")
            actor:send("</>I've been looking for this for some time.")
            actor:send("</>You have now given me " .. proto_short(object_id) .. ".'")
        else
            _return_value = true
            wait(2)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'Hey now, you've already given me one of these!'")
            actor:send(tostring(self.name) .. " refuses your item.")
            return _return_value
        end
    else
        local gem_key = tostring(object_id) .. "_gems_acquired"
        local gem_count = actor:get_quest_var("phase_armor:" .. gem_key) or 0
        if gem_count < 3 then
            _return_value = false
            wait(1)
            world.destroy(object)
            gem_count = gem_count + 1
            actor:set_quest_var("phase_armor", gem_key, gem_count)
            actor:send(tostring(self.name) .. " tells you, 'Hey, very nice.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'It is good to see that adventurers are out conquering the realm.'")
            wait(2)
            if gem_count == 1 then
                actor:send(tostring(self.name) .. " tells you, 'You have given me 1 " .. proto_noa(object_id) .. ".'")
            else
                actor:send(tostring(self.name) .. " tells you, 'You have given me " .. tostring(gem_count) .. " " .. proto_plural(object_id) .. ".'")
            end
        else
            _return_value = true
            wait(1)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'Hey now, you've already given me " .. tostring(gem_count) .. " of these!'")
            actor:send(tostring(self.name) .. " refuses your item.")
            return _return_value
        end
    end
    --
    -- Check to see if the quest is complete and if the reward can be given.
    -- The original DG looked up `<gem_id>_gems_acquired` and
    -- `<armor_id>_armor_acquired`; we mirror that using the same
    -- `<id>_..._acquired` keying pattern used above. Per-slot pairing
    -- is derived from whichever gem/armor slot matches `object_id`.
    --
    local function _slot_for(oid)
        if oid == hands_armor or oid == hands_gem then return hands_armor, hands_gem end
        if oid == feet_armor  or oid == feet_gem  then return feet_armor,  feet_gem  end
        if oid == wrist_armor or oid == wrist_gem then return wrist_armor, wrist_gem end
        if oid == head_armor  or oid == head_gem  then return head_armor,  head_gem  end
        if oid == arms_armor  or oid == arms_gem  then return arms_armor,  arms_gem  end
        if oid == legs_armor  or oid == legs_gem  then return legs_armor,  legs_gem  end
        if oid == body_armor  or oid == body_gem  then return body_armor,  body_gem  end
    end
    local slot_armor_id, slot_gem_id = _slot_for(object_id)
    if slot_armor_id
       and (actor:get_quest_var("phase_armor:" .. tostring(slot_gem_id) .. "_gems_acquired") == 3)
       and (actor:get_quest_var("phase_armor:" .. tostring(slot_armor_id) .. "_armor_acquired") == 1) then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Excellent work, intrepid adventurer!")
        actor:send("</>You have provided me with all I need to reward you with:")
        actor:send("</>" .. proto_short(reward_id) .. "!'")
        wait(2)
        actor:send("<b:white>You gain experience!</>")
        local exp
        if actor.class == "warrior" or actor.class == "berserker" then
            exp = 7590
        elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
            exp = 7935
        elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
            exp = 8280
        elseif actor.class == "necromancer" or actor.class == "monk" then
            exp = 8970
        else
            exp = 6900
        end
        if phase == 2 then
            exp = math.floor(exp * 608 / 100)
        elseif phase == 3 then
            exp = math.floor(exp * 1340 / 100)
        end
        local lap = 1
        while lap <= exp_x do
            actor:award_exp(exp)
            lap = lap + 1
        end
        self.room:spawn_object(math.floor(reward_id / 100), reward_id % 100)
        self:command("give all " .. tostring(actor.name))
        self:command("drop all")
        actor:save()
    end
end  -- auto-close block
return _return_value$trig$, '867bd621f9eef4db90d36420aee64923'),
  -- data/triggers/557/557_04_phase_armor_-_status.lua
  (557, 4, $trig$-- Converted from DG Script #55704: Phase Armor - Status
-- Original: MOB trigger, flags: SPEECH_TO, probability: 0%
-- Speech phrase: armor progress (DG num_arg 0 = the speech contains the phrase, not a chance)
local said = string.lower(speech)
if not string.find(said, "armor progress", 1, true) and not string.find(said, "progress", 1, true) then
    return true  -- Not the phrase (`ask <master> progress` is accepted too)
end
-- DG `%get.obj_shortdesc/noadesc/pldesc[VNUM]%` (legacy dg_scripts.cpp): VNUM = zone * 100 + id.
local function proto_short(vnum)
    vnum = tonumber(vnum)
    if not vnum then return "[no description for object ?]" end
    local name = objects.template(math.floor(vnum / 100), vnum % 100).name
    if name == nil or name == "" then return "[no description for object " .. vnum .. "]" end
    return name
end
local function without_article(s)
    for _, a in ipairs({"a pair ", "a ", "an ", "some ", "the "}) do
        if string.lower(string.sub(s, 1, #a)) == a then return string.sub(s, #a + 1) end
    end
    return s
end
local function proto_noa(vnum)
    return without_article(proto_short(vnum))
end
local function proto_plural(vnum)
    local s = proto_short(vnum)
    if string.lower(string.sub(s, 1, 5)) == "some " then
        return "quantities of " .. string.sub(s, 6)
    end
    local u = without_article(s)
    local last2, last1 = string.sub(u, -2, -2), string.sub(u, -1)
    local function consonant(c) return c:match("%a") ~= nil and not c:match("[aeiouAEIOU]") end
    if #u < 2 then return u .. "'s" end
    if last1 == "s" and last2 ~= "s" then return u end  -- already plural ("mittens")
    if (last2 == "e" or last2 == "i") and last1 == "z" then return u .. "zes" end
    if last1 == "x" or last1 == "z" or u:sub(-2) == "sh" or u:sub(-2) == "ss" or u:sub(-2) == "ch"
       or (consonant(last2) and last1 == "o") then
        return u .. "es"
    end
    if consonant(last2) and last1 == "y" then return u:sub(1, -2) .. "ies" end
    return u .. "s"
end
-- DG globals set on this mob by its init (LOAD) trigger, 557:10-39
local classes = self:getvar("classes")
local phase = self:getvar("phase")
local feet_gem = self:getvar("feet_gem")
local head_gem = self:getvar("head_gem")
local hands_gem = self:getvar("hands_gem")
local arms_gem = self:getvar("arms_gem")
local legs_gem = self:getvar("legs_gem")
local body_gem = self:getvar("body_gem")
local wrist_gem = self:getvar("wrist_gem")
local feet_armor = self:getvar("feet_armor")
local head_armor = self:getvar("head_armor")
local hands_armor = self:getvar("hands_armor")
local arms_armor = self:getvar("arms_armor")
local legs_armor = self:getvar("legs_armor")
local body_armor = self:getvar("body_armor")
local wrist_armor = self:getvar("wrist_armor")
local feet_reward = self:getvar("feet_reward")
local head_reward = self:getvar("head_reward")
local hands_reward = self:getvar("hands_reward")
local arms_reward = self:getvar("arms_reward")
local legs_reward = self:getvar("legs_reward")
local body_reward = self:getvar("body_reward")
local wrist_reward = self:getvar("wrist_reward")
if classes == nil or phase == nil then
    return true  -- the init trigger has not run for this mob
end
local anti = "Anti-Paladin"
wait(2)
if not actor or not actor.can_be_seen then
    self:command("peer")
    self:say("I can't help you if I can't see you.")
    return true
elseif not string.find(string.lower(classes), actor.class, 1, true) or (classes == anti and actor.class == "paladin") then
    if string.find(classes, "and") then
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the")
        actor:send("</>" .. tostring(classes))
        actor:send("</>classes only.'")
    else
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the")
        actor:send("</>" .. tostring(classes))
        actor:send("</>class only.'")
    end
    return true
elseif actor.level <= 20 * (phase - 1) then
    actor:send(tostring(self.name) .. " tells you, 'Sorry, why don't you come back when you've")
    actor:send("</>gained more experience?'")
    return true
elseif actor:get_quest_stage("phase_armor") < phase then
    actor:send(tostring(self.name) .. " tells you, 'I don't think you're ready for my quests yet.'")
    return true
end
-- Progress is keyed by the legacy vnum, as in 557:3 (`<vnum>_armor_acquired` /
-- `<vnum>_gems_acquired`).
local function acquired(vnum, suffix)
    return tonumber(actor:get_quest_var("phase_armor:" .. tostring(vnum) .. suffix)) or 0
end
local slots = {
    {armor = hands_armor, gem = hands_gem, reward = hands_reward},
    {armor = feet_armor, gem = feet_gem, reward = feet_reward},
    {armor = wrist_armor, gem = wrist_gem, reward = wrist_reward},
    {armor = head_armor, gem = head_gem, reward = head_reward},
    {armor = arms_armor, gem = arms_gem, reward = arms_reward},
    {armor = legs_armor, gem = legs_gem, reward = legs_reward},
    {armor = body_armor, gem = body_gem, reward = body_reward},
}
local given, unrewarded = 0, 0
local any_done = false
for _, slot in ipairs(slots) do
    slot.got = acquired(slot.armor, "_armor_acquired")
    slot.count = acquired(slot.gem, "_gems_acquired")
    slot.done = slot.got == 1 and slot.count == 3
    any_done = any_done or slot.done
    given = given + slot.got + slot.count
    if slot.got + slot.count ~= 4 then unrewarded = unrewarded + 1 end
end
actor:send(tostring(self.name) .. " tells you, 'Look for treasures from creatures:")
if phase == 1 then
    actor:send("<b:cyan>below level 20</>.'_")
elseif phase == 2 then
    actor:send("<b:cyan>level 20 to 40</>.'_")
elseif phase == 3 then
    actor:send("<b:cyan>level 40 to 70</>.'_")
end
if given == 0 then
    actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
    return true
elseif unrewarded > 0 then
    actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
end
for _, slot in ipairs(slots) do
    if slot.got > 0 and not slot.done then
        actor:send("</>  " .. proto_short(slot.armor))
    end
    if slot.count > 0 and not slot.done then
        actor:send("</>  " .. tostring(slot.count) .. " of " .. proto_short(slot.gem))
    end
end
if any_done then
    actor:send("_")
    actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
end
for _, slot in ipairs(slots) do
    if slot.done then
        actor:send("</>  " .. proto_short(slot.reward))
    end
end$trig$, 'bce612635fb655124edc99a45f5d1586')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
