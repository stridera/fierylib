-- Playtest r14: academy money lesson (519:65, 519:92), graduation wording (519:73), CTF flag pass (188:82)
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
  -- data/triggers/188/188_82_ctf_flag_pass.lua
  (188, 82, $trig$-- Rewritten from DG Script #18882: ctf_flag_pass
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%
--
-- Capture the flag. The flags (188:82 team A's, 188:83 team B's) carry this
-- trigger. A player holding a flag types "pass flag <player>": the target is
-- looked up in the room (arg is only the typed word). Passing to a teammate
-- hands the flag over; passing to the other team resets the flag at its home
-- room. Teams are told apart by the armband worn (188:80 team A, 188:81
-- team B), as in the armband trigger 188:80.

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2
-- (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: pass
if not (cmd == "pass") then
    return true  -- Not our command
end

local dg = require("dg")

-- *** Set entity IDs ****
-- Mobiles and objects are ids in zone 188
local referee = 80
local team_a_id = 80
local team_b_id = 81
local flag_a = 82
local flag_b = 83
-- Rooms are legacy numbers (zone * 100 + id), see dg.room: where each
-- team's flag lives (the same rooms as the armband trigger 188:80)
local flag_room_a = 3500
local flag_room_b = 8050

-- "pass flag <who>": the last word is the target
local words = {}
for w in string.gmatch(string.lower(arg or ""), "%S+") do
    words[#words + 1] = w
end
local word = words[#words] or ""
if word == "flag" or word == "" then
    actor:send("Pass the flag to whom?")
    return false
end

-- Who is being passed to: someone in this room
local target
if word ~= "self" then
    target = actor.room:find_actor(word)
end

if word == "self" or (target and target.name == actor.name) then
    -- Player tries to pass to self
    actor:send("There's really no point to that, now is there?")
    return false
end
if not target then
    -- Player tries to pass to someone who isn't in room or doesn't exist
    actor:send("Pass the flag to whom?  They're not here!")
    return false
end
if target.level > 99 then
    -- Player tries to pass to an immortal
    actor:send("You can't pass to an immortal!")
    return false
end

-- Player tries to pass to a player or the referee mob
local is_referee = target.is_npc and target.zone_id == 188
    and target.id == referee
if not (target.is_player or is_referee) then
    -- Player tries to pass to other mob
    actor:send("You can only pass the flag to players!")
    return false
end

local function team_of(who)
    if who:has_equipped(188, team_a_id) then
        return team_a_id
    elseif who:has_equipped(188, team_b_id) then
        return team_b_id
    end
    return nil
end

local tname = tostring(target.name)
local aname = tostring(actor.name)
local target_team = team_of(target)
if not target_team then
    -- Player tries to pass to someone who isn't playing
    actor:send(tname .. " doesn't seem to be playing.")
    return false
end

-- This flag's team and home room
local flag_room
if self.zone_id == 188 and self.id == flag_a then
    flag_room = flag_room_a
elseif self.zone_id == 188 and self.id == flag_b then
    flag_room = flag_room_b
end

local shortdesc = tostring(self.shortdesc)
local here = actor.room
if target_team == team_of(actor) then
    -- Player passes to someone on the same team
    target:send(aname .. " quickly passes " .. shortdesc .. " to you.")
    actor:send("You slyly hand off " .. shortdesc .. " to " .. tname .. ".")
    here:send_except(actor, aname .. " quietly passes a flag to " .. tname .. ".")
    here:spawn_object(self.zone_id, self.id)
    target:command("get ctf-flag")
    world.destroy(self)
else
    -- Player passes to someone on an enemy team (Reset flag)
    actor:send("You accidentally pass the flag to " .. tname .. ", resetting it.")
    local home = flag_room and get_room(dg.room(flag_room))
    if home then
        home:spawn_object(self.zone_id, self.id)
    end
    world.destroy(self)
end
return false$trig$, ARRAY['d21ac0ca3f5d2270699ca233fa47cf2e', '50709b25cb03ba9cc075e7ffe108eb58', 'eecb0fe6339d2bbb8c8fea27a9241f1d']),
  -- data/triggers/519/519_65_academy_revel_command_deposit.lua
  (519, 65, $trig$-- Converted from DG Script #51965: academy_revel_command_deposit
-- Original: MOB trigger, flags: COMMAND, probability: 100%
--
-- The real `deposit` runs (this script lets it through) and takes ONE amount:
-- `deposit <amount> [copper|silver|gold|platinum]` or `deposit all`, at a
-- banker (the Master of the Revel is one). The lesson used to ask for
-- "deposit 1 gold 1 silver 1 copper", which the command rejects with a usage
-- line, and advanced anyway. It now advances only when the typed amount is one
-- the command accepts and the student can have on hand: Lua cannot read the
-- wallet, so the cap is the purse the lesson hands out (5 gold 5 silver
-- 5 copper = 555 copper).

-- Command filter: deposit
if not (cmd == "deposit") then
    return true  -- Not our command
end

local LESSON_PURSE = 555  -- copper handed out by 519:92
local COIN = { copper = 1, cop = 1, c = 1, silver = 10, sil = 10, s = 10,
    gold = 100, gol = 100, g = 100, platinum = 1000, plat = 1000, p = 1000 }

-- Copper value of a deposit argument, "all", or nil when the command would
-- answer with its usage line (same rules as the server's bank amount parser).
local function bank_amount(text)
    text = string.lower(string.match(text or "", "^%s*(.-)%s*$"))
    if text == "all" then
        return "all"
    end
    local words = {}
    for w in string.gmatch(text, "%S+") do
        words[#words + 1] = w
    end
    local num, attached = string.match(words[1] or "", "^(%d+)(.*)$")
    if not num then
        return nil
    end
    local unit
    if attached == "" then
        if words[3] then
            return nil
        end
        unit = words[2] or "copper"
    else
        if words[2] then
            return nil
        end
        unit = attached
    end
    local scale = COIN[unit]
    if not scale then
        return nil
    end
    local total = tonumber(num) * scale
    if total <= 0 then
        return nil
    end
    return total
end

local lesson_open = (actor:get_quest_var("school:money") or 0) == 1
if not (lesson_open or actor:get_quest_var("school:money") == "complete") then
    return true  -- Not in the money lesson: the plain command
end

-- Let the real command run and answer for itself.
local amount = bank_amount(arg)
allow_command()
wait(0.5)
if lesson_open then
    if amount == "all" or (amount and amount <= LESSON_PURSE) then
        actor:set_quest_var("school", "money", "complete")
        actor:send(tostring(self.name) .. " tells you, 'Thank you for using Academy Bank.")
        actor:send("You can <b:cyan>WITHDRAW</> your funds at any time.'")
        wait(1)
    else
        actor:send(tostring(self.name) .. " tells you, 'Name one amount, like <b:green>deposit 1 gold</>.'")
        return
    end
end
if actor:get_quest_stage("school") == 5 then
    if actor:get_quest_var("school:money") == "complete" and actor:get_quest_var("school:rest") == "complete" then
        actor:advance_quest("school")
        actor:send(tostring(self.name) .. " tells you, 'You're ready to graduate from Ethilien Academy!")
        actor:send(tostring(self.name) .. " says, '<b:green>Say finish</> to end the school.'")
    else
        actor:send(tostring(self.name) .. " tells you, '<b:green>Say resting</> to finish your last lesson, or say <magenta>SKIP</> to jump to the end of the Academy.'")
    end
end$trig$, ARRAY['dd79162a27fc2f9eb5c6e34df60c8972', 'd27894a5486f95edacc64b29f8ec2834', 'db4fbe78597c15291b09f5609a698027']),
  -- data/triggers/519/519_73_academy_revel_speech_finish.lua
  (519, 73, $trig$-- Converted from DG Script #51973: academy_revel_speech_finish
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"finish"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("school") == 6 then
    actor:complete_quest("school")
    if actor.level == 1 then
        -- switch on actor.class -- target XP for level 2 by class
        local goal
        if actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
            goal = 6323
        elseif actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer" or actor.class == "illusionist" or actor.class == "bard" then
            goal = 6599
        elseif actor.class == "monk" or actor.class == "necromancer" then
            goal = 7149
        elseif actor.class == "warrior" or actor.class == "berserker" then
            goal = 6049
        elseif actor.class == "cleric" or actor.class == "priest" or actor.class == "diabolist" or actor.class == "druid" or actor.class == "rogue" or actor.class == "thief" or actor.class == "assassin" or actor.class == "mercenary" then
            goal = 5499
        else
            goal = 5499
        end
        local cap = (goal / 5)
        local reward = (goal - actor.exp)
        local loops = (reward / cap)
        local diff = (reward - (loops * cap))
        local lap = 1
        while lap <= loops do
            actor:award_exp(cap)
            lap = lap + 1
        end
        actor:award_exp(diff)
        -- switch on actor.class -- guild routing
        local direction, direction2, master
        if actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" or actor.class == "warrior" or actor.class == "monk" or actor.class == "berserker" then
            direction = "the Warrior's Guild"
            direction2 = "south&_ south&_ south&_ east&_ east&_ north&_ east&_ north&_"
            master = "Warrior Coach"
        elseif actor.class == "rogue" or actor.class == "thief" or actor.class == "mercenary" or actor.class == "assassin" or actor.class == "bard" then
            direction = "the Rogue's Guild"
            direction2 = "south&_ south&_ south&_ west&_ south&_ east&_ down&_"
            master = "the Master Rogue"
        elseif actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer" or actor.class == "necromancer" or actor.class == "illusionist" then
            direction = "the Mage's Guild"
            direction2 = "south&_ south&_ south&_ west&_ west&_ south&_ south&_ east&_"
            master = "the Archmage"
        elseif actor.class == "cleric" or actor.class == "priest" or actor.class == "druid" or actor.class == "diabolist" then
            direction = "the Cleric's Guild"
            direction2 = "west&_ north&_"
            master = "the High Priestess"
        else
            self:say("Oops, you broke, find a god.")
            return true
        end
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Now that you've finished the Academy, it's time to find your Guild Master!")
        actor:send("They are waiting in your guild's Inner Sanctum, just beyond the entrance room to your guild.'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, '<b:cyan>Look</> at the <b:cyan>map</> in your inventory.")
        actor:send("It will show you a layout of town.'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, '<b:green>East</> is the Forest Temple of Mielikki.")
        actor:send("Your guild is <b:magenta>" .. tostring(direction) .. "</>.")
        actor:send("From the Temple of Mielikki it is:")
        actor:send("<b:yellow> " .. tostring(direction2) .. "</>")
        actor:send("Your Guild Master is <b:magenta>" .. tostring(master) .. "</>.")
        actor:send("</>")
        actor:send("You gain levels automatically as you earn experience; type <b:cyan>LEVEL</> to see how close you are.")
        actor:send("If you ever forget anything you can always consult the <b:cyan>HELP</> file.'")
        wait(3)
    end
    actor:send(tostring(self.name) .. " tells you, 'Your Guild Master here in the Town of Mielikki will grant you your first quest.")
    actor:send("They will ask you for <b:yellow>gems</> and <b:yellow>armor</> which drop randomly from creatures across the world.")
    actor:send("Bring back what they ask for and you'll be well rewarded!'")
    wait(4)
    actor:send(tostring(self.name) .. " tells you, 'Congratulations again, graduate!  May you climb to ever greater fortune!'")
end$trig$, ARRAY['9267771f7af1f88ffe46abc2cb0c0bbe', 'a5af852ed67af7f0b08e37d84a80541f', 'a3e9ca45703357a296a7d93ae4f09552']),
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
    actor:send("To check your current wealth, use <b:cyan>SCORE</>.'")
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
end$trig$, ARRAY['2950465267a6c79bce008b33d371894b', 'fc2f2410c42e7068fffe2a05cebbd8ba', '2fc283968a1d355e1e29a170e7202dd5'])
) AS v(zone_id, id, commands, old_md5s)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = ANY (v.old_md5s)
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
